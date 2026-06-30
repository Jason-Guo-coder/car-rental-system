import { ElMessage, ElMessageBox } from 'element-plus'
import { hasPermission } from '@/utils/permission'

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
type Params = Record<string, unknown>
const TOKEN_EXPIRED_CODES = new Set([50008, 50012, 50014])
let tokenPrompting = false

const WRITE_PERMISSION_RULES: Array<{ method: Method; pattern: RegExp; codes: string[] }> = [
  { method: 'POST', pattern: /^\/rental\/autoInfo$/, codes: ['auto:info:add'] },
  { method: 'PUT', pattern: /^\/rental\/autoInfo$/, codes: ['auto:info:edit'] },
  { method: 'DELETE', pattern: /^\/rental\/autoInfo\//, codes: ['auto:info:delete'] },
  { method: 'POST', pattern: /^\/rental\/autoMaker$/, codes: ['auto:maker:add'] },
  { method: 'PUT', pattern: /^\/rental\/autoMaker$/, codes: ['auto:maker:edit'] },
  { method: 'DELETE', pattern: /^\/rental\/autoMaker\//, codes: ['auto:maker:delete'] },
  { method: 'POST', pattern: /^\/rental\/autoBrand$/, codes: ['auto:brand:add'] },
  { method: 'PUT', pattern: /^\/rental\/autoBrand$/, codes: ['auto:brand:edit'] },
  { method: 'DELETE', pattern: /^\/rental\/autoBrand\//, codes: ['auto:brand:delete'] },
  { method: 'POST', pattern: /^\/rental\/rentalType$/, codes: ['auto:rentalType:add'] },
  { method: 'PUT', pattern: /^\/rental\/rentalType$/, codes: ['auto:rentalType:edit'] },
  { method: 'DELETE', pattern: /^\/rental\/rentalType\//, codes: ['auto:rentalType:delete'] },
  { method: 'POST', pattern: /^\/rental\/order$/, codes: ['busi:rental:rent'] },
  { method: 'PUT', pattern: /^\/rental\/order$/, codes: ['busi:return:return'] },
  { method: 'GET', pattern: /^\/rental\/order\/doReturnDeposit\//, codes: ['busi:order:returnDeposit'] },
  { method: 'POST', pattern: /^\/rental\/customer$/, codes: ['busi:customer:add'] },
  { method: 'PUT', pattern: /^\/rental\/customer$/, codes: ['busi:customer:edit'] },
  { method: 'DELETE', pattern: /^\/rental\/customer\//, codes: ['busi:customer:delete'] },
  { method: 'POST', pattern: /^\/rental\/violation$/, codes: ['busi:violation:add'] },
  { method: 'PUT', pattern: /^\/rental\/violation$/, codes: ['busi:violation:edit', 'busi:violation:handle'] },
  { method: 'DELETE', pattern: /^\/rental\/violation\//, codes: ['busi:violation:delete'] },
  { method: 'POST', pattern: /^\/rental\/maintain$/, codes: ['busi:maintain:add'] },
  { method: 'PUT', pattern: /^\/rental\/maintain$/, codes: ['busi:maintain:edit'] },
  { method: 'DELETE', pattern: /^\/rental\/maintain\//, codes: ['busi:maintain:delete'] },
  { method: 'POST', pattern: /^\/rental\/user$/, codes: ['sys:user:add'] },
  { method: 'PUT', pattern: /^\/rental\/user$/, codes: ['sys:user:edit'] },
  { method: 'DELETE', pattern: /^\/rental\/user\//, codes: ['sys:user:delete', 'sys:user:deleteBatch'] },
  { method: 'GET', pattern: /^\/rental\/user\/bind\//, codes: ['sys:user:bindRole'] },
  { method: 'POST', pattern: /^\/rental\/dept\/save$/, codes: ['sys:dept:add'] },
  { method: 'PUT', pattern: /^\/rental\/dept$/, codes: ['sys:dept:edit'] },
  { method: 'DELETE', pattern: /^\/rental\/dept\//, codes: ['sys:dept:delete'] },
  { method: 'POST', pattern: /^\/rental\/role$/, codes: ['sys:role:save'] },
  { method: 'PUT', pattern: /^\/rental\/role$/, codes: ['sys:role:edit'] },
  { method: 'DELETE', pattern: /^\/rental\/role\//, codes: ['sys:role:delete'] },
  { method: 'GET', pattern: /^\/rental\/role\/\d+\//, codes: ['sys:role:bindPermission'] },
  { method: 'POST', pattern: /^\/rental\/permission$/, codes: ['sys:permission:add'] },
  { method: 'PUT', pattern: /^\/rental\/permission$/, codes: ['sys:permission:edit'] },
  { method: 'DELETE', pattern: /^\/rental\/permission\//, codes: ['sys:permission:delete'] },
  { method: 'POST', pattern: /^\/rental\/oss\/upload$/, codes: ['auto:info:add', 'auto:info:edit', 'sys:user:add', 'sys:user:edit'] },
]

function assertPermission(method: Method, url: string) {
  const rule = WRITE_PERMISSION_RULES.find((item) => item.method === method && item.pattern.test(url))
  if (!rule || rule.codes.some(hasPermission)) return
  const message = '当前账号没有该操作权限'
  ElMessage.warning(message)
  throw new Error(message)
}

function appendParams(url: string, params?: Params) {
  if (!params) return url
  const query = new URLSearchParams()
  for (const [key, value] of Object.entries(params)) {
    if (value == null || value === '') continue
    if (Array.isArray(value)) value.forEach((item) => item != null && item !== '' && query.append(key, String(item)))
    else query.append(key, String(value))
  }
  const text = query.toString()
  return text ? `${url}${url.includes('?') ? '&' : '?'}${text}` : url
}

function appendRest(url: string, params?: Params) {
  if (!params) return url
  const parts = Object.values(params).filter((value) => value != null && value !== '').map((value) => encodeURIComponent(String(value)))
  return parts.length ? `${url}/${parts.join('/')}` : url
}

function handleTokenExpired(message: string) {
  if (tokenPrompting) return
  tokenPrompting = true
  ElMessageBox.confirm(message || '登录已失效，请重新登录', '确认退出', {
    confirmButtonText: '重新登录',
    cancelButtonText: '取消',
    type: 'warning',
  })
    .then(() => {
      clearToken()
      location.reload()
    })
    .finally(() => {
      tokenPrompting = false
    })
}

async function request<T>(method: Method, url: string, body?: unknown): Promise<T> {
  const json = await rawRequest<T>(method, url, body)
  return json.data as T
}

async function rawRequest<T>(method: Method, url: string, body?: unknown): Promise<ApiResult<T>> {
  assertPermission(method, url)
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
    const message = json.message || `HTTP ${response.status}`
    if (TOKEN_EXPIRED_CODES.has(Number(json.code))) handleTokenExpired(message)
    else ElMessage.error(message)
    throw new Error(message)
  }
  return json as ApiResult<T>
}

export const http = {
  get: <T>(url: string, params?: Params) => request<T>('GET', appendParams(url, params)),
  post: <T>(url: string, body?: unknown) => request<T>('POST', url, body),
  put: <T>(url: string, body?: unknown) => request<T>('PUT', url, body),
  delete: <T>(url: string, params?: Params) => request<T>('DELETE', appendRest(url, params)),
  getRestFulApi: <T>(url: string, params?: Params) => request<T>('GET', appendRest(url, params)),
  result: <T>(url: string, params?: Params) => rawRequest<T>('GET', appendParams(url, params)),
  resultPost: <T>(url: string, body?: unknown) => rawRequest<T>('POST', url, body),
  resultPut: <T>(url: string, body?: unknown) => rawRequest<T>('PUT', url, body),
  resultDelete: <T>(url: string, params?: Params) => rawRequest<T>('DELETE', appendRest(url, params)),
  resultGetRestFulApi: <T>(url: string, params?: Params) => rawRequest<T>('GET', appendRest(url, params)),
  upload: uploadResult,
  login: loginForm,
}

export async function uploadResult<T = unknown>(url: string, form: FormData) {
  assertPermission('POST', url)
  const headers: Record<string, string> = {}
  const token = getToken()
  if (token) headers.token = token

  const response = await fetch(`${API_BASE}${url}`, { method: 'POST', headers, body: form })
  const json = await response.json().catch(() => ({}))
  if (!response.ok || json.code !== 200) {
    const message = json.message || `HTTP ${response.status}`
    ElMessage.error(message)
    throw new Error(message)
  }
  return json as ApiResult<T>
}

export async function uploadFile(url: string, file: File) {
  const form = new FormData()
  form.append('file', file)
  const json = await uploadResult<string>(url, form)
  return json.data
}

export async function loginForm<T = unknown>(url: string, params: Params) {
  const response = await fetch(`${API_BASE}${url}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: new URLSearchParams(Object.entries(params).map(([key, value]) => [key, String(value ?? '')])),
  })
  const json = await response.json().catch(() => ({}))
  if (!response.ok || json.code !== 200) {
    const message = json.message || '登录失败'
    ElMessage.error(message)
    throw new Error(message)
  }
  return json as ApiResult<T> & { token?: string }
}

export async function login(username: string, password: string) {
  const json = await loginForm('/rental/user/login', { username, password })
  if (!json.token) throw new Error(json.message || '登录失败')
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

export const requestHttp = {
  get: http.result,
  post: http.resultPost,
  put: http.resultPut,
  delete: http.resultDelete,
  getRestFulApi: http.resultGetRestFulApi,
  upload: uploadResult,
  login: loginForm,
}

export default requestHttp
