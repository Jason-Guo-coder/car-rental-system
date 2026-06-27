<script setup lang="ts">
import { Delete } from '@element-plus/icons-vue'

/** 过滤栏内的批量删除按钮组：未激活=浅红，激活=实红+出现取消按钮。 */
defineProps<{ active: boolean }>()
defineEmits<{ trigger: []; cancel: [] }>()
</script>

<template>
  <button
    class="h-10 rounded-field px-5 text-sm font-medium transition-all"
    :class="active ? 'bg-danger text-white shadow-glass-sm' : 'bg-danger/10 text-danger hover:bg-danger/20'"
    @click="$emit('trigger')"
  >
    <el-icon class="mr-1"><Delete /></el-icon>批量删除
  </button>
  <button v-if="active" class="btn-ghost h-10 px-4 text-sm" @click="$emit('cancel')">取消</button>
</template>
