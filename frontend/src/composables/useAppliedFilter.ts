import { reactive } from 'vue'

/**
 * 过滤栏「点击查询才生效」复用逻辑。
 * form = 表单实时输入；applied = 查询后生效的快照。
 * 视图用 applied 做筛选，避免边输边筛。
 */
export function useAppliedFilter<T extends object>(initial: () => T) {
  const form = reactive(initial()) as T
  const applied = reactive(initial()) as T

  function doSearch() {
    Object.assign(applied, JSON.parse(JSON.stringify(form)))
  }
  function reset() {
    Object.assign(form, initial())
    Object.assign(applied, initial())
  }

  return { form, applied, doSearch, reset }
}
