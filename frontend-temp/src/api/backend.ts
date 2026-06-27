import { http } from './http'
import type {
  Brand,
  CarInfo,
  Customer,
  Maintain,
  MaintainCandidate,
  Maker,
  PageResult,
  RentalOrder,
  RentalType,
  SysDept,
  SysPermission,
  SysRole,
  SysUser,
  Violation,
} from '@/types'

type Page<T> = { records: T[]; total: number }
type AnyObj = Record<string, any>
type UserSearchParams = Partial<SysUser> & { page?: number; size?: number }
type RoleSearchParams = Partial<SysRole> & { page?: number; size?: number; createrId?: number }
type OrderSearchParams = Partial<RentalOrder> & { page?: number; size?: number }
type BrandSearchParams = Partial<Brand> & { page?: number; size?: number }
type CarSearchParams = Partial<CarInfo> & { page?: number; size?: number; rentMin?: number; rentMax?: number; lowRegistrationDate?: string; highRegistrationDate?: string }
type CustomerSearchParams = Partial<Customer> & { page?: number; size?: number; ageMin?: number; ageMax?: number }
type MaintainSearchParams = Partial<Maintain> & { page?: number; size?: number }
type ViolationSearchParams = Partial<Violation> & { page?: number; size?: number; fineMin?: number; fineMax?: number; lowViolationTime?: string; highViolationTime?: string }

const page = <T>(p: Page<T>): PageResult<T> => ({ list: p?.records ?? [], total: p?.total ?? 0 })
const userPage = (p: Page<AnyObj>): PageResult<SysUser> => ({ list: p?.records?.map(mapUser) ?? [], total: p?.total ?? 0 })
const rolePage = (p: Page<AnyObj>): PageResult<SysRole> => ({ list: p?.records?.map(mapRole) ?? [], total: p?.total ?? 0 })
const orderPage = (p: Page<AnyObj>): PageResult<RentalOrder> => ({ list: p?.records?.map(mapOrder) ?? [], total: p?.total ?? 0 })
const maintainPage = (p: Page<AnyObj>): PageResult<Maintain> => ({ list: p?.records?.map(mapMaintain) ?? [], total: p?.total ?? 0 })
const violationPage = (p: Page<AnyObj>): PageResult<Violation> => ({ list: p?.records?.map(mapViolation) ?? [], total: p?.total ?? 0 })
const yn = (v: unknown) => v === true || v === 1
const currentUserId = async () => Number((await http.get<AnyObj>('/rental/auth/info')).id ?? 0)

export const carStatus = {
  toUi: (v: unknown): CarInfo['status'] => (v === 1 ? 'renting' : v === 2 ? 'maintain' : v === 3 ? 'selfUse' : 'idle'),
  toApi: (v: CarInfo['status']) => (v === 'renting' ? 1 : v === 'maintain' ? 2 : v === 'selfUse' ? 3 : 0),
}

