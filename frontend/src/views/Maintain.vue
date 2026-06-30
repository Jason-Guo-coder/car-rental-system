<script setup lang="ts">
import { computed, ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import PageHeader from '@/components/PageHeader.vue'
import StatCard from '@/components/StatCard.vue'
import GlassCard from '@/components/GlassCard.vue'
import FilterBar from '@/components/FilterBar.vue'
import FilterField from '@/components/FilterField.vue'
import FloatingPagination from '@/components/FloatingPagination.vue'
import BatchDeleteButton from '@/components/BatchDeleteButton.vue'
import SelectCheckbox from '@/components/SelectCheckbox.vue'
import CircleIconButton from '@/components/CircleIconButton.vue'
import { useAppliedFilter } from '@/composables/useAppliedFilter'
import { useBatchDelete } from '@/composables/useBatchDelete'
import { api } from '@/api/backend'
import { useAuthStore } from '@/stores/auth'
import { useMaintainStore } from '@/stores/maintain'
import type { Maintain, MaintainCandidate } from '@/types'

const store = useMaintainStore()
const auth = useAuthStore()
const maintainCandidates = ref<MaintainCandidate[]>([])
const page = reactive({ current: 1, size: 5 })

// 多字段过滤：车牌/项目/地点/金额区间/日期范围（点击查询才生效）
const { form, applied, doSearch: applySearch, reset: resetFilter } = useAppliedFilter(() => ({
  plateNo: '',
  item: '',
  location: '',
  costMin: undefined as number | undefined,
  costMax: undefined as number | undefined,
  dateRange: [] as string[],
  viewMode: 'records' as 'records' | 'pending',
}))

const showPending = computed(() => applied.viewMode === 'pending')
const pendingRows = computed(() => maintainCandidates.value
  .filter((item) => !applied.plateNo || item.plateNo.includes(applied.plateNo))
  .map((item) => ({ ...item, pendingNum: item.expectedNum - item.actualNum })))
const tableRows = computed(() => {
  if (!showPending.value) return store.list
  const start = (page.current - 1) * page.size
  return pendingRows.value.slice(start, start + page.size)
})
const tableTotal = computed(() => showPending.value ? pendingRows.value.length : (store.totalCount || store.list.length))

async function searchMaintains() {
  if (showPending.value) {
    await loadMaintainCandidates()
    return
  }
  await store.load({
    plateNo: applied.plateNo || undefined,
    item: applied.item || undefined,
    location: applied.location || undefined,
    costMin: applied.costMin,
    costMax: applied.costMax,
    lowMaintainTime: applied.dateRange?.[0],
    highMaintainTime: applied.dateRange?.[1],
    page: page.current,
    size: page.size,
  })
}
async function doSearch() {
  applySearch()
  page.current = 1
  await searchMaintains()
}
async function reset() {
  resetFilter()
  page.current = 1
  await searchMaintains()
}
async function changePage(current: number) {
  page.current = current
  if (!showPending.value) await searchMaintains()
}
onMounted(() => {
  searchMaintains()
  loadMaintainCandidates()
})

// 批量删除
const batch = useBatchDelete((ids) => store.removeMany(ids), '保养')

// 新增 / 编辑弹窗
const dialog = ref(false)
const isNew = ref(false)
const editing = reactive<Omit<Maintain, 'id'> & { id?: number }>({
  plateNo: '', time: '', location: '', item: '', cost: 0, status: 'pending',
})

async function loadMaintainCandidates() {
  maintainCandidates.value = await api.cars.toBeMaintain()
}

function syncMaintainCar(plateNo: string) {
  const car = maintainCandidates.value.find((item) => item.plateNo === plateNo)
  editing.autoId = car?.id
}

async function openAdd() {
  if (!auth.hasPermission('busi:maintain:add')) return ElMessage.warning('当前账号没有该操作权限')
  isNew.value = true
  await loadMaintainCandidates()
  Object.assign(editing, { id: undefined, plateNo: '', time: '', location: '', item: '', cost: 0, status: 'pending' })
  dialog.value = true
}
async function openEdit(m: Maintain) {
  if (!auth.hasPermission('busi:maintain:edit')) return ElMessage.warning('当前账号没有该操作权限')
  isNew.value = false
  await loadMaintainCandidates()
  Object.assign(editing, m)
  dialog.value = true
}
async function save() {
  if (!auth.hasPermission(isNew.value ? 'busi:maintain:add' : 'busi:maintain:edit')) return ElMessage.warning('当前账号没有该操作权限')
  if (!editing.plateNo.trim()) return ElMessage.warning('请填写车牌号码')
  if (isNew.value && !maintainCandidates.value.some((item) => item.plateNo === editing.plateNo)) return ElMessage.warning('请选择待保养车辆')
  if (!editing.time) return ElMessage.warning('请选择保养时间')
  if (!editing.location.trim()) return ElMessage.warning('请填写保养地点')
  if (!editing.item.trim()) return ElMessage.warning('请填写保养项目')
  syncMaintainCar(editing.plateNo)
  if (isNew.value) {
    const { id: _omit, ...rest } = editing
    await store.add(rest)
    ElMessage.success('新增保养成功')
  } else {
    await store.update(editing as Maintain)
    ElMessage.success('保存成功')
  }
  dialog.value = false
}

function remove(m: Maintain) {
  if (!auth.hasPermission('busi:maintain:delete')) return ElMessage.warning('当前账号没有该操作权限')
  ElMessageBox.confirm('确认删除该保养记录？', '删除', { type: 'warning', confirmButtonText: '删除', cancelButtonText: '取消' })
    .then(() => {
      store.remove(m.id)
      ElMessage.success('已删除')
    })
    .catch(() => {})
}
</script>

<template>
  <div class="paged-view-tight space-y-6">
    <PageHeader title="车辆保养" subtitle="车辆保养计划与维修记录管理" />

    <div class="grid grid-cols-3 gap-5">
      <StatCard label="保养记录" :value="store.overviewTotal" suffix="条" icon="Tools" tone="brand" />
      <StatCard label="待保养车辆" :value="maintainCandidates.length" suffix="辆" icon="Bell" tone="orange" />
      <StatCard label="累计费用" :value="store.totalCost" suffix="元" icon="Money" tone="purple" />
    </div>

    <FilterBar @search="doSearch" @reset="reset">
      <FilterField label="显示范围" :grow="1">
        <el-select v-model="form.viewMode" class="w-full">
          <el-option label="保养记录" value="records" />
          <el-option label="待保养车辆" value="pending" />
        </el-select>
      </FilterField>
      <FilterField label="车牌号码" :grow="1">
        <el-input v-model="form.plateNo" placeholder="车牌" class="w-full" />
      </FilterField>
      <FilterField label="保养项目" :grow="1.2">
        <el-input v-model="form.item" placeholder="项目" class="w-full" />
      </FilterField>
      <FilterField label="保养地点" :grow="1.2">
        <el-input v-model="form.location" placeholder="地点" class="w-full" />
      </FilterField>
      <FilterField label="费用区间（元）" :grow="1.2">
        <div class="flex items-center gap-2">
          <el-input v-model.number="form.costMin" placeholder="最低" class="min-w-0 flex-1" />
          <span class="text-ink-muted">~</span>
          <el-input v-model.number="form.costMax" placeholder="最高" class="min-w-0 flex-1" />
        </div>
      </FilterField>
      <FilterField label="保养日期" :grow="1.8">
        <el-date-picker v-model="form.dateRange" type="daterange" range-separator="~" start-placeholder="开始" end-placeholder="结束" value-format="YYYY-MM-DD" class="!w-full" />
      </FilterField>
      <template #actions>
        <BatchDeleteButton v-if="!showPending && auth.hasPermission('busi:maintain:delete')" :active="batch.active.value" @trigger="batch.trigger" @cancel="batch.exit" />
        <CircleIconButton v-if="auth.hasPermission('busi:maintain:add')" icon="Plus" title="新增保养" tone="brand" @click="openAdd" />
      </template>
    </FilterBar>

    <GlassCard>
      <el-table :data="tableRows" :class="['glass-table', { 'has-check': batch.active.value && !showPending }]">
        <el-table-column v-if="batch.active.value && !showPending && auth.hasPermission('busi:maintain:delete')" label="" width="56">
          <template #default="{ row }">
            <SelectCheckbox :checked="batch.isSelected(row.id)" @toggle="batch.toggle(row.id)" />
          </template>
        </el-table-column>
        <template v-if="showPending">
          <el-table-column prop="plateNo" label="车牌" min-width="160" />
          <el-table-column prop="expectedNum" label="应保次数" min-width="160" />
          <el-table-column prop="actualNum" label="实保次数" min-width="160" />
          <el-table-column prop="pendingNum" label="待保养次数" min-width="160" />
        </template>
        <template v-else>
          <el-table-column prop="plateNo" label="车牌" width="160" />
          <el-table-column prop="time" label="保养时间" width="160" />
          <el-table-column prop="location" label="地点" min-width="200" show-overflow-tooltip />
          <el-table-column prop="item" label="项目" min-width="180" show-overflow-tooltip />
          <el-table-column label="费用" width="110">
            <template #default="{ row }">¥{{ row.cost.toLocaleString() }}</template>
          </el-table-column>
          <el-table-column v-if="auth.hasPermission('busi:maintain:edit') || auth.hasPermission('busi:maintain:delete')" label="操作" width="110" fixed="right">
            <template #default="{ row }">
              <div class="flex gap-2">
                <button v-if="auth.hasPermission('busi:maintain:edit')" class="flex h-8 w-8 items-center justify-center rounded-lg bg-editblue/10 text-editblue hover:bg-editblue/20" title="编辑" @click="openEdit(row)">
                  <el-icon><Edit /></el-icon>
                </button>
                <button v-if="auth.hasPermission('busi:maintain:delete')" class="flex h-8 w-8 items-center justify-center rounded-lg bg-danger/10 text-danger hover:bg-danger/20" @click="remove(row)">
                  <el-icon><Close /></el-icon>
                </button>
              </div>
            </template>
          </el-table-column>
        </template>
      </el-table>
    </GlassCard>

    <FloatingPagination v-model:current-page="page.current" :total="tableTotal" :page-size="page.size" @change="changePage" />

    <!-- 新增 / 编辑保养弹窗 -->
    <el-dialog v-model="dialog" :title="isNew ? '新增保养' : '编辑保养'" width="520px" align-center>
      <div class="grid grid-cols-2 gap-x-4 gap-y-3">
        <div>
          <label class="mb-1.5 block text-xs text-ink-label">车牌号码</label>
          <el-select v-model="editing.plateNo" placeholder="请选择待保养车辆" filterable class="w-full" @change="syncMaintainCar">
            <el-option v-for="item in maintainCandidates" :key="item.id" :label="item.plateNo" :value="item.plateNo">
              <span class="float-left">{{ item.plateNo }}</span>
              <span class="float-right text-xs text-ink-muted">未保次数：{{ item.expectedNum - item.actualNum }}</span>
            </el-option>
          </el-select>
        </div>
        <div>
          <label class="mb-1.5 block text-xs text-ink-label">保养时间</label>
          <el-date-picker v-model="editing.time" type="date" placeholder="请选择" value-format="YYYY-MM-DD" class="!w-full" />
        </div>
        <div class="col-span-2">
          <label class="mb-1.5 block text-xs text-ink-label">保养地点</label>
          <el-input v-model="editing.location" placeholder="请输入地点" />
        </div>
        <div class="col-span-2">
          <label class="mb-1.5 block text-xs text-ink-label">保养项目</label>
          <el-input v-model="editing.item" placeholder="请输入项目" />
        </div>
        <div>
          <label class="mb-1.5 block text-xs text-ink-label">费用（元）</label>
          <el-input v-model.number="editing.cost" placeholder="费用金额" />
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
