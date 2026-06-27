<script setup lang="ts">
import { ref, reactive, computed, watch } from 'vue'
import { ElMessage } from 'element-plus'
import PageHeader from '@/components/PageHeader.vue'
import GlassCard from '@/components/GlassCard.vue'
import FilterBar from '@/components/FilterBar.vue'
import FilterField from '@/components/FilterField.vue'
import { useCarStore } from '@/stores/car'
import { useMakerStore } from '@/stores/maker'
import { useRentalTypeStore } from '@/stores/rentalType'
import { useCustomerStore } from '@/stores/customer'
import { useOrderStore } from '@/stores/order'
import { parseIdCard } from '@/utils/idCard'
import type { CarInfo } from '@/types'

const carStore = useCarStore()
const makerStore = useMakerStore()
const rentalTypeStore = useRentalTypeStore()
const customerStore = useCustomerStore()

const steps = ['选择车辆', '填写信息', '确认出租']
const activeStep = ref(0)

// 过滤（2 行）：厂商/品牌/号码/类型/租金区间/日期范围
const filters = reactive({
  maker: '',
  brand: '',
  plateNo: '',
  carType: '',
  rentMin: undefined as number | undefined,
  rentMax: undefined as number | undefined,
  dateRange: [] as string[],
})

const carTypes = computed(() => [...new Set(carStore.rentable.map((c) => c.carType))])

const rentableCars = computed(() =>
  carStore.rentable.filter((c) => {
    if (filters.maker && c.makerName !== filters.maker) return false
    if (filters.brand && !c.brandName.includes(filters.brand)) return false
    if (filters.plateNo && !c.plateNo.includes(filters.plateNo)) return false
    if (filters.carType && c.carType !== filters.carType) return false
    if (filters.rentMin != null && c.dayRent < filters.rentMin) return false
    if (filters.rentMax != null && c.dayRent > filters.rentMax) return false
    return true
  }),
)

function reset() {
  Object.assign(filters, { maker: '', brand: '', plateNo: '', carType: '', rentMin: undefined, rentMax: undefined, dateRange: [] })
}

// 办理出租悬浮窗
const dialog = ref(false)
const selectedCar = ref<CarInfo | null>(null)
const form = reactive({
  rentalType: '日租',
  name: '',
  phone: '',
  idCard: '',
  age: undefined as number | undefined,
  gender: '' as '' | '男' | '女',
  birthDate: '',
})

// 输入身份证号后自动填充出生日期、年龄、性别
watch(
  () => form.idCard,
  (id) => {
    const info = parseIdCard(id.trim())
    if (info) {
      form.birthDate = info.birthDate
      form.age = info.age
      form.gender = info.gender
    }
  },
)

function openRent(car: CarInfo) {
  selectedCar.value = car
  activeStep.value = 1
  Object.assign(form, { rentalType: '日租', name: '', phone: '', idCard: '', age: undefined, gender: '', birthDate: '' })
  dialog.value = true
}
async function confirmRent() {
  if (!form.name.trim()) return ElMessage.warning('请填写客户姓名')
  if (!form.phone.trim()) return ElMessage.warning('请填写联系电话')
  if (!selectedCar.value?.id) return
  const type = rentalTypeStore.list.find((t) => t.name === form.rentalType)
  let customer = customerStore.list.find((c) => c.phone === form.phone)
  if (!customer) {
    await customerStore.add({
      name: form.name,
      phone: form.phone,
      idCard: form.idCard,
      age: form.age ?? 0,
      gender: form.gender || '男',
      birthDate: form.birthDate,
      orderCount: 0,
      listType: 'white',
      createTime: new Date().toISOString().slice(0, 10),
    })
    customer = customerStore.list.find((c) => c.phone === form.phone)
  }
  if (!customer || !type) return ElMessage.error('客户或出租类型不存在')
  await carStore.load()
  await useOrderStore().rentCar({
    autoId: selectedCar.value.id,
    customerId: customer.id,
    typeId: type.id,
    rent: selectedCar.value.dayRent,
    deposit: selectedCar.value.deposit,
    mileage: selectedCar.value.mileage,
  })
  await carStore.load()
  activeStep.value = 2
  ElMessage.success(`车辆 ${selectedCar.value?.plateNo} 出租办理成功`)
  dialog.value = false
  setTimeout(() => (activeStep.value = 0), 400)
}

