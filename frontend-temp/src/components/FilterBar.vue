<script setup lang="ts">
/**
 * 多字段过滤栏：白玻璃卡 + 横向 auto-layout（字段多自动换行）。
 * 字段通过默认插槽传入（用 FilterField 包裹），按钮区固定在右侧/末尾。
 */
defineEmits<{ search: []; reset: [] }>()
</script>

<template>
  <div class="glass-card flex flex-wrap items-end gap-2 p-4">
    <slot />
    <div class="ml-auto flex items-end gap-2">
      <button class="btn-brand h-10 px-4 text-sm" @click="$emit('search')">查询</button>
      <button class="btn-ghost h-10 px-4 text-sm" @click="$emit('reset')">重置</button>
      <slot name="actions" />
    </div>
  </div>
</template>
