#!/bin/zsh

set -u

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
FRONTEND_DIR="$ROOT_DIR/frontend-temp"
BACKEND_DIR="$ROOT_DIR/backend"
RUNTIME_DIR="$ROOT_DIR/.runtime/cloudrent"
REDIS_DIR="$RUNTIME_DIR/redis"
LOG_DIR="$RUNTIME_DIR/logs"

FRONTEND_PORT="${FRONTEND_PORT:-5180}"
BACKEND_PORT="${BACKEND_PORT:-8888}"
REDIS_PORT="${REDIS_PORT:-6379}"
MYSQL_PORT="${MYSQL_PORT:-3306}"
OPEN_BROWSER="${OPEN_BROWSER:-1}"

FRONTEND_PID=""
BACKEND_PID=""
BACKEND_EXTERNAL=0
REDIS_STARTED=0
CLEANED_UP=0

RESET=$'\033[0m'
BOLD=$'\033[1m'
GREEN=$'\033[32m'
YELLOW=$'\033[33m'
RED=$'\033[31m'
CYAN=$'\033[36m'

ok() { printf "%sOK%s %s\n" "$GREEN" "$RESET" "$1"; }
info() { printf "%s..%s %s\n" "$CYAN" "$RESET" "$1"; }
warn() { printf "%s!!%s %s\n" "$YELLOW" "$RESET" "$1"; }
fail() { printf "%sXX%s %s\n" "$RED" "$RESET" "$1"; }

pause_before_exit() {
  echo ""
  echo "Press Enter to close this window."
  read -r
}

port_open() {
  lsof -nP -iTCP:"$1" -sTCP:LISTEN >/dev/null 2>&1
}

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    fail "$1 not found"
    echo "  $2"
    pause_before_exit
    exit 1
  fi
}

choose_port() {
  local port="$1"
  local label="$2"
  local max_port=$((port + 20))

  while port_open "$port"; do
    warn "$label port $port is busy; trying $((port + 1))" >&2
    port=$((port + 1))
    if [ "$port" -gt "$max_port" ]; then
      fail "No free $label port found near $1" >&2
      pause_before_exit
      exit 1
    fi
  done

  REPLY="$port"
}

stop_tree() {
  local pid="$1"
  local name="$2"

  [ -n "$pid" ] || return
  kill -0 "$pid" 2>/dev/null || return

  if command -v pgrep >/dev/null 2>&1; then
    local child
    for child in $(pgrep -P "$pid" 2>/dev/null); do
      stop_tree "$child" "$name"
    done
  fi

  kill "$pid" 2>/dev/null || true
  sleep 1
  kill -0 "$pid" 2>/dev/null && kill -9 "$pid" 2>/dev/null || true
  wait "$pid" 2>/dev/null || true
}

cleanup() {
  [ "$CLEANED_UP" = "1" ] && return
  CLEANED_UP=1

  echo ""
  echo "${BOLD}Shutdown${RESET}"

  stop_tree "$FRONTEND_PID" "frontend"
  [ -n "$FRONTEND_PID" ] && ok "Frontend stopped"

  stop_tree "$BACKEND_PID" "backend"
  [ -n "$BACKEND_PID" ] && ok "Backend stopped"
  [ "$BACKEND_EXTERNAL" = "1" ] && ok "External backend left running"

  if [ "$REDIS_STARTED" = "1" ]; then
    redis-cli -h 127.0.0.1 -p "$REDIS_PORT" shutdown nosave >/dev/null 2>&1 || true
    ok "Redis stopped"
  fi

  rm -rf "$FRONTEND_DIR/dist" \
    "$FRONTEND_DIR/node_modules/.vite" \
    "$FRONTEND_DIR/node_modules/.cache" \
    "$RUNTIME_DIR"
  find "$ROOT_DIR" -name ".DS_Store" -type f -delete 2>/dev/null || true
  ok "Generated cache cleaned"
}

cleanup_and_exit() {
  cleanup
  exit 0
}

show_log_tail() {
  local file="$1"
  [ -f "$file" ] || return
  echo ""
  warn "Last log lines from $file"
  tail -n 60 "$file"
}

wait_for_port() {
  local port="$1"
  local pid="$2"
  local name="$3"
  local log_file="$4"
  local max_wait="$5"
  local i=0

  while [ "$i" -lt "$max_wait" ]; do
    if port_open "$port"; then
      ok "$name is listening on port $port"
      return
    fi

    if [ -n "$pid" ] && ! kill -0 "$pid" 2>/dev/null; then
      fail "$name exited before port $port became ready"
      show_log_tail "$log_file"
      pause_before_exit
      exit 1
    fi

    sleep 1
    i=$((i + 1))
  done

  fail "$name did not become ready on port $port"
  show_log_tail "$log_file"
  pause_before_exit
  exit 1
}

