import requestHttp from '@/utils/request'

// 登录
export function login(data) {
  return requestHttp.login('/rental/user/login', data)
}

// 获取用户信息
export function getInfo() {
  return requestHttp.get('/rental/auth/info')
}

// 获取用户菜单列表
export function getMenuList() {
  return requestHttp.get('/rental/auth/menuList')
}

// 登出
export function logout(param) {
  return requestHttp.post('/rental/auth/logout', param)
}

// 用户管理 CRUD
export default {
  async search(start, size, data) {
    return await requestHttp.post(`/rental/user/${start}/${size}`, data)
  },
  async save(data) {
    return await requestHttp.post('/rental/user', data)
  },
  async update(data) {
    return await requestHttp.put('/rental/user', data)
  },
  async delete(ids) {
    return await requestHttp.delete(`/rental/user/${ids}`)
  },
  // 获取用户已绑定的角色id
  async selectRoleIdByUserId(id) {
    return await requestHttp.get(`/rental/user/role/${id}`)
  },
  // 绑定角色
  async bindRole(userId, roleIds) {
    return await requestHttp.get(`/rental/user/bind/${userId}/${roleIds}`)
  }
}
