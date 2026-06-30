<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import PageHeader from '@/components/PageHeader.vue'
import StatCard from '@/components/StatCard.vue'
import GlassCard from '@/components/GlassCard.vue'
import FilterBar from '@/components/FilterBar.vue'
import FilterField from '@/components/FilterField.vue'
import FloatingPagination from '@/components/FloatingPagination.vue'
import StatusBadge from '@/components/StatusBadge.vue'
import { useAuthStore } from '@/stores/auth'
import { useOrderStore } from '@/stores/order'
import type { RentalOrder } from '@/types'

const store = useOrderStore()
const auth = useAuthStore()

// 过滤条件（单行：订单编号 / 车牌 / 姓名 / 电话）
const filters = reactive({ orderNo: '', plateNo: '', customerName: '', customerPhone: '' })
const page = reactive({ current: 1, size: 5 })

async function searchOrders() {
  await store.searchOrders({
    orderNo: filters.orderNo.trim() || undefined,
    plateNo: filters.plateNo.trim() || undefined,
    customerName: filters.customerName.trim() || undefined,
    customerPhone: filters.customerPhone.trim() || undefined,
    page: page.current,
    size: page.size,
  })
}

async function doSearch() {
  page.current = 1
  await searchOrders()
}

async function reset() {
  Object.assign(filters, { orderNo: '', plateNo: '', customerName: '', customerPhone: '' })
  page.current = 1
  await searchOrders()
}

async function changePage(current: number) {
  page.current = current
  await searchOrders()
}

onMounted(searchOrders)

// 仅取日期部分（表格密度）
const dateOnly = (s?: string) => (s ? s.slice(0, 10) : '')

// 详情弹窗
const dialog = ref(false)
const current = ref<RentalOrder | null>(null)
function openDetail(o: RentalOrder) {
  current.value = o
  dialog.value = true
}

async function returnDeposit(row: RentalOrder) {
  if (!auth.hasPermission('busi:order:returnDeposit')) return ElMessage.warning('当前账号没有该操作权限')
  if (!row.autoId) return
  const count = await store.countViolation(row.autoId)
  if (count > 0) {
    ElMessage.warning('该订单有未处理违章记录，请前往违章管理处理')
    return
  }
  await store.returnDeposit(row.id)
  ElMessage.success('押金返还完成')
  if (current.value?.id === row.id) current.value.depositReturn = 1
}
</script>

