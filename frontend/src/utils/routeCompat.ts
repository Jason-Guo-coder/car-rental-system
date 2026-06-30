import type { MenuItem } from '@/config/menu'

export type SystemTabKey = 'user' | 'dept' | 'role' | 'menu'

export const systemTabPaths: Record<SystemTabKey, string> = {
  user: '/system/user/userList',
  dept: '/system/dept/deptList',
  role: '/system/role/roleList',
  menu: '/system/permission/perr',
}
export const systemTabPathList = Object.values(systemTabPaths)

const legacyPathMap: Record<string, string> = {
  '/': '/dashboard',
  '/auto/maker/makerList': '/maker',
  '/auto/brand/brandList': '/maker',
  '/auto/info/autoInfoList': '/car',
  '/auto/rentalType/rentalTypeList': '/rental-type',
  '/busi/rental/rentalList': '/rent',
  '/busi/rental/returnList': '/return',
  '/busi/rental/orderList': '/order',
  '/busi/customer/customerList': '/customer',
  '/busi/violation/violationList': '/violation',
  '/busi/maintain/maintainList': '/maintain',
  '/system/system': '/system',
  '/system/user/userList': systemTabPaths.user,
  '/system/dept/deptList': systemTabPaths.dept,
  '/system/role/roleList': systemTabPaths.role,
  '/system/permission/perr': systemTabPaths.menu,
  '/finance/finance': '/finance',
  '/excel': '/excel/export-excel',
  '/excel/export-excel': '/excel/export-excel',
  '/excel/export-selected-excel': '/excel/export-selected-excel',
  '/excel/export-merge-header': '/excel/export-merge-header',
  '/excel/upload-excel': '/excel/upload-excel',
  '/zip': '/zip/download',
  '/zip/download': '/zip/download',
  '/pdf': '/pdf/download',
  '/pdf/index': '/pdf/download',
  '/pdf/download': '/pdf/download',
}

export const routeMetaByPath: Record<string, { title: string; icon: string }> = {
  '/dashboard': { title: '概览', icon: 'Odometer' },
  '/maker': { title: '厂商品牌', icon: 'OfficeBuilding' },
  '/car': { title: '车辆信息', icon: 'Van' },
  '/rental-type': { title: '出租类型', icon: 'PriceTag' },
  '/rent': { title: '汽车出租', icon: 'Key' },
  '/return': { title: '车辆归还', icon: 'RefreshLeft' },
  '/order': { title: '订单总览', icon: 'Tickets' },
  '/customer': { title: '客户管理', icon: 'User' },
  '/violation': { title: '违章处理', icon: 'Warning' },
  '/maintain': { title: '车辆保养', icon: 'Tools' },
  '/finance': { title: '财务报表', icon: 'TrendCharts' },
  '/finance/dayReport': { title: '财务日报', icon: 'Money' },
  '/finance/monthReport': { title: '财务月报', icon: 'TrendCharts' },
  '/excel/export-excel': { title: 'Excel 导出', icon: 'Document' },
  '/excel/export-selected-excel': { title: '选中导出', icon: 'DocumentChecked' },
  '/excel/export-merge-header': { title: '合并表头导出', icon: 'Files' },
  '/excel/upload-excel': { title: 'Excel 上传', icon: 'Upload' },
  '/zip/download': { title: 'Zip 导出', icon: 'FolderOpened' },
  '/pdf/download': { title: 'PDF 打印', icon: 'Printer' },
  [systemTabPaths.user]: { title: '用户管理', icon: 'User' },
  [systemTabPaths.dept]: { title: '部门管理', icon: 'OfficeBuilding' },
  [systemTabPaths.role]: { title: '角色管理', icon: 'UserFilled' },
  [systemTabPaths.menu]: { title: '菜单管理', icon: 'Setting' },
  '/system': { title: '权限管理', icon: 'Setting' },
}

export function normalizePath(path?: unknown, component?: unknown) {
  const candidates = [component, path]
    .map((value) => String(value ?? '').trim())
    .filter((value) => value && value !== 'Layout')

  for (const candidate of candidates) {
    const fullPath = candidate.startsWith('/') ? candidate : `/${candidate}`
    if (legacyPathMap[fullPath]) return legacyPathMap[fullPath]
    if (routeMetaByPath[fullPath]) return fullPath
  }

  return ''
}

export function normalizeIcon(icon: unknown, path: string) {
  const value = String(icon ?? '').trim()
  if (value && !value.startsWith('el-icon-') && value !== 'component' && value !== 'guide') return value
  return routeMetaByPath[path]?.icon ?? 'Menu'
}

export function menuItemFor(path: string, title?: unknown, icon?: unknown): MenuItem {
  const meta = routeMetaByPath[path]
  return {
    title: String(title || meta?.title || '未命名菜单'),
    path,
    icon: normalizeIcon(icon, path),
  }
}

export function systemTabFromPath(path: string): SystemTabKey {
  if (path.includes('/dept/')) return 'dept'
  if (path.includes('/role/')) return 'role'
  if (path.includes('/permission/')) return 'menu'
  return 'user'
}

export function isSameMenuPath(currentPath: string, menuPath: string) {
  const current = normalizePath(currentPath) || currentPath
  const target = normalizePath(menuPath) || menuPath
  return current === target || (target === '/system' && current.startsWith('/system/')) || (target === '/finance' && current.startsWith('/finance/'))
}
