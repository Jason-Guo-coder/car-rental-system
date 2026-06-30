<script setup lang="ts">
import { ref, reactive, computed, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import PageHeader from '@/components/PageHeader.vue'
import GlassCard from '@/components/GlassCard.vue'
import FilterBar from '@/components/FilterBar.vue'
import FilterField from '@/components/FilterField.vue'
import FloatingPagination from '@/components/FloatingPagination.vue'
import StatusBadge from '@/components/StatusBadge.vue'
import { useAppliedFilter } from '@/composables/useAppliedFilter'
import { useAuthStore } from '@/stores/auth'
import { useOrderStore } from '@/stores/order'
import type { RentalOrder } from '@/types'

const store = useOrderStore()
const auth = useAuthStore()

// 过滤：订单编号 / 车牌 / 姓名 / 电话（点击查询才生效）
const { form, applied, doSearch: applySearch, reset: resetFilter } = useAppliedFilter(() => ({
  orderNo: '',
  plateNo: '',
  customerName: '',
  customerPhone: '',
}))

const page = reactive({ current: 1, size: 5 })

async function searchUnfinished() {
  await store.searchUnfinished({
    ...applied,
    page: page.current,
    size: page.size,
  })
}

async function doSearch() {
  applySearch()
  page.current = 1
  await searchUnfinished()
}

async function reset() {
  resetFilter()
  page.current = 1
  await searchUnfinished()
}

async function changePage(current: number) {
  page.current = current
  await searchUnfinished()
}

onMounted(searchUnfinished)

function k2(v: number) {
  return v >= 10 ? String(v) : `0${v}`
}

function getDateTime() {
  const d = new Date()
  return `${d.getFullYear()}-${k2(d.getMonth() + 1)}-${k2(d.getDate())} ${k2(d.getHours())}:${k2(d.getMinutes())}:${k2(d.getSeconds())}`
}

// 与旧前端一致：按完整时间差向上取整，不只截日期。
function daysBetween(start: string, end: string): number {
  const s = new Date(start).getTime()
  const e = new Date(end).getTime()
  return Math.ceil(Math.abs(e - s) / 86400000)
}

// 办理归还弹窗
const dialog = ref(false)
const current = ref<RentalOrder | null>(null)
const returnForm = reactive({ returnMileage: undefined as number | undefined, returnTime: '' })

// 应付金额：按实际归还时间结算 = 日租 × 实际天数
const payable = computed(() => {
  const o = current.value
  if (!o || !returnForm.returnTime) return 0
  return daysBetween(o.startDate, returnForm.returnTime) * o.dayRent
})

// 实付金额：按实际归还时间结算 = 日租 × 实际天数 × 折扣
const paid = computed(() => {
  const o = current.value
  if (!o) return 0
  return Math.trunc(payable.value * (o.discount / 100))
})

function openReturn(o: RentalOrder) {
  if (!auth.hasPermission('busi:return:return')) return ElMessage.warning('当前账号没有该操作权限')
  current.value = o
  returnForm.returnMileage = undefined
  returnForm.returnTime = getDateTime()
  dialog.value = true
}

async function confirmReturn() {
  if (!auth.hasPermission('busi:return:return')) return ElMessage.warning('当前账号没有该操作权限')
  if (returnForm.returnMileage == null) return ElMessage.warning('请填写归还里程')
  if (!returnForm.returnTime) return ElMessage.warning('请选择归还时间')
  if (current.value && returnForm.returnMileage <= current.value.startMileage) {
    return ElMessage.warning('还车里程必须大于起租里程')
  }
  await store.returnCar(current.value!.id, {
    returnMileage: returnForm.returnMileage,
    returnTime: returnForm.returnTime,
    payable: payable.value,
    paid: paid.value,
  })
  ElMessage.success('归还成功')
  dialog.value = false
}
</script>

<template>
  <div class="paged-view">
    <div class="space-y-6">
      <PageHeader title="车辆归还" subtitle="办理进行中订单的车辆归还与押金结算" />

      <FilterBar @search="doSearch" @reset="reset">
        <FilterField label="订单编号" :grow="1.4">
          <el-input v-model="form.orderNo" placeholder="请输入订单编号" class="w-full" />
        </FilterField>
        <FilterField label="车牌号码" :grow="1">
          <el-input v-model="form.plateNo" placeholder="请输入车牌" class="w-full" />
        </FilterField>
        <FilterField label="客户姓名" :grow="1">
          <el-input v-model="form.customerName" placeholder="请输入姓名" class="w-full" />
        </FilterField>
        <FilterField label="联系电话" :grow="1">
          <el-input v-model="form.customerPhone" placeholder="请输入电话" class="w-full" />
        </FilterField>
      </FilterBar>

      <GlassCard>
        <el-table :data="store.returnList" class="glass-table">
        <el-table-column prop="orderNo" label="订单编号" min-width="150" />
        <el-table-column prop="plateNo" label="车牌号码" min-width="110" />
        <el-table-column prop="customerName" label="客户姓名" min-width="85" />
        <el-table-column prop="customerPhone" label="客户电话" min-width="130" />
        <el-table-column prop="startDate" label="出租时间" min-width="110" />
        <el-table-column label="出租类型" min-width="160">
          <template #default="{ row }">
            <div class="flex items-center justify-between gap-2 pr-3">
              <span class="text-ink">{{ row.rentalType }}</span>
              <StatusBadge :text="`${row.discount}%`" :tone="row.discount < 90 ? 'danger' : row.discount < 100 ? 'warning' : 'success'" />
            </div>
          </template>
        </el-table-column>
        <el-table-column label="日租金额" min-width="95">
          <template #default="{ row }">¥{{ row.dayRent }}</template>
        </el-table-column>
        <el-table-column label="车辆押金" min-width="100">
          <template #default="{ row }">¥{{ row.deposit.toLocaleString() }}</template>
        </el-table-column>
        <el-table-column label="起租里程" min-width="110">
          <template #default="{ row }">{{ row.startMileage.toLocaleString() }} km</template>
        </el-table-column>
        <el-table-column label="操作" width="110">
          <template #default="{ row }">
            <button v-if="auth.hasPermission('busi:return:return')" class="btn-brand h-8 px-4 text-xs" @click="openReturn(row)">办理归还</button>
          </template>
        </el-table-column>
        </el-table>
        <el-empty v-if="!store.returnList.length" description="暂无待归还的订单" />
      </GlassCard>
    </div>

    <FloatingPagination v-model:current-page="page.current" :total="store.returnTotal" :page-size="page.size" @change="changePage" />

    <!-- 办理归还弹窗 -->
    <el-dialog v-model="dialog" title="办理车辆归还" width="640px" align-center>
      <div v-if="current" class="grid grid-cols-2 gap-x-6 gap-y-3.5">
        <!-- 只读信息 -->
        <div><p class="text-xs text-ink-label">订单编号</p><p class="mt-0.5 text-sm font-medium text-ink">{{ current.orderNo }}</p></div>
        <div><p class="text-xs text-ink-label">车牌号码</p><p class="mt-0.5 text-sm font-medium text-ink">{{ current.plateNo }}</p></div>
        <div><p class="text-xs text-ink-label">客户姓名</p><p class="mt-0.5 text-sm font-medium text-ink">{{ current.customerName }}</p></div>
        <div><p class="text-xs text-ink-label">客户电话</p><p class="mt-0.5 text-sm font-medium text-ink">{{ current.customerPhone }}</p></div>
        <div><p class="text-xs text-ink-label">起租里程</p><p class="mt-0.5 text-sm font-medium text-ink">{{ current.startMileage.toLocaleString() }} km</p></div>
        <div><p class="text-xs text-ink-label">出租时间</p><p class="mt-0.5 text-sm font-medium text-ink">{{ current.startDate }}</p></div>
        <div><p class="text-xs text-ink-label">出租类型</p><p class="mt-0.5 text-sm font-medium text-ink">{{ current.rentalType }}</p></div>
        <div><p class="text-xs text-ink-label">享受折扣</p><p class="mt-0.5 text-sm font-medium text-ink">{{ current.discount }}%</p></div>
        <div><p class="text-xs text-ink-label">日租金额</p><p class="mt-0.5 text-sm font-medium text-ink">¥{{ current.dayRent }}</p></div>
        <div><p class="text-xs text-ink-label">车辆押金</p><p class="mt-0.5 text-sm font-medium text-ink">¥{{ current.deposit.toLocaleString() }}</p></div>

        <!-- 必填项 -->
        <div>
          <label class="mb-1.5 block text-xs text-ink-label"><span class="text-danger">*</span> 归还里程（km）</label>
          <el-input v-model.number="returnForm.returnMileage" placeholder="请输入归还里程" />
        </div>
        <div>
          <label class="mb-1.5 block text-xs text-ink-label"><span class="text-danger">*</span> 归还时间</label>
          <el-date-picker v-model="returnForm.returnTime" type="datetime" placeholder="请选择归还时间" value-format="YYYY-MM-DD HH:mm:ss" class="!w-full" />
        </div>

        <!-- 计算金额 -->
        <div><p class="text-xs text-ink-label">应付金额</p><p class="mt-0.5 text-base font-semibold text-ink">¥{{ payable.toLocaleString() }}</p></div>
        <div><p class="text-xs text-ink-label">实付金额（按实际归还结算）</p><p class="mt-0.5 text-base font-semibold text-brand">¥{{ paid.toLocaleString() }}</p></div>
      </div>

      <template #footer>
        <button class="btn-ghost h-10 px-5 text-sm" @click="dialog = false">取消</button>
        <button v-if="auth.hasPermission('busi:return:return')" class="btn-brand ml-3 h-10 px-6 text-sm" @click="confirmReturn">确认归还</button>
      </template>
    </el-dialog>
  </div>
</template>

<style scoped>
.paged-view {
  position: relative;
  margin-bottom: 76px;
}

.paged-view :deep(.floating-pagination-wrap) {
  top: calc(100% + 8px);
}
</style>
