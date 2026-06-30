# 车辆租赁管理系统（Car Rental System）

一套面向中小型汽车租赁公司的内部运营管理系统，覆盖**权限管理、车辆建档、出租归还、客户与违章保养、财务统计**的完整业务闭环。前后端分离架构。

> 详细的产品设计见 [doc/PRD.md](./doc/PRD.md)。

---

## 技术栈

| 端 | 技术 |
|---|---|
| 后端 | Spring Boot 3.0.10 · JDK 17 · MyBatis-Plus 3.5.5 · Spring Security + JWT · MySQL 8 · Redis · 阿里云 OSS · EasyExcel · Spring Mail |
| 前端 | Vue 3.4 · Vite 5 · TypeScript · Element Plus · Pinia · ECharts 5 · Axios |

---

## 目录结构

```
car-rental-system/
├── backend/                       # Spring Boot 后端
│   └── src/main/
│       ├── java/com/gjq/
│       │   ├── controller/        # 接口层
│       │   ├── service/(impl)     # 业务层
│       │   ├── mapper/            # MyBatis-Plus Mapper
│       │   ├── entity/ vo/        # 实体与视图对象
│       │   ├── config/ security/  # 全局配置与安全鉴权
│       │   └── utils/             # 工具类（OSS、JWT、定时邮件等）
│       └── resources/
│           ├── application.yml    # 主配置（敏感信息走环境变量）
│           └── mapper/            # Mapper XML
├── frontend/                      # Vue 新前端
│   └── src/
│       ├── api/                   # 接口请求封装
│       ├── views/                 # 业务页面（system/auto/busi/finance）
│       ├── router/ stores/        # 路由与状态
│       └── api/http.ts            # Axios 封装
├── database/
│   └── car_rental_system.sql      # 全量演示数据库脚本
└── doc/                           # 项目文档（PRD、README）
```

---

## 环境要求

- JDK 17
- Maven 3.6+
- MySQL 8.x（数据库名 `car_rental_system`）
- Redis 6+
- Node.js 18+（适配 Vite 5）
- 阿里云 OSS 账号（图片上传，可选）
- 支持 SMTP 的邮箱（定时上报，可选）

---

## 快速开始

### 一键启动新前端 + 后端 + Redis

已提供双击脚本：

```bash
./start-cloudrent.command
```

脚本会启动 `frontend`，并优先复用已运行的 `8888` 后端和 `6379` Redis；如果它们未运行，才由脚本启动。默认前端地址是 `http://localhost:5180/`，如端口被占用会自动使用下一个可用端口。关闭窗口或按 `Ctrl+C` 时，会停止本脚本启动的进程，并保留原本已运行的后端/Redis。启动前仍需本机 MySQL 已运行，且已准备好 `car_rental_system` 数据库。

### 1. 数据库准备

创建数据库并导入数据：

```sql
CREATE DATABASE car_rental_system DEFAULT CHARACTER SET utf8mb4;
```

```bash
mysql -uroot -p car_rental_system < database/car_rental_system.sql
```

> `car_rental_system.sql` 保留表结构并重置演示数据，覆盖权限、车辆、客户、订单、保养、违章、财务统计等主要演示场景。

### 2. 启动 Redis

```bash
redis-server
```

### 3. 后端启动

后端通过**环境变量**读取敏感配置（不写入代码库），启动前需设置：

| 环境变量 | 说明 |
|---|---|
| `MYSQL_USERNAME` | 数据库用户名（默认 root） |
| `MYSQL_PASSWORD` | 数据库密码 |
| `ALIYUN_OSS_ACCESS_KEY_ID` | OSS AccessKey ID（用图片上传时） |
| `ALIYUN_OSS_ACCESS_KEY_SECRET` | OSS AccessKey Secret |
| `MAIL_USERNAME` | 发件邮箱账号（用定时邮件时） |
| `MAIL_PASSWORD` | 邮箱 SMTP 授权码 |

```bash
cd backend
mvn spring-boot:run
```

> IntelliJ IDEA 用户：在 Run Configuration 的 Environment variables 中配置上述变量。后端默认端口 **8888**。

### 4. 前端启动

```bash
cd frontend
npm install
npm run dev
```

前端默认端口 **5180**，浏览器访问 `http://localhost:5180`。

---

## 默认账号

| 用户名 | 密码 | 角色 |
|---|---|---|
| `admin` | `041009` | 系统管理员（全部权限） |

> 其余演示账号（运营/财务/维保/客服专员）密码同为 `041009`，权限按角色收窄。

---

## 功能模块

- **权限管理**：用户、角色、部门、菜单管理；RBAC 菜单级 + 按钮级权限；菜单动态下发。
- **数据初始**：车辆厂商、品牌（二级联动）、出租类型、车辆信息（OSS 图片上传、多条件检索）。
- **日常业务**：车辆出租、车辆归还（自动结算租金）、订单详情（押金返还 + 违章校验）、客户管理（黑白名单、身份证解析）、违章处理、保养管理（应保/实保）。
- **财务统计**：日报 / 月报（ECharts 图表）、数据导出、定时邮件上报业绩。

---

## 安全说明

- 所有密钥、密码均通过**环境变量**注入，请勿硬编码进 `application.yml` 或提交到仓库。
- `.idea/` 已在 `.gitignore` 中，本地运行配置中的密钥不会进入版本库。
- 建议定期轮换 OSS AccessKey 与邮箱授权码。

---

## 构建打包

```bash
# 后端打 jar
cd backend && mvn clean package

# 前端打生产包
cd frontend && npm run build
```

---

## 常见问题

- **启动报 `Could not resolve placeholder`**：检查对应环境变量是否已配置。
- **财务图表无数据**：日报/月报按系统当天/当月统计，需保证订单的出租/归还时间落在统计区间内。
- **菜单变更后不生效**：菜单登录时一次性下发，修改后需**退出重新登录**。
- **图片上传失败**：检查 OSS 环境变量与 bucket 配置。
