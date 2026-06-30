<script setup lang="ts">
import { ref, reactive, computed, watch } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Search } from '@element-plus/icons-vue'
import PageHeader from '@/components/PageHeader.vue'
import GlassCard from '@/components/GlassCard.vue'
import BatchDeleteButton from '@/components/BatchDeleteButton.vue'
import SelectCheckbox from '@/components/SelectCheckbox.vue'
import CircleIconButton from '@/components/CircleIconButton.vue'
import { useBatchDelete } from '@/composables/useBatchDelete'
import { useMakerStore } from '@/stores/maker'
import { useAuthStore } from '@/stores/auth'

const store = useMakerStore()
const auth = useAuthStore()
const makerKeyword = ref('')
const brandKeyword = ref('')
const brandMakerId = ref<number | undefined>(undefined)

const filteredMakers = computed(() => store.makers.filter((m) => m.name.includes(makerKeyword.value)))
const filteredBrands = computed(() => store.brandsOfActive)
const activeMaker = computed(() => store.makers.find((m) => m.id === store.activeMakerId))
const makerBatch = useBatchDelete((ids) => store.removeManyMakers(ids), '厂商')
const brandBatch = useBatchDelete((ids) => store.removeManyBrands(ids), '品牌')

watch([brandKeyword, brandMakerId], () => {
  store.searchBrands(brandKeyword.value, brandMakerId.value)
})

function removeMaker(id: number, name: string) {
  if (!auth.hasPermission('auto:maker:delete')) return ElMessage.warning('当前账号没有该操作权限')
  ElMessageBox.confirm(`确认删除厂商「${name}」及其所有品牌？`, '删除厂商', { type: 'warning', confirmButtonText: '删除', cancelButtonText: '取消' })
    .then(() => {
      store.removeMaker(id)
      ElMessage.success('已删除')
    })
    .catch(() => {})
}
function removeBrand(id: number, name: string) {
  if (!auth.hasPermission('auto:brand:delete')) return ElMessage.warning('当前账号没有该操作权限')
  ElMessageBox.confirm(`确认删除品牌「${name}」？`, '删除品牌', { type: 'warning', confirmButtonText: '删除', cancelButtonText: '取消' })
    .then(() => {
      store.removeBrand(id)
      ElMessage.success('已删除')
    })
    .catch(() => {})
}

// 厂商弹窗（仅填名称）
const makerDialog = ref(false)
const makerIsNew = ref(false)
const makerForm = reactive({ id: 0, name: '', orderLetter: '' })
function openAddMaker() {
  if (!auth.hasPermission('auto:maker:add')) return ElMessage.warning('当前账号没有该操作权限')
  makerIsNew.value = true
  Object.assign(makerForm, { id: 0, name: '', orderLetter: '' })
  makerDialog.value = true
}
function openEditMaker(m: { id: number; name: string; orderLetter: string }) {
  if (!auth.hasPermission('auto:maker:edit')) return ElMessage.warning('当前账号没有该操作权限')
  makerIsNew.value = false
  makerForm.id = m.id
  makerForm.name = m.name
  makerForm.orderLetter = m.orderLetter
  makerDialog.value = true
}
function saveMaker() {
  if (!auth.hasPermission(makerIsNew.value ? 'auto:maker:add' : 'auto:maker:edit')) return ElMessage.warning('当前账号没有该操作权限')
  if (!makerForm.name.trim()) return ElMessage.warning('请输入厂商名称')
  if (makerIsNew.value) {
    store.addMaker(makerForm.name.trim(), '—', makerForm.name.trim().charAt(0), makerForm.orderLetter.trim())
    ElMessage.success('新增厂商成功')
  } else {
    store.updateMaker(makerForm.id, makerForm.name.trim(), makerForm.orderLetter.trim())
    ElMessage.success('已保存')
  }
  makerDialog.value = false
}

// 品牌弹窗（对应厂商下拉 + 名称）
const brandDialog = ref(false)
const brandIsNew = ref(false)
const brandForm = reactive({ id: 0, makerId: 0, name: '' })
function openAddBrand() {
  if (!auth.hasPermission('auto:brand:add')) return ElMessage.warning('当前账号没有该操作权限')
  brandIsNew.value = true
  Object.assign(brandForm, { id: 0, makerId: store.activeMakerId, name: '' })
  brandDialog.value = true
}
function openEditBrand(b: { id: number; makerId: number; name: string }) {
  if (!auth.hasPermission('auto:brand:edit')) return ElMessage.warning('当前账号没有该操作权限')
  brandIsNew.value = false
  brandForm.id = b.id
  brandForm.makerId = b.makerId
  brandForm.name = b.name
  brandDialog.value = true
}
function saveBrand() {
  if (!auth.hasPermission(brandIsNew.value ? 'auto:brand:add' : 'auto:brand:edit')) return ElMessage.warning('当前账号没有该操作权限')
  if (!brandForm.makerId) return ElMessage.warning('请选择所属厂商')
  if (!brandForm.name.trim()) return ElMessage.warning('请输入品牌名称')
  if (brandIsNew.value) {
    store.addBrand(brandForm.makerId, brandForm.name.trim())
    ElMessage.success('新增品牌成功')
  } else {
    store.updateBrand(brandForm.id, brandForm.makerId, brandForm.name.trim())
    ElMessage.success('已保存')
  }
  brandDialog.value = false
}

