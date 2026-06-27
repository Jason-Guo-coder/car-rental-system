<script setup lang="ts">
import { ref, reactive, computed } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import type { UploadRequestOptions } from 'element-plus'
import GlassCard from '@/components/GlassCard.vue'
import FilterBar from '@/components/FilterBar.vue'
import FilterField from '@/components/FilterField.vue'
import FloatingPagination from '@/components/FloatingPagination.vue'
import { useAppliedFilter } from '@/composables/useAppliedFilter'
import { uploadFile } from '@/api/http'
import { useAuthStore } from '@/stores/auth'
import { useSystemStore } from '@/stores/system'
import type { SysDept, SysUser } from '@/types'

const store = useSystemStore()
const auth = useAuthStore()
type UserFilter = {
  username: string
  realName: string
  nickname: string
  gender: '' | '男' | '女'
  deptName: string
  phone: string
  email: string
}
const expandedIds = ref<Set<number>>(new Set([1, 2, 3]))
const page = reactive({ current: 1, size: 10 })
// 当前选中的部门（0 = 所有部门）
const activeDeptId = ref(0)

function toggle(id: number) {
  if (expandedIds.value.has(id)) expandedIds.value.delete(id)
  else expandedIds.value.add(id)
}

interface FlatNode {
  dept: SysDept
  level: number
  hasChildren: boolean
}

// 树形扁平化为可渲染列表（受展开状态控制）
function flatten(nodes: SysDept[], level = 0, out: FlatNode[] = []): FlatNode[] {
  for (const dept of nodes) {
    const hasChildren = !!dept.children?.length
    out.push({ dept, level, hasChildren })
    if (hasChildren && expandedIds.value.has(dept.id)) flatten(dept.children!, level + 1, out)
  }
  return out
}

// 点击树节点：按老前端契约把单个 deptId 交给后端查询；"所有部门" 不传 deptId。
async function selectDept(node: SysDept) {
  activeDeptId.value = node.parentId === 0 ? 0 : node.id
  page.current = 1
  await searchUsers()
}

// 所有叶子部门（过滤/弹窗下拉用）
const leafDepts = computed(() => {
  const out: { id: number; name: string }[] = []
  function walk(nodes: SysDept[]) {
    for (const d of nodes) {
      if (d.children?.length) walk(d.children)
      else out.push({ id: d.id, name: d.name })
    }
  }
  walk(store.deptTree)
  return out
})

// 多字段过滤：账号/姓名/昵称/性别/部门/电话/邮箱（点击查询才生效）
const { form, applied, doSearch: applySearch, reset: resetFilter } = useAppliedFilter<UserFilter>(() => ({
  username: '',
  realName: '',
  nickname: '',
  gender: '',
  deptName: '',
  phone: '',
  email: '',
}))

async function searchUsers() {
  await store.searchUsers({
    ...applied,
    gender: applied.gender || undefined,
    deptId: activeDeptId.value || undefined,
    page: page.current,
    size: page.size,
  })
}

async function doSearch() {
  applySearch()
  page.current = 1
  await searchUsers()
}

async function reset() {
  resetFilter()
  activeDeptId.value = 0
  page.current = 1
  await searchUsers()
}

async function changePage(current: number) {
  page.current = current
  await searchUsers()
}

function removeUser(u: SysUser) {
  ElMessageBox.confirm(`确认删除用户「${u.realName}」？`, '删除用户', { type: 'warning', confirmButtonText: '删除', cancelButtonText: '取消' })
    .then(() => {
      store.removeUser(u.id)
      ElMessage.success('已删除')
    })
    .catch(() => {})
}

