import { createRouter, createWebHistory } from 'vue-router'
import { clearToken, getToken } from '@/api/http'
import { useAuthStore } from '@/stores/auth'
import { normalizePath } from '@/utils/routeCompat'

const AppLayout = () => import('@/layout/AppLayout.vue')
const SystemView = () => import('@/views/System.vue')
const ToolsView = () => import('@/views/Tools.vue')

const router = createRouter({
  history: createWebHistory(),
  routes: [
    { path: '/login', name: 'login', component: () => import('@/views/Login.vue') },
    {
      path: '/',
      component: AppLayout,
      redirect: '/dashboard',
      children: [
        { path: 'dashboard', name: 'dashboard', component: () => import('@/views/Dashboard.vue'), meta: { title: '概览' } },
        { path: 'maker', alias: ['/auto/maker/makerList', '/auto/brand/brandList'], name: 'maker', component: () => import('@/views/MakerBrand.vue'), meta: { title: '厂商品牌' } },
        { path: 'car', alias: '/auto/info/autoInfoList', name: 'car', component: () => import('@/views/CarInfo.vue'), meta: { title: '车辆信息' } },
        { path: 'rental-type', alias: '/auto/rentalType/rentalTypeList', name: 'rental-type', component: () => import('@/views/RentalType.vue'), meta: { title: '出租类型' } },
        { path: 'rent', alias: '/busi/rental/rentalList', name: 'rent', component: () => import('@/views/CarRent.vue'), meta: { title: '汽车出租' } },
        { path: 'return', alias: '/busi/rental/returnList', name: 'return', component: () => import('@/views/CarReturn.vue'), meta: { title: '车辆归还' } },
        { path: 'order', alias: '/busi/rental/orderList', name: 'order', component: () => import('@/views/OrderList.vue'), meta: { title: '订单总览' } },
        { path: 'customer', alias: '/busi/customer/customerList', name: 'customer', component: () => import('@/views/Customer.vue'), meta: { title: '客户管理' } },
        { path: 'violation', alias: '/busi/violation/violationList', name: 'violation', component: () => import('@/views/Violation.vue'), meta: { title: '违章处理' } },
        { path: 'maintain', alias: '/busi/maintain/maintainList', name: 'maintain', component: () => import('@/views/Maintain.vue'), meta: { title: '车辆保养' } },
        { path: 'finance', name: 'finance', component: () => import('@/views/Finance.vue'), meta: { title: '财务报表' } },
        { path: 'finance/dayReport', name: 'finance-day-report', component: () => import('@/views/FinanceReport.vue'), props: { mode: 'day' }, meta: { title: '财务日报' } },
        { path: 'finance/monthReport', name: 'finance-month-report', component: () => import('@/views/FinanceReport.vue'), props: { mode: 'month' }, meta: { title: '财务月报' } },
        { path: 'excel/export-excel', name: 'excel-export', component: ToolsView, meta: { title: 'Excel 导出' } },
        { path: 'excel/export-selected-excel', name: 'excel-export-selected', component: ToolsView, meta: { title: '选中导出' } },
        { path: 'excel/export-merge-header', name: 'excel-export-merge', component: ToolsView, meta: { title: '合并表头导出' } },
        { path: 'excel/upload-excel', name: 'excel-upload', component: ToolsView, meta: { title: 'Excel 上传' } },
        { path: 'zip/download', name: 'zip-download', component: ToolsView, meta: { title: 'Zip 导出' } },
        { path: 'pdf/download', name: 'pdf-download', component: ToolsView, meta: { title: 'PDF 打印' } },
        { path: 'system', alias: '/system/system', name: 'system', component: SystemView, meta: { title: '权限管理' } },
        { path: 'system/user/userList', name: 'system-user', component: SystemView, meta: { title: '用户管理', tab: 'user' } },
        { path: 'system/dept/deptList', name: 'system-dept', component: SystemView, meta: { title: '部门管理', tab: 'dept' } },
        { path: 'system/role/roleList', name: 'system-role', component: SystemView, meta: { title: '角色管理', tab: 'role' } },
        { path: 'system/permission/perr', name: 'system-menu', component: SystemView, meta: { title: '菜单管理', tab: 'menu' } },
      ],
    },
  ],
})

router.beforeEach(async (to) => {
  if (to.path === '/login') return true

  if (!getToken()) {
    return { path: '/login', query: { redirect: to.fullPath } }
  }

  const auth = useAuthStore()
  try {
    await auth.load()
  } catch {
    auth.reset()
    clearToken()
    return { path: '/login', query: { redirect: to.fullPath } }
  }

  const normalized = auth.resolvePath(to.path) || normalizePath(to.path) || to.path
  if (normalized !== to.path && auth.canAccessPath(normalized)) {
    return { path: normalized, query: to.query, hash: to.hash }
  }
  if (normalized === '/system') return auth.firstSystemPath || auth.firstPath
  if (!auth.canAccessPath(to.path)) return auth.firstPath
  return true
})

export default router
