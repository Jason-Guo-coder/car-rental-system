<script setup lang="ts">
import { Check } from '@element-plus/icons-vue'

/** 表格批量选择列里的圆角勾选框。 */
defineProps<{ checked: boolean }>()
defineEmits<{ toggle: [] }>()
</script>

<template>
  <button
    class="flex h-5 w-5 items-center justify-center rounded-md border-2 transition-all"
    :class="checked ? 'border-brand bg-brand text-white' : 'border-black/20 bg-white hover:border-brand'"
    @click="$emit('toggle')"
  >
    <el-icon v-if="checked" :size="12"><Check /></el-icon>
  </button>
</template>