// 新增 / 编辑弹窗（含角色选择）
const dialog = ref(false)
const isNew = ref(false)
const editing = reactive<Omit<SysUser, 'id'> & { id?: number }>({
  username: '', realName: '', nickname: '', gender: '男', deptId: 0, deptName: '', phone: '', email: '', avatar: '', password: '', roleIds: [], roleName: '', enabled: true,
})
function openAdd() {
  isNew.value = true
  Object.assign(editing, { id: undefined, username: '', realName: '', nickname: '', gender: '男', deptId: leafDepts.value[0]?.id ?? 0, deptName: '', phone: '', email: '', avatar: '', password: '', roleIds: [], roleName: '', enabled: true })
  dialog.value = true
}
function openEdit(u: SysUser) {
  isNew.value = false
  Object.assign(editing, { ...u, password: '', roleIds: [] })
  dialog.value = true
}
function save() {
  if (!editing.username.trim()) return ElMessage.warning('请填写用户账号')
  if (isNew.value && !editing.password?.trim()) return ElMessage.warning('请填写用户密码')
  if (!editing.realName.trim()) return ElMessage.warning('请填写真实姓名')
  editing.deptName = leafDepts.value.find((d) => d.id === editing.deptId)?.name ?? ''
  if (isNew.value) {
    const { id: _omit, ...rest } = editing
    store.addUser(rest)
    ElMessage.success('新增用户成功')
  } else {
    store.updateUser(editing as SysUser)
    ElMessage.success('保存成功')
  }
  dialog.value = false
}

async function uploadAvatar(options: UploadRequestOptions) {
  try {
    editing.avatar = await uploadFile('/rental/oss/upload', options.file)
    options.onSuccess?.(editing.avatar)
    ElMessage.success('头像上传成功')
  } catch (error) {
    const message = error instanceof Error ? error.message : '头像上传失败'
    const uploadError = Object.assign(new Error(message), { name: 'UploadAjaxError', status: 0, method: 'POST', url: '/rental/oss/upload' }) as Parameters<NonNullable<UploadRequestOptions['onError']>>[0]
    options.onError?.(uploadError)
    ElMessage.error(message)
  }
}

function beforeAvatarUpload(file: File) {
  const isImage = file.type === 'image/jpeg' || file.type === 'image/png'
  const isLt2M = file.size / 1024 / 1024 < 2
  if (!isImage) ElMessage.error('上传头像图片只能是 JPG 或 PNG 格式')
  if (!isLt2M) ElMessage.error('上传头像图片大小不能超过 2MB')
  return isImage && isLt2M
}

// 绑定角色弹窗
const roleDialog = ref(false)
const roleTarget = reactive({ id: 0, realName: '', roleIds: [] as number[] })
async function openBindRole(u: SysUser) {
  roleTarget.id = u.id
  roleTarget.realName = u.realName
  roleTarget.roleIds = await store.userRoleIds(u.id)
  roleDialog.value = true
}
function saveBindRole() {
  store.bindRole(roleTarget.id, roleTarget.roleIds)
  ElMessage.success(`已为 ${roleTarget.realName} 绑定角色`)
  roleDialog.value = false
}

// 头像颜色轮转
const avatarColors = ['from-[#3B83F5] to-[#7368F2]', 'from-[#22b07d] to-[#10b3a3]', 'from-[#f5a623] to-[#f97316]', 'from-[#9b5de5] to-[#7368f2]']
</script>

