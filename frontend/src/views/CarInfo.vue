<script setup lang="ts">
import { ref, reactive, computed, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import type { UploadRequestOptions } from 'element-plus'
import PageHeader from '@/components/PageHeader.vue'
import GlassCard from '@/components/GlassCard.vue'
import FilterBar from '@/components/FilterBar.vue'
import FilterField from '@/components/FilterField.vue'
import FloatingPagination from '@/components/FloatingPagination.vue'
import StatusBadge from '@/components/StatusBadge.vue'
import CircleIconButton from '@/components/CircleIconButton.vue'
import { uploadFile } from '@/api/http'
import { useAuthStore } from '@/stores/auth'
import { useCarStore } from '@/stores/car'
import { useMakerStore } from '@/stores/maker'
import { carStatusMeta } from '@/utils/dict'
import type { CarInfo } from '@/types'

const carStore = useCarStore()
const makerStore = useMakerStore()
const auth = useAuthStore()

// 多字段过滤栏：厂商/品牌/车牌/类型/状态/租金区间/上牌日期
// filters = 表单实时输入；applied = 点击查询后生效的快照（避免边输边筛）
type CarFilter = {
  maker: string
  makerId: number | undefined
  brand: string
  brandId: number | undefined
  plateNo: string
  carType: string
  status: string
  rentMin: number | undefined
  rentMax: number | undefined
  registerRange: string[]
}
const emptyFilter = (): CarFilter => ({
  maker: '',
  makerId: undefined,
  brand: '',
  brandId: undefined,
  plateNo: '',
  carType: '',
  status: '',
  rentMin: undefined,
  rentMax: undefined,
  registerRange: [],
})
const filters = reactive<CarFilter>(emptyFilter())
const applied = reactive<CarFilter>(emptyFilter())
const page = reactive({ current: 1, size: 5 })

const carTypes = ['燃油车', '电动车', '混动车']
const queryBrands = computed(() => filters.makerId ? makerStore.brands.filter((b) => b.makerId === filters.makerId) : makerStore.brands)

// 抽屉内品牌随所属厂商联动：未选厂商时显示全部品牌
const drawerBrands = computed(() => {
  return editing.makerId ? makerStore.brands.filter((b) => b.makerId === editing.makerId) : makerStore.brands
})
function onQueryMakerChange() {
  filters.brandId = undefined
  filters.brand = ''
}
function onDrawerMakerChange() {
  editing.makerName = makerStore.makers.find((m) => m.id === editing.makerId)?.name ?? ''
  // 切换厂商后，若已选品牌不属于新厂商则清空
  if (!drawerBrands.value.some((b) => b.id === editing.brandId)) {
    editing.brandId = undefined
    editing.brandName = ''
  }
}
function onDrawerBrandChange() {
  const brand = makerStore.brands.find((b) => b.id === editing.brandId)
  editing.brandName = brand?.name ?? ''
}

// 点击查询：把表单快照应用到生效条件
async function searchCars() {
  await carStore.search({
    makerId: applied.makerId,
    brandId: applied.brandId,
    plateNo: applied.plateNo || undefined,
    carType: applied.carType || undefined,
    status: (applied.status || undefined) as CarInfo['status'] | undefined,
    rentMin: applied.rentMin,
    rentMax: applied.rentMax,
    lowRegistrationDate: applied.registerRange?.[0],
    highRegistrationDate: applied.registerRange?.[1],
    page: page.current,
    size: page.size,
  })
}
async function doSearch() {
  Object.assign(applied, JSON.parse(JSON.stringify(filters)))
  page.current = 1
  await searchCars()
}

async function reset() {
  Object.assign(filters, emptyFilter())
  Object.assign(applied, emptyFilter())
  page.current = 1
  await searchCars()
}
async function changePage(current: number) {
  page.current = current
  await searchCars()
}
onMounted(async () => {
  if (!makerStore.makers.length) await makerStore.load()
  await searchCars()
})

// 编辑抽屉
const drawer = ref(false)
const editing = reactive<Partial<CarInfo>>({})
const isNew = ref(false)

function openEdit(car: CarInfo) {
  if (!auth.hasPermission('auto:info:edit')) return ElMessage.warning('当前账号没有该操作权限')
  isNew.value = false
  Object.assign(editing, car)
  drawer.value = true
}
function openAdd() {
  if (!auth.hasPermission('auto:info:add')) return ElMessage.warning('当前账号没有该操作权限')
  isNew.value = true
  Object.assign(editing, {
    plateNo: '', makerId: undefined, brandId: undefined, makerName: '', brandName: '', carType: '燃油车', color: '',
    displacement: '', displacementUnit: 'T', registerDate: '', mileage: 0,
    dayRent: 0, deposit: 0, status: 'idle', image: '',
  })
  drawer.value = true
}
function validateCar() {
  if (!editing.makerId) return '请选择所属厂商'
  if (!editing.brandId) return '请选择所属品牌'
  if (!editing.plateNo?.trim()) return '请填写车牌号码'
  if (!editing.carType) return '请选择车辆类型'
  if (!editing.registerDate) return '请选择上牌日期'
  if ((editing.mileage ?? 0) < 0 || (editing.dayRent ?? 0) < 0 || (editing.deposit ?? 0) < 0) return '里程、租金和押金不能为负数'
  return ''
}
async function uploadCarImage(options: UploadRequestOptions) {
  if (!auth.hasPermission(isNew.value ? 'auto:info:add' : 'auto:info:edit')) {
    const message = '当前账号没有该操作权限'
    const uploadError = Object.assign(new Error(message), { name: 'UploadAjaxError', status: 0, method: 'POST', url: '/rental/oss/upload' }) as Parameters<NonNullable<UploadRequestOptions['onError']>>[0]
    options.onError?.(uploadError)
    return ElMessage.warning(message)
  }
  try {
    editing.image = await uploadFile('/rental/oss/upload', options.file)
    options.onSuccess?.(editing.image)
    ElMessage.success('车辆图片上传成功')
  } catch (error) {
    const message = error instanceof Error ? error.message : '车辆图片上传失败'
    const uploadError = Object.assign(new Error(message), { name: 'UploadAjaxError', status: 0, method: 'POST', url: '/rental/oss/upload' }) as Parameters<NonNullable<UploadRequestOptions['onError']>>[0]
    options.onError?.(uploadError)
    ElMessage.error(message)
  }
}
function beforeCarImageUpload(file: File) {
  const okType = file.type === 'image/jpeg' || file.type === 'image/png'
  const okSize = file.size / 1024 / 1024 < 2
  if (!okType) ElMessage.error('车辆图片只能是 JPG 或 PNG 格式')
  if (!okSize) ElMessage.error('车辆图片大小不能超过 2MB')
  return okType && okSize
}
async function save() {
  if (!auth.hasPermission(isNew.value ? 'auto:info:add' : 'auto:info:edit')) return ElMessage.warning('当前账号没有该操作权限')
  const message = validateCar()
  if (message) return ElMessage.warning(message)
  if (isNew.value) {
    await carStore.add(editing as Omit<CarInfo, 'id'>)
    ElMessage.success('新增车辆成功')
  } else {
    await carStore.update(editing as CarInfo)
    ElMessage.success('保存成功')
  }
  drawer.value = false
}
function remove(car: CarInfo) {
  if (!auth.hasPermission('auto:info:delete')) return ElMessage.warning('当前账号没有该操作权限')
  ElMessageBox.confirm(`确认删除车辆 ${car.plateNo}？`, '删除车辆', { type: 'warning', confirmButtonText: '删除', cancelButtonText: '取消' })
    .then(() => {
      carStore.remove(car.id)
      ElMessage.success('已删除')
    })
    .catch(() => {})
}

// 批量删除：选择模式 + 选中集合
const selectMode = ref(false)
const selectedIds = ref<Set<number>>(new Set())

function toggleSelect(id: number) {
  if (selectedIds.value.has(id)) selectedIds.value.delete(id)
  else selectedIds.value.add(id)
}

// 第一次点 → 进入选择模式；再次点 → 弹确认删除选中项
function onBatchDelete() {
  if (!auth.hasPermission('auto:info:delete')) return ElMessage.warning('当前账号没有该操作权限')
  if (!selectMode.value) {
    selectMode.value = true
    selectedIds.value.clear()
    return
  }
  if (selectedIds.value.size === 0) {
    ElMessage.warning('请先勾选要删除的车辆')
    return
  }
  const ids = [...selectedIds.value]
  ElMessageBox.confirm(`确认删除选中的 ${ids.length} 辆车辆？此操作不可恢复。`, '批量删除', {
    type: 'warning',
    confirmButtonText: '删除',
    cancelButtonText: '取消',
  })
    .then(() => {
      carStore.removeMany(ids)
      ElMessage.success(`已删除 ${ids.length} 辆车辆`)
      exitSelect()
    })
    .catch(() => {})
}

function exitSelect() {
  selectMode.value = false
  selectedIds.value.clear()
}

const colorValue = (color?: string) => (color && color.startsWith('#') ? color : '#d8dde8')
</script>

<template>
  <div class="paged-view-tight space-y-6">
    <PageHeader title="车辆信息" :subtitle="`车辆档案管理 · 共 ${carStore.total} 辆`" />

    <FilterBar @search="doSearch" @reset="reset">
      <FilterField label="所属厂商" :grow="1">
        <el-select v-model="filters.makerId" placeholder="全部" clearable class="w-full" @change="onQueryMakerChange">
          <el-option v-for="m in makerStore.makers" :key="m.id" :label="m.name" :value="m.id" />
        </el-select>
      </FilterField>
      <FilterField label="所属品牌" :grow="1">
        <el-select v-model="filters.brandId" placeholder="全部" clearable class="w-full">
          <el-option v-for="b in queryBrands" :key="b.id" :label="b.name" :value="b.id" />
        </el-select>
      </FilterField>
      <FilterField label="车牌号码" :grow="1">
        <el-input v-model="filters.plateNo" placeholder="车牌" class="w-full" />
      </FilterField>
      <FilterField label="车辆类型" :grow="1">
        <el-select v-model="filters.carType" placeholder="全部" clearable class="w-full">
          <el-option v-for="t in carTypes" :key="t" :label="t" :value="t" />
        </el-select>
      </FilterField>
      <FilterField label="车辆状态" :grow="1">
        <el-select v-model="filters.status" placeholder="全部" clearable class="w-full">
          <el-option label="空闲" value="idle" />
          <el-option label="出租中" value="renting" />
          <el-option label="保养中" value="maintain" />
          <el-option label="自用" value="selfUse" />
        </el-select>
      </FilterField>
      <FilterField label="日租金额（元）" :grow="1.3">
        <div class="flex items-center gap-1">
          <el-input v-model.number="filters.rentMin" placeholder="最低" class="min-w-0 flex-1" />
          <span class="text-ink-muted">~</span>
          <el-input v-model.number="filters.rentMax" placeholder="最高" class="min-w-0 flex-1" />
        </div>
      </FilterField>
      <FilterField label="上牌日期" :grow="1.8">
        <el-date-picker v-model="filters.registerRange" type="daterange" size="default" range-separator="~" start-placeholder="开始" end-placeholder="结束" value-format="YYYY-MM-DD" class="!w-full" />
      </FilterField>
      <template #actions>
        <CircleIconButton v-if="auth.hasPermission('auto:info:delete')" icon="Delete" title="批量删除" tone="danger" :active="selectMode" @click="onBatchDelete" />
        <CircleIconButton v-if="selectMode" icon="Close" title="取消选择" @click="exitSelect" />
        <CircleIconButton v-if="auth.hasPermission('auto:info:add')" icon="Plus" title="新增车辆" tone="brand" @click="openAdd" />
      </template>
    </FilterBar>

    <GlassCard>
      <el-table :data="carStore.list" :class="['glass-table', { 'has-check': selectMode }]">
        <el-table-column v-if="selectMode && auth.hasPermission('auto:info:delete')" label="" width="56">
          <template #default="{ row }">
            <button
              class="flex h-5 w-5 items-center justify-center rounded-md border-2 transition-all"
              :class="selectedIds.has(row.id) ? 'border-brand bg-brand text-white' : 'border-black/20 bg-white hover:border-brand'"
              @click="toggleSelect(row.id)"
            >
              <el-icon v-if="selectedIds.has(row.id)" :size="12"><Check /></el-icon>
            </button>
          </template>
        </el-table-column>
        <el-table-column label="车辆" min-width="220">
          <template #default="{ row }">
            <div class="flex items-center gap-3">
              <div class="flex h-11 w-16 items-center justify-center overflow-hidden rounded-lg bg-gradient-to-br from-[#eef2ff] to-[#f5f0fb] text-ink-muted">
                <img v-if="row.image" :src="row.image" :alt="row.plateNo" class="h-full w-full object-cover" />
                <el-icon v-else :size="20"><Van /></el-icon>
              </div>
              <div>
                <p class="font-medium text-ink">{{ row.plateNo }}</p>
                <p class="text-xs text-ink-muted">{{ row.makerName }} · {{ row.brandName }}</p>
              </div>
            </div>
          </template>
        </el-table-column>
        <el-table-column prop="carType" label="类型" width="110" />
        <el-table-column label="颜色" width="110">
          <template #default="{ row }">
            <span class="inline-flex items-center gap-2">
              <span class="h-4 w-4 rounded-full border border-black/10" :style="{ backgroundColor: colorValue(row.color) }" />
              <span>{{ row.color }}</span>
            </span>
          </template>
        </el-table-column>
        <el-table-column label="排量" width="90">
          <template #default="{ row }">{{ row.displacement }}{{ row.displacementUnit }}</template>
        </el-table-column>
        <el-table-column label="里程" width="110">
          <template #default="{ row }">{{ row.mileage.toLocaleString() }} km</template>
        </el-table-column>
        <el-table-column prop="registerDate" label="上牌日期" width="120" />
        <el-table-column label="日租金" width="100">
          <template #default="{ row }">¥{{ row.dayRent }}</template>
        </el-table-column>
        <el-table-column label="状态" width="100">
          <template #default="{ row }">
            <StatusBadge :text="carStatusMeta[row.status].text" :tone="carStatusMeta[row.status].tone" />
          </template>
        </el-table-column>
        <el-table-column label="操作" width="120" fixed="right">
          <template #default="{ row }">
            <div class="flex gap-2">
              <button v-if="auth.hasPermission('auto:info:edit')" class="flex h-8 w-8 items-center justify-center rounded-lg bg-editblue/10 text-editblue hover:bg-editblue/20" @click="openEdit(row)">
                <el-icon><Edit /></el-icon>
              </button>
              <button v-if="auth.hasPermission('auto:info:delete')" class="flex h-8 w-8 items-center justify-center rounded-lg bg-danger/10 text-danger hover:bg-danger/20" @click="remove(row)">
                <el-icon><Close /></el-icon>
              </button>
            </div>
          </template>
        </el-table-column>
      </el-table>
    </GlassCard>

    <FloatingPagination v-model:current-page="page.current" :total="carStore.total" :page-size="page.size" @change="changePage" />

    <!-- 编辑抽屉 -->
    <el-drawer v-model="drawer" :title="isNew ? '新增车辆' : '编辑车辆'" size="460px">
      <div class="space-y-5">
        <!-- 车辆图片占位（4:3） -->
        <el-upload class="block" :show-file-list="false" :http-request="uploadCarImage" :before-upload="beforeCarImageUpload">
          <div class="flex aspect-[4/3] w-full items-center justify-center overflow-hidden rounded-card border-2 border-dashed border-black/10 bg-white/40 text-ink-muted">
            <img v-if="editing.image" :src="editing.image" alt="车辆照片" class="h-full w-full object-cover" />
            <div v-else class="text-center">
              <el-icon :size="32"><Picture /></el-icon>
              <p class="mt-1 text-xs">点击上传车辆照片</p>
            </div>
          </div>
        </el-upload>

        <!-- 属性竖排单列 -->
        <div class="space-y-4">
          <div>
            <label class="mb-1.5 block text-xs text-ink-label">所属厂商</label>
            <el-select v-model="editing.makerId" placeholder="请选择厂商" class="w-full" @change="onDrawerMakerChange">
              <el-option v-for="m in makerStore.makers" :key="m.id" :label="m.name" :value="m.id" />
            </el-select>
          </div>
          <div>
            <label class="mb-1.5 block text-xs text-ink-label">所属品牌</label>
            <el-select v-model="editing.brandId" placeholder="请选择品牌" class="w-full" @change="onDrawerBrandChange">
              <el-option v-for="b in drawerBrands" :key="b.id" :label="b.name" :value="b.id" />
            </el-select>
          </div>
          <div>
            <label class="mb-1.5 block text-xs text-ink-label">车牌号码</label>
            <el-input v-model="editing.plateNo" />
          </div>
          <div>
            <label class="mb-1.5 block text-xs text-ink-label">车辆类型</label>
            <el-select v-model="editing.carType" placeholder="请选择类型" class="w-full">
              <el-option v-for="t in carTypes" :key="t" :label="t" :value="t" />
            </el-select>
          </div>
          <div>
            <label class="mb-1.5 block text-xs text-ink-label">车辆颜色</label>
            <div class="flex items-center gap-3">
              <el-color-picker v-model="editing.color" color-format="hex" />
              <el-input v-model="editing.color" />
            </div>
          </div>
          <div>
            <label class="mb-1.5 block text-xs text-ink-label">汽车排量</label>
            <div class="flex gap-2">
              <el-input v-model="editing.displacement" class="flex-1" />
              <el-select v-model="editing.displacementUnit" class="!w-24">
                <el-option label="T" value="T" />
                <el-option label="L" value="L" />
              </el-select>
            </div>
          </div>
          <div>
            <label class="mb-1.5 block text-xs text-ink-label">行驶里程(km)</label>
            <el-input-number v-model="editing.mileage" :min="0" class="!w-full" />
          </div>
          <div>
            <label class="mb-1.5 block text-xs text-ink-label">上牌日期</label>
            <el-date-picker v-model="editing.registerDate" type="date" value-format="YYYY-MM-DD" class="!w-full" />
          </div>
          <div>
            <label class="mb-1.5 block text-xs text-ink-label">日租金额(元)</label>
            <el-input-number v-model="editing.dayRent" :min="0" class="!w-full" />
          </div>
          <div>
            <label class="mb-1.5 block text-xs text-ink-label">车辆押金(元)</label>
            <el-input-number v-model="editing.deposit" :min="0" class="!w-full" />
          </div>
          <div>
            <label class="mb-1.5 block text-xs text-ink-label">车辆状态</label>
            <el-select v-model="editing.status" placeholder="请选择状态" class="w-full">
              <el-option label="未租" value="idle" />
              <el-option label="已租" value="renting" />
              <el-option label="维保" value="maintain" />
              <el-option label="自用" value="selfUse" />
            </el-select>
          </div>
        </div>
      </div>
      <template #footer>
        <div class="flex justify-end gap-3">
          <button class="btn-ghost h-10 px-5 text-sm" @click="drawer = false">取消</button>
          <button class="btn-brand h-10 px-6 text-sm" @click="save">保存</button>
        </div>
      </template>
    </el-drawer>
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
