<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import PageHeader from '@/components/PageHeader.vue'
import StatCard from '@/components/StatCard.vue'
import GlassCard from '@/components/GlassCard.vue'
import FilterBar from '@/components/FilterBar.vue'
import FilterField from '@/components/FilterField.vue'
import FloatingPagination from '@/components/FloatingPagination.vue'
import StatusBadge from '@/components/StatusBadge.vue'
import BatchDeleteButton from '@/components/BatchDeleteButton.vue'
import SelectCheckbox from '@/components/SelectCheckbox.vue'
import CircleIconButton from '@/components/CircleIconButton.vue'
import { useAppliedFilter } from '@/composables/useAppliedFilter'
import { useBatchDelete } from '@/composables/useBatchDelete'
import { api } from '@/api/backend'
import { useAuthStore } from '@/stores/auth'
import { useViolationStore } from '@/stores/violation'
import { violationStatusMeta } from '@/utils/dict'
import type { Violation } from '@/types'

const store = useViolationStore()
const auth = useAuthStore()
const page = reactive({ current: 1, size: 5 })

// 多字段过滤：车牌/事由/地点/罚款区间/日期范围/状态（点击查询才生效）
const { form, applied, doSearch: applySearch, reset: resetFilter } = useAppliedFilter(() => ({
  plateNo: '',
  reason: '',
  location: '',
  fineMin: undefined as number | undefined,
  fineMax: undefined as number | undefined,
  dateRange: [] as string[],
  status: '',
}))

async function searchViolations() {
  await store.load({
    plateNo: applied.plateNo || undefined,
    reason: applied.reason || undefined,
    location: applied.location || undefined,
    fineMin: applied.fineMin,
    fineMax: applied.fineMax,
    status: applied.status as Violation['status'] | undefined,
    lowViolationTime: applied.dateRange?.[0],
    highViolationTime: applied.dateRange?.[1],
    page: page.current,
    size: page.size,
  })
}

async function doSearch() {
  applySearch()
  page.current = 1
  await searchViolations()
}

async function reset() {
  resetFilter()
  page.current = 1
  await searchViolations()
}
async function changePage(current: number) {
  page.current = current
  await searchViolations()
}
onMounted(searchViolations)

// 批量删除
const batch = useBatchDelete((ids) => store.removeMany(ids), '违章')

// 新增 / 编辑弹窗
const dialog = ref(false)
const isNew = ref(false)
const editing = reactive<Omit<Violation, 'id'> & { id?: number }>({
  plateNo: '', time: '', reason: '', location: '', points: 0, fine: 0, status: 'pending',
})

function openAdd() {
  if (!auth.hasPermission('busi:violation:add')) return ElMessage.warning('当前账号没有该操作权限')
  isNew.value = true
  Object.assign(editing, { id: undefined, plateNo: '', time: '', reason: '', location: '', points: 0, fine: 0, status: 'pending' })
  dialog.value = true
}
function openEdit(v: Violation) {
  if (!auth.hasPermission('busi:violation:edit')) return ElMessage.warning('当前账号没有该操作权限')
  isNew.value = false
  Object.assign(editing, v)
  dialog.value = true
}
async function save() {
  if (!auth.hasPermission(isNew.value ? 'busi:violation:add' : 'busi:violation:edit')) return ElMessage.warning('当前账号没有该操作权限')
  if (!editing.plateNo.trim()) return ElMessage.warning('请填写车牌号码')
  if (!editing.time) return ElMessage.warning('请选择违章时间')
  if (!editing.reason.trim()) return ElMessage.warning('请填写违章事由')
  if (!editing.location.trim()) return ElMessage.warning('请填写违章地点')
  const exists = await api.cars.exists(editing.plateNo.trim())
  if (!exists) return ElMessage.error('车牌号不存在')
  if (isNew.value) {
    const { id: _omit, ...rest } = editing
    await store.add(rest)
    ElMessage.success('新增违章成功')
  } else {
    await store.update(editing as Violation)
    ElMessage.success('保存成功')
  }
  dialog.value = false
}

