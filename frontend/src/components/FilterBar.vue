<script setup lang="ts">
import CircleIconButton from '@/components/CircleIconButton.vue'

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
      <CircleIconButton icon="Search" title="查询" tone="brand" @click="$emit('search')" />
      <CircleIconButton icon="RefreshLeft" title="重置" @click="$emit('reset')" />
      <slot name="actions" />
    </div>
  </div>
</template>
