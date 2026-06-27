const API_BASE = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8888'
const TOKEN_KEY = 'cloudrent-token'
const PERMISSION_CODE_KEY = 'permissionCode'

export function getToken() {
  return localStorage.getItem(TOKEN_KEY) || ''
}

export function setToken(token: string) {
  localStorage.setItem(TOKEN_KEY, token)
}

export function clearToken() {
  localStorage.removeItem(TOKEN_KEY)
  sessionStorage.removeItem(PERMISSION_CODE_KEY)
}

type Method = 'GET' | 'POST' | 'PUT' | 'DELETE'
export type ApiResult<T = unknown> = { code: number; message: string; success: boolean; data: T }

async function request<T>(method: Method, url: string, body?: unknown): Promise<T> {
  const json = await rawRequest<T>(method, url, body)
  return json.data as T
}

async function rawRequest<T>(method: Method, url: string, body?: unknown): Promise<ApiResult<T>> {
  const headers: Record<string, string> = {}
  const token = getToken()
  if (token) headers.token = token

  let payload: BodyInit | undefined
  if (body != null) {
    headers['Content-Type'] = 'application/json'
    payload = JSON.stringify(body)
  }

  const response = await fetch(`${API_BASE}${url}`, { method, headers, body: payload })
  const json = await response.json().catch(() => ({}))
  if (!response.ok || json.code !== 200) {
    throw new Error(json.message || `HTTP ${response.status}`)
  }
  return json as ApiResult<T>
}

export const http = {
  get: <T>(url: string) => request<T>('GET', url),
  post: <T>(url: string, body?: unknown) => request<T>('POST', url, body),
  put: <T>(url: string, body?: unknown) => request<T>('PUT', url, body),
  delete: <T>(url: string) => request<T>('DELETE', url),
  result: <T>(url: string) => rawRequest<T>('GET', url),
  resultPost: <T>(url: string, body?: unknown) => rawRequest<T>('POST', url, body),
}

export async function uploadFile(url: string, file: File) {
  const form = new FormData()
  form.append('file', file)

  const headers: Record<string, string> = {}
  const token = getToken()
  if (token) headers.token = token

  const response = await fetch(`${API_BASE}${url}`, { method: 'POST', headers, body: form })
  const json = await response.json().catch(() => ({}))
  if (!response.ok || json.code !== 200) {
    throw new Error(json.message || `HTTP ${response.status}`)
  }
  return json.data as string
}

export async function login(username: string, password: string) {
  const response = await fetch(`${API_BASE}/rental/user/login`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: new URLSearchParams({ username, password }),
  })
  const json = await response.json().catch(() => ({}))
  if (!response.ok || json.code !== 200 || !json.token) {
    throw new Error(json.message || '登录失败')
  }
  setToken(json.token)
  return json
}

export async function logout() {
  try {
    await http.post('/rental/auth/logout', { token: getToken() })
  } finally {
    clearToken()
  }
}
