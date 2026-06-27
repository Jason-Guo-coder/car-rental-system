<script setup lang="ts">
/** 统计卡：图标 + 数值 + 标签，玻璃卡风格 */
defineProps<{
  label: string
  value: string | number
  icon?: string
  /** 图标渐变色调：brand | green | orange | purple */
  tone?: 'brand' | 'green' | 'orange' | 'purple'
  suffix?: string
}>()

const toneBg: Record<string, string> = {
  brand: 'from-[#3B83F5] to-[#7368F2]',
  green: 'from-[#22b07d] to-[#10b3a3]',
  orange: 'from-[#f5a623] to-[#f97316]',
  purple: 'from-[#9b5de5] to-[#7368f2]',
}
</script>

<template>
  <div class="glass-card flex items-center gap-4 p-5">
    <div
      v-if="icon"
      class="flex h-12 w-12 shrink-0 items-center justify-center rounded-2xl bg-gradient-to-br text-white shadow-glass-sm"
      :class="toneBg[tone || 'brand']"
    >
      <el-icon :size="22"><component :is="icon" /></el-icon>
    </div>
    <div>
      <p class="text-sm text-ink-muted">{{ label }}</p>
      <p class="mt-0.5 text-2xl font-semibold text-ink">
        {{ value }}<span v-if="suffix" class="ml-1 text-sm font-normal text-ink-muted">{{ suffix }}</span>
      </p>
    </div>
  </div>
</template>
