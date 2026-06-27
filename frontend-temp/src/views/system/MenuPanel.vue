<script setup lang="ts">
import { ref, reactive, computed } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import GlassCard from '@/components/GlassCard.vue'
import StatusBadge from '@/components/StatusBadge.vue'
import { useSystemStore } from '@/stores/system'
import { permTypeMeta } from '@/utils/dict'
import type { SysPermission } from '@/types'

const store = useSystemStore()

// 上级菜单下拉使用旧前端同款 /permission/tree：后端排除按钮并补充根目录。
const parentOptions = computed(() => {
  const out: { id: number; name: string; level: number }[] = []
  const walk = (list: SysPermission[], level = 0) => {
    for (const p of list) {
      out.push({ id: p.id, name: p.name, level })
      if (p.children) walk(p.children, level + 1)
    }
  }
  walk(store.permissionParents)
  if (!out.some((p) => p.id === 0)) out.unshift({ id: 0, name: '根目录', level: 0 })
  return out
})

// 新增 / 编辑弹窗
const dialog = ref(false)
const isNew = ref(false)
const form = reactive<Omit<SysPermission, 'id' | 'children'> & { id?: number }>({
  name: '', parentId: 0, parentLabel: '根目录', type: 'menu', routeName: '', routePath: '', componentPath: '', icon: '', permCode: '',
})

async function ensureParentOptions() {
  if (!store.permissionParents.length) await store.loadPermissionParents()
}
function syncParentLabel() {
  form.parentLabel = parentOptions.value.find((p) => p.id === form.parentId)?.name ?? ''
}
async function openAdd() {
  await ensureParentOptions()
  isNew.value = true
  Object.assign(form, { id: undefined, name: '', parentId: 0, parentLabel: '根目录', type: 'menu', routeName: '', routePath: '', componentPath: '', icon: '', permCode: '' })
  dialog.value = true
}
async function openEdit(p: SysPermission) {
  await ensureParentOptions()
  isNew.value = false
  Object.assign(form, { id: p.id, name: p.name, parentId: p.parentId, parentLabel: p.parentLabel, type: p.type, routeName: p.routeName, routePath: p.routePath, componentPath: p.componentPath, icon: p.icon, permCode: p.permCode })
  if (!form.parentLabel) syncParentLabel()
  dialog.value = true
}
async function save() {
  if (!form.name.trim()) return ElMessage.warning('请填写菜单名称')
  syncParentLabel()
  if (isNew.value) {
    const { id: _omit, ...rest } = form
    await store.addPermission(rest)
    ElMessage.success('新增菜单成功')
  } else {
    await store.updatePermission(form as SysPermission)
    ElMessage.success('保存成功')
  }
  dialog.value = false
}
async function remove(p: SysPermission) {
  if (await store.permissionHasChildren(p.id)) {
    ElMessage.warning('该菜单下有子菜单，不能删除')
    return
  }
  ElMessageBox.confirm(`确认删除菜单「${p.name}」？`, '删除菜单', { type: 'warning', confirmButtonText: '删除', cancelButtonText: '取消' })
    .then(async () => {
      await store.removePermission(p.id)
      ElMessage.success('已删除')
    })
    .catch(() => {})
}

const dash = (s: string) => (s && s !== '—' ? s : '')

// 菜单图标可选项（Element Plus 图标名）
const iconOptions = ['Odometer', 'Van', 'OfficeBuilding', 'PriceTag', 'Tickets', 'Key', 'RefreshLeft', 'List', 'Warning', 'Tools', 'User', 'TrendCharts', 'Money', 'Setting', 'Lock']
</script>

