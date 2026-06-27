<script setup lang="ts">
/** 白玻璃卡片容器：半透明白 + 大圆角 + 柔阴影 + 背景模糊 */
withDefaults(
  defineProps<{
    padding?: string
  }>(),
  { padding: 'p-6' },
)
</script>

<template>
  <div class="glass-card" :class="padding">
    <slot />
  </div>
</template>
