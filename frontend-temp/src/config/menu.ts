/** 侧边栏菜单配置 —— 数据驱动，分组对齐 sys_permission 目录结构 */
export interface MenuItem {
  title: string
  path: string
  icon: string // Element Plus 图标组件名
}
export interface MenuGroup {
  group: string
  items: MenuItem[]
}

export const menuConfig: MenuGroup[] = [
  {
    group: '数据初始',
    items: [
      { title: '概览', path: '/dashboard', icon: 'Odometer' },
      { title: '车辆信息', path: '/car', icon: 'Van' },
      { title: '厂商品牌', path: '/maker', icon: 'OfficeBuilding' },
      { title: '出租类型', path: '/rental-type', icon: 'PriceTag' },
    ],
  },
  {
    group: '日常业务',
    items: [
      { title: '汽车出租', path: '/rent', icon: 'Key' },
      { title: '车辆归还', path: '/return', icon: 'RefreshLeft' },
      { title: '订单总览', path: '/order', icon: 'Tickets' },
      { title: '客户管理', path: '/customer', icon: 'User' },
      { title: '违章处理', path: '/violation', icon: 'Warning' },
      { title: '车辆保养', path: '/maintain', icon: 'Tools' },
    ],
  },
  {
    group: '财务中心',
    items: [{ title: '财务报表', path: '/finance', icon: 'TrendCharts' }],
  },
  {
    group: '系统管理',
    items: [{ title: '权限管理', path: '/system', icon: 'Setting' }],
  },
]