export const api = {
  auth: {
    info: () => http.get<AnyObj>('/rental/auth/info'),
    menuList: () => http.get<AnyObj[]>('/rental/auth/menuList'),
  },
  dashboard: {
    overview: () => http.get<AnyObj>('/rental/dashboard/overview'),
  },
  makers: {
    all: async () => (await http.get<AnyObj[]>('/rental/autoMaker')).map(mapMaker),
    search: async () => page(await http.post<Page<AnyObj>>('/rental/autoMaker/1/999', {})).list.map(mapMaker),
    save: (m: Partial<Maker>) => http.post<void>('/rental/autoMaker', makerToApi(m)),
    update: (m: Partial<Maker>) => http.put<void>('/rental/autoMaker', makerToApi(m)),
    delete: (ids: number[]) => http.delete<void>(`/rental/autoMaker/${ids.join(',')}`),
  },
  brands: {
    search: async (params: BrandSearchParams = {}) => {
      const { page: current = 1, size = 999, ...filters } = params
      return page(await http.post<Page<AnyObj>>(`/rental/autoBrand/${current}/${size}`, brandSearchToApi(filters))).list.map(mapBrand)
    },
    byMaker: async (makerId: number) => (await http.get<AnyObj[]>(`/rental/autoBrand/maker/${makerId}`)).map(mapBrand),
    save: (b: Partial<Brand>) => http.post<void>('/rental/autoBrand', { mid: b.makerId, brandName: b.name }),
    update: (b: Partial<Brand>) => http.put<void>('/rental/autoBrand', { id: b.id, mid: b.makerId, brandName: b.name }),
    delete: (ids: number[]) => http.delete<void>(`/rental/autoBrand/${ids.join(',')}`),
  },
  cars: {
    search: async (params: CarSearchParams = {}) => {
      const { page: current = 1, size = 999, ...filters } = params
      return page(await http.post<Page<AnyObj>>(`/rental/autoInfo/${current}/${size}`, carSearchToApi(filters))).list.map(mapCar)
    },
    exists: async (plateNo: string) => (await http.resultPost<null>('/rental/autoInfo/exist', { autoNum: plateNo })).message === 'have',
    toBeMaintain: async () => (await http.get<AnyObj[]>('/rental/autoInfo/toBeMaintain')).map(mapMaintainCandidate),
    save: (c: Partial<CarInfo>) => http.post<void>('/rental/autoInfo', carToApi(c)),
    update: (c: Partial<CarInfo>) => http.put<void>('/rental/autoInfo', carToApi(c)),
    delete: (ids: number[]) => http.delete<void>(`/rental/autoInfo/${ids.join(',')}`),
  },
  rentalTypes: {
    all: async () => (await http.get<AnyObj[]>('/rental/rentalType')).map(mapRentalType),
    search: async () => page(await http.post<Page<AnyObj>>('/rental/rentalType/1/999', {})).list.map(mapRentalType),
    save: (t: Partial<RentalType>) => http.post<void>('/rental/rentalType', rentalTypeToApi(t)),
    update: (t: Partial<RentalType>) => http.put<void>('/rental/rentalType', rentalTypeToApi(t)),
    delete: (ids: number[]) => http.delete<void>(`/rental/rentalType/${ids.join(',')}`),
  },
  customers: {
    search: async (params: CustomerSearchParams = {}) => {
      const { page: current = 1, size = 999, ...filters } = params
      return page(await http.post<Page<AnyObj>>(`/rental/customer/${current}/${size}`, customerSearchToApi(filters))).list.map(mapCustomer)
    },
    byPhone: async (phone: string) => {
      const data = await http.post<AnyObj | null>('/rental/customer/tel', { tel: phone })
      return data ? mapCustomer(data) : null
    },
    save: (c: Partial<Customer>) => http.post<number>('/rental/customer', customerToApi(c)),
    update: (c: Partial<Customer>) => http.put<void>('/rental/customer', customerToApi(c)),
    delete: (ids: number[]) => http.delete<void>(`/rental/customer/${ids.join(',')}`),
  },
  orders: {
    search: async (params: OrderSearchParams = {}) => {
      const { page: current = 1, size = 999, ...filters } = params
      return orderPage(await http.post<Page<AnyObj>>(`/rental/order/${current}/${size}`, orderSearchToApi(filters)))
    },
    unfinished: async (params: OrderSearchParams = {}) => {
      const { page: current = 1, size = 5, ...filters } = params
      return orderPage(await http.post<Page<AnyObj>>(`/rental/order/unfinished/${current}/${size}`, orderSearchToApi(filters)))
    },
    save: (o: AnyObj) => http.post<void>('/rental/order', o),
    update: (o: Partial<RentalOrder>) => http.put<void>('/rental/order', orderToApi(o)),
    countViolation: (autoId: number) => http.get<number>(`/rental/order/countViolation/${autoId}`),
    returnDeposit: (id: number) => http.get<void>(`/rental/order/doReturnDeposit/${id}`),
  },
  violations: {
    searchPage: async (params: ViolationSearchParams = {}) => {
      const { page: current = 1, size = 999, ...filters } = params
      return violationPage(await http.post<Page<AnyObj>>(`/rental/violation/${current}/${size}`, violationSearchToApi(filters)))
    },
    search: async (params: ViolationSearchParams = {}) => (await api.violations.searchPage(params)).list,
    save: (v: Partial<Violation>) => http.post<void>('/rental/violation', violationToApi(v)),
    update: (v: Partial<Violation>) => http.put<void>('/rental/violation', violationToApi(v)),
    delete: (ids: number[]) => http.delete<void>(`/rental/violation/${ids.join(',')}`),
  },
  maintains: {
    searchPage: async (params: MaintainSearchParams = {}) => {
      const { page: current = 1, size = 999, ...filters } = params
      return maintainPage(await http.post<Page<AnyObj>>(`/rental/maintain/${current}/${size}`, maintainSearchToApi(filters)))
    },
    search: async (params: MaintainSearchParams = {}) => (await api.maintains.searchPage(params)).list,
    save: (m: Partial<Maintain>) => http.post<void>('/rental/maintain', maintainToApi(m)),
    update: (m: Partial<Maintain>) => http.put<void>('/rental/maintain', maintainToApi(m)),
    delete: (ids: number[]) => http.delete<void>(`/rental/maintain/${ids.join(',')}`),
  },
  finance: {
    dayCost: () => http.get<AnyObj>('/rental/finance/countDayCost'),
    dayRental: () => http.get<[Array<string | number>, number[]]>('/rental/finance/countDayRental'),
    dayReturn: () => http.get<[Array<string | number>, number[]]>('/rental/finance/countDayReturn'),
    monthCost: () => http.get<AnyObj>('/rental/finance/countMonthCost'),
    monthRental: () => http.get<[Array<string | number>, number[]]>('/rental/finance/countMonthRental'),
    monthReturn: () => http.get<[Array<string | number>, number[]]>('/rental/finance/countMonthReturn'),
  },
  system: {
    users: async (params: UserSearchParams = {}) => {
      const { page: current = 1, size = 10, ...filters } = params
      return userPage(await http.post<Page<AnyObj>>(`/rental/user/${current}/${size}`, userSearchToApi(filters)))
    },
    depts: async () => (await http.get<AnyObj[]>('/rental/dept')).map(mapDept),
    searchDepts: async (deptName = '') => (await http.post<AnyObj[]>('/rental/dept', { deptName })).map(mapDept),
    roles: async (params: RoleSearchParams = {}) => {
      const { page: current = 1, size = 5, ...filters } = params
      const createrId = filters.createrId ?? await currentUserId()
      return rolePage(await http.post<Page<AnyObj>>(`/rental/role/${current}/${size}`, roleSearchToApi({ ...filters, createrId })))
    },
    allRoles: async () => (await http.get<AnyObj[]>('/rental/role')).map(mapRole),
    permissions: async () => (await http.get<AnyObj[]>('/rental/permission')).map(mapPermission),
    permissionTree: async () => (await http.get<AnyObj[]>('/rental/permission/tree')).map(mapPermission),
    rolePermissionTree: async (roleId: number) => {
      const user = await api.auth.info()
      const data = await http.get<AnyObj>(`/rental/role/permissionTrees?userId=${user.id}&roleId=${roleId}`)
      return { checkedList: (data.checkedList ?? []).map(Number), permissionList: (data.permissionList ?? []).map(mapPermission) }
    },
    saveUser: (u: Partial<SysUser>) => http.post<void>('/rental/user', userToApi(u)),
    updateUser: (u: Partial<SysUser>) => http.put<void>('/rental/user', userToApi(u)),
    deleteUser: (ids: number[]) => http.delete<void>(`/rental/user/${ids.join(',')}`),
    userRoleIds: (userId: number) => http.get<number[]>(`/rental/user/role/${userId}`),
    bindRole: (userId: number, roleIds: number[]) => http.get<void>(`/rental/user/bind/${userId}/${roleIds.join(',')}`),
    saveDept: (d: Partial<SysDept>) => http.post<void>('/rental/dept/save', deptToApi(d)),
    updateDept: (d: Partial<SysDept>) => http.put<void>('/rental/dept', deptToApi(d)),
    hasDeptChildren: async (id: number) => (await http.result<null>(`/rental/dept/${id}`)).message === '有',
    deleteDept: (id: number) => http.delete<void>(`/rental/dept/${id}`),
    saveRole: async (r: Partial<SysRole>) => http.post<void>('/rental/role', roleToApi({ ...r, createrId: r.createrId ?? await currentUserId() })),
    updateRole: async (r: Partial<SysRole>) => http.put<void>('/rental/role', roleToApi({ ...r, createrId: r.createrId ?? await currentUserId() })),
    hasRoleUser: async (id: number) => (await http.result<null>(`/rental/role/hasUser/${id}`)).message === '有',
    deleteRole: (ids: number[]) => http.delete<void>(`/rental/role/${ids.join(',')}`),
    assignPermission: (roleId: number, ids: number[]) => http.get<void>(`/rental/role/${roleId}/${ids.join(',')}`),
    savePermission: (p: Partial<SysPermission>) => http.post<void>('/rental/permission', permissionToApi(p)),
    updatePermission: (p: Partial<SysPermission>) => http.put<void>('/rental/permission', permissionToApi(p)),
    hasPermissionChildren: async (id: number) => (await http.result<null>(`/rental/permission/hasChildren/${id}`)).message === '有',
    deletePermission: (id: number) => http.delete<void>(`/rental/permission/${id}`),
  },
}

