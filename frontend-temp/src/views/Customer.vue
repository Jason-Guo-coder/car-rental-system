<script setup lang="ts">
import { ref, reactive, computed, watch } from 'vue'
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
import { useCustomerStore } from '@/stores/customer'
import { customerListMeta } from '@/utils/dict'
import { parseIdCard } from '@/utils/idCard'
import type { Customer } from '@/types'

const store = useCustomerStore()

// 多字段过滤：姓名 / 电话 / 身份证 / 年龄区间 / 性别（点击查询才生效）
const { form, applied, doSearch, reset } = useAppliedFilter(() => ({
  name: '',
  phone: '',
  idCard: '',
  ageMin: undefined as number | undefined,
  ageMax: undefined as number | undefined,
  gender: '',
}))

const filtered = computed(() =>
  store.list.filter((c) => {
    if (applied.name && !c.name.includes(applied.name)) return false
    if (applied.phone && !c.phone.includes(applied.phone)) return false
    if (applied.idCard && !c.idCard.includes(applied.idCard)) return false
    if (applied.ageMin != null && c.age < applied.ageMin) return false
    if (applied.ageMax != null && c.age > applied.ageMax) return false
    if (applied.gender && c.gender !== applied.gender) return false
    return true
  }),
)

// 批量删除
const batch = useBatchDelete((ids) => store.removeMany(ids), '客户')

// 新增 / 编辑弹窗
const dialog = ref(false)
const isNew = ref(false)
const editing = reactive<Omit<Customer, 'id'> & { id?: number }>({
  name: '', gender: '男', age: undefined as unknown as number, phone: '', idCard: '', birthDate: '', orderCount: 0, listType: 'white', createTime: '',
})

// 填写身份证号自动识别出生日期 + 年龄 + 性别
watch(
  () => editing.idCard,
  (id) => {
    const info = parseIdCard((id || '').trim())
    if (info) {
      editing.birthDate = info.birthDate
      editing.age = info.age
      editing.gender = info.gender
    }
  },
)

function openAdd() {
  isNew.value = true
  Object.assign(editing, { id: undefined, name: '', gender: '男', age: undefined, phone: '', idCard: '', birthDate: '', orderCount: 0, listType: 'white', createTime: new Date().toISOString().slice(0, 10) })
  dialog.value = true
}
function openEdit(c: Customer) {
  isNew.value = false
  Object.assign(editing, c)
  dialog.value = true
}
function save() {
  if (!editing.name.trim()) return ElMessage.warning('请填写客户姓名')
  if (!editing.phone.trim()) return ElMessage.warning('请填写联系电话')
  if (isNew.value) {
    const { id: _omit, ...rest } = editing
    store.add(rest)
    ElMessage.success('新增客户成功')
  } else {
    store.update(editing as Customer)
    ElMessage.success('保存成功')
  }
  dialog.value = false
}

function remove(c: Customer) {
  ElMessageBox.confirm(`确认删除客户 ${c.name}？`, '删除客户', { type: 'warning', confirmButtonText: '删除', cancelButtonText: '取消' })
    .then(() => {
      store.remove(c.id)
      ElMessage.success('已删除')
    })
    .catch(() => {})
}

// 头像颜色轮转
const avatarColors = ['from-[#3B83F5] to-[#7368F2]', 'from-[#22b07d] to-[#10b3a3]', 'from-[#f5a623] to-[#f97316]', 'from-[#9b5de5] to-[#7368f2]']
</script>

