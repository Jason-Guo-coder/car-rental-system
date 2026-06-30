const PERMISSION_CODE_KEY = 'permissionCode'

export function getPermissionCodes() {
  try {
    const raw = sessionStorage.getItem(PERMISSION_CODE_KEY)
    const data = raw ? JSON.parse(raw) : []
    return Array.isArray(data) ? data.map(String).filter(Boolean) : []
  } catch {
    return []
  }
}

export function setPermissionCodes(codes: unknown[]) {
  sessionStorage.setItem(PERMISSION_CODE_KEY, JSON.stringify(codes.filter((code) => code != null && String(code).trim()).map((code) => String(code).trim())))
}

export function clearPermissionCodes() {
  sessionStorage.removeItem(PERMISSION_CODE_KEY)
}

export function hasPermission(code: string) {
  return getPermissionCodes().includes(code)
}