// 品牌色块颜色轮转
const brandColors = ['from-[#3B83F5] to-[#7368F2]', 'from-[#22b07d] to-[#10b3a3]', 'from-[#f5a623] to-[#f97316]', 'from-[#9b5de5] to-[#7368f2]', 'from-[#f472b6] to-[#fb7185]', 'from-[#38bdf8] to-[#3b82f6]']
</script>

<template>
  <div class="space-y-6">
    <PageHeader title="厂商品牌" subtitle="汽车厂商与旗下品牌的层级管理" />

    <div class="grid grid-cols-[340px_1fr] gap-5">
      <!-- 左：厂商列表 -->
      <GlassCard padding="p-5">
        <div class="mb-4 flex items-center gap-2">
          <div class="glass-field flex h-10 flex-1 items-center gap-2 px-3">
            <el-icon class="text-ink-muted"><Search /></el-icon>
            <input v-model="makerKeyword" placeholder="搜索厂商" class="w-full border-0 bg-transparent text-sm outline-none placeholder:text-ink-muted" />
          </div>
          <CircleIconButton v-if="auth.hasPermission('auto:maker:add')" icon="Plus" title="新增厂商" tone="brand" @click="openAddMaker" />
          <CircleIconButton v-if="auth.hasPermission('auto:maker:delete')" icon="Delete" title="批量删除" tone="danger" :active="makerBatch.active.value" @click="makerBatch.trigger" />
          <CircleIconButton v-if="makerBatch.active.value" icon="Close" title="取消选择" @click="makerBatch.exit" />
        </div>
        <div class="space-y-1.5">
          <div
            v-for="m in filteredMakers"
            :key="m.id"
            class="group flex cursor-pointer items-center gap-3 rounded-field px-3 py-2.5 transition-all"
            :class="store.activeMakerId === m.id ? 'bg-brand-gradient text-white shadow-glass-sm' : 'hover:bg-white/60'"
            @click="store.selectMaker(m.id)"
          >
            <SelectCheckbox v-if="makerBatch.active.value" :checked="makerBatch.isSelected(m.id)" @toggle="makerBatch.toggle(m.id)" @click.stop />
            <div
              class="flex h-9 w-9 shrink-0 items-center justify-center rounded-xl text-xs font-bold"
              :class="store.activeMakerId === m.id ? 'bg-white/25 text-white' : 'bg-brand/10 text-brand'"
            >
              {{ m.logo }}
            </div>
            <div class="flex-1">
              <p class="text-sm font-medium" :class="store.activeMakerId === m.id ? 'text-white' : 'text-ink'">{{ m.name }}</p>
              <p class="text-xs" :class="store.activeMakerId === m.id ? 'text-white/75' : 'text-ink-muted'">排序 {{ m.orderLetter || '—' }} · {{ m.brandCount }} 品牌</p>
            </div>
            <div class="flex gap-1 opacity-0 transition-all group-hover:opacity-100">
              <button
                v-if="auth.hasPermission('auto:maker:edit')"
                class="flex h-7 w-7 items-center justify-center rounded-lg"
                :class="store.activeMakerId === m.id ? 'bg-white/20 text-white hover:bg-white/30' : 'bg-editblue/10 text-editblue hover:bg-editblue/20'"
                @click.stop="openEditMaker(m)"
              >
                <el-icon><Edit /></el-icon>
              </button>
              <button
                v-if="auth.hasPermission('auto:maker:delete')"
                class="flex h-7 w-7 items-center justify-center rounded-lg"
                :class="store.activeMakerId === m.id ? 'bg-white/20 text-white hover:bg-white/30' : 'bg-danger/10 text-danger hover:bg-danger/20'"
                @click.stop="removeMaker(m.id, m.name)"
              >
                <el-icon><Close /></el-icon>
              </button>
            </div>
          </div>
        </div>
      </GlassCard>

      <!-- 右：品牌网格（16:27 竖向圆角卡，车标横向居中） -->
      <GlassCard padding="p-5">
        <div class="mb-4 flex items-center justify-between">
          <p class="text-base font-semibold text-ink">{{ brandMakerId ? activeMaker?.name : '全部厂商' }} · 品牌</p>
          <div class="flex items-center gap-3">
            <el-select v-model="brandMakerId" placeholder="全部厂商" clearable class="!w-36">
              <el-option v-for="m in store.makers" :key="m.id" :label="m.name" :value="m.id" />
            </el-select>
            <div class="glass-field flex h-10 w-56 items-center gap-2 px-3">
              <el-icon class="text-ink-muted"><Search /></el-icon>
              <input v-model="brandKeyword" placeholder="搜索品牌" class="w-full border-0 bg-transparent text-sm outline-none placeholder:text-ink-muted" />
            </div>
            <CircleIconButton v-if="auth.hasPermission('auto:brand:add')" icon="Plus" title="新增品牌" tone="brand" @click="openAddBrand" />
            <BatchDeleteButton v-if="auth.hasPermission('auto:brand:delete')" :active="brandBatch.active.value" @trigger="brandBatch.trigger" @cancel="brandBatch.exit" />
          </div>
        </div>
        <div class="grid grid-cols-8 gap-2.5">
          <div
            v-for="(b, i) in filteredBrands"
            :key="b.id"
            class="group relative flex flex-col items-center gap-1.5 rounded-xl border border-black/5 bg-white/70 px-2 py-3 transition-all hover:shadow-glass-sm"
          >
            <div v-if="brandBatch.active.value" class="absolute left-1 top-1">
              <SelectCheckbox :checked="brandBatch.isSelected(b.id)" @toggle="brandBatch.toggle(b.id)" />
            </div>
            <!-- 悬浮操作：编辑 + 删除 -->
            <div class="absolute right-1 top-1 flex gap-0.5 opacity-0 transition-all group-hover:opacity-100">
              <button v-if="auth.hasPermission('auto:brand:edit')" class="flex h-5 w-5 items-center justify-center rounded bg-editblue/10 text-editblue hover:bg-editblue/20" @click="openEditBrand(b)">
                <el-icon :size="11"><Edit /></el-icon>
              </button>
              <button v-if="auth.hasPermission('auto:brand:delete')" class="flex h-5 w-5 items-center justify-center rounded bg-danger/10 text-danger hover:bg-danger/20" @click="removeBrand(b.id, b.name)">
                <el-icon :size="11"><Close /></el-icon>
              </button>
            </div>
            <!-- 车标 -->
            <div class="flex h-10 w-10 items-center justify-center rounded-lg bg-gradient-to-br text-sm font-bold text-white" :class="brandColors[i % brandColors.length]">
              {{ b.initial }}
            </div>
            <!-- 品牌名 -->
            <p class="w-full truncate text-center text-xs font-medium text-ink">{{ b.name }}</p>
          </div>
          <el-empty v-if="!filteredBrands.length" description="该厂商暂无品牌" class="col-span-8" />
        </div>
      </GlassCard>
    </div>

    <!-- 厂商新增 / 编辑弹窗 -->
    <el-dialog v-model="makerDialog" :title="makerIsNew ? '新增厂商' : '编辑厂商'" width="380px">
      <label class="mb-1.5 block text-xs text-ink-label">厂商名称</label>
      <el-input v-model="makerForm.name" placeholder="请输入厂商名称" />
      <label class="mb-1.5 mt-4 block text-xs text-ink-label">排序字母</label>
      <el-input v-model="makerForm.orderLetter" placeholder="后端会按厂商名称自动生成" />
      <template #footer>
        <button class="btn-ghost h-10 px-5 text-sm" @click="makerDialog = false">取消</button>
        <button class="btn-brand ml-3 h-10 px-6 text-sm" @click="saveMaker">保存</button>
      </template>
    </el-dialog>

    <!-- 品牌新增 / 编辑弹窗 -->
    <el-dialog v-model="brandDialog" :title="brandIsNew ? '新增品牌' : '编辑品牌'" width="380px">
      <label class="mb-1.5 block text-xs text-ink-label">所属厂商</label>
      <el-select v-model="brandForm.makerId" placeholder="请选择厂商" class="mb-4 w-full">
        <el-option v-for="m in store.makers" :key="m.id" :label="m.name" :value="m.id" />
      </el-select>
      <label class="mb-1.5 block text-xs text-ink-label">品牌名称</label>
      <el-input v-model="brandForm.name" placeholder="请输入品牌名称" />
      <template #footer>
        <button class="btn-ghost h-10 px-5 text-sm" @click="brandDialog = false">取消</button>
        <button class="btn-brand ml-3 h-10 px-6 text-sm" @click="saveBrand">保存</button>
      </template>
    </el-dialog>
  </div>
</template>
