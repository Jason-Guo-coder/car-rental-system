<script setup lang="ts">
/** 过滤栏中的单个字段：上方标签 + 下方控件插槽。
 *  grow 可选：传入弹性系数后字段按比例撑满过滤栏剩余空间。 */
defineProps<{ label: string; grow?: number }>()
</script>

<template>
  <div class="flex flex-col gap-1.5" :class="grow ? 'min-w-0' : ''" :style="grow ? { flex: grow } : undefined">
    <label class="text-xs font-medium text-ink-label">{{ label }}</label>
    <slot />
  </div>
</template>