<template>
  <div class="user-panel-grid grid grid-cols-[220px_1fr] gap-5">
    <!-- 左：部门树 -->
    <GlassCard padding="p-4">
      <p class="mb-3 px-2 text-sm font-semibold text-ink">部门</p>
      <div class="space-y-0.5">
        <div
          v-for="node in flatten(store.deptTree)"
          :key="node.dept.id"
          class="flex cursor-pointer items-center gap-2 rounded-field py-2 pr-2 text-sm transition-all"
          :class="(node.dept.parentId === 0 ? activeDeptId === 0 : activeDeptId === node.dept.id) ? 'bg-brand/10 text-brand' : 'text-ink-soft hover:bg-white/60'"
          :style="{ paddingLeft: 8 + node.level * 18 + 'px' }"
          @click="selectDept(node.dept)"
        >
          <el-icon v-if="node.hasChildren" :size="14" class="transition-transform" :class="expandedIds.has(node.dept.id) ? 'rotate-90' : ''" @click.stop="toggle(node.dept.id)">
            <CaretRight />
          </el-icon>
          <span v-else class="ml-1 h-1.5 w-1.5 rounded-full bg-ink-muted/40" />
          {{ node.dept.name }}
        </div>
      </div>
    </GlassCard>

    <!-- 右：过滤栏 + 用户表 -->
    <div class="user-panel-content">
      <FilterBar @search="doSearch" @reset="reset">
        <FilterField label="用户账号" :grow="1">
          <el-input v-model="form.username" placeholder="账号" class="w-full" />
        </FilterField>
        <FilterField label="真实姓名" :grow="1">
          <el-input v-model="form.realName" placeholder="姓名" class="w-full" />
        </FilterField>
        <FilterField label="用户昵称" :grow="1">
          <el-input v-model="form.nickname" placeholder="昵称" class="w-full" />
        </FilterField>
        <FilterField label="用户性别" :grow="1">
          <el-select v-model="form.gender" placeholder="全部" clearable class="w-full">
            <el-option label="男" value="男" />
            <el-option label="女" value="女" />
          </el-select>
        </FilterField>
        <FilterField label="用户电话" :grow="1.2">
          <el-input v-model="form.phone" placeholder="电话" class="w-full" />
        </FilterField>
        <FilterField label="电子邮箱" :grow="1.4">
          <el-input v-model="form.email" placeholder="邮箱" class="w-full" />
        </FilterField>
        <template #actions>
          <button v-if="auth.hasPermission('sys:user:add')" class="btn-brand h-10 px-5 text-sm" @click="openAdd"><el-icon class="mr-1"><Plus /></el-icon>新增用户</button>
        </template>
      </FilterBar>

      <GlassCard class="user-table-card" padding="p-5">
        <el-table :data="store.users" class="glass-table" show-overflow-tooltip>
          <el-table-column label="头像" width="60">
            <template #default="{ row, $index }">
              <img v-if="row.avatar" :src="row.avatar" :alt="row.realName" class="h-9 w-9 rounded-full object-cover" />
              <div v-else class="flex h-9 w-9 items-center justify-center rounded-full bg-gradient-to-br text-sm font-medium text-white" :class="avatarColors[$index % 4]">
                {{ row.realName.charAt(0) }}
              </div>
            </template>
          </el-table-column>
          <el-table-column prop="username" label="用户账号" min-width="90" />
          <el-table-column prop="realName" label="真实姓名" min-width="78" />
          <el-table-column prop="nickname" label="用户昵称" min-width="78" />
          <el-table-column prop="gender" label="性别" min-width="55" />
          <el-table-column prop="deptName" label="所在部门" min-width="95" />
          <el-table-column prop="phone" label="用户电话" min-width="115" />
          <el-table-column prop="email" label="电子邮箱" min-width="140" />
          <el-table-column label="操作" width="120">
            <template #default="{ row }">
              <div class="flex gap-2">
                <button v-if="auth.hasPermission('sys:user:edit')" class="flex h-8 w-8 items-center justify-center rounded-lg bg-editblue/10 text-editblue hover:bg-editblue/20" title="编辑" @click="openEdit(row)">
                  <el-icon><Edit /></el-icon>
                </button>
                <button class="flex h-8 w-8 items-center justify-center rounded-lg bg-rolepurple/10 text-rolepurple hover:bg-rolepurple/20" title="绑定角色" @click="openBindRole(row)">
                  <el-icon><UserFilled /></el-icon>
                </button>
                <button v-if="auth.hasPermission('sys:user:delete')" class="flex h-8 w-8 items-center justify-center rounded-lg bg-danger/10 text-danger hover:bg-danger/20" title="删除" @click="removeUser(row)">
                  <el-icon><Close /></el-icon>
                </button>
              </div>
            </template>
          </el-table-column>
        </el-table>
      </GlassCard>

      <FloatingPagination v-model:current-page="page.current" :total="store.userTotal" :page-size="page.size" @change="changePage" />
    </div>

    <!-- 新增 / 编辑用户弹窗（含绑定角色） -->
    <el-dialog v-model="dialog" :title="isNew ? '新增用户' : '编辑用户'" width="560px" align-center>
      <div class="grid grid-cols-2 gap-x-4 gap-y-3">
        <div class="col-span-2">
          <label class="mb-1.5 block text-xs text-ink-label">用户头像</label>
          <el-upload
            :http-request="uploadAvatar"
            :before-upload="beforeAvatarUpload"
            :show-file-list="false"
            accept="image/jpeg,image/png"
          >
            <div class="flex h-20 w-20 items-center justify-center overflow-hidden rounded-full border border-dashed border-black/15 bg-white/70 text-ink-muted transition-colors hover:border-brand hover:text-brand">
              <img v-if="editing.avatar" :src="editing.avatar" :alt="editing.realName || editing.username" class="h-full w-full object-cover" />
              <el-icon v-else :size="22"><Plus /></el-icon>
            </div>
          </el-upload>
        </div>
        <div>
          <label class="mb-1.5 block text-xs text-ink-label">用户账号</label>
          <el-input v-model="editing.username" placeholder="请输入账号" />
        </div>
        <div>
          <label class="mb-1.5 block text-xs text-ink-label">真实姓名</label>
          <el-input v-model="editing.realName" placeholder="请输入姓名" />
        </div>
        <div v-if="isNew">
          <label class="mb-1.5 block text-xs text-ink-label">用户密码</label>
          <el-input v-model="editing.password" placeholder="请输入密码" show-password />
        </div>
        <div>
          <label class="mb-1.5 block text-xs text-ink-label">用户昵称</label>
          <el-input v-model="editing.nickname" placeholder="请输入昵称" />
        </div>
        <div>
          <label class="mb-1.5 block text-xs text-ink-label">用户性别</label>
          <el-select v-model="editing.gender" class="w-full">
            <el-option label="男" value="男" />
            <el-option label="女" value="女" />
          </el-select>
        </div>
        <div>
          <label class="mb-1.5 block text-xs text-ink-label">所在部门</label>
          <el-select v-model="editing.deptId" placeholder="请选择部门" class="w-full">
            <el-option v-for="d in leafDepts" :key="d.id" :label="d.name" :value="d.id" />
          </el-select>
        </div>
        <div>
          <label class="mb-1.5 block text-xs text-ink-label">绑定角色</label>
          <el-select v-model="editing.roleIds" placeholder="请选择角色" multiple collapse-tags collapse-tags-tooltip class="w-full">
            <el-option v-for="r in store.roles" :key="r.id" :label="r.name" :value="r.id" />
          </el-select>
        </div>
        <div>
          <label class="mb-1.5 block text-xs text-ink-label">用户电话</label>
          <el-input v-model="editing.phone" placeholder="请输入电话" />
        </div>
        <div>
          <label class="mb-1.5 block text-xs text-ink-label">电子邮箱</label>
          <el-input v-model="editing.email" placeholder="请输入邮箱" />
        </div>
      </div>
      <template #footer>
        <button class="btn-ghost h-10 px-5 text-sm" @click="dialog = false">取消</button>
        <button class="btn-brand ml-3 h-10 px-6 text-sm" @click="save">保存</button>
      </template>
    </el-dialog>

    <!-- 绑定角色弹窗 -->
    <el-dialog v-model="roleDialog" title="绑定角色" width="380px" align-center>
      <p class="mb-3 text-sm text-ink-soft">为用户「<span class="font-medium text-ink">{{ roleTarget.realName }}</span>」绑定角色</p>
      <label class="mb-1.5 block text-xs text-ink-label">选择角色</label>
      <el-select v-model="roleTarget.roleIds" placeholder="请选择角色" multiple collapse-tags collapse-tags-tooltip class="w-full">
        <el-option v-for="r in store.roles" :key="r.id" :label="r.name" :value="r.id" />
      </el-select>
      <template #footer>
        <button class="btn-ghost h-10 px-5 text-sm" @click="roleDialog = false">取消</button>
        <button class="btn-brand ml-3 h-10 px-6 text-sm" @click="saveBindRole">确认绑定</button>
      </template>
    </el-dialog>
  </div>
</template>

<style scoped>
.user-panel-grid {
  align-items: stretch;
  margin-bottom: 76px;
}

.user-panel-content {
  position: relative;
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.user-table-card {
  flex: 0 0 auto;
  min-height: 0;
}
</style>