function handle(v: Violation) {
  if (!auth.hasPermission('busi:violation:handle')) return ElMessage.warning('当前账号没有该操作权限')
  ElMessageBox.confirm(`确认将车牌 ${v.plateNo} 的违章标记为已处理？`, '处理违章', { type: 'warning', confirmButtonText: '确认', cancelButtonText: '取消' })
    .then(() => {
      store.handle(v.id)
      ElMessage.success('已标记为处理')
    })
    .catch(() => {})
}
function remove(v: Violation) {
  if (!auth.hasPermission('busi:violation:delete')) return ElMessage.warning('当前账号没有该操作权限')
  ElMessageBox.confirm('确认删除该违章记录？', '删除', { type: 'warning', confirmButtonText: '删除', cancelButtonText: '取消' })
    .then(() => {
      store.remove(v.id)
      ElMessage.success('已删除')
    })
    .catch(() => {})
}
</script>

<template>
  <div class="paged-view-tight space-y-6">
    <PageHeader title="违章处理" subtitle="车辆违章记录登记与处理跟踪" />

    <div class="grid grid-cols-3 gap-5">
      <StatCard label="违章总数" :value="store.overviewTotal" suffix="条" icon="Warning" tone="brand" />
      <StatCard label="待处理" :value="store.pendingCount" suffix="条" icon="Bell" tone="orange" />
      <StatCard label="累计罚款" :value="store.totalFine" suffix="元" icon="Money" tone="purple" />
    </div>

    <FilterBar @search="doSearch" @reset="reset">
      <FilterField label="车牌号码" :grow="1">
        <el-input v-model="form.plateNo" placeholder="车牌" class="w-full" />
      </FilterField>
      <FilterField label="违章事由" :grow="1.2">
        <el-input v-model="form.reason" placeholder="事由" class="w-full" />
      </FilterField>
      <FilterField label="违章地点" :grow="1.2">
        <el-input v-model="form.location" placeholder="地点" class="w-full" />
      </FilterField>
      <FilterField label="罚款区间（元）" :grow="1.2">
        <div class="flex items-center gap-2">
          <el-input v-model.number="form.fineMin" placeholder="最低" class="min-w-0 flex-1" />
          <span class="text-ink-muted">~</span>
          <el-input v-model.number="form.fineMax" placeholder="最高" class="min-w-0 flex-1" />
        </div>
      </FilterField>
      <FilterField label="违章日期" :grow="1.8">
        <el-date-picker v-model="form.dateRange" type="datetimerange" range-separator="~" start-placeholder="开始" end-placeholder="结束" value-format="YYYY-MM-DD HH:mm:ss" class="!w-full" />
      </FilterField>
      <FilterField label="状态" :grow="1">
        <el-select v-model="form.status" placeholder="全部" clearable class="w-full">
          <el-option label="待处理" value="pending" />
          <el-option label="已处理" value="handled" />
        </el-select>
      </FilterField>
      <template #actions>
        <BatchDeleteButton v-if="auth.hasPermission('busi:violation:delete')" :active="batch.active.value" @trigger="batch.trigger" @cancel="batch.exit" />
        <CircleIconButton v-if="auth.hasPermission('busi:violation:add')" icon="Plus" title="新增违章" tone="brand" @click="openAdd" />
      </template>
    </FilterBar>

    <GlassCard>
      <el-table :data="store.list" :class="['glass-table', { 'has-check': batch.active.value }]">
        <el-table-column v-if="batch.active.value && auth.hasPermission('busi:violation:delete')" label="" width="56">
          <template #default="{ row }">
            <SelectCheckbox :checked="batch.isSelected(row.id)" @toggle="batch.toggle(row.id)" />
          </template>
        </el-table-column>
        <el-table-column prop="plateNo" label="车牌" width="120" />
        <el-table-column prop="time" label="违章时间" width="150" />
        <el-table-column prop="reason" label="事由" min-width="200" show-overflow-tooltip />
        <el-table-column prop="location" label="地点" width="160" show-overflow-tooltip />
        <el-table-column label="扣分" width="80">
          <template #default="{ row }">{{ row.points }} 分</template>
        </el-table-column>
        <el-table-column label="罚款" width="100">
          <template #default="{ row }">¥{{ row.fine }}</template>
        </el-table-column>
        <el-table-column label="状态" width="100">
          <template #default="{ row }">
            <StatusBadge :text="violationStatusMeta[row.status].text" :tone="violationStatusMeta[row.status].tone" />
          </template>
        </el-table-column>
        <el-table-column v-if="auth.hasPermission('busi:violation:handle') || auth.hasPermission('busi:violation:edit') || auth.hasPermission('busi:violation:delete')" label="操作" width="160" fixed="right">
          <template #default="{ row }">
            <div class="flex gap-2">
              <button v-if="row.status === 'pending' && auth.hasPermission('busi:violation:handle')" class="flex h-8 w-8 items-center justify-center rounded-lg bg-statusOk/10 text-statusOk hover:bg-statusOk/20" title="处理" @click="handle(row)">
                <el-icon><Check /></el-icon>
              </button>
              <button v-if="auth.hasPermission('busi:violation:edit')" class="flex h-8 w-8 items-center justify-center rounded-lg bg-editblue/10 text-editblue hover:bg-editblue/20" title="编辑" @click="openEdit(row)">
                <el-icon><Edit /></el-icon>
              </button>
              <button v-if="auth.hasPermission('busi:violation:delete')" class="flex h-8 w-8 items-center justify-center rounded-lg bg-danger/10 text-danger hover:bg-danger/20" @click="remove(row)">
                <el-icon><Close /></el-icon>
              </button>
            </div>
          </template>
        </el-table-column>
      </el-table>
    </GlassCard>

    <FloatingPagination v-model:current-page="page.current" :total="store.totalCount || store.list.length" :page-size="page.size" @change="changePage" />

    <!-- 新增 / 编辑违章弹窗 -->
    <el-dialog v-model="dialog" :title="isNew ? '新增违章' : '编辑违章'" width="520px" align-center>
      <div class="grid grid-cols-2 gap-x-4 gap-y-3">
        <div>
          <label class="mb-1.5 block text-xs text-ink-label">车牌号码</label>
          <el-input v-model="editing.plateNo" placeholder="请输入车牌" />
        </div>
        <div>
          <label class="mb-1.5 block text-xs text-ink-label">违章时间</label>
          <el-date-picker v-model="editing.time" type="datetime" placeholder="请选择" value-format="YYYY-MM-DD HH:mm:ss" class="!w-full" />
        </div>
        <div class="col-span-2">
          <label class="mb-1.5 block text-xs text-ink-label">违章事由</label>
          <el-input v-model="editing.reason" placeholder="请输入事由" />
        </div>
        <div class="col-span-2">
          <label class="mb-1.5 block text-xs text-ink-label">违章地点</label>
          <el-input v-model="editing.location" placeholder="请输入地点" />
        </div>
        <div>
          <label class="mb-1.5 block text-xs text-ink-label">扣分</label>
          <el-input v-model.number="editing.points" placeholder="扣分" />
        </div>
        <div>
          <label class="mb-1.5 block text-xs text-ink-label">罚款（元）</label>
          <el-input v-model.number="editing.fine" placeholder="罚款金额" />
        </div>
        <div class="col-span-2">
          <label class="mb-1.5 block text-xs text-ink-label">处理状态</label>
          <el-select v-model="editing.status" placeholder="请选择" class="w-full">
            <el-option label="待处理" value="pending" />
            <el-option label="已处理" value="handled" />
          </el-select>
        </div>
      </div>
      <template #footer>
        <button class="btn-ghost h-10 px-5 text-sm" @click="dialog = false">取消</button>
        <button class="btn-brand ml-3 h-10 px-6 text-sm" @click="save">保存</button>
      </template>
    </el-dialog>
  </div>
</template>

<style scoped>
.paged-view-tight {
  position: relative;
  margin-bottom: 76px;
}

:deep(.floating-pagination-wrap) {
  top: calc(100% + 8px);
}
</style>
