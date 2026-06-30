import { ref } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'

/**
 * 两段式批量删除复用逻辑。
 * 第一次触发 → 进入选择模式（视图据 active 显示圆角勾选框列）；
 * 已勾选后再次触发 → 弹确认框，确认则调用 onConfirm(ids)。
 */
export function useBatchDelete(onConfirm: (ids: number[]) => void | string | Promise<void | string>, label = '记录') {
  const active = ref(false)
  const selectedIds = ref<Set<number>>(new Set())

  function toggle(id: number) {
    if (selectedIds.value.has(id)) selectedIds.value.delete(id)
    else selectedIds.value.add(id)
  }
  function isSelected(id: number) {
    return selectedIds.value.has(id)
  }
  function exit() {
    active.value = false
    selectedIds.value.clear()
  }
  function trigger() {
    if (!active.value) {
      active.value = true
      selectedIds.value.clear()
      return
    }
    if (selectedIds.value.size === 0) {
      ElMessage.warning(`请先勾选要删除的${label}`)
      return
    }
    const ids = [...selectedIds.value]
    ElMessageBox.confirm(`确认删除选中的 ${ids.length} 条${label}？此操作不可恢复。`, '批量删除', {
      type: 'warning',
      confirmButtonText: '删除',
      cancelButtonText: '取消',
    })
      .then(async () => {
        const message = await onConfirm(ids)
        ElMessage.success(message || `已删除 ${ids.length} 条${label}`)
        exit()
      })
      .catch(() => {})
  }

  return { active, selectedIds, toggle, isSelected, exit, trigger }
}
