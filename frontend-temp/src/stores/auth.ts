import { defineStore } from 'pinia'
import { api } from '@/api/backend'
import { menuConfig, type MenuGroup, type MenuItem } from '@/config/menu'
import { clearPermissionCodes, setPermissionCodes } from '@/utils/permission'
import { normalizePath } from '@/utils/routeCompat'

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

function collectPaths(route: BackendMenu, out: Set<string>) {
  const path = normalizePath(route.path, route.component)
  if (path) out.add(path)
  route.children?.forEach((child) => collectPaths(child, out))
}

function buildMenuGroups(routes: BackendMenu[]) {
  const backendPaths = new Set<string>()
  routes.forEach((route) => collectPaths(route, backendPaths))

  if (!backendPaths.size) return menuConfig

  const canShow = (item: MenuItem) => {
    if (item.path === '/dashboard') return true
    if (item.path === '/system') return [...backendPaths].some((path) => path === '/system' || path.startsWith('/system/'))
    return backendPaths.has(item.path)
  }

  const groups = menuConfig
    .map((group) => ({ ...group, items: group.items.filter(canShow) }))
    .filter((group) => group.items.length)

  return groups.length ? groups : menuConfig
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
    firstPath: (state) => state.menuPaths[0] || '/dashboard',
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
      clearPermissionCodes()
    },
    hasPermission(code: string) {
      return this.permissionCodes.includes(code)
    },
    canAccessPath(path: string) {
      const normalized = normalizePath(path) || path
      if (normalized === '/dashboard') return true
      if (normalized === '/system') return this.menuPaths.some((item) => item.startsWith('/system'))
      if (normalized.startsWith('/system/')) return this.menuPaths.includes('/system')
      return this.menuPaths.includes(normalized)
    },
  },
})