function mapMaker(x: AnyObj): Maker {
  const orderLetter = x.orderLetter ?? ''
  return { id: x.id, name: x.name ?? '', orderLetter, country: '中国', logo: (orderLetter || x.name || '').charAt(0).toUpperCase(), brandCount: 0, createTime: x.createTime?.slice?.(0, 10) ?? '' }
}

function mapBrand(x: AnyObj): Brand {
  return { id: x.id, makerId: x.mid ?? x.makerId ?? 0, makerName: x.makerName ?? '', name: x.brandName ?? x.name ?? '', initial: (x.brandName ?? x.name ?? '').charAt(0), modelCount: 0 }
}

function mapCar(x: AnyObj): CarInfo {
  return {
    id: x.id,
    makerId: x.makerId,
    brandId: x.brandId,
    plateNo: x.autoNum ?? '',
    makerName: x.makerName ?? '',
    brandName: x.brandName ?? '',
    carType: ['燃油车', '电动车', '混动车'][Number(x.infoType ?? 0)] ?? '燃油车',
    color: x.color ?? '',
    displacement: String(x.displacement ?? ''),
    displacementUnit: x.unit ?? '',
    registerDate: x.registrationDate ?? '',
    mileage: x.mileage ?? 0,
    dayRent: x.rent ?? 0,
    deposit: x.deposit ?? 0,
    status: carStatus.toUi(x.status),
    image: x.pic,
  }
}

