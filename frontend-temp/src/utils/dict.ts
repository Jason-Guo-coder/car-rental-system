/** 状态码 → 显示文案 + 徽章色调 的集中字典，供各视图复用 */
type Tone = 'success' | 'warning' | 'danger' | 'info' | 'primary'
interface Meta {
  text: string
  tone: Tone
}

/** 订单状态 */
export const orderStatusMeta: Record<string, Meta> = {
  renting: { text: '租用中', tone: 'primary' },
  returned: { text: '已归还', tone: 'success' },
  overdue: { text: '已逾期', tone: 'danger' },
}

/** 车辆状态 */
export const carStatusMeta: Record<string, Meta> = {
  idle: { text: '未租', tone: 'success' },
  renting: { text: '出租中', tone: 'primary' },
  maintain: { text: '保养中', tone: 'warning' },
  selfUse: { text: '自用', tone: 'info' },
}

/** 违章状态 */
export const violationStatusMeta: Record<string, Meta> = {
  pending: { text: '待处理', tone: 'warning' },
  handled: { text: '已处理', tone: 'success' },
}

/** 保养状态 */
export const maintainStatusMeta: Record<string, Meta> = {
  pending: { text: '待保养', tone: 'warning' },
  done: { text: '已保养', tone: 'success' },
}

/** 客户名单类型 */
export const customerListMeta: Record<string, Meta> = {
  white: { text: '白名单', tone: 'success' },
  black: { text: '黑名单', tone: 'danger' },
}

/** 权限类型 */
export const permTypeMeta: Record<string, Meta> = {
  catalog: { text: '根目录', tone: 'primary' },
  menu: { text: '菜单', tone: 'info' },
  button: { text: '按钮', tone: 'warning' },
}
