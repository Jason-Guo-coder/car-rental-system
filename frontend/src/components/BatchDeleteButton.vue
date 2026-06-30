<script setup lang="ts">
import CircleIconButton from '@/components/CircleIconButton.vue'

/** 过滤栏内的批量删除按钮组：未激活=浅红，激活=实红+出现取消按钮。 */
defineProps<{ active: boolean }>()
defineEmits<{ trigger: []; cancel: [] }>()
</script>

<template>
  <CircleIconButton icon="Delete" title="批量删除" tone="danger" :active="active" @click="$emit('trigger')" />
  <CircleIconButton v-if="active" icon="Close" title="取消选择" @click="$emit('cancel')" />
</template>
