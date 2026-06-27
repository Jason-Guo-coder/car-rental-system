// 领域模型类型定义 —— 对齐后端 14 张表的 VO 结构
// 新前端领域模型，字段命名贴合后端实体和页面展示

/** 厂商 auto_maker */
export interface Maker {
  id: number
  name: string
  orderLetter: string
  country: string
  logo?: string
  brandCount: number
  createTime: string
}

/** 品牌 auto_brand */
export interface Brand {
  id: number
  makerId: number
  makerName: string
  name: string
  initial: string // 首字母，用于色块
  modelCount: number
}

/** 车辆信息 auto_info */
export interface CarInfo {
  id: number
  makerId?: number
  brandId?: number
  plateNo: string // 车牌号码
  makerName: string // 所属厂商
  brandName: string // 所属品牌
  carType: string // 车辆类型
  color: string // 车辆颜色
  displacement: string // 汽车排量
  displacementUnit: string // 排量单位
  registerDate: string // 上牌日期
  mileage: number // 行驶里程
  dayRent: number // 日租金额
  deposit: number // 车辆押金
  status: 'idle' | 'renting' | 'maintain' | 'selfUse' // 未租/出租中/保养中/自用
  image?: string
}

/** 客户 busi_customer */
export interface Customer {
  id: number
  name: string
  gender: '男' | '女'
  age: number
  phone: string
  idCard: string // 身份证
  birthDate: string // 出生日期 YYYY-MM-DD
  orderCount: number
  listType: 'white' | 'black' // 白名单/黑名单
  createTime: string
}

/** 出租类型 busi_rental_type */
export interface RentalType {
  id: number
  name: string // 类型名称
  coefficient: number // 系数
  discount: number // 折扣
  remark: string // 说明
}

/** 出租订单 busi_order */
export interface RentalOrder {
  id: number
  autoId?: number
  customerId?: number
  typeId?: number
  orderNo: string // 订单编号
  plateNo: string // 车牌
  customerName: string // 客户姓名
  customerPhone: string // 电话
  rentalType: string // 出租类型
  discount: number // 享受折扣（%）
  dayRent: number // 日租金额
  startMileage: number // 起租里程
  startDate: string // 出租日期
  endDate: string // 应还日期
  days: number
  amount: number // 应付金额（按合同天数计算）
  deposit: number // 车辆押金
  returnMileage?: number // 归还里程（归还后）
  returnTime?: string // 归还时间（归还后）
  paid?: number // 实付金额（按实际归还结算）
  depositReturn: number // 押金返还状态：0 未返还，1 已返还
  status: 'renting' | 'returned' | 'overdue' // 租用中/已归还/已逾期
}

/** 违章 busi_violation */
export interface Violation {
  id: number
  autoId?: number
  plateNo: string // 车牌
  time: string // 违章时间
  reason: string // 事由
  location: string // 地点
  points: number // 扣分
  fine: number // 罚款
  status: 'pending' | 'handled' // 待处理/已处理
}

/** 保养 busi_maintain */
export interface Maintain {
  id: number
  autoId?: number
  plateNo: string // 车牌
  time: string // 保养时间
  location: string // 地点
  item: string // 项目
  cost: number // 费用
  status: 'pending' | 'done' // 待保养/已保养
}

/** 待保养车辆下拉项 */
export interface MaintainCandidate {
  id: number
  plateNo: string
  expectedNum: number
  actualNum: number
}

/** 系统用户 sys_user */
export interface SysUser {
  id: number
  username: string // 用户账号
  realName: string // 真实姓名
  nickname: string // 用户昵称
  gender: '男' | '女' // 用户性别
  deptId: number // 所在部门 id（用于部门树联动）
  deptName: string // 所在部门
  phone: string // 用户电话
  email: string // 电子邮箱
  avatar?: string // 用户头像
  password?: string // 新增用户密码
  roleIds?: number[] // 绑定角色 id
  roleName: string // 绑定角色
  enabled: boolean
}

/** 部门 sys_dept（树形） */
export interface SysDept {
  id: number
  name: string // 部门名称
  parentId: number
  parentName: string // 上级部门名称
  orderNum: number // 排序号
  phone: string // 部门电话
  address: string // 部门地址
  children?: SysDept[]
}

/** 角色 sys_role */
export interface SysRole {
  id: number
  name: string
  code: string // 角色标识
  remark: string // 说明
  createrId?: number // 创建人 id
  permIds: number[] // 已分配的权限 id 列表
}

/** 菜单/权限 sys_permission（树形） */
export interface SysPermission {
  id: number
  name: string // 菜单名称
  parentId: number // 上级菜单 id（0 = 顶级）
  parentLabel: string // 上级菜单名称
  type: 'catalog' | 'menu' | 'button' // 根目录/菜单/按钮
  routeName: string // 路由名称
  routePath: string // 路由地址
  componentPath: string // 组件路径
  icon: string // 菜单图标（Element Plus 图标组件名）
  permCode: string // 权限标识
  children?: SysPermission[]
}

/** 分页查询通用结果 */
export interface PageResult<T> {
  list: T[]
  total: number
}
