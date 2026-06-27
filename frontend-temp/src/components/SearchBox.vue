<script setup lang="ts">
import { Search } from '@element-plus/icons-vue'

/** 玻璃风搜索框：白底 + 描边 + 放大镜图标 */
withDefaults(
  defineProps<{
    modelValue: string
    placeholder?: string
    width?: string
  }>(),
  { placeholder: '搜索...', width: 'w-64' },
)
defineEmits<{ 'update:modelValue': [v: string] }>()
</script>

<template>
  <div class="glass-field flex h-10 items-center gap-2 px-3" :class="width">
    <el-icon class="text-ink-muted"><Search /></el-icon>
    <input
      :value="modelValue"
      :placeholder="placeholder"
      class="w-full border-0 bg-transparent text-sm text-ink outline-none placeholder:text-ink-muted"
      @input="$emit('update:modelValue', ($event.target as HTMLInputElement).value)"
    />
  </div>
</template>
