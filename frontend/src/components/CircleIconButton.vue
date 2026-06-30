<script setup lang="ts">
withDefaults(defineProps<{
  icon: string
  title: string
  tone?: 'brand' | 'danger' | 'ghost'
  active?: boolean
}>(), {
  tone: 'ghost',
  active: false,
})

defineEmits<{ click: [] }>()
</script>

<template>
  <button
    class="flex h-10 w-10 shrink-0 items-center justify-center rounded-full transition-all"
    :class="[
      tone === 'brand' ? 'bg-brand text-white shadow-glass-sm hover:bg-brand/90' : '',
      tone === 'danger' && active ? 'bg-danger text-white shadow-glass-sm' : '',
      tone === 'danger' && !active ? 'bg-danger/10 text-danger hover:bg-danger/20' : '',
      tone === 'ghost' ? 'bg-white/70 text-ink-muted shadow-glass-sm hover:bg-white' : '',
    ]"
    :title="title"
    @click="$emit('click')"
  >
    <el-icon><component :is="icon" /></el-icon>
  </button>
</template>
