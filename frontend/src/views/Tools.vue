<script setup lang="ts">
import { computed, ref } from 'vue'
import { useRoute } from 'vue-router'
import { ElMessage } from 'element-plus'
import PageHeader from '@/components/PageHeader.vue'
import GlassCard from '@/components/GlassCard.vue'
import CircleIconButton from '@/components/CircleIconButton.vue'

type ToolMode = 'export' | 'upload' | 'zip' | 'pdf'
type Row = Record<string, string | number>

const route = useRoute()
const selected = ref<Row[]>([])
const uploadRows = ref<Row[]>([])
const uploadHeaders = ref<string[]>([])
const filename = ref('cloudrent-data')

const demoRows: Row[] = [
  { id: 1, title: '车辆出租订单', author: 'CloudRent', readings: 320, date: '2026-06-30' },
  { id: 2, title: '车辆归还结算', author: 'CloudRent', readings: 248, date: '2026-06-29' },
  { id: 3, title: '违章处理记录', author: 'CloudRent', readings: 186, date: '2026-06-28' },
  { id: 4, title: '车辆保养费用', author: 'CloudRent', readings: 142, date: '2026-06-27' },
]
const headers = ['id', 'title', 'author', 'readings', 'date']

const mode = computed<ToolMode>(() => {
  const path = route.path
  if (path.includes('/upload-excel')) return 'upload'
  if (path.includes('/zip')) return 'zip'
  if (path.includes('/pdf')) return 'pdf'
  return 'export'
})
const title = computed(() => mode.value === 'upload' ? 'Excel 上传解析' : mode.value === 'zip' ? 'Zip 导出' : mode.value === 'pdf' ? 'PDF 打印' : 'Excel 导出')
const subtitle = computed(() => '兼容旧前端工具入口，使用浏览器本地能力完成导入、导出与打印')
const tableRows = computed(() => uploadRows.value.length ? uploadRows.value : demoRows)
const tableHeaders = computed(() => uploadHeaders.value.length ? uploadHeaders.value : headers)

function cell(value: unknown) {
  return String(value ?? '').replaceAll('"', '""')
}

function download(content: string, name: string, type: string) {
  const blob = new Blob([content], { type })
  downloadBlob(blob, name)
}

function downloadBlob(blob: Blob, name: string) {
  const url = URL.createObjectURL(blob)
  const link = document.createElement('a')
  link.href = url
  link.download = name
  link.click()
  URL.revokeObjectURL(url)
}

function crc32(bytes: Uint8Array) {
  let crc = -1
  for (const byte of bytes) {
    crc ^= byte
    for (let i = 0; i < 8; i += 1) crc = (crc >>> 1) ^ (0xedb88320 & -(crc & 1))
  }
  return (crc ^ -1) >>> 0
}

function dosTime(date = new Date()) {
  return ((date.getHours() & 31) << 11) | ((date.getMinutes() & 63) << 5) | ((date.getSeconds() / 2) & 31)
}

function dosDate(date = new Date()) {
  return (((date.getFullYear() - 1980) & 127) << 9) | (((date.getMonth() + 1) & 15) << 5) | (date.getDate() & 31)
}

function makeZip(name: string, content: string) {
  const encoder = new TextEncoder()
  const fileName = encoder.encode(name)
  const data = encoder.encode(content)
  const crc = crc32(data)
  const localSize = 30 + fileName.length + data.length
  const centralSize = 46 + fileName.length
  const bytes = new Uint8Array(localSize + centralSize + 22)
  const view = new DataView(bytes.buffer)
  let offset = 0
  const u16 = (value: number) => { view.setUint16(offset, value, true); offset += 2 }
  const u32 = (value: number) => { view.setUint32(offset, value, true); offset += 4 }
  const put = (value: Uint8Array) => { bytes.set(value, offset); offset += value.length }
  const time = dosTime()
  const date = dosDate()

  u32(0x04034b50); u16(20); u16(0x0800); u16(0); u16(time); u16(date); u32(crc); u32(data.length); u32(data.length); u16(fileName.length); u16(0); put(fileName); put(data)
  const centralOffset = offset
  u32(0x02014b50); u16(20); u16(20); u16(0x0800); u16(0); u16(time); u16(date); u32(crc); u32(data.length); u32(data.length); u16(fileName.length); u16(0); u16(0); u16(0); u16(0); u32(0); u32(0); put(fileName)
  const centralEnd = offset
  u32(0x06054b50); u16(0); u16(0); u16(1); u16(1); u32(centralEnd - centralOffset); u32(centralOffset); u16(0)
  return bytes
}

function toCsv(rows: Row[]) {
  return [
    headers.map((h) => `"${cell(h)}"`).join(','),
    ...rows.map((row) => headers.map((h) => `"${cell(row[h])}"`).join(',')),
  ].join('\n')
}

function toHtmlTable(rows: Row[]) {
  const head = headers.map((h) => `<th>${cell(h)}</th>`).join('')
  const body = rows.map((row) => `<tr>${headers.map((h) => `<td>${cell(row[h])}</td>`).join('')}</tr>`).join('')
  return `<html><head><meta charset="utf-8"></head><body><table>${head}${body}</table></body></html>`
}

