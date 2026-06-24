#!/bin/zsh

set -u

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
FRONTEND_DIR="$ROOT_DIR/frontend"
RUNTIME_DIR="$ROOT_DIR/.runtime"
REDIS_DIR="$RUNTIME_DIR/redis"
REDIS_PORT=6379
FRONTEND_PORT=9527
BACKEND_PORT=8888
REDIS_STARTED_BY_SCRIPT=0
FRONTEND_PID=""
TOKEN_WATCH_PID=""

RESET=$'\033[0m'
BOLD=$'\033[1m'
DIM=$'\033[2m'
GREEN=$'\033[32m'
YELLOW=$'\033[33m'
RED=$'\033[31m'
CYAN=$'\033[36m'
BLUE=$'\033[34m'

line() {
  printf "%s\n" "${DIM}──────────────────────────────────────────${RESET}"
}

section() {
  printf "\n%s%s%s\n" "$BOLD" "$1" "$RESET"
  line
}

ok() {
  printf "%s✓%s %s\n" "$GREEN" "$RESET" "$1"
}

info() {
  printf "%s•%s %s\n" "$CYAN" "$RESET" "$1"
}

warn() {
  printf "%s!%s %s\n" "$YELLOW" "$RESET" "$1"
}

fail() {
  printf "%s✗%s %s\n" "$RED" "$RESET" "$1"
}

pause_before_exit() {
  echo ""
  echo "Press Enter to close this window."
  read -r
}

cleanup() {
  echo ""
  section "Shutdown"

  if [ -n "${TOKEN_WATCH_PID:-}" ] && kill -0 "$TOKEN_WATCH_PID" 2>/dev/null; then
    kill "$TOKEN_WATCH_PID" 2>/dev/null || true
    wait "$TOKEN_WATCH_PID" 2>/dev/null || true
    ok "Token monitor stopped"
  fi

  if [ -n "${FRONTEND_PID:-}" ] && kill -0 "$FRONTEND_PID" 2>/dev/null; then
    kill "$FRONTEND_PID" 2>/dev/null || true
    wait "$FRONTEND_PID" 2>/dev/null || true
    ok "Frontend dev server stopped"
  fi

  if [ "$REDIS_STARTED_BY_SCRIPT" = "1" ]; then
    redis-cli -h 127.0.0.1 -p "$REDIS_PORT" shutdown nosave >/dev/null 2>&1 || true
    ok "Script-started Redis stopped"
  else
    info "External Redis left running"
  fi

  rm -rf "$FRONTEND_DIR/dist" "$FRONTEND_DIR/node_modules/.cache"
  rm -f "$REDIS_DIR/redis.pid" "$REDIS_DIR/dump.rdb"
  rm -rf "$RUNTIME_DIR"
  find "$ROOT_DIR" -name ".DS_Store" -type f -delete 2>/dev/null || true
  ok "Generated cache cleaned"
}

print_jwt_payload() {
  local token="$1"

  python3 - "$token" <<'PY'
import base64
import json
import sys
from datetime import datetime

token = sys.argv[1]
parts = token.split(".")
if len(parts) < 2:
    print("payload: <invalid jwt>")
    raise SystemExit

payload = parts[1] + "=" * (-len(parts[1]) % 4)

try:
    data = json.loads(base64.urlsafe_b64decode(payload.encode()).decode())
except Exception as exc:
    print(f"payload: <decode failed: {exc}>")
    raise SystemExit

for key in sorted(data.keys()):
    value = data[key]
    if key in {"iat", "nbf", "exp"} and isinstance(value, (int, float)):
        local_time = datetime.fromtimestamp(value).strftime("%Y-%m-%d %H:%M:%S")
        print(f"  {key:<8} {value}  {local_time}")
    else:
        print(f"  {key:<8} {value}")
PY
}

print_token_summary() {
  local token="$1"

  python3 - "$token" <<'PY'
import base64
import json
import sys
from datetime import datetime

token = sys.argv[1]
summary = token[:18] + "..." + token[-12:] if len(token) > 36 else token
parts = token.split(".")

print(f"token     {summary}")

if len(parts) < 2:
    print("user      <invalid jwt>")
    print("expires   <invalid jwt>")
    raise SystemExit

payload = parts[1] + "=" * (-len(parts[1]) % 4)

try:
    data = json.loads(base64.urlsafe_b64decode(payload.encode()).decode())
except Exception as exc:
    print(f"user      <decode failed: {exc}>")
    print("expires   <decode failed>")
    raise SystemExit

username = data.get("username", "<unknown>")
userid = data.get("userid", "<unknown>")
exp = data.get("exp")

print(f"user      {username} (id={userid})")
if isinstance(exp, (int, float)):
    print(f"expires   {datetime.fromtimestamp(exp).strftime('%Y-%m-%d %H:%M:%S')}")
else:
    print("expires   <unknown>")
PY
}

