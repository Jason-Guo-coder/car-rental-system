// 按钮权限校验：判断当前登录用户是否拥有某个权限码
export default function hasPermission(permission) {
  let flag = false
  const permissionCode = JSON.parse(sessionStorage.getItem('permissionCode'))
  if (!permissionCode) {
    return flag
  }
  for (let i = 0; i < permissionCode.length; i++) {
    if (permissionCode[i] === permission) {
      flag = true
      break
    }
  }
  return flag
}