function exportAll() {
  download(toHtmlTable(demoRows), `${filename.value || 'cloudrent-data'}.xls`, 'application/vnd.ms-excel;charset=utf-8')
}

function exportSelected() {
  if (!selected.value.length) return ElMessage.warning('请先选择要导出的行')
  download(toHtmlTable(selected.value), `${filename.value || 'cloudrent-selected'}.xls`, 'application/vnd.ms-excel;charset=utf-8')
}

function exportMergeHeader() {
  const content = `<html><head><meta charset="utf-8"></head><body><table><tr><th colspan="${headers.length}">CloudRent 数据导出</th></tr>${toHtmlTable(demoRows).match(/<table>(.*)<\/table>/)?.[1] ?? ''}</table></body></html>`
  download(content, `${filename.value || 'cloudrent-merge'}.xls`, 'application/vnd.ms-excel;charset=utf-8')
}

function exportZipText() {
  const content = toCsv(demoRows)
  const zip = makeZip(`${filename.value || 'cloudrent-data'}.csv`, content)
  downloadBlob(new Blob([zip], { type: 'application/zip' }), `${filename.value || 'cloudrent-data'}.zip`)
}

function parseText(text: string) {
  const lines = text.split(/\r?\n/).filter(Boolean)
  const separator = text.includes('\t') ? '\t' : ','
  const [headLine, ...body] = lines
  const heads = headLine.split(separator).map((item) => item.trim().replace(/^"|"$/g, ''))
  uploadHeaders.value = heads
  uploadRows.value = body.map((line) => {
    const values = line.split(separator).map((item) => item.trim().replace(/^"|"$/g, ''))
    return Object.fromEntries(heads.map((head, index) => [head, values[index] ?? '']))
  })
}

function beforeUpload(file: File) {
  if (file.size / 1024 / 1024 >= 1) {
    ElMessage.warning('文件大小不能超过 1MB')
    return false
  }
  const reader = new FileReader()
  reader.onload = () => parseText(String(reader.result ?? ''))
  reader.readAsText(file, 'utf-8')
  return false
}

function printPage() {
  window.print()
}
</script>

<template>
  <div class="space-y-6">
    <PageHeader :title="title" :subtitle="subtitle">
      <template #actions>
        <CircleIconButton v-if="mode === 'pdf'" icon="Printer" title="打印" tone="brand" @click="printPage" />
        <CircleIconButton v-else-if="mode === 'zip'" icon="Download" title="导出 Zip" tone="brand" @click="exportZipText" />
        <CircleIconButton v-else-if="mode === 'export'" icon="Download" title="导出全部" tone="brand" @click="exportAll" />
      </template>
    </PageHeader>

    <GlassCard v-if="mode !== 'pdf'" padding="p-5">
      <div class="flex flex-wrap items-center gap-3">
        <el-input v-model="filename" placeholder="文件名" class="!w-52" />
        <button v-if="mode === 'export'" class="btn-brand h-10 px-4 text-sm" @click="exportAll">导出全部</button>
        <button v-if="mode === 'export'" class="btn-ghost h-10 px-4 text-sm" @click="exportSelected">导出选中</button>
        <button v-if="mode === 'export'" class="btn-ghost h-10 px-4 text-sm" @click="exportMergeHeader">合并表头导出</button>
        <button v-if="mode === 'zip'" class="btn-brand h-10 px-4 text-sm" @click="exportZipText">导出文本包</button>
        <el-upload v-if="mode === 'upload'" :show-file-list="false" :before-upload="beforeUpload" accept=".csv,.txt,.tsv">
          <button class="btn-brand h-10 px-4 text-sm">上传解析</button>
        </el-upload>
      </div>
    </GlassCard>

    <GlassCard v-if="mode === 'pdf'" padding="p-8" class="print-card">
      <div class="mx-auto max-w-3xl">
        <p class="text-2xl font-semibold text-ink">CloudRent 运营报表</p>
        <p class="mt-2 text-sm text-ink-muted">该页面使用浏览器打印生成 PDF，与旧前端 `window.print()` 行为对齐。</p>
        <div class="mt-6 grid grid-cols-3 gap-4">
          <div v-for="row in demoRows.slice(0, 3)" :key="row.id" class="rounded-2xl bg-white/70 p-4">
            <p class="text-sm text-ink-muted">{{ row.title }}</p>
            <p class="mt-2 text-2xl font-semibold text-ink">{{ row.readings }}</p>
          </div>
        </div>
      </div>
    </GlassCard>

    <GlassCard v-else>
      <el-table :data="tableRows" class="glass-table" @selection-change="selected = $event">
        <el-table-column v-if="mode === 'export'" type="selection" width="52" />
        <el-table-column v-for="head in tableHeaders" :key="head" :prop="head" :label="head" />
      </el-table>
    </GlassCard>
  </div>
</template>

<style scoped>
@media print {
  :global(.app-sidebar),
  :global(.app-header) {
    display: none !important;
  }

  .print-card {
    box-shadow: none !important;
    background: white !important;
  }
}
</style>
