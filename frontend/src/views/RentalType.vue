<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import PageHeader from '@/components/PageHeader.vue'
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
import { useAuthStore } from '@/stores/auth'
import { useRentalTypeStore } from '@/stores/rentalType'
import type { RentalType } from '@/types'

const store = useRentalTypeStore()
const auth = useAuthStore()
const page = reactive({ current: 1, size: 5 })

// 过滤：类型名称 + 折扣区间（点击查询才生效）
const { form, applied, doSearch: applySearch, reset: resetFilter } = useAppliedFilter(() => ({
  name: '',
  discountMin: undefined as number | undefined,
  discountMax: undefined as number | undefined,
}))

async function searchTypes() {
  await store.search({ name: applied.name, discountMin: applied.discountMin, discountMax: applied.discountMax, page: page.current, size: page.size })
}
async function doSearch() {
  applySearch()
  page.current = 1
  await searchTypes()
}
async function reset() {
  resetFilter()
  page.current = 1
  await searchTypes()
}
async function changePage(current: number) {
  page.current = current
  await searchTypes()
}
onMounted(searchTypes)

// 批量删除
const batch = useBatchDelete((ids) => store.removeMany(ids), '类型')

// 新增 / 编辑弹窗
const dialog = ref(false)
const isNew = ref(false)
const editing = reactive<Omit<RentalType, 'id'> & { id?: number }>({
  name: '', coefficient: 1, discount: 100, remark: '',
})

function openAdd() {
  if (!auth.hasPermission('auto:rentalType:add')) return ElMessage.warning('当前账号没有该操作权限')
  isNew.value = true
  Object.assign(editing, { id: undefined, name: '', coefficient: 1, discount: 100, remark: '' })
  dialog.value = true
}
function openEdit(t: RentalType) {
  if (!auth.hasPermission('auto:rentalType:edit')) return ElMessage.warning('当前账号没有该操作权限')
  isNew.value = false
  Object.assign(editing, t)
  dialog.value = true
}
function save() {
  if (!auth.hasPermission(isNew.value ? 'auto:rentalType:add' : 'auto:rentalType:edit')) return ElMessage.warning('当前账号没有该操作权限')
  if (!editing.name.trim()) return ElMessage.warning('请填写类型名称')
  if (editing.coefficient == null) return ElMessage.warning('请填写类型折扣')
  if (editing.coefficient < 0 || editing.coefficient > 1) return ElMessage.warning('类型折扣必须在 0 到 1 之间')
  editing.discount = Math.round(editing.coefficient * 100)
  if (isNew.value) {
    const { id: _omit, ...rest } = editing
    store.add(rest)
    ElMessage.success('新增类型成功')
  } else {
    store.update(editing as RentalType)
    ElMessage.success('保存成功')
  }
  dialog.value = false
}

function remove(t: RentalType) {
  if (!auth.hasPermission('auto:rentalType:delete')) return ElMessage.warning('当前账号没有该操作权限')
  ElMessageBox.confirm(`确认删除出租类型「${t.name}」？`, '删除', { type: 'warning', confirmButtonText: '删除', cancelButtonText: '取消' })
    .then(() => {
      store.remove(t.id)
      ElMessage.success('已删除')
    })
    .catch(() => {})
}
</script>

<template>
  <div class="paged-view-tight space-y-6">
    <PageHeader title="出租类型" subtitle="租赁计费类型与折扣系数配置" />

    <FilterBar @search="doSearch" @reset="reset">
      <FilterField label="类型名称" :grow="2">
        <el-input v-model="form.name" placeholder="名称" class="w-full" />
      </FilterField>
      <FilterField label="折扣区间" :grow="2">
        <div class="flex items-center gap-2">
          <el-input-number v-model="form.discountMin" :min="0" :max="1" :step="0.01" placeholder="下限" class="min-w-0 flex-1" />
          <span class="text-ink-muted">~</span>
          <el-input-number v-model="form.discountMax" :min="0" :max="1" :step="0.01" placeholder="上限" class="min-w-0 flex-1" />
        </div>
      </FilterField>
      <template #actions>
        <BatchDeleteButton v-if="auth.hasPermission('auto:rentalType:delete')" :active="batch.active.value" @trigger="batch.trigger" @cancel="batch.exit" />
        <CircleIconButton v-if="auth.hasPermission('auto:rentalType:add')" icon="Plus" title="新增类型" tone="brand" @click="openAdd" />
      </template>
    </FilterBar>

    <GlassCard>
      <el-table :data="store.list" :class="['glass-table', { 'has-check': batch.active.value }]">
        <el-table-column v-if="batch.active.value && auth.hasPermission('auto:rentalType:delete')" label="" width="56">
          <template #default="{ row }">
            <SelectCheckbox :checked="batch.isSelected(row.id)" @toggle="batch.toggle(row.id)" />
          </template>
        </el-table-column>
        <el-table-column prop="name" label="类型名称" min-width="180">
          <template #default="{ row }">
            <span class="font-medium text-ink">{{ row.name }}</span>
          </template>
        </el-table-column>
        <el-table-column label="折扣" min-width="140">
          <template #default="{ row }">
            <StatusBadge :text="String(row.coefficient)" :tone="row.coefficient < 0.9 ? 'danger' : row.coefficient < 1 ? 'warning' : 'success'" />
          </template>
        </el-table-column>
        <el-table-column prop="remark" label="说明" min-width="320" show-overflow-tooltip />
        <el-table-column v-if="auth.hasPermission('auto:rentalType:edit') || auth.hasPermission('auto:rentalType:delete')" label="操作" width="120" fixed="right">
          <template #default="{ row }">
            <div class="flex gap-2">
              <button v-if="auth.hasPermission('auto:rentalType:edit')" class="flex h-8 w-8 items-center justify-center rounded-lg bg-editblue/10 text-editblue hover:bg-editblue/20" @click="openEdit(row)">
                <el-icon><Edit /></el-icon>
              </button>
              <button v-if="auth.hasPermission('auto:rentalType:delete')" class="flex h-8 w-8 items-center justify-center rounded-lg bg-danger/10 text-danger hover:bg-danger/20" @click="remove(row)">
                <el-icon><Close /></el-icon>
              </button>
            </div>
          </template>
        </el-table-column>
      </el-table>
    </GlassCard>

    <FloatingPagination v-model:current-page="page.current" :total="store.totalCount || store.list.length" :page-size="page.size" @change="changePage" />

    <!-- 新增 / 编辑类型弹窗 -->
    <el-dialog v-model="dialog" :title="isNew ? '新增出租类型' : '编辑出租类型'" width="460px" align-center>
      <div class="space-y-3">
        <div>
          <label class="mb-1.5 block text-xs text-ink-label">类型名称</label>
          <el-input v-model="editing.name" placeholder="如：日租 / 周租 / 月租" />
        </div>
        <div>
          <label class="mb-1.5 block text-xs text-ink-label">类型折扣</label>
          <el-input-number v-model="editing.coefficient" :min="0" :max="1" :step="0.01" class="!w-full" />
        </div>
        <div>
          <label class="mb-1.5 block text-xs text-ink-label">说明</label>
          <el-input v-model="editing.remark" type="textarea" :rows="2" placeholder="请输入说明" />
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
