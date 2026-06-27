<script setup lang="ts">
import { computed, ref, watch } from 'vue'

const props = withDefaults(defineProps<{
  currentPage: number
  total: number
  pageSize: number
  maxPages?: number
}>(), {
  maxPages: 5,
})

const emit = defineEmits<{
  'update:currentPage': [value: number]
  change: [value: number]
}>()

const jumpPage = ref(props.currentPage)

const pageCount = computed(() => Math.max(1, Math.ceil(props.total / props.pageSize)))
const canPrev = computed(() => props.currentPage > 1)
const canNext = computed(() => props.currentPage < pageCount.value)
const visiblePages = computed(() => {
  const total = pageCount.value
  if (total <= props.maxPages) return Array.from({ length: total }, (_, i) => i + 1)
  const start = Math.min(Math.max(1, props.currentPage - 2), total - props.maxPages + 1)
  return Array.from({ length: props.maxPages }, (_, i) => start + i)
})

watch(
  () => props.currentPage,
  (current) => {
    jumpPage.value = current
  },
)

function changePage(current: number) {
  const next = Math.min(Math.max(1, current), pageCount.value)
  jumpPage.value = next
  if (next === props.currentPage) return
  emit('update:currentPage', next)
  emit('change', next)
}

function prevPage() {
  if (canPrev.value) changePage(props.currentPage - 1)
}

function nextPage() {
  if (canNext.value) changePage(props.currentPage + 1)
}

function jumpToPage() {
  changePage(Number(jumpPage.value) || 1)
}
</script>

<template>
  <div class="floating-pagination-wrap">
    <div class="liquid-pagination" aria-label="分页">
      <span class="pagination-total">共 {{ total }} 条</span>
      <button class="pagination-nav" :disabled="!canPrev" title="上一页" @click="prevPage">
        <el-icon><ArrowLeft /></el-icon>
      </button>
      <div class="pagination-pages">
        <button
          v-for="item in visiblePages"
          :key="item"
          class="pagination-page"
          :class="{ active: item === currentPage }"
          @click="changePage(item)"
        >
          {{ item }}
        </button>
      </div>
      <button class="pagination-nav" :disabled="!canNext" title="下一页" @click="nextPage">
        <el-icon><ArrowRight /></el-icon>
      </button>
      <span class="pagination-jump-label">前往</span>
      <input
        v-model.number="jumpPage"
        class="pagination-jump"
        type="number"
        min="1"
        :max="pageCount"
        @blur="jumpToPage"
        @keyup.enter="jumpToPage"
      />
      <span class="pagination-jump-label">页</span>
    </div>
  </div>
</template>

<style scoped>
.floating-pagination-wrap {
  position: absolute;
  right: 18px;
  top: calc(100% + 14px);
  z-index: 2;
  display: flex;
  justify-content: flex-end;
}

.liquid-pagination {
  position: relative;
  display: inline-flex;
  align-items: center;
  gap: 10px;
  min-height: 52px;
  padding: 9px 14px;
  overflow: hidden;
  border: 1px solid rgba(255, 255, 255, 0.72);
  border-radius: 19px;
  background:
    linear-gradient(135deg, rgba(255, 255, 255, 0.72), rgba(255, 255, 255, 0.36)),
    radial-gradient(circle at 18% 0%, rgba(255, 255, 255, 0.9), transparent 44%);
  box-shadow:
    0 18px 48px rgba(85, 91, 180, 0.18),
    0 6px 18px rgba(60, 70, 130, 0.1),
    inset 0 1px 0 rgba(255, 255, 255, 0.72),
    inset 0 -1px 0 rgba(118, 125, 230, 0.08);
  backdrop-filter: blur(24px) saturate(168%);
  -webkit-backdrop-filter: blur(24px) saturate(168%);
}

.liquid-pagination::before {
  position: absolute;
  inset: 1px;
  pointer-events: none;
  content: '';
  border-radius: 18px;
  background: linear-gradient(180deg, rgba(255, 255, 255, 0.5), transparent 48%);
}

.pagination-total,
.pagination-jump-label {
  position: relative;
  z-index: 1;
  font-size: 13px;
  color: #5a5e6b;
  white-space: nowrap;
}

.pagination-pages {
  position: relative;
  z-index: 1;
  display: inline-flex;
  gap: 6px;
}

.pagination-nav,
.pagination-page,
.pagination-jump {
  position: relative;
  z-index: 1;
  height: 34px;
  border: 1px solid rgba(255, 255, 255, 0.52);
  border-radius: 12px;
  background: rgba(255, 255, 255, 0.42);
  color: #5a5e6b;
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.62);
  transition:
    transform 0.18s ease,
    box-shadow 0.18s ease,
    background 0.18s ease,
    color 0.18s ease,
    opacity 0.18s ease;
}

.pagination-nav,
.pagination-page {
  display: inline-flex;
  align-items: center;
  justify-content: center;
}

.pagination-nav {
  width: 34px;
}

.pagination-page {
  min-width: 34px;
  padding: 0 10px;
  font-size: 14px;
  font-weight: 600;
}

.pagination-nav:not(:disabled):hover,
.pagination-page:not(.active):hover {
  color: #3b83f5;
  background: rgba(255, 255, 255, 0.72);
  box-shadow:
    0 8px 18px rgba(91, 110, 240, 0.14),
    inset 0 1px 0 rgba(255, 255, 255, 0.7);
  transform: translateY(-1px);
}

.pagination-page.active {
  color: #fff;
  background: linear-gradient(135deg, #3b83f5 0%, #7368f2 100%);
  border-color: rgba(255, 255, 255, 0.36);
  box-shadow:
    0 10px 22px rgba(91, 110, 240, 0.34),
    inset 0 1px 0 rgba(255, 255, 255, 0.28);
}

.pagination-nav:disabled {
  cursor: not-allowed;
  opacity: 0.38;
}

.pagination-jump {
  width: 58px;
  padding: 0 8px;
  font-size: 14px;
  font-weight: 600;
  text-align: center;
  outline: none;
}

.pagination-jump:focus {
  border-color: rgba(59, 131, 245, 0.48);
  background: rgba(255, 255, 255, 0.78);
  box-shadow:
    0 0 0 3px rgba(59, 131, 245, 0.1),
    inset 0 1px 0 rgba(255, 255, 255, 0.68);
}

.pagination-jump::-webkit-outer-spin-button,
.pagination-jump::-webkit-inner-spin-button {
  margin: 0;
  appearance: none;
}

.pagination-jump[type='number'] {
  appearance: textfield;
}
</style>
