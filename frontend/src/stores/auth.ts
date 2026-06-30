import { defineStore } from 'pinia'
import { api } from '@/api/backend'
import { menuConfig, type MenuGroup, type MenuItem } from '@/config/menu'
import { clearPermissionCodes, setPermissionCodes } from '@/utils/permission'
import { menuItemFor, normalizePath, systemTabPathList } from '@/utils/routeCompat'

type AuthInfo = {
  id: number
  username: string
  nickname: string
  avatar: string
  roles: string[]
}

type BackendMenu = {
  path?: string
  name?: string
  component?: string
  meta?: {
    title?: string
    icon?: string
    roles?: unknown[]
  }
  children?: BackendMenu[]
}

const menuPathSet = new Set(menuConfig.flatMap((group) => group.items.map((item) => item.path)))
const dashboardFallback = menuConfig[0]?.items.find((item) => item.path === '/dashboard') as MenuItem

function asPath(value?: unknown) {
  const path = String(value ?? '').trim()
  if (!path || path === 'Layout') return ''
  return path.startsWith('/') ? path : `/${path}`
}

function collectPaths(route: BackendMenu, out: Set<string>, aliases: Record<string, string>) {
  const path = normalizePath(route.path, route.component)
  if (path) {
    out.add(path)
    const rawPath = asPath(route.path)
    const componentPath = asPath(route.component)
    if (rawPath) aliases[rawPath] = path
    if (componentPath) aliases[componentPath] = path
  }
  route.children?.forEach((child) => collectPaths(child, out, aliases))
}

function backendRouteInfo(routes: BackendMenu[]) {
  const backendPaths = new Set<string>()
  const aliases: Record<string, string> = {}
  routes.forEach((route) => collectPaths(route, backendPaths, aliases))
  return { backendPaths, aliases }
}

function routeTitle(route: BackendMenu) {
  return String(route.meta?.title || route.name || '').trim()
}

function routeIcon(route: BackendMenu) {
  return route.meta?.icon
}

function findSystemRoute(route: BackendMenu): BackendMenu | null {
  const normalized = normalizePath(route.path, route.component)
  if (normalized === '/system' && routeTitle(route) !== '系统管理') return route
  for (const child of route.children ?? []) {
    const found = findSystemRoute(child)
    if (found) return found
  }
  return null
}

function hasSystemTabAccess(route: BackendMenu): boolean {
  const normalized = normalizePath(route.path, route.component)
  return systemTabPathList.includes(normalized) || (route.children ?? []).some(hasSystemTabAccess)
}

function collectMenuItems(route: BackendMenu, out: Map<string, MenuItem>) {
  const normalized = normalizePath(route.path, route.component)
  if (normalized && menuPathSet.has(normalized) && normalized !== '/system') {
    out.set(normalized, menuItemFor(normalized, routeTitle(route), routeIcon(route)))
  }
  route.children?.forEach((child) => collectMenuItems(child, out))
}

function buildMenuGroups(routes: BackendMenu[]) {
  const groups = routes.flatMap((route) => {
    const items = new Map<string, MenuItem>()
    if (hasSystemTabAccess(route)) {
      const systemRoute = findSystemRoute(route) ?? route
      items.set('/system', menuItemFor('/system', routeTitle(systemRoute) || '权限管理', routeIcon(systemRoute)))
    } else {
      collectMenuItems(route, items)
    }

    return items.size ? [{ group: routeTitle(route) || '菜单', items: [...items.values()] }] : []
  })

  return groups.length ? groups : [{ group: '数据初始', items: [dashboardFallback] }]
}

function flattenPaths(groups: MenuGroup[]) {
  return groups.flatMap((group) => group.items.map((item) => item.path))
}

export const useAuthStore = defineStore('auth', {
  state: () => ({
    loaded: false,
    loading: false,
    user: null as AuthInfo | null,
    permissionCodes: [] as string[],
    menuGroups: menuConfig as MenuGroup[],
    menuPaths: flattenPaths(menuConfig),
    allowedPaths: [...flattenPaths(menuConfig), ...systemTabPathList],
    pathAliases: {} as Record<string, string>,
  }),
  getters: {
    displayName: (state) => state.user?.nickname || state.user?.username || '用户',
    username: (state) => state.user?.username || '',
    avatar: (state) => state.user?.avatar || '',
    isAdmin: (state) => {
      const codes = state.permissionCodes
      return state.user?.username === 'admin' || codes.includes('admin') || codes.includes('sys:manager')
    },
    roleLabel(): string {
      return this.isAdmin ? '超级管理员' : '业务人员'
    },
    systemAccessPaths: (state) => state.allowedPaths.filter((path) => systemTabPathList.includes(path)),
    firstSystemPath(): string {
      return this.systemAccessPaths[0] || ''
    },
    firstPath(): string {
      const first = this.menuPaths[0] || '/dashboard'
      return first === '/system' ? this.firstSystemPath || '/dashboard' : first
    },
  },
  actions: {
    async load(force = false) {
      if (this.loading) return
      if (this.loaded && !force) return

      this.loading = true
      try {
        const [info, menus] = await Promise.all([api.auth.info(), api.auth.menuList()])
        const roles = Array.isArray(info.roles) ? info.roles.filter((role) => role != null && String(role).trim()).map((role) => String(role).trim()) : []

        this.user = {
          id: Number(info.id ?? 0),
          username: String(info.username ?? ''),
          nickname: String(info.nickname ?? info.name ?? ''),
          avatar: String(info.avatar ?? ''),
          roles,
        }
        this.permissionCodes = roles
        setPermissionCodes(roles)

        const { backendPaths, aliases } = backendRouteInfo(menus as BackendMenu[])
        this.allowedPaths = ['/dashboard', ...backendPaths]
        this.pathAliases = aliases
        this.menuGroups = buildMenuGroups(menus as BackendMenu[])
        this.menuPaths = flattenPaths(this.menuGroups)
        this.loaded = true
      } finally {
        this.loading = false
      }
    },
    reset() {
      this.loaded = false
      this.user = null
      this.permissionCodes = []
      this.menuGroups = menuConfig
      this.menuPaths = flattenPaths(menuConfig)
      this.allowedPaths = [...flattenPaths(menuConfig), ...systemTabPathList]
      this.pathAliases = {}
      clearPermissionCodes()
    },
    hasPermission(code: string) {
      return this.permissionCodes.includes(code)
    },
    resolvePath(path: string) {
      const fullPath = asPath(path)
      return this.pathAliases[fullPath] || normalizePath(fullPath) || fullPath
    },
    canAccessPath(path: string) {
      const normalized = this.resolvePath(path)
      if (normalized === '/dashboard') return true
      if (normalized === '/system') return this.systemAccessPaths.length > 0
      if (normalized.startsWith('/finance/')) return this.allowedPaths.includes('/finance') || this.allowedPaths.includes(normalized)
      if (normalized.startsWith('/excel/')) return this.allowedPaths.includes('/excel/export-excel') || this.allowedPaths.includes(normalized)
      if (normalized.startsWith('/zip/')) return this.allowedPaths.includes('/zip/download') || this.allowedPaths.includes(normalized)
      if (normalized.startsWith('/pdf/')) return this.allowedPaths.includes('/pdf/download') || this.allowedPaths.includes(normalized)
      return this.allowedPaths.includes(normalized)
    },
  },
})