start_redis() {
  if redis-cli -h 127.0.0.1 -p "$REDIS_PORT" ping >/dev/null 2>&1; then
    ok "Using existing Redis on port $REDIS_PORT"
    return
  fi

  mkdir -p "$REDIS_DIR"
  info "Starting project Redis on 127.0.0.1:$REDIS_PORT"
  redis-server --port "$REDIS_PORT" \
    --bind 127.0.0.1 \
    --dir "$REDIS_DIR" \
    --dbfilename dump.rdb \
    --pidfile "$REDIS_DIR/redis.pid" \
    --save "" \
    --appendonly no \
    --daemonize yes >/dev/null

  REDIS_STARTED=1

  local i=0
  while [ "$i" -lt 30 ]; do
    if redis-cli -h 127.0.0.1 -p "$REDIS_PORT" ping >/dev/null 2>&1; then
      ok "Redis started"
      return
    fi
    sleep 1
    i=$((i + 1))
  done

  fail "Redis failed to start"
  pause_before_exit
  exit 1
}

start_backend() {
  local log_file="$LOG_DIR/backend.log"

  if port_open "$BACKEND_PORT"; then
    BACKEND_EXTERNAL=1
    ok "Using existing backend on port $BACKEND_PORT"
    return
  fi

  info "Starting backend"
  (
    cd "$BACKEND_DIR" || exit 1
    env \
      SERVER_PORT="$BACKEND_PORT" \
      SPRING_DATA_REDIS_HOST="127.0.0.1" \
      SPRING_DATA_REDIS_PORT="$REDIS_PORT" \
      mvn -q -o spring-boot:run
  ) >"$log_file" 2>&1 &
  BACKEND_PID=$!

  wait_for_port "$BACKEND_PORT" "$BACKEND_PID" "Backend" "$log_file" 90
}

start_frontend() {
  local log_file="$LOG_DIR/frontend.log"
  local open_arg=()

  if [ "$OPEN_BROWSER" != "0" ]; then
    open_arg=(--open /login)
  fi

  info "Starting new frontend"
  (
    cd "$FRONTEND_DIR" || exit 1
    env VITE_API_BASE_URL="http://localhost:$BACKEND_PORT" \
      npm run dev -- --host 127.0.0.1 --port "$FRONTEND_PORT" "${open_arg[@]}"
  ) >"$log_file" 2>&1 &
  FRONTEND_PID=$!

  wait_for_port "$FRONTEND_PORT" "$FRONTEND_PID" "Frontend" "$log_file" 45
}

monitor() {
  echo ""
  echo "Open: http://localhost:$FRONTEND_PORT/login"
  if [ "$BACKEND_EXTERNAL" = "1" ]; then
    echo "Press Ctrl+C or close this window to stop the frontend. Existing backend/Redis will be left running."
  else
    echo "Press Ctrl+C or close this window to stop frontend, backend, and Redis."
  fi

  while true; do
    if ! kill -0 "$FRONTEND_PID" 2>/dev/null; then
      warn "Frontend process exited"
      return
    fi

    if [ "$BACKEND_EXTERNAL" != "1" ] && ! kill -0 "$BACKEND_PID" 2>/dev/null; then
      fail "Backend process exited"
      show_log_tail "$LOG_DIR/backend.log"
      return
    fi

    sleep 2
  done
}

trap cleanup EXIT
trap cleanup_and_exit INT TERM HUP

if [ ! -d "$FRONTEND_DIR" ]; then
  fail "frontend-temp directory not found"
  pause_before_exit
  exit 1
fi

if [ ! -d "$BACKEND_DIR" ]; then
  fail "backend directory not found"
  pause_before_exit
  exit 1
fi

mkdir -p "$LOG_DIR"

require_command lsof "Install lsof or use macOS default /usr/sbin/lsof."
require_command pgrep "Install procps or use macOS default /usr/bin/pgrep."
require_command redis-server "Install Redis, for example: brew install redis."
require_command redis-cli "Install Redis, for example: brew install redis."
require_command mvn "Install Maven first."
require_command npm "Install Node.js/npm first."

if [ ! -d "$FRONTEND_DIR/node_modules" ]; then
  fail "frontend-temp/node_modules not found"
  echo "  Run npm install in frontend-temp once, then try again."
  pause_before_exit
  exit 1
fi

if ! port_open "$MYSQL_PORT"; then
  fail "MySQL port $MYSQL_PORT is not listening"
  echo "  Start MySQL and make sure database car_rental_system exists."
  pause_before_exit
  exit 1
fi

choose_port "$FRONTEND_PORT" Frontend
FRONTEND_PORT="$REPLY"
clear
echo "${BOLD}CloudRent Full Stack Dev${RESET}"
echo "Frontend  http://localhost:$FRONTEND_PORT"
echo "Backend   http://localhost:$BACKEND_PORT"
echo "Redis     127.0.0.1:$REDIS_PORT"
echo ""

start_redis
start_backend
start_frontend
monitor