<template>
  <div>
    <GlassCard padding="p-5">
      <div class="mb-4 flex items-center justify-between">
        <p class="text-base font-semibold text-ink">菜单 / 权限列表</p>
        <button class="btn-brand h-10 px-5 text-sm" @click="openAdd"><el-icon class="mr-1"><Plus /></el-icon>新增菜单</button>
      </div>

      <el-table :data="store.permissions" class="glass-table" row-key="id" :indent="40" :tree-props="{ children: 'children' }" show-overflow-tooltip>
        <el-table-column label="菜单名称" min-width="200">
          <template #default="{ row }">
            <span :class="row.type === 'catalog' ? 'text-[15px] font-semibold text-ink' : row.type === 'menu' ? 'text-sm font-medium text-ink' : 'text-sm text-ink-muted'">{{ row.name }}</span>
          </template>
        </el-table-column>
        <el-table-column label="菜单类型" width="110">
          <template #default="{ row }">
            <StatusBadge :text="permTypeMeta[row.type].text" :tone="permTypeMeta[row.type].tone" />
          </template>
        </el-table-column>
        <el-table-column label="路由名称" min-width="120">
          <template #default="{ row }"><span class="text-ink-soft">{{ dash(row.routeName) || '—' }}</span></template>
        </el-table-column>
        <el-table-column label="路由地址" min-width="150">
          <template #default="{ row }"><span class="text-ink-soft">{{ dash(row.routePath) || '—' }}</span></template>
        </el-table-column>
        <el-table-column label="组件路径" min-width="170">
          <template #default="{ row }"><span class="text-ink-muted">{{ dash(row.componentPath) || '—' }}</span></template>
        </el-table-column>
        <el-table-column label="权限标识" min-width="150">
          <template #default="{ row }">
            <code v-if="row.permCode !== '—'" class="rounded bg-ink/5 px-2 py-0.5 text-xs text-ink-soft">{{ row.permCode }}</code>
            <span v-else class="text-ink-muted">—</span>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="110">
          <template #default="{ row }">
            <div class="flex gap-2">
              <button class="flex h-8 w-8 items-center justify-center rounded-lg bg-editblue/10 text-editblue hover:bg-editblue/20" title="编辑" @click="openEdit(row)">
                <el-icon><Edit /></el-icon>
              </button>
              <button class="flex h-8 w-8 items-center justify-center rounded-lg bg-danger/10 text-danger hover:bg-danger/20" title="删除" @click="remove(row)">
                <el-icon><Close /></el-icon>
              </button>
            </div>
          </template>
        </el-table-column>
      </el-table>
    </GlassCard>

    <!-- 新增 / 编辑菜单弹窗 -->
    <el-dialog v-model="dialog" :title="isNew ? '新增菜单' : '编辑菜单'" width="560px" align-center>
      <div class="grid grid-cols-2 gap-x-4 gap-y-3">
        <div class="col-span-2">
          <label class="mb-1.5 block text-xs text-ink-label">上级菜单</label>
          <el-select v-model="form.parentId" placeholder="请选择上级菜单" class="w-full" @change="syncParentLabel">
            <el-option v-for="o in parentOptions" :key="o.id" :label="o.name" :value="o.id">
              <span :style="{ paddingLeft: o.level * 14 + 'px' }">{{ o.name }}</span>
            </el-option>
          </el-select>
        </div>
        <div>
          <label class="mb-1.5 block text-xs text-ink-label">菜单名称</label>
          <el-input v-model="form.name" placeholder="请输入菜单名称" />
        </div>
        <div>
          <label class="mb-1.5 block text-xs text-ink-label">菜单类型</label>
          <el-select v-model="form.type" class="w-full">
            <el-option label="根目录" value="catalog" />
            <el-option label="菜单" value="menu" />
            <el-option label="按钮" value="button" />
          </el-select>
        </div>
        <div>
          <label class="mb-1.5 block text-xs text-ink-label">权限标识</label>
          <el-input v-model="form.permCode" placeholder="请输入权限标识" />
        </div>
        <div>
          <label class="mb-1.5 block text-xs text-ink-label">组件路径</label>
          <el-input v-model="form.componentPath" placeholder="请输入组件路径" />
        </div>
        <div class="col-span-2">
          <label class="mb-1.5 block text-xs text-ink-label">菜单图标</label>
          <el-select v-model="form.icon" placeholder="请选择图标" class="w-full" clearable>
            <el-option v-for="ic in iconOptions" :key="ic" :label="ic" :value="ic">
              <span class="flex items-center gap-2"><el-icon><component :is="ic" /></el-icon>{{ ic }}</span>
            </el-option>
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
