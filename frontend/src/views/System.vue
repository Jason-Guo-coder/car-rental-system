<script setup lang="ts">
import { computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import PageHeader from '@/components/PageHeader.vue'
import { useAuthStore } from '@/stores/auth'
import { useSystemStore } from '@/stores/system'
import UserPanel from './system/UserPanel.vue'
import DeptPanel from './system/DeptPanel.vue'
import RolePanel from './system/RolePanel.vue'
import MenuPanel from './system/MenuPanel.vue'
import { systemTabFromPath, systemTabPaths, type SystemTabKey } from '@/utils/routeCompat'

const route = useRoute()
const router = useRouter()
const auth = useAuthStore()
const store = useSystemStore()

const allTabs = [
  { key: 'user', label: '用户管理', comp: UserPanel },
  { key: 'dept', label: '部门管理', comp: DeptPanel },
  { key: 'role', label: '角色管理', comp: RolePanel },
  { key: 'menu', label: '菜单管理', comp: MenuPanel },
]
const tabs = computed(() => allTabs.filter((tab) => auth.canAccessPath(systemTabPaths[tab.key as SystemTabKey])))
const active = computed<SystemTabKey | undefined>(() => {
  const key = systemTabFromPath(route.path)
  return tabs.value.some((tab) => tab.key === key) ? key : tabs.value[0]?.key as SystemTabKey | undefined
})
const activeComp = computed(() => tabs.value.find((t) => t.key === active.value)?.comp)

onMounted(() => {
  store.load()
})

function changeTab(key: string) {
  router.push(systemTabPaths[key as SystemTabKey])
}
</script>

<template>
  <div class="space-y-6">
    <PageHeader title="权限管理" subtitle="用户、部门、角色与菜单权限统一配置" />

    <!-- 滑动切换器：胶囊容器 + 蓝底白字激活态 -->
    <div class="inline-flex rounded-field bg-white/60 p-1 shadow-glass-sm backdrop-blur">
      <button
        v-for="t in tabs"
        :key="t.key"
        class="rounded-[9px] px-6 py-2 text-sm font-medium transition-all"
        :class="active === t.key ? 'bg-brand-gradient text-white shadow-glass-sm' : 'text-ink-soft hover:text-ink'"
        @click="changeTab(t.key)"
      >
        {{ t.label }}
      </button>
    </div>

    <transition name="fade" mode="out-in">
      <component :is="activeComp" v-if="activeComp" :key="active" />
      <p v-else class="text-sm text-ink-muted">暂无系统管理权限</p>
    </transition>
  </div>
</template>

<style scoped>
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.18s ease;
}
.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>
