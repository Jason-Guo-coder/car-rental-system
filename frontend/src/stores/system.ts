import { defineStore } from 'pinia'
import { api } from '@/api/backend'
import type { SysUser, SysDept, SysRole, SysPermission } from '@/types'

type UserQuery = Partial<SysUser> & { page?: number; size?: number }
type RoleQuery = Partial<SysRole> & { page?: number; size?: number }

/** 在部门树中按 id 查找节点 */
function findDept(nodes: SysDept[], id: number): SysDept | null {
  for (const n of nodes) {
    if (n.id === id) return n
    const found = n.children ? findDept(n.children, id) : null
    if (found) return found
  }
  return null
}
/** 取部门树中最大 id + 1 */
function nextDeptId(nodes: SysDept[]): number {
  let max = 0
  function walk(list: SysDept[]) {
    for (const n of list) {
      if (n.id > max) max = n.id
      if (n.children) walk(n.children)
    }
  }
  walk(nodes)
  return max + 1
}

/** 系统管理 store（用户/部门/角色/菜单 4 个 Tab 共用） */
export const useSystemStore = defineStore('system', {
  state: () => ({
    users: [] as SysUser[],
    deptTree: [] as SysDept[],
    roles: [] as SysRole[],
    rolePageRows: [] as SysRole[],
    permissions: [] as SysPermission[],
    permissionParents: [] as SysPermission[],
    userTotal: 0,
    userQuery: { page: 1, size: 5 } as UserQuery,
    roleTotal: 0,
    roleQuery: { page: 1, size: 5 } as RoleQuery,
    loading: false,
  }),
  actions: {
    async load() {
      this.loading = true
      try {
        const [userPage, deptTree, roles, permissions, permissionParents] = await Promise.all([
          api.system.users(this.userQuery),
          api.system.depts(),
          api.system.allRoles(),
          api.system.permissions(),
          api.system.permissionTree(),
        ])
        this.users = userPage.list
        this.userTotal = userPage.total
        this.deptTree = deptTree
        this.roles = roles
        this.permissions = permissions
        this.permissionParents = permissionParents
      } finally {
        this.loading = false
      }
    },
    async searchUsers(query: UserQuery = {}) {
      this.userQuery = { ...this.userQuery, ...query }
      const result = await api.system.users(this.userQuery)
      this.users = result.list
      this.userTotal = result.total
    },
    async searchRoles(query: RoleQuery = {}) {
      this.roleQuery = { ...this.roleQuery, ...query }
      const result = await api.system.roles(this.roleQuery)
      this.rolePageRows = result.list
      this.roleTotal = result.total
    },
    async reloadAllRoles() {
      this.roles = await api.system.allRoles()
    },
    async addUser(u: Omit<SysUser, 'id'>) {
      await api.system.saveUser(u)
      await this.searchUsers()
      if (u.roleIds?.length) {
        const result = await api.system.users({ username: u.username, page: 1, size: 1 })
        const created = result.list.find((item) => item.username === u.username)
        if (created) await api.system.bindRole(created.id, u.roleIds)
        await this.searchUsers()
      }
    },
    async updateUser(u: SysUser) {
      await api.system.updateUser(u)
      await this.searchUsers()
    },
    async userRoleIds(id: number) {
      return api.system.userRoleIds(id)
    },
    async bindRole(id: number, roleIds: number[]) {
      if (roleIds.length) await api.system.bindRole(id, roleIds)
      await this.searchUsers()
    },
    async removeUsers(ids: number[]) {
      await api.system.deleteUser(ids)
      await this.searchUsers()
    },
    // —— 部门树增删改 ——
    async searchDepts(name = '') {
      this.deptTree = name.trim() ? await api.system.searchDepts(name.trim()) : await api.system.depts()
    },
    async addDept(d: Partial<SysDept>) {
      await api.system.saveDept(d)
      await this.searchDepts()
    },
    async updateDept(id: number, patch: Partial<SysDept>) {
      await api.system.updateDept({ id, ...patch })
      await this.searchDepts()
    },
    async removeDept(id: number) {
      if (await api.system.hasDeptChildren(id)) throw new Error('该部门存在下级部门，不能删除')
      await api.system.deleteDept(id)
      await this.searchDepts()
    },
    toggleUser(id: number) {
      const u = this.users.find((x) => x.id === id)
      if (u) u.enabled = !u.enabled
    },
    async removeUser(id: number) {
      await this.removeUsers([id])
    },
    async removeRole(id: number) {
      if (await api.system.hasRoleUser(id)) throw new Error('该角色下有用户，不能删除')
      await api.system.deleteRole([id])
      await this.searchRoles()
      await this.reloadAllRoles()
    },
    async removeRoles(ids: number[]) {
      for (const id of ids) {
        if (await api.system.hasRoleUser(id)) throw new Error('选中的角色下有用户，不能删除')
      }
      await api.system.deleteRole(ids)
      await this.searchRoles()
      await this.reloadAllRoles()
    },
    async addRole(r: Omit<SysRole, 'id'>) {
      await api.system.saveRole(r)
      await this.searchRoles()
      await this.reloadAllRoles()
    },
    async updateRole(r: SysRole) {
      await api.system.updateRole(r)
      await this.searchRoles()
      await this.reloadAllRoles()
    },
    async setRolePermissions(id: number, permIds: number[]) {
      await api.system.assignPermission(id, permIds)
      await this.searchRoles()
    },
    async roleHasUser(id: number) {
      return api.system.hasRoleUser(id)
    },
    async loadPermissionParents() {
      this.permissionParents = await api.system.permissionTree()
    },
    async permissionHasChildren(id: number) {
      return api.system.hasPermissionChildren(id)
    },
    async removePermission(id: number) {
      await api.system.deletePermission(id)
      await this.load()
    },
    async addPermission(p: Omit<SysPermission, 'id' | 'children'>) {
      await api.system.savePermission(p)
      await this.load()
    },
    async updatePermission(p: SysPermission) {
      await api.system.updatePermission(p)
      await this.load()
    },
  },
})