const cardColors = ['from-[#eef2ff] to-[#f5f0fb]', 'from-[#eafff5] to-[#eef7ff]', 'from-[#fff5ea] to-[#fdf0f5]']
</script>

<template>
  <div class="space-y-6">
    <PageHeader title="汽车出租" subtitle="选择可租车辆，办理出租手续" />

    <!-- 步骤条 -->
    <GlassCard padding="px-8 py-5">
      <el-steps :active="activeStep" align-center finish-status="success">
        <el-step v-for="s in steps" :key="s" :title="s" />
      </el-steps>
    </GlassCard>

    <!-- 过滤栏 -->
    <FilterBar @search="() => {}" @reset="reset">
      <FilterField label="所属厂商">
        <el-select v-model="filters.maker" placeholder="全部厂商" clearable class="w-36">
          <el-option v-for="m in makerStore.makers" :key="m.id" :label="m.name" :value="m.name" />
        </el-select>
      </FilterField>
      <FilterField label="所属品牌">
        <el-input v-model="filters.brand" placeholder="品牌" class="w-28" />
      </FilterField>
      <FilterField label="车牌号码">
        <el-input v-model="filters.plateNo" placeholder="车牌" class="w-28" />
      </FilterField>
      <FilterField label="车辆类型">
        <el-select v-model="filters.carType" placeholder="全部类型" clearable class="w-36">
          <el-option v-for="t in carTypes" :key="t" :label="t" :value="t" />
        </el-select>
      </FilterField>
      <FilterField label="日租金（元）">
        <div class="flex items-center gap-2">
          <el-input v-model.number="filters.rentMin" placeholder="最低" class="w-20" />
          <span class="text-ink-muted">~</span>
          <el-input v-model.number="filters.rentMax" placeholder="最高" class="w-20" />
        </div>
      </FilterField>
      <FilterField label="租期">
        <el-date-picker v-model="filters.dateRange" type="daterange" range-separator="至" start-placeholder="提车" end-placeholder="还车" value-format="YYYY-MM-DD" class="!w-64" />
      </FilterField>
    </FilterBar>

    <!-- 可租车辆网格 -->
    <div class="grid grid-cols-4 gap-4">
      <GlassCard v-for="(car, i) in rentableCars" :key="car.id" padding="p-3">
        <!-- 车辆图片 4:3 -->
        <div class="mb-2.5 flex aspect-[4/3] w-full items-center justify-center rounded-xl bg-gradient-to-br text-ink-muted" :class="cardColors[i % 3]">
          <el-icon :size="38"><Van /></el-icon>
        </div>
        <p class="text-sm font-semibold text-ink">{{ car.plateNo }}</p>
        <p class="mt-0.5 truncate text-xs text-ink-muted">{{ car.makerName }} · {{ car.brandName }} · {{ car.carType }}</p>

        <!-- 详细信息 -->
        <div class="mt-2.5 grid grid-cols-2 gap-x-3 gap-y-1 border-t border-black/5 pt-2.5 text-[11px]">
          <div class="flex justify-between"><span class="text-ink-muted">颜色</span><span class="text-ink-soft">{{ car.color }}</span></div>
          <div class="flex justify-between"><span class="text-ink-muted">排量</span><span class="text-ink-soft">{{ car.displacement }}{{ car.displacementUnit }}</span></div>
          <div class="flex justify-between"><span class="text-ink-muted">里程</span><span class="text-ink-soft">{{ car.mileage.toLocaleString() }}km</span></div>
          <div class="flex justify-between"><span class="text-ink-muted">押金</span><span class="text-ink-soft">¥{{ car.deposit.toLocaleString() }}</span></div>
          <div class="flex justify-between"><span class="text-ink-muted">上牌日期</span><span class="text-ink-soft">{{ car.registerDate }}</span></div>
        </div>

        <div class="mt-2.5 flex items-center justify-between">
          <p class="text-base font-semibold text-brand">¥{{ car.dayRent }}<span class="text-[11px] font-normal text-ink-muted">/天</span></p>
          <button class="btn-brand h-7 px-3 text-xs" @click="openRent(car)">立即出租</button>
        </div>
      </GlassCard>
      <el-empty v-if="!rentableCars.length" description="暂无可租车辆" class="col-span-4" />
    </div>

    <!-- 办理出租悬浮窗 -->
    <el-dialog v-model="dialog" title="办理出租" width="560px" align-center>
      <div v-if="selectedCar" class="space-y-5">
        <!-- 车辆摘要 -->
        <div class="flex items-center gap-3 rounded-card bg-white/60 p-3">
          <div class="flex h-12 w-16 shrink-0 items-center justify-center rounded-lg bg-gradient-to-br from-[#eef2ff] to-[#f5f0fb] text-ink-muted">
            <el-icon :size="24"><Van /></el-icon>
          </div>
          <div class="flex-1">
            <p class="font-semibold text-ink">{{ selectedCar.plateNo }}</p>
            <p class="text-xs text-ink-muted">{{ selectedCar.makerName }} · {{ selectedCar.brandName }} · {{ selectedCar.carType }}</p>
          </div>
          <p class="text-base font-semibold text-brand">¥{{ selectedCar.dayRent }}<span class="text-xs font-normal text-ink-muted">/天</span></p>
        </div>

        <!-- 出租类型下拉 -->
        <div>
          <label class="mb-1.5 block text-xs text-ink-label">出租类型</label>
          <el-select v-model="form.rentalType" placeholder="请选择出租类型" class="w-full">
            <el-option v-for="t in rentalTypeStore.list" :key="t.id" :label="t.name" :value="t.name" />
          </el-select>
        </div>

        <!-- 客户信息 -->
        <div>
          <p class="mb-2 text-sm font-medium text-ink">客户信息</p>
          <div class="grid grid-cols-2 gap-x-4 gap-y-3">
            <div>
              <label class="mb-1.5 block text-xs text-ink-label">客户姓名</label>
              <el-input v-model="form.name" placeholder="请输入姓名" />
            </div>
            <div>
              <label class="mb-1.5 block text-xs text-ink-label">联系电话</label>
              <el-input v-model="form.phone" placeholder="请输入电话" />
            </div>
            <div class="col-span-2">
              <label class="mb-1.5 block text-xs text-ink-label">身份证号</label>
              <el-input v-model="form.idCard" placeholder="请输入身份证号" maxlength="18" />
            </div>
            <div>
              <label class="mb-1.5 block text-xs text-ink-label">出生日期</label>
              <el-date-picker v-model="form.birthDate" type="date" placeholder="请选择" value-format="YYYY-MM-DD" class="!w-full" />
            </div>
            <div>
              <label class="mb-1.5 block text-xs text-ink-label">客户年龄</label>
              <el-input v-model.number="form.age" placeholder="请输入年龄" />
            </div>
            <div>
              <label class="mb-1.5 block text-xs text-ink-label">客户性别</label>
              <el-select v-model="form.gender" placeholder="请选择" class="w-full">
                <el-option label="男" value="男" />
                <el-option label="女" value="女" />
              </el-select>
            </div>
          </div>
        </div>
      </div>

      <template #footer>
        <button class="btn-ghost h-10 px-5 text-sm" @click="dialog = false">取消</button>
        <button class="btn-brand ml-3 h-10 px-6 text-sm" @click="confirmRent">确认出租</button>
      </template>
    </el-dialog>
  </div>
</template>
