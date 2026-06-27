# 云途租车 CloudRent · 新前端

车辆租赁管理系统的新前端，保留 iOS 玻璃拟态风格，默认连接 Spring Boot 后端真实接口。默认 API 地址为 `http://localhost:8888`，可通过 `VITE_API_BASE_URL` 覆盖。

## 技术栈

| 类别 | 选型 | 说明 |
|---|---|---|
| 框架 | Vue 3.4 + `<script setup>` + TypeScript | 组合式 API |
| 构建 | Vite 5 | 秒级冷启动与 HMR |
| 组件库 | Element Plus 2.7 | 提供表格/表单/抽屉/日期选择器等交互骨架 |
| 样式 | Tailwind CSS 3.4 + 自定义玻璃拟态类 | 视觉层完全可控，还原玻璃风 |
| 状态 | Pinia 2 | 各业务模块独立 store |
| 图表 | ECharts 5 | 仪表盘与财务报表 |
| 路由 | Vue Router 4 | |

> 设计理念：**Element Plus 负责交互行为，Tailwind/自定义 CSS 负责玻璃外观**。组件库默认皮肤通过 CSS 变量覆盖融入玻璃拟态。

## 快速开始

根目录已提供一键启动脚本，会启动新前端，并优先复用已运行的后端和 Redis；前端端口占用时会自动选择下一个可用端口：

```bash
../start-cloudrent.command
```

```bash
npm install
npm run dev      # 启动开发服务器 http://localhost:5180
npm run build    # 生产构建（含 vue-tsc 类型检查）
npm run preview  # 预览构建产物
```

登录页会调用后端 `/rental/user/login`，默认演示账号见根目录 README。

## 目录结构

```
src/
├── components/        # 通用组件（数据无关、可复用）
│   ├── GlassCard.vue      玻璃卡容器
│   ├── PageHeader.vue     页面标题区
│   ├── StatCard.vue       统计卡
│   ├── StatusBadge.vue    圆点状态徽章
│   ├── SearchBox.vue      玻璃搜索框
│   ├── FilterBar.vue      多字段过滤栏
│   └── FilterField.vue    过滤字段
├── layout/
│   └── AppLayout.vue      主框架：透明侧边栏 + 背景光晕 + 路由出口
├── views/             # 页面（仅从 store 取数，不硬编码数据）
│   ├── Login.vue / Dashboard.vue / CarInfo.vue ...
│   └── system/            权限管理 4 个 Tab 子面板
├── stores/            # Pinia：状态 + 增删改查 + 过滤逻辑
├── api/               # fetch 客户端、后端接口与字段映射
├── data/              # 少量空态/图表默认展示数据
├── types/             # TypeScript 领域模型（对齐后端 14 张表 VO）
├── config/menu.ts     # 侧边栏菜单配置（数据驱动）
├── utils/dict.ts      # 状态码 → 文案/色调 字典
└── styles/index.css   # 玻璃拟态基类 + Element Plus 变量覆盖
```

## 数据接入

- `src/api/http.ts` —— 最小 fetch 客户端，负责 base URL、token、登录/退出。
- `src/api/backend.ts` —— 后端接口封装与字段映射。
- `src/stores/*.ts` —— Pinia store 调用 API，对外提供 getters（统计/过滤）与 actions（增删改）。
- `src/views/*.vue` —— 组件**只**通过 store 读写数据，不直接 import data 文件，也不在模板内硬编码列表。

## 页面清单（16 个，对齐 Figma）

数据初始：概览仪表盘、车辆信息、厂商品牌、出租类型
日常业务：汽车出租、车辆归还、订单总览、客户管理、违章处理、车辆保养
财务中心：财务报表
系统管理：权限管理（用户 / 部门组织架构图 / 角色 / 菜单 4 Tab）
独立页：登录页

## 设计 Token

- 主色渐变：`#3B83F5 → #7368F2`
- 玻璃卡：`bg-white/95` + `backdrop-blur(18px)` + 柔阴影 + 圆角 18/20
- 功能色：删除红 `#f24d5c`、编辑蓝 `#3a73f2`、角色紫 `#7368f2`、权限 teal `#009999`
- 字体：Inter / PingFang SC
