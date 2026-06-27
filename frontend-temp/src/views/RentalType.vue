<script setup lang="ts">
import { ref, reactive, computed } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import PageHeader from '@/components/PageHeader.vue'
import GlassCard from '@/components/GlassCard.vue'
import FilterBar from '@/components/FilterBar.vue'
import FilterField from '@/components/FilterField.vue'
import StatusBadge from '@/components/StatusBadge.vue'
import BatchDeleteButton from '@/components/BatchDeleteButton.vue'
import SelectCheckbox from '@/components/SelectCheckbox.vue'
import { useAppliedFilter } from '@/composables/useAppliedFilter'
import { useBatchDelete } from '@/composables/useBatchDelete'
import { useRentalTypeStore } from '@/stores/rentalType'
import type { RentalType } from '@/types'

const store = useRentalTypeStore()

// 过滤：类型名称 + 折扣区间（点击查询才生效）
const { form, applied, doSearch, reset } = useAppliedFilter(() => ({
  name: '',
  discountMin: undefined as number | undefined,
  discountMax: undefined as number | undefined,
}))

const filtered = computed(() =>
  store.list.filter((t) => {
    if (applied.name && !t.name.includes(applied.name)) return false
    if (applied.discountMin != null && t.discount < applied.discountMin) return false
    if (applied.discountMax != null && t.discount > applied.discountMax) return false
    return true
  }),
)

// 批量删除
const batch = useBatchDelete((ids) => store.removeMany(ids), '类型')

// 新增 / 编辑弹窗
const dialog = ref(false)
const isNew = ref(false)
const editing = reactive<Omit<RentalType, 'id'> & { id?: number }>({
  name: '', coefficient: 1, discount: 100, remark: '',
})

function openAdd() {
  isNew.value = true
  Object.assign(editing, { id: undefined, name: '', coefficient: 1, discount: 100, remark: '' })
  dialog.value = true
}
function openEdit(t: RentalType) {
  isNew.value = false
  Object.assign(editing, t)
  dialog.value = true
}
function save() {
  if (!editing.name.trim()) return ElMessage.warning('请填写类型名称')
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
  ElMessageBox.confirm(`确认删除出租类型「${t.name}」？`, '删除', { type: 'warning', confirmButtonText: '删除', cancelButtonText: '取消' })
    .then(() => {
      store.remove(t.id)
      ElMessage.success('已删除')
    })
    .catch(() => {})
}
</script>

<template>
  <div class="space-y-6">
    <PageHeader title="出租类型" subtitle="租赁计费类型与折扣系数配置">
      <template #actions>
        <button class="btn-brand h-10 px-5 text-sm" @click="openAdd"><el-icon class="mr-1"><Plus /></el-icon>新增类型</button>
      </template>
    </PageHeader>

    <FilterBar @search="doSearch" @reset="reset">
      <FilterField label="类型名称" :grow="2">
        <el-input v-model="form.name" placeholder="名称" class="w-full" />
      </FilterField>
      <FilterField label="折扣区间（%）" :grow="2">
        <div class="flex items-center gap-2">
          <el-input v-model.number="form.discountMin" placeholder="下限" class="min-w-0 flex-1" />
          <span class="text-ink-muted">~</span>
          <el-input v-model.number="form.discountMax" placeholder="上限" class="min-w-0 flex-1" />
        </div>
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
        <el-table-column prop="name" label="类型名称" min-width="180">
          <template #default="{ row }">
            <span class="font-medium text-ink">{{ row.name }}</span>
          </template>
        </el-table-column>
        <el-table-column label="折扣" min-width="140">
          <template #default="{ row }">
            <StatusBadge :text="`${row.discount}%`" :tone="row.discount < 90 ? 'danger' : row.discount < 100 ? 'warning' : 'success'" />
          </template>
        </el-table-column>
        <el-table-column prop="remark" label="说明" min-width="320" show-overflow-tooltip />
        <el-table-column label="操作" width="120" fixed="right">
          <template #default="{ row }">
            <div class="flex gap-2">
              <button class="flex h-8 w-8 items-center justify-center rounded-lg bg-editblue/10 text-editblue hover:bg-editblue/20" @click="openEdit(row)">
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

    <!-- 新增 / 编辑类型弹窗 -->
    <el-dialog v-model="dialog" :title="isNew ? '新增出租类型' : '编辑出租类型'" width="460px" align-center>
      <div class="space-y-3">
        <div>
          <label class="mb-1.5 block text-xs text-ink-label">类型名称</label>
          <el-input v-model="editing.name" placeholder="如：日租 / 周租 / 月租" />
        </div>
        <div>
          <label class="mb-1.5 block text-xs text-ink-label">折扣（%）</label>
          <el-input v-model.number="editing.discount" placeholder="如 90 表示 9 折" />
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
