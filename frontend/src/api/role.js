import requestHttp from '@/utils/request'

export default {
  async search(start, size, data) {
    return await requestHttp.post(`/rental/role/${start}/${size}`, data)
  },
  async save(data) {
    return await requestHttp.post('/rental/role', data)
  },
  async update(data) {
    return await requestHttp.put('/rental/role', data)
  },
  async hasUser(id) {
    return await requestHttp.get(`/rental/role/hasUser/${id}`)
  },
  async delete(ids) {
    return await requestHttp.delete(`/rental/role/${ids}`)
  },
  async permissionTree(params) {
    return await requestHttp.get('/rental/role/permissionTrees', params)
  },
  async assignPermission(roleId, permissionIds) {
    return await requestHttp.get(`/rental/role/${roleId}/${permissionIds}`)
  },
  // 获取所有角色（不分页）
  async list() {
    return await requestHttp.get('/rental/role')
  }
}

export function getRoutes() {
  return requestHttp.get('/vue-element-admin/routes')
}

export function getRoles() {
  return requestHttp.get('/vue-element-admin/roles')
}

export function addRole(data) {
  return requestHttp.post('/vue-element-admin/role', data)
}

export function updateRole(id, data) {
  return requestHttp.put(`/vue-element-admin/role/${id}`, data)
}

export function deleteRole(id) {
  return requestHttp.delete(`/vue-element-admin/role/${id}`)
}