function mapRentalType(x: AnyObj): RentalType {
  return { id: x.id, name: x.typeName ?? '', coefficient: x.typeDiscount ?? 1, discount: Math.round((x.typeDiscount ?? 1) * 100), remark: x.remark ?? '' }
}

function mapCustomer(x: AnyObj): Customer {
  return { id: x.id, name: x.name ?? '', gender: Number(x.gender) === 0 ? '女' : '男', age: x.age ?? 0, phone: x.tel ?? '', idCard: x.idNum ?? '', birthDate: x.birthday ?? '', orderCount: 0, listType: yn(x.status) ? 'white' : 'black', createTime: x.createTime?.slice?.(0, 10) ?? '' }
}

function mapOrder(x: AnyObj): RentalOrder {
  const returned = !!x.returnTime
  return {
    id: x.id,
    autoId: x.autoId,
    customerId: x.customerId,
    typeId: x.typeId,
    orderNo: x.orderNum ?? '',
    plateNo: x.autoNum ?? '',
    customerName: x.customerName ?? '',
    customerPhone: x.customerTel ?? '',
    rentalType: x.typeName ?? '',
    discount: Math.round((x.typeDiscount ?? 1) * 100),
    dayRent: x.rent ?? 0,
    startMileage: x.mileage ?? 0,
    startDate: x.rentalTime ?? '',
    endDate: x.returnTime ?? '',
    days: 0,
    amount: x.rentPayable ?? 0,
    deposit: x.deposit ?? 0,
    returnMileage: x.returnMileage,
    returnTime: x.returnTime,
    paid: x.rentActual,
    depositReturn: x.depositReturn ?? 0,
    status: returned ? 'returned' : 'renting',
  }
}

