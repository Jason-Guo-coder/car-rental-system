<script setup lang="ts">
import { ref, reactive, computed, nextTick, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import type { ElTree } from 'element-plus'
import GlassCard from '@/components/GlassCard.vue'
import FilterBar from '@/components/FilterBar.vue'
import FilterField from '@/components/FilterField.vue'
import FloatingPagination from '@/components/FloatingPagination.vue'
import { api } from '@/api/backend'
import { useAuthStore } from '@/stores/auth'
import { useSystemStore } from '@/stores/system'
import type { SysRole } from '@/types'

const store = useSystemStore()
const auth = useAuthStore()

// 权限已是树形结构，直接派生给 el-tree（label=name, children=children）
const permTree = computed(() => store.permissions)

const query = reactive({ name: '' })
const page = reactive({ current: 1, size: 5 })

async function searchRoles() {
  await store.searchRoles({
    name: query.name.trim() || undefined,
    page: page.current,
    size: page.size,
  })
}

async function doSearch() {
  page.current = 1
  await searchRoles()
}

async function reset() {
  query.name = ''
  page.current = 1
  await searchRoles()
}

async function changePage(current: number) {
  page.current = current
  await searchRoles()
}

onMounted(searchRoles)

// —— 新增 / 编辑角色 ——
const dialog = ref(false)
const isNew = ref(false)
const form = reactive<Omit<SysRole, 'id'> & { id?: number }>({ name: '', code: '', remark: '', createrId: undefined, permIds: [] })

function openAdd() {
  isNew.value = true
  Object.assign(form, { id: undefined, name: '', code: '', remark: '', createrId: undefined, permIds: [] })
  dialog.value = true
}
function openEdit(r: SysRole) {
  isNew.value = false
  Object.assign(form, { ...r, permIds: [...r.permIds] })
  dialog.value = true
}
async function save() {
  if (!form.name.trim()) return ElMessage.warning('请输入角色名称')
  if (!form.code.trim()) return ElMessage.warning('请输入角色编码')
  if (isNew.value) {
    const { id: _omit, ...rest } = form
    await store.addRole(rest)
    ElMessage.success('新增角色成功')
  } else {
    await store.updateRole(form as SysRole)
    ElMessage.success('保存成功')
  }
  dialog.value = false
}
async function remove(r: SysRole) {
  if (await store.roleHasUser(r.id)) {
    ElMessage.warning('该角色下有用户，不能删除')
    return
  }
  ElMessageBox.confirm(`确认删除角色「${r.name}」？`, '删除角色', { type: 'warning', confirmButtonText: '删除', cancelButtonText: '取消' })
    .then(async () => {
      await store.removeRole(r.id)
      ElMessage.success('已删除')
    })
    .catch((error) => {
      if (error instanceof Error) ElMessage.warning(error.message)
    })
}

// —— 权限分配（树形勾选） ——
const permDialog = ref(false)
const permTarget = reactive({ id: 0, name: '' })
const treeRef = ref<InstanceType<typeof ElTree>>()
const checkedKeys = ref<number[]>([])
const permLoading = ref(false)

async function openPerm(r: SysRole) {
  permTarget.id = r.id
  permTarget.name = r.name
  checkedKeys.value = []
  permDialog.value = true
  permLoading.value = true
  try {
    const data = await api.system.rolePermissionTree(r.id)
    checkedKeys.value = data.checkedList
    r.permIds = [...data.checkedList]
    await nextTick()
    treeRef.value?.setCheckedKeys(data.checkedList, false)
  } finally {
    permLoading.value = false
  }
}
async function savePerm() {
  // 严格勾选，直接对应 sys_role_permission 中保存的权限 id
  const checked = treeRef.value?.getCheckedKeys(false) as number[] ?? []
  await store.setRolePermissions(permTarget.id, checked)
  const role = store.rolePageRows.find((r) => r.id === permTarget.id)
  if (role) role.permIds = checked
  ElMessage.success(`已为「${permTarget.name}」分配权限`)
  permDialog.value = false
}
</script>

<template>
  <div class="role-panel-content">
    <FilterBar @search="doSearch" @reset="reset">
      <FilterField label="角色名称" :grow="1">
        <el-input v-model="query.name" placeholder="请输入角色名称" class="w-full" @keydown.enter.prevent="doSearch" />
      </FilterField>
      <template #actions>
        <button v-if="auth.hasPermission('sys:role:save')" class="btn-brand h-10 px-5 text-sm" @click="openAdd"><el-icon class="mr-1"><Plus /></el-icon>新增角色</button>
      </template>
    </FilterBar>

    <GlassCard class="role-table-card" padding="p-5">
      <el-table :data="store.rolePageRows" class="glass-table" show-overflow-tooltip>
        <el-table-column prop="name" label="角色名称" min-width="140">
          <template #default="{ row }"><span class="font-medium text-ink">{{ row.name }}</span></template>
        </el-table-column>
        <el-table-column prop="code" label="角色编码" min-width="170">
          <template #default="{ row }">
            <code class="rounded bg-brand/8 px-2 py-0.5 text-xs text-brand">{{ row.code }}</code>
          </template>
        </el-table-column>
        <el-table-column label="权限数" min-width="90">
          <template #default="{ row }">{{ row.permIds.length }} 项</template>
        </el-table-column>
        <el-table-column prop="remark" label="角色描述" min-width="200" />
        <el-table-column label="操作" width="120">
          <template #default="{ row }">
            <div class="flex gap-2">
              <button v-if="auth.hasPermission('sys:role:edit')" class="flex h-8 w-8 items-center justify-center rounded-lg bg-editblue/10 text-editblue hover:bg-editblue/20" title="编辑" @click="openEdit(row)">
                <el-icon><Edit /></el-icon>
              </button>
              <button class="flex h-8 w-8 items-center justify-center rounded-lg bg-permteal/10 text-permteal hover:bg-permteal/20" title="权限分配" @click="openPerm(row)">
                <el-icon><Key /></el-icon>
              </button>
              <button v-if="auth.hasPermission('sys:role:delete')" class="flex h-8 w-8 items-center justify-center rounded-lg bg-danger/10 text-danger hover:bg-danger/20" title="删除" @click="remove(row)">
                <el-icon><Close /></el-icon>
              </button>
            </div>
          </template>
        </el-table-column>
      </el-table>
    </GlassCard>

    <FloatingPagination v-model:current-page="page.current" :total="store.roleTotal" :page-size="page.size" @change="changePage" />

    <!-- 新增 / 编辑角色弹窗 -->
    <el-dialog v-model="dialog" :title="isNew ? '新增角色' : '编辑角色'" width="440px" align-center>
      <div class="space-y-3">
        <div>
          <label class="mb-1.5 block text-xs text-ink-label">角色名称</label>
          <el-input v-model="form.name" placeholder="如：客服专员" />
        </div>
        <div>
          <label class="mb-1.5 block text-xs text-ink-label">角色编码</label>
          <el-input v-model="form.code" placeholder="如：ROLE_SERVICE" />
        </div>
        <div>
          <label class="mb-1.5 block text-xs text-ink-label">角色描述</label>
          <el-input v-model="form.remark" type="textarea" :rows="2" placeholder="请输入角色描述" />
        </div>
      </div>
      <template #footer>
        <button class="btn-ghost h-10 px-5 text-sm" @click="dialog = false">取消</button>
        <button class="btn-brand ml-3 h-10 px-6 text-sm" @click="save">保存</button>
      </template>
    </el-dialog>

    <!-- 权限分配弹窗（树形勾选） -->
    <el-dialog v-model="permDialog" title="权限分配" width="440px" top="8vh" class="perm-dialog">
      <p class="mb-3 text-sm text-ink-soft">为角色「<span class="font-medium text-ink">{{ permTarget.name }}</span>」勾选权限</p>
      <div v-loading="permLoading" class="max-h-[56vh] overflow-y-auto rounded-card border border-black/5 bg-white/40 p-2">
        <el-tree
          ref="treeRef"
          :data="permTree"
          show-checkbox
          node-key="id"
          :default-checked-keys="checkedKeys"
          :default-expand-all="true"
          check-strictly
          :props="{ label: 'name', children: 'children' }"
        />
      </div>
      <template #footer>
        <button class="btn-ghost h-10 px-5 text-sm" @click="permDialog = false">取消</button>
        <button class="btn-brand ml-3 h-10 px-6 text-sm" @click="savePerm">确认分配</button>
      </template>
    </el-dialog>
  </div>
</template>

<style scoped>
.role-panel-content {
  position: relative;
  display: flex;
  flex-direction: column;
  gap: 20px;
  margin-bottom: 76px;
}

.role-table-card {
  flex: 0 0 auto;
  min-height: 0;
}

/* 权限树融入玻璃风 */
.perm-dialog :deep(.el-tree) {
  background: transparent;
  color: #1f2330;
}
.perm-dialog :deep(.el-tree-node__content) {
  height: 34px;
  border-radius: 8px;
}
.perm-dialog :deep(.el-tree-node__content:hover) {
  background: rgba(91, 110, 240, 0.06);
}
</style>
