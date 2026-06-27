<script setup lang="ts">
import { ref, reactive, computed } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import PageHeader from '@/components/PageHeader.vue'
import StatCard from '@/components/StatCard.vue'
import GlassCard from '@/components/GlassCard.vue'
import FilterBar from '@/components/FilterBar.vue'
import FilterField from '@/components/FilterField.vue'
import StatusBadge from '@/components/StatusBadge.vue'
import BatchDeleteButton from '@/components/BatchDeleteButton.vue'
import SelectCheckbox from '@/components/SelectCheckbox.vue'
import { useAppliedFilter } from '@/composables/useAppliedFilter'
import { useBatchDelete } from '@/composables/useBatchDelete'
import { api } from '@/api/backend'
import { useMaintainStore } from '@/stores/maintain'
import { maintainStatusMeta } from '@/utils/dict'
import type { Maintain, MaintainCandidate } from '@/types'

const store = useMaintainStore()
const maintainCandidates = ref<MaintainCandidate[]>([])

// 多字段过滤：车牌/项目/地点/金额区间/日期范围（点击查询才生效）
const { form, applied, doSearch, reset } = useAppliedFilter(() => ({
  plateNo: '',
  item: '',
  location: '',
  costMin: undefined as number | undefined,
  costMax: undefined as number | undefined,
  dateRange: [] as string[],
}))

const filtered = computed(() =>
  store.list.filter((m) => {
    if (applied.plateNo && !m.plateNo.includes(applied.plateNo)) return false
    if (applied.item && !m.item.includes(applied.item)) return false
    if (applied.location && !m.location.includes(applied.location)) return false
    if (applied.costMin != null && m.cost < applied.costMin) return false
    if (applied.costMax != null && m.cost > applied.costMax) return false
    if (applied.dateRange?.length === 2) {
      const d = m.time.slice(0, 10)
      if (d < applied.dateRange[0] || d > applied.dateRange[1]) return false
    }
    return true
  }),
)

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
  isNew.value = true
  await loadMaintainCandidates()
  Object.assign(editing, { id: undefined, plateNo: '', time: '', location: '', item: '', cost: 0, status: 'pending' })
  dialog.value = true
}
async function openEdit(m: Maintain) {
  isNew.value = false
  await loadMaintainCandidates()
  Object.assign(editing, m)
  dialog.value = true
}
async function save() {
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

function finish(m: Maintain) {
  ElMessageBox.confirm(`确认车牌 ${m.plateNo} 的保养已完成？`, '完成保养', { type: 'warning', confirmButtonText: '确认', cancelButtonText: '取消' })
    .then(() => {
      store.finish(m.id)
      ElMessage.success('已标记为已保养')
    })
    .catch(() => {})
}
function remove(m: Maintain) {
  ElMessageBox.confirm('确认删除该保养记录？', '删除', { type: 'warning', confirmButtonText: '删除', cancelButtonText: '取消' })
    .then(() => {
      store.remove(m.id)
      ElMessage.success('已删除')
    })
    .catch(() => {})
}
</script>

<template>
  <div class="space-y-6">
    <PageHeader title="车辆保养" subtitle="车辆保养计划与维修记录管理">
      <template #actions>
        <button class="btn-brand h-10 px-5 text-sm" @click="openAdd">
          <el-icon class="mr-1"><Plus /></el-icon>新增保养
        </button>
      </template>
    </PageHeader>

    <div class="grid grid-cols-3 gap-5">
      <StatCard label="保养记录" :value="store.list.length" suffix="条" icon="Tools" tone="brand" />
      <StatCard label="待保养" :value="store.pendingCount" suffix="条" icon="Bell" tone="orange" />
      <StatCard label="累计费用" :value="store.list.reduce((s, m) => s + m.cost, 0)" suffix="元" icon="Money" tone="purple" />
    </div>

    <FilterBar @search="doSearch" @reset="reset">
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
        <BatchDeleteButton :active="batch.active.value" @trigger="batch.trigger" @cancel="batch.exit" />
      </template>
    </FilterBar>

    <GlassCard>
      <el-table :data="filtered" :class="['glass-table', { 'has-check': batch.active.value }]">
        <el-table-column v-if="batch.active.value" label="" width="56">
          <template #default="{ row }">
            <SelectCheckbox :checked="batch.isSelected(row.id)" @toggle="batch.toggle(row.id)" />
          </template>
        </el-table-column>
        <el-table-column prop="plateNo" label="车牌" width="120" />
        <el-table-column prop="time" label="保养时间" width="160" />
        <el-table-column prop="location" label="地点" min-width="200" show-overflow-tooltip />
        <el-table-column prop="item" label="项目" min-width="180" show-overflow-tooltip />
        <el-table-column label="费用" width="110">
          <template #default="{ row }">¥{{ row.cost.toLocaleString() }}</template>
        </el-table-column>
        <el-table-column label="状态" width="100">
          <template #default="{ row }">
            <StatusBadge :text="maintainStatusMeta[row.status].text" :tone="maintainStatusMeta[row.status].tone" />
          </template>
        </el-table-column>
        <el-table-column label="操作" width="160" fixed="right">
          <template #default="{ row }">
            <div class="flex gap-2">
              <button v-if="row.status === 'pending'" class="flex h-8 w-8 items-center justify-center rounded-lg bg-statusOk/10 text-statusOk hover:bg-statusOk/20" title="完成" @click="finish(row)">
                <el-icon><Check /></el-icon>
              </button>
              <button class="flex h-8 w-8 items-center justify-center rounded-lg bg-editblue/10 text-editblue hover:bg-editblue/20" title="编辑" @click="openEdit(row)">
                <el-icon><Edit /></el-icon>
              </button>
              <button class="flex h-8 w-8 items-center justify-center rounded-lg bg-danger/10 text-danger hover:bg-danger/20" @click="remove(row)">
                <el-icon><Close /></el-icon>
              </button>
            </div>
          </template>
        </el-table-column>
      </el-table>
    </GlassCard>

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
        <div>
          <label class="mb-1.5 block text-xs text-ink-label">保养状态</label>
          <el-select v-model="editing.status" placeholder="请选择" class="w-full">
            <el-option label="待保养" value="pending" />
            <el-option label="已保养" value="done" />
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