function mapViolation(x: AnyObj): Violation {
  return { id: x.id, autoId: x.autoId, plateNo: x.autoNum ?? '', time: x.violationTime ?? '', reason: x.reason ?? '', location: x.location ?? '', points: x.deductPoints ?? 0, fine: x.fine ?? 0, status: x.status === 1 ? 'handled' : 'pending' }
}

function mapMaintain(x: AnyObj): Maintain {
  return { id: x.id, autoId: x.autoId, plateNo: x.autoNum ?? '', time: x.maintainTime ?? '', location: x.location ?? '', item: x.item ?? '', cost: x.cost ?? 0, status: 'done' }
}

function mapMaintainCandidate(x: AnyObj): MaintainCandidate {
  return { id: x.id, plateNo: x.autoNum ?? '', expectedNum: x.expectedNum ?? 0, actualNum: x.actualNum ?? 0 }
}

function mapUser(x: AnyObj): SysUser {
  return { id: x.id, username: x.username ?? '', realName: x.realname ?? '', nickname: x.nickname ?? '', gender: Number(x.gender) === 0 ? '女' : '男', deptId: x.deptId ?? 0, deptName: x.deptName ?? '', phone: x.phone ?? '', email: x.email ?? '', avatar: x.avatar ?? '', roleName: '', enabled: x.enabled ?? x.isEnabled ?? true }
}

function mapDept(x: AnyObj): SysDept {
  return { id: x.id, name: x.deptName ?? '', parentId: x.pid ?? 0, parentName: x.parentName ?? '', orderNum: x.orderNum ?? 0, phone: x.phone ?? '', address: x.address ?? '', children: x.children?.map?.(mapDept) }
}

function mapRole(x: AnyObj): SysRole {
  return { id: x.id, name: x.roleName ?? '', code: x.roleCode ?? '', remark: x.remark ?? '', createrId: x.createrId, permIds: [] }
}

function mapPermission(x: AnyObj): SysPermission {
  return { id: x.id, name: x.permissionLable ?? '', parentId: x.pid ?? 0, parentLabel: x.parentLabel ?? '', type: x.permissionType === 2 ? 'button' : x.permissionType === 1 ? 'menu' : 'catalog', routeName: x.routeName ?? '', routePath: x.routePath ?? '', componentPath: x.routeUrl ?? '', icon: x.icon ?? '', permCode: x.permissionCode ?? '', children: x.children?.map?.(mapPermission) }
}

