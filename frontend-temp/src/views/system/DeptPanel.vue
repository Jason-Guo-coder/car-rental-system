<script setup lang="ts">
import { ref, reactive, computed } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Search, OfficeBuilding, Phone, Location, Sort } from '@element-plus/icons-vue'
import GlassCard from '@/components/GlassCard.vue'
import { useAuthStore } from '@/stores/auth'
import { useSystemStore } from '@/stores/system'
import type { SysDept } from '@/types'

const store = useSystemStore()
const auth = useAuthStore()
const root = computed(() => store.deptTree[0])
const companies = computed(() => root.value.children ?? [])

const keyword = ref('')
const deptsOf = (company: SysDept) => company.children ?? []

// 上级部门下拉：用户管理左侧树的全部节点（根 + 公司 + 各部门），带层级缩进
const parentOptions = computed(() => {
  const out: { id: number; name: string; level: number }[] = []
  function walk(nodes: SysDept[], level = 0) {
    for (const n of nodes) {
      out.push({ id: n.id, name: n.name, level })
      if (n.children) walk(n.children, level + 1)
    }
  }
  walk(store.deptTree)
  return out
})

// 新增 / 编辑弹窗
const dialog = ref(false)
const isNew = ref(false)
const form = reactive({ id: 0, parentId: 0, parentName: '', name: '', orderNum: 0, phone: '', address: '' })

const parentName = (id: number) => parentOptions.value.find((p) => p.id === id)?.name ?? ''

function openAdd(parentId?: number) {
  isNew.value = true
  // 默认上级 = 所有部门（根），选它则创建公司级部门；传入 parentId 则预选该上级
  const pid = parentId ?? root.value.id
  Object.assign(form, { id: 0, parentId: pid, parentName: parentName(pid), name: '', orderNum: 0, phone: '', address: '' })
  dialog.value = true
}
function openEdit(d: SysDept) {
  isNew.value = false
  Object.assign(form, { id: d.id, parentId: d.parentId, parentName: d.parentName || parentName(d.parentId), name: d.name, orderNum: d.orderNum, phone: d.phone, address: d.address })
  dialog.value = true
}
async function searchDept() {
  await store.searchDepts(keyword.value)
}
async function resetDept() {
  keyword.value = ''
  await store.searchDepts()
}
const deptPayload = () => ({ name: form.name.trim(), parentId: form.parentId, parentName: parentName(form.parentId), orderNum: form.orderNum, phone: form.phone.trim(), address: form.address.trim() })

async function save() {
  if (!form.name.trim()) return ElMessage.warning('请填写部门名称')
  if (isNew.value) {
    await store.addDept(deptPayload())
    ElMessage.success('新增部门成功')
  } else {
    await store.updateDept(form.id, deptPayload())
    ElMessage.success('保存成功')
  }
  dialog.value = false
}
function removeDept(d: SysDept) {
  ElMessageBox.confirm(`确认删除部门「${d.name}」？`, '删除部门', { type: 'warning', confirmButtonText: '删除', cancelButtonText: '取消' })
    .then(async () => {
      await store.removeDept(d.id)
      ElMessage.success('已删除')
    })
    .catch((error) => {
      if (error instanceof Error) ElMessage.warning(error.message)
    })
}

const companyColors = ['from-[#3B83F5] to-[#7368F2]', 'from-[#22b07d] to-[#10b3a3]']
</script>

