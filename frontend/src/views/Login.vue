<script setup lang="ts">
import { ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { User, Lock } from '@element-plus/icons-vue'
import { login as loginApi } from '@/api/http'
import { useAuthStore } from '@/stores/auth'

const router = useRouter()
const route = useRoute()
const auth = useAuthStore()
const username = ref('admin')
const password = ref('041009')
const loading = ref(false)

async function login() {
  loading.value = true
  try {
    await loginApi(username.value.trim(), password.value)
    await auth.load(true)
    const redirect = typeof route.query.redirect === 'string' ? route.query.redirect : auth.firstPath
    router.push(redirect)
  } catch (error) {
    ElMessage.error(error instanceof Error ? error.message : '登录失败')
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <div class="relative flex h-screen items-center justify-center overflow-hidden bg-app-bg">
    <!-- 背景光晕 -->
    <div class="pointer-events-none absolute inset-0 overflow-hidden">
      <div class="absolute -left-32 -top-32 h-[520px] w-[520px] rounded-full bg-[#5b8def]/25 blur-[120px]" />
      <div class="absolute -right-40 top-20 h-[460px] w-[460px] rounded-full bg-[#9b5de5]/22 blur-[120px]" />
      <div class="absolute -bottom-40 left-1/3 h-[480px] w-[480px] rounded-full bg-[#f472b6]/18 blur-[120px]" />
    </div>

    <!-- 登录玻璃卡 -->
    <div class="liquid-glass relative z-10 w-[420px] rounded-[28px] p-10">
      <!-- 品牌 -->
      <div class="mb-8 flex flex-col items-center">
        <div class="mb-4 flex h-16 w-16 items-center justify-center rounded-3xl bg-brand-gradient shadow-glass">
          <el-icon :size="32" color="#fff"><Van /></el-icon>
        </div>
        <h1 class="text-2xl font-semibold text-ink">云途租车</h1>
        <p class="mt-1 text-sm text-ink-muted">CloudRent · 车辆租赁管理系统</p>
      </div>

      <!-- 表单 -->
      <div class="space-y-4">
        <div class="glass-field flex h-12 items-center gap-3 px-4">
          <el-icon class="text-ink-muted"><User /></el-icon>
          <input v-model="username" placeholder="请输入用户名" class="w-full border-0 bg-transparent text-sm outline-none placeholder:text-ink-muted" />
        </div>
        <div class="glass-field flex h-12 items-center gap-3 px-4">
          <el-icon class="text-ink-muted"><Lock /></el-icon>
          <input v-model="password" type="password" placeholder="请输入密码" class="w-full border-0 bg-transparent text-sm outline-none placeholder:text-ink-muted" @keyup.enter="login" />
        </div>

        <div class="flex items-center justify-between text-sm">
          <label class="flex items-center gap-2 text-ink-soft">
            <input type="checkbox" class="accent-brand" checked />
            记住我
          </label>
          <a class="text-brand hover:underline">忘记密码？</a>
        </div>

        <button class="btn-brand h-12 w-full text-base" :disabled="loading" @click="login">
          {{ loading ? '登录中...' : '登 录' }}
        </button>
      </div>

      <p class="mt-6 text-center text-xs text-ink-muted">请使用后端账号登录</p>
    </div>
  </div>
</template>