function carToApi(c: Partial<CarInfo>) {
  return { id: c.id, autoNum: c.plateNo, makerId: c.makerId, brandId: c.brandId, infoType: c.carType === '电动车' ? 1 : c.carType === '混动车' ? 2 : 0, color: c.color, displacement: Number(c.displacement) || 0, unit: c.displacementUnit, registrationDate: c.registerDate, mileage: c.mileage, rent: c.dayRent, pic: c.image, deposit: c.deposit, status: c.status ? carStatus.toApi(c.status) : undefined }
}
function makerToApi(m: Partial<Maker>) { return { id: m.id, name: m.name, orderLetter: m.orderLetter } }
function brandSearchToApi(b: Partial<Brand>) { return { mid: b.makerId || undefined, brandName: b.name || undefined } }
function carSearchToApi(c: CarSearchParams) {
  return {
    autoNum: c.plateNo || undefined,
    makerId: c.makerId || undefined,
    brandId: c.brandId || undefined,
    infoType: c.carType === '电动车' ? 1 : c.carType === '混动车' ? 2 : c.carType === '燃油车' ? 0 : undefined,
    status: c.status ? carStatus.toApi(c.status) : undefined,
    lowRent: c.rentMin,
    highRent: c.rentMax,
    lowRegistrationDate: c.lowRegistrationDate,
    highRegistrationDate: c.highRegistrationDate,
  }
}
function rentalTypeToApi(t: Partial<RentalType>) { return { id: t.id, typeName: t.name, typeDiscount: (t.discount ?? 100) / 100, remark: t.remark } }
function customerToApi(c: Partial<Customer>) { return { id: c.id, name: c.name, age: c.age, gender: c.gender === '女' ? 0 : 1, tel: c.phone, birthday: c.birthDate, idNum: c.idCard, status: c.listType !== 'black' } }
function customerSearchToApi(c: CustomerSearchParams) { return { name: c.name || undefined, tel: c.phone || undefined, idNum: c.idCard || undefined, lowAge: c.ageMin, highAge: c.ageMax, gender: c.gender === '女' ? 0 : c.gender === '男' ? 1 : undefined } }
function violationToApi(v: Partial<Violation>) { return { id: v.id, autoId: v.autoId, autoNum: v.plateNo, violationTime: v.time, reason: v.reason, location: v.location, deductPoints: v.points, fine: v.fine, status: v.status === 'handled' ? 1 : 0 } }
function violationSearchToApi(v: ViolationSearchParams) { return { autoNum: v.plateNo || undefined, reason: v.reason || undefined, location: v.location || undefined, lowFine: v.fineMin, highFine: v.fineMax, lowViolationTime: v.lowViolationTime, highViolationTime: v.highViolationTime, status: v.status === 'handled' ? 1 : v.status === 'pending' ? 0 : undefined } }
function maintainSearchToApi(m: Partial<Maintain>) { return { autoNum: m.plateNo || undefined, item: m.item || undefined, location: m.location || undefined } }
function maintainToApi(m: Partial<Maintain>) { return { id: m.id, autoId: m.autoId, autoNum: m.plateNo, maintainTime: m.time?.slice(0, 10), location: m.location, item: m.item, cost: m.cost } }
function orderSearchToApi(o: Partial<RentalOrder>) { return { orderNum: o.orderNo || undefined, autoNum: o.plateNo || undefined, customerName: o.customerName || undefined, customerTel: o.customerPhone || undefined } }
function orderToApi(o: Partial<RentalOrder>) {
  return {
    id: o.id,
    orderNum: o.orderNo,
    autoId: o.autoId,
    customerId: o.customerId,
    rentalTime: o.startDate,
    typeId: o.typeId,
    rent: o.dayRent,
    deposit: o.deposit,
    mileage: o.startMileage,
    returnTime: o.returnTime,
    returnMileage: o.returnMileage,
    rentPayable: o.amount,
    rentActual: o.paid,
    depositReturn: o.depositReturn,
  }
}
function userToApi(u: Partial<SysUser>) {
  const data: AnyObj = { id: u.id, username: u.username, realname: u.realName, nickname: u.nickname, gender: u.gender === '女' ? 0 : 1, deptId: u.deptId, deptName: u.deptName, phone: u.phone, email: u.email, avatar: u.avatar, isEnabled: u.enabled }
  if (!u.id) data.password = u.password
  return data
}
function userSearchToApi(u: Partial<SysUser>) { return { username: u.username || undefined, realname: u.realName || undefined, nickname: u.nickname || undefined, gender: u.gender === '女' ? 0 : u.gender === '男' ? 1 : undefined, deptId: u.deptId && u.deptId > 0 ? u.deptId : undefined, phone: u.phone || undefined, email: u.email || undefined } }
function deptToApi(d: Partial<SysDept>) { return { id: d.id, deptName: d.name, pid: d.parentId, parentName: d.parentName, orderNum: d.orderNum, phone: d.phone, address: d.address } }
function roleSearchToApi(r: RoleSearchParams) { return { roleName: r.name || undefined, createrId: r.createrId } }
function roleToApi(r: Partial<SysRole>) { return { id: r.id, roleName: r.name, roleCode: r.code, remark: r.remark, createrId: r.createrId } }
function permissionToApi(p: Partial<SysPermission>) { return { id: p.id, permissionLable: p.name, pid: p.parentId, parentLabel: p.parentLabel, permissionType: p.type === 'button' ? 2 : p.type === 'menu' ? 1 : 0, routeName: p.routeName, routePath: p.routePath, routeUrl: p.componentPath, icon: p.icon, permissionCode: p.permCode } }