mark_existing_tokens_seen() {
  local seen_file="$RUNTIME_DIR/seen-tokens.txt"
  mkdir -p "$RUNTIME_DIR"
  redis-cli -h 127.0.0.1 -p "$REDIS_PORT" --scan --pattern 'token:*' > "$seen_file" 2>/dev/null || true
}

watch_tokens() {
  local seen_file="$RUNTIME_DIR/seen-tokens.txt"
  mkdir -p "$RUNTIME_DIR"
  touch "$seen_file"

  while true; do
    redis-cli -h 127.0.0.1 -p "$REDIS_PORT" --scan --pattern 'token:*' 2>/dev/null | while IFS= read -r key; do
      [ -z "$key" ] && continue
      grep -Fxq "$key" "$seen_file" 2>/dev/null && continue

      echo "$key" >> "$seen_file"

      local token="${key#token:}"
      local ttl
      ttl="$(redis-cli -h 127.0.0.1 -p "$REDIS_PORT" ttl "$key" 2>/dev/null || echo unknown)"

      section "Login Token"
      print_token_summary "$token" | sed 's/^/  /'
      echo ""
      printf "  redis    key=token:<JWT>  ttl=%ss\n" "$ttl"
      echo ""
      echo "  full token"
      echo "  $token"
      echo ""
      echo "  payload"
      print_jwt_payload "$token"
      line
    done
    sleep 2
  done
}

require_command() {
  local command_name="$1"
  local install_hint="$2"

  if ! command -v "$command_name" >/dev/null 2>&1; then
    fail "$command_name not found"
    echo "  $install_hint"
    pause_before_exit
    exit 1
  fi
}

check_backend_status() {
  if lsof -nP -iTCP:"$BACKEND_PORT" -sTCP:LISTEN >/dev/null 2>&1; then
    ok "Backend port $BACKEND_PORT is listening"
  else
    warn "Backend port $BACKEND_PORT is not listening"
    echo "  Start backend in IntelliJ IDEA: CarRentalSystemApplication"
  fi
}

start_redis_if_needed() {
  info "Checking Redis on 127.0.0.1:$REDIS_PORT"

  if redis-cli -h 127.0.0.1 -p "$REDIS_PORT" ping >/dev/null 2>&1; then
    ok "Redis is already running"
    REDIS_STARTED_BY_SCRIPT=0
    return
  fi

  mkdir -p "$REDIS_DIR"
  info "Starting project-local Redis"
  redis-server --port "$REDIS_PORT" \
    --bind 127.0.0.1 \
    --dir "$REDIS_DIR" \
    --dbfilename dump.rdb \
    --pidfile "$REDIS_DIR/redis.pid" \
    --daemonize yes

  for i in {1..25}; do
    if redis-cli -h 127.0.0.1 -p "$REDIS_PORT" ping >/dev/null 2>&1; then
      REDIS_STARTED_BY_SCRIPT=1
      ok "Redis started by this script"
      return
    fi
    sleep 0.2
  done

  fail "Redis failed to start"
  pause_before_exit
  exit 1
}

start_frontend() {
  cd "$FRONTEND_DIR" || exit 1

  if [ ! -d "node_modules" ]; then
    fail "frontend/node_modules not found"
    echo "  Run: cd \"$FRONTEND_DIR\" && npm install"
    pause_before_exit
    exit 1
  fi

  export port="$FRONTEND_PORT"

  info "Starting frontend dev server"
  npm run dev &
  FRONTEND_PID=$!
}

trap cleanup EXIT INT TERM HUP

clear
printf "%s%s%s\n" "$BOLD" "Car Rental System Dev Console" "$RESET"
line
echo "Frontend  http://localhost:$FRONTEND_PORT"
echo "Backend   http://localhost:$BACKEND_PORT  ${DIM}(start in IntelliJ IDEA)${RESET}"
echo "Redis     127.0.0.1:$REDIS_PORT"
line

if [ ! -d "$FRONTEND_DIR" ]; then
  fail "frontend directory not found: $FRONTEND_DIR"
  pause_before_exit
  exit 1
fi

section "Preflight"
require_command "redis-cli" "Install Redis, for example: brew install redis"
require_command "redis-server" "Install Redis, for example: brew install redis"
require_command "npm" "Install Node.js/npm first"
ok "Required commands found"
check_backend_status
start_redis_if_needed
mark_existing_tokens_seen
ok "Existing Redis tokens marked as already seen"

section "Run"
echo "Keep this window open while using the frontend."
echo "Press Ctrl+C or close this window to stop frontend and script-started Redis."
echo "Only new login tokens created after this window starts will be printed."
echo ""

watch_tokens &
TOKEN_WATCH_PID=$!
ok "Token monitor started"

start_frontend
ok "Frontend process started, pid=$FRONTEND_PID"
echo ""
wait "$FRONTEND_PID"
