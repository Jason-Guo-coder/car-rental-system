<script setup lang="ts">
import { computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { logout } from '@/api/http'
import { useAuthStore } from '@/stores/auth'
import { useCarStore } from '@/stores/car'
import { useMakerStore } from '@/stores/maker'
import { useRentalTypeStore } from '@/stores/rentalType'
import { useOrderStore } from '@/stores/order'
import { useCustomerStore } from '@/stores/customer'
import { useViolationStore } from '@/stores/violation'
import { useMaintainStore } from '@/stores/maintain'
import { useDashboardStore } from '@/stores/dashboard'
import { useSystemStore } from '@/stores/system'
import { isSameMenuPath } from '@/utils/routeCompat'

const route = useRoute()
const router = useRouter()
const auth = useAuthStore()

const menuGroups = computed(() => auth.menuGroups)
const userInitial = computed(() => auth.displayName.charAt(0).toUpperCase())

function go(path: string) {
  router.push(path)
}

function isActive(path: string) {
  return isSameMenuPath(route.path, path)
}

onMounted(async () => {
  const results = await Promise.allSettled([
    auth.load(),
    useMakerStore().load(),
    useRentalTypeStore().load(),
    useCarStore().load(),
    useOrderStore().load(),
    useCustomerStore().load(),
    useViolationStore().load(),
    useMaintainStore().load(),
    useDashboardStore().load(),
    useSystemStore().load(),
  ])
  const failed = results.find((result) => result.status === 'rejected')
  if (failed) {
    const reason = failed.reason
    ElMessage.error(reason instanceof Error ? reason.message : '部分后端数据加载失败')
  }
})

async function doLogout() {
  await logout()
  auth.reset()
  router.push('/login')
}
</script>

<template>
  <div class="relative flex h-screen overflow-hidden bg-app-bg">
    <!-- 背景彩色模糊光晕 blob -->
    <div class="pointer-events-none absolute inset-0 overflow-hidden">
      <div class="absolute -right-32 -top-40 h-[560px] w-[560px] rounded-full bg-[#5b8def]/25 blur-[120px]" />
      <div class="absolute right-20 top-32 h-[380px] w-[380px] rounded-full bg-[#9b5de5]/20 blur-[110px]" />
      <div class="absolute -left-40 top-1/2 h-[500px] w-[500px] rounded-full bg-[#f472b6]/15 blur-[120px]" />
      <div class="absolute bottom-0 right-40 h-[420px] w-[420px] rounded-full bg-[#38bdf8]/15 blur-[120px]" />
    </div>

    <!-- 透明侧边栏 -->
    <aside class="relative z-10 flex w-[232px] shrink-0 flex-col px-4 py-7">
      <!-- Logo -->
      <div class="mb-6 flex items-center gap-3 px-2">
        <div class="flex h-10 w-10 items-center justify-center rounded-2xl bg-brand-gradient shadow-glass-sm">
          <el-icon :size="20" color="#fff"><Van /></el-icon>
        </div>
        <div>
          <p class="text-base font-semibold leading-tight text-ink">云途租车</p>
          <p class="text-[11px] leading-tight text-ink-muted">CloudRent</p>
        </div>
      </div>

      <!-- 菜单分组 -->
      <nav class="flex-1 space-y-5 overflow-y-auto pr-1">
        <div v-for="grp in menuGroups" :key="grp.group">
          <p class="mb-2 px-3 text-[11px] font-medium uppercase tracking-wide text-ink-muted/70">
            {{ grp.group }}
          </p>
          <div class="space-y-1">
            <button
              v-for="item in grp.items"
              :key="item.path"
              class="flex w-full items-center gap-3 rounded-field px-3 py-2.5 text-sm transition-all"
              :class="
                isActive(item.path)
                  ? 'bg-white/90 font-medium text-brand shadow-glass-sm'
                  : 'text-ink-soft hover:bg-white/40'
              "
              @click="go(item.path)"
            >
              <el-icon :size="17"><component :is="item.icon" /></el-icon>
              {{ item.title }}
            </button>
          </div>
        </div>
      </nav>

      <!-- 底部用户 -->
      <div class="mt-4 flex items-center gap-3 rounded-field bg-white/40 px-3 py-2.5">
        <div class="flex h-9 w-9 items-center justify-center overflow-hidden rounded-full bg-brand-gradient text-sm font-medium text-white">
          <img v-if="auth.avatar" :src="auth.avatar" :alt="auth.displayName" class="h-full w-full object-cover" />
          <span v-else>{{ userInitial }}</span>
        </div>
        <div class="flex-1">
          <p class="text-sm font-medium leading-tight text-ink">{{ auth.roleLabel }}</p>
          <p class="text-[11px] leading-tight text-ink-muted">{{ auth.username }}</p>
        </div>
        <el-icon class="cursor-pointer text-ink-muted hover:text-danger" @click="doLogout">
          <SwitchButton />
        </el-icon>
      </div>
    </aside>

    <!-- 主内容区 -->
    <main class="relative z-10 flex-1 overflow-y-auto px-8 py-7">
      <router-view v-slot="{ Component }">
        <transition name="fade-slide" mode="out-in">
          <component :is="Component" />
        </transition>
      </router-view>
    </main>
  </div>
</template>

<style scoped>
.fade-slide-enter-active,
.fade-slide-leave-active {
  transition: all 0.22s ease;
}
.fade-slide-enter-from {
  opacity: 0;
  transform: translateY(8px);
}
.fade-slide-leave-to {
  opacity: 0;
  transform: translateY(-8px);
}
</style>
