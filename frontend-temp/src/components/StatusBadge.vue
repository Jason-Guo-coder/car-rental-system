<script setup lang="ts">
/** 圆点状态徽章：根据类型显示对应颜色的圆点 + 文字 */
type Tone = 'success' | 'warning' | 'danger' | 'info' | 'primary'

const props = withDefaults(
  defineProps<{
    text: string
    tone?: Tone
  }>(),
  { tone: 'info' },
)

const toneMap: Record<Tone, { dot: string; bg: string; text: string }> = {
  success: { dot: 'bg-statusOk', bg: 'bg-statusOk/10', text: 'text-statusOk' },
  warning: { dot: 'bg-statusWarn', bg: 'bg-statusWarn/10', text: 'text-statusWarn' },
  danger: { dot: 'bg-danger', bg: 'bg-danger/10', text: 'text-danger' },
  primary: { dot: 'bg-brand', bg: 'bg-brand/10', text: 'text-brand' },
  info: { dot: 'bg-ink-muted', bg: 'bg-ink-muted/10', text: 'text-ink-soft' },
}

const style = () => toneMap[props.tone]
</script>

<template>
  <span class="badge-dot" :class="[style().bg, style().text]">
    <span class="h-1.5 w-1.5 rounded-full" :class="style().dot" />
    {{ text }}
  </span>
</template>