<template>
  <div class="paged-view">
    <div class="space-y-6">
      <PageHeader title="订单总览" subtitle="全部租赁订单的状态与明细" />

      <div class="grid grid-cols-4 gap-5">
        <StatCard label="订单总数" :value="store.overviewTotal" suffix="单" icon="Tickets" tone="brand" />
        <StatCard label="租用中" :value="store.rentingCount" suffix="单" icon="Loading" tone="green" />
        <StatCard label="已归还" :value="store.returnedCount" suffix="单" icon="CircleCheck" tone="purple" />
        <StatCard label="待返押金" :value="store.depositPendingCount" suffix="单" icon="Warning" tone="orange" />
      </div>

      <FilterBar @search="doSearch" @reset="reset">
        <FilterField label="订单编号">
          <el-input v-model="filters.orderNo" placeholder="请输入订单编号" class="w-44" />
        </FilterField>
        <FilterField label="车牌号码">
          <el-input v-model="filters.plateNo" placeholder="请输入车牌" class="w-40" />
        </FilterField>
        <FilterField label="客户姓名">
          <el-input v-model="filters.customerName" placeholder="请输入姓名" class="w-36" />
        </FilterField>
        <FilterField label="联系电话">
          <el-input v-model="filters.customerPhone" placeholder="请输入电话" class="w-40" />
        </FilterField>
      </FilterBar>

      <GlassCard>
        <el-table :data="store.list" class="glass-table" show-overflow-tooltip>
        <el-table-column prop="plateNo" label="车牌号码" min-width="96" />
        <el-table-column prop="customerName" label="客户姓名" min-width="72" />
        <el-table-column label="出租时间" width="120">
          <template #default="{ row }">{{ dateOnly(row.startDate) }}</template>
        </el-table-column>
        <el-table-column label="归还时间" width="120">
          <template #default="{ row }">
            <span v-if="row.returnTime">{{ dateOnly(row.returnTime) }}</span>
            <span v-else class="text-ink-muted">—</span>
          </template>
        </el-table-column>
        <el-table-column label="出租类型" min-width="96">
          <template #default="{ row }">
            <div class="flex items-center gap-2">
              <span class="text-ink">{{ row.rentalType }}</span>
              <StatusBadge :text="`${row.discount}%`" :tone="row.discount < 90 ? 'danger' : row.discount < 100 ? 'warning' : 'success'" />
            </div>
          </template>
        </el-table-column>
        <el-table-column label="车辆押金" min-width="82">
          <template #default="{ row }">¥{{ row.deposit.toLocaleString() }}</template>
        </el-table-column>
        <el-table-column label="起租里程" min-width="88">
          <template #default="{ row }">{{ row.startMileage.toLocaleString() }}</template>
        </el-table-column>
        <el-table-column label="归还里程" min-width="88">
          <template #default="{ row }">
            <span v-if="row.returnMileage != null">{{ row.returnMileage.toLocaleString() }}</span>
            <span v-else class="text-ink-muted">—</span>
          </template>
        </el-table-column>
        <el-table-column label="应付费用" min-width="82">
          <template #default="{ row }">¥{{ row.amount.toLocaleString() }}</template>
        </el-table-column>
        <el-table-column label="实付费用" min-width="82">
          <template #default="{ row }">
            <span v-if="row.paid != null" class="font-medium text-statusOk">¥{{ row.paid.toLocaleString() }}</span>
            <span v-else class="text-ink-muted">—</span>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="82">
          <template #default="{ row }">
            <div class="flex justify-center gap-1">
              <button v-if="auth.hasPermission('busi:order:detail')" class="flex h-7 w-7 items-center justify-center rounded-full bg-brand/10 text-brand hover:bg-brand/20" title="详情" @click="openDetail(row)">
                <el-icon><View /></el-icon>
              </button>
              <button
                v-if="row.depositReturn === 0 && row.returnTime && auth.hasPermission('busi:order:returnDeposit')"
                class="flex h-7 w-7 items-center justify-center rounded-full bg-danger/10 text-danger hover:bg-danger/20"
                title="押金返还"
                @click="returnDeposit(row)"
              >
                <el-icon><Wallet /></el-icon>
              </button>
            </div>
          </template>
        </el-table-column>
        </el-table>
      </GlassCard>
    </div>

    <FloatingPagination v-model:current-page="page.current" :total="store.totalCount" :page-size="page.size" @change="changePage" />

    <!-- 订单详情弹窗 -->
    <el-dialog v-model="dialog" title="订单详情" width="640px" align-center>
      <div v-if="current" class="grid grid-cols-2 gap-x-6 gap-y-3.5">
        <div><p class="text-xs text-ink-label">订单编号</p><p class="mt-0.5 text-sm font-medium text-ink">{{ current.orderNo }}</p></div>
        <div><p class="text-xs text-ink-label">车牌号码</p><p class="mt-0.5 text-sm font-medium text-ink">{{ current.plateNo }}</p></div>
        <div><p class="text-xs text-ink-label">客户姓名</p><p class="mt-0.5 text-sm font-medium text-ink">{{ current.customerName }}</p></div>
        <div><p class="text-xs text-ink-label">客户电话</p><p class="mt-0.5 text-sm font-medium text-ink">{{ current.customerPhone }}</p></div>
        <div><p class="text-xs text-ink-label">出租时间</p><p class="mt-0.5 text-sm font-medium text-ink">{{ current.startDate }}</p></div>
        <div><p class="text-xs text-ink-label">出租类型</p><p class="mt-0.5 text-sm font-medium text-ink">{{ current.rentalType }}</p></div>
        <div><p class="text-xs text-ink-label">享受折扣</p><p class="mt-0.5 text-sm font-medium text-ink">{{ current.discount }}%</p></div>
        <div><p class="text-xs text-ink-label">日租金额</p><p class="mt-0.5 text-sm font-medium text-ink">¥{{ current.dayRent }}</p></div>
        <div><p class="text-xs text-ink-label">车辆押金</p><p class="mt-0.5 text-sm font-medium text-ink">¥{{ current.deposit.toLocaleString() }}</p></div>
        <div><p class="text-xs text-ink-label">起租里程</p><p class="mt-0.5 text-sm font-medium text-ink">{{ current.startMileage.toLocaleString() }} km</p></div>
        <div>
          <p class="text-xs text-ink-label">归还时间</p>
          <p class="mt-0.5 text-sm font-medium text-ink">{{ current.returnTime || '—' }}</p>
        </div>
        <div>
          <p class="text-xs text-ink-label">归还里程</p>
          <p class="mt-0.5 text-sm font-medium text-ink">{{ current.returnMileage != null ? current.returnMileage.toLocaleString() + ' km' : '—' }}</p>
        </div>
        <div><p class="text-xs text-ink-label">应付金额</p><p class="mt-0.5 text-base font-semibold text-ink">¥{{ current.amount.toLocaleString() }}</p></div>
        <div>
          <p class="text-xs text-ink-label">实付金额</p>
          <p class="mt-0.5 text-base font-semibold text-brand">{{ current.paid != null ? '¥' + current.paid.toLocaleString() : '—' }}</p>
        </div>
        <div>
          <p class="text-xs text-ink-label">押金返还</p>
          <p class="mt-0.5 text-sm font-medium" :class="current.depositReturn === 1 ? 'text-statusOk' : 'text-ink-muted'">
            {{ current.depositReturn === 1 ? '¥' + current.deposit.toLocaleString() + '（已返还）' : '未返还' }}
          </p>
        </div>
      </div>
      <template #footer>
        <button class="btn-brand h-10 px-6 text-sm" @click="dialog = false">关闭</button>
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