<template>
  <div class="space-y-6">
    <PageHeader title="客户管理" subtitle="客户档案与信用名单维护">
      <template #actions>
        <button class="btn-brand h-10 px-5 text-sm" @click="openAdd">
          <el-icon class="mr-1"><Plus /></el-icon>新增客户
        </button>
      </template>
    </PageHeader>

    <div class="grid grid-cols-3 gap-5">
      <StatCard label="客户总数" :value="store.total" suffix="人" icon="User" tone="brand" />
      <StatCard label="白名单客户" :value="store.whiteCount" suffix="人" icon="CircleCheck" tone="green" />
      <StatCard label="黑名单客户" :value="store.blackCount" suffix="人" icon="CircleClose" tone="orange" />
    </div>

    <FilterBar @search="doSearch" @reset="reset">
      <FilterField label="客户姓名" :grow="1">
        <el-input v-model="form.name" placeholder="姓名" class="w-full" />
      </FilterField>
      <FilterField label="联系电话" :grow="1.2">
        <el-input v-model="form.phone" placeholder="电话" class="w-full" />
      </FilterField>
      <FilterField label="身份证号" :grow="1.6">
        <el-input v-model="form.idCard" placeholder="身份证" class="w-full" />
      </FilterField>
      <FilterField label="年龄区间" :grow="1.2">
        <div class="flex items-center gap-2">
          <el-input v-model.number="form.ageMin" placeholder="最小" class="min-w-0 flex-1" />
          <span class="text-ink-muted">~</span>
          <el-input v-model.number="form.ageMax" placeholder="最大" class="min-w-0 flex-1" />
        </div>
      </FilterField>
      <FilterField label="性别" :grow="1">
        <el-select v-model="form.gender" placeholder="全部" clearable class="w-full">
          <el-option label="男" value="男" />
          <el-option label="女" value="女" />
        </el-select>
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
        <el-table-column label="客户" min-width="150">
          <template #default="{ row, $index }">
            <div class="flex items-center gap-3">
              <div class="flex h-9 w-9 items-center justify-center rounded-full bg-gradient-to-br text-sm font-medium text-white" :class="avatarColors[$index % 4]">
                {{ row.name.charAt(0) }}
              </div>
              <span class="font-medium text-ink">{{ row.name }}</span>
            </div>
          </template>
        </el-table-column>
        <el-table-column prop="phone" label="联系电话" width="140" />
        <el-table-column prop="idCard" label="身份证号" width="180" />
        <el-table-column label="年龄" width="80">
          <template #default="{ row }">{{ row.age }} 岁</template>
        </el-table-column>
        <el-table-column prop="gender" label="性别" width="80" />
        <el-table-column prop="birthDate" label="出生日期" width="130" />
        <el-table-column label="客户状态" width="110">
          <template #default="{ row }">
            <StatusBadge :text="customerListMeta[row.listType].text" :tone="customerListMeta[row.listType].tone" />
          </template>
        </el-table-column>
        <el-table-column label="操作" width="110" fixed="right">
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

    <!-- 新增 / 编辑客户弹窗 -->
    <el-dialog v-model="dialog" :title="isNew ? '新增客户' : '编辑客户'" width="520px" align-center>
      <div class="grid grid-cols-2 gap-x-4 gap-y-3">
        <div>
          <label class="mb-1.5 block text-xs text-ink-label">客户姓名</label>
          <el-input v-model="editing.name" placeholder="请输入姓名" />
        </div>
        <div>
          <label class="mb-1.5 block text-xs text-ink-label">联系电话</label>
          <el-input v-model="editing.phone" placeholder="请输入电话" />
        </div>
        <div class="col-span-2">
          <label class="mb-1.5 block text-xs text-ink-label">身份证号</label>
          <el-input v-model="editing.idCard" placeholder="请输入身份证号" maxlength="18" />
        </div>
        <div>
          <label class="mb-1.5 block text-xs text-ink-label">出生日期</label>
          <el-date-picker v-model="editing.birthDate" type="date" placeholder="请选择" value-format="YYYY-MM-DD" class="!w-full" />
        </div>
        <div>
          <label class="mb-1.5 block text-xs text-ink-label">客户年龄</label>
          <el-input v-model.number="editing.age" placeholder="请输入年龄" />
        </div>
        <div>
          <label class="mb-1.5 block text-xs text-ink-label">客户性别</label>
          <el-select v-model="editing.gender" placeholder="请选择" class="w-full">
            <el-option label="男" value="男" />
            <el-option label="女" value="女" />
          </el-select>
        </div>
        <div>
          <label class="mb-1.5 block text-xs text-ink-label">客户状态</label>
          <el-select v-model="editing.listType" placeholder="请选择" class="w-full">
            <el-option label="白名单" value="white" />
            <el-option label="黑名单" value="black" />
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