<template>
  <div class="space-y-5">
    <!-- 顶部：标题 + 搜索 + 新增 -->
    <div class="flex items-center justify-between">
      <div>
        <p class="text-base font-semibold text-ink">{{ root.name }}</p>
        <p class="mt-0.5 text-xs text-ink-muted">{{ companies.length }} 家公司</p>
      </div>
      <div class="flex items-center gap-3">
        <div class="glass-field flex h-10 w-56 items-center gap-2 px-3">
          <el-icon class="text-ink-muted"><Search /></el-icon>
          <input v-model="keyword" placeholder="搜索部门名称" class="w-full border-0 bg-transparent text-sm outline-none placeholder:text-ink-muted" @keydown.enter.prevent="searchDept" />
        </div>
        <button class="btn-ghost h-10 px-4 text-sm" @click="searchDept">查询</button>
        <button class="btn-ghost h-10 px-4 text-sm" @click="resetDept">重置</button>
        <button v-if="auth.hasPermission('sys:dept:add')" class="btn-brand h-10 px-5 text-sm" @click="openAdd()"><el-icon class="mr-1"><Plus /></el-icon>新增部门</button>
      </div>
    </div>

    <!-- 各公司分组 -->
    <GlassCard v-for="(company, ci) in companies" :key="company.id" padding="p-6">
      <!-- 公司头 -->
      <div class="group mb-5 flex items-center gap-3">
        <div class="flex h-11 w-11 items-center justify-center rounded-2xl bg-gradient-to-br text-white shadow-glass-sm" :class="companyColors[ci % 2]">
          <el-icon :size="20"><OfficeBuilding /></el-icon>
        </div>
        <div class="flex-1">
          <p class="font-semibold text-ink">{{ company.name }}</p>
          <p class="text-xs text-ink-muted">排序 {{ company.orderNum }} · {{ company.phone || '未填电话' }}</p>
        </div>
        <div class="flex gap-1.5 opacity-0 transition-all group-hover:opacity-100">
          <button v-if="auth.hasPermission('sys:dept:add')" class="flex h-8 w-8 items-center justify-center rounded-lg bg-brand/10 text-brand hover:bg-brand/20" title="新增下属部门" @click="openAdd(company.id)"><el-icon><Plus /></el-icon></button>
          <button v-if="auth.hasPermission('sys:dept:edit')" class="flex h-8 w-8 items-center justify-center rounded-lg bg-editblue/10 text-editblue hover:bg-editblue/20" title="编辑" @click="openEdit(company)"><el-icon><Edit /></el-icon></button>
          <button v-if="auth.hasPermission('sys:dept:delete')" class="flex h-8 w-8 items-center justify-center rounded-lg bg-danger/10 text-danger hover:bg-danger/20" title="删除" @click="removeDept(company)"><el-icon><Close /></el-icon></button>
        </div>
      </div>

      <!-- 部门卡片网格 -->
      <div class="grid grid-cols-4 gap-4">
        <div
          v-for="dept in deptsOf(company)"
          :key="dept.id"
          class="group relative rounded-card border border-black/5 bg-white/70 p-4 transition-all hover:shadow-glass-sm"
        >
          <div class="absolute right-2.5 top-2.5 flex gap-1 opacity-0 transition-all group-hover:opacity-100">
            <button v-if="auth.hasPermission('sys:dept:edit')" class="flex h-6 w-6 items-center justify-center rounded-md bg-editblue/10 text-editblue hover:bg-editblue/20" @click="openEdit(dept)"><el-icon :size="13"><Edit /></el-icon></button>
            <button v-if="auth.hasPermission('sys:dept:delete')" class="flex h-6 w-6 items-center justify-center rounded-md bg-danger/10 text-danger hover:bg-danger/20" @click="removeDept(dept)"><el-icon :size="13"><Close /></el-icon></button>
          </div>
          <p class="font-medium text-ink">{{ dept.name }}</p>
          <div class="mt-2 space-y-1 text-xs text-ink-muted">
            <p class="flex items-center gap-1.5"><el-icon><Sort /></el-icon>排序 {{ dept.orderNum }}</p>
            <p class="flex items-center gap-1.5"><el-icon><Phone /></el-icon>{{ dept.phone }}</p>
            <p class="flex items-center gap-1.5 truncate"><el-icon><Location /></el-icon><span class="truncate">{{ dept.address }}</span></p>
          </div>
        </div>
      </div>
    </GlassCard>

    <!-- 新增 / 编辑部门弹窗 -->
    <el-dialog v-model="dialog" :title="isNew ? '新增部门' : '编辑部门'" width="440px" align-center>
      <div class="space-y-3">
        <div>
          <label class="mb-1.5 block text-xs text-ink-label">上级部门</label>
          <el-select v-model="form.parentId" placeholder="请选择上级部门" class="w-full" @change="form.parentName = parentName(form.parentId)">
            <el-option v-for="p in parentOptions" :key="p.id" :label="p.name" :value="p.id">
              <span :style="{ paddingLeft: p.level * 14 + 'px' }">{{ p.name }}</span>
            </el-option>
          </el-select>
        </div>
        <div>
          <label class="mb-1.5 block text-xs text-ink-label">部门名称</label>
          <el-input v-model="form.name" placeholder="请输入部门名称" />
        </div>
        <div>
          <label class="mb-1.5 block text-xs text-ink-label">排序号</label>
          <el-input-number v-model="form.orderNum" :min="0" class="!w-full" />
        </div>
        <div>
          <label class="mb-1.5 block text-xs text-ink-label">部门电话</label>
          <el-input v-model="form.phone" placeholder="请输入部门电话" />
        </div>
        <div>
          <label class="mb-1.5 block text-xs text-ink-label">部门地址</label>
          <el-input v-model="form.address" placeholder="请输入部门地址" />
        </div>
      </div>
      <template #footer>
        <button class="btn-ghost h-10 px-5 text-sm" @click="dialog = false">取消</button>
        <button class="btn-brand ml-3 h-10 px-6 text-sm" @click="save">保存</button>
      </template>
    </el-dialog>
  </div>
</template>
