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
