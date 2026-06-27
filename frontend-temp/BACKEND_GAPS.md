# 新前端对接后端缺口记录

本文件只记录前端接入真实后端时发现的后端/API缺口。当前任务不修改后端。

## 已接入

- 登录：`POST /rental/user/login`
- 鉴权：请求头 `token`
- 车辆、厂商、品牌、出租类型、客户、订单、违章、保养 CRUD/分页接口
- 财务：当日/当月收入与出租/归还数量统计
- 首页：`GET /rental/dashboard/overview`
- 系统：用户、部门、角色、菜单权限基础接口

## 缺口与限制

1. ~~后端没有新前端首页需要的聚合仪表盘接口。~~ 已补 `GET /rental/dashboard/overview`，前端保留旧多接口组合作为兜底。
2. ~~后端财务接口没有运营成本、按出租类型收入构成、完整年度/月度财务明细。当前前端只能展示当月收入/押金/订单趋势，成本为 `0`。~~ 已在前端用现有订单与保养接口聚合兜底：运营成本按保养费统计，收入构成按出租类型统计，年度/月度财务明细按当前年度 1-12 月生成。
3. 订单创建接口不返回新订单实体，只返回成功/失败；前端创建后必须重新拉取订单列表。
4. 客户创建接口返回客户 id，但没有“创建或按手机号复用”的单接口；出租流程前端先查本地已加载列表，不存在再创建。
5. 保养接口没有状态字段。新前端统一把已存在保养记录显示为已保养。
6. 用户角色绑定接口只接受角色 id，用户列表接口不直接返回角色名称；新前端系统管理里角色名可能需要额外查询/绑定后刷新。
7. 角色新增接口有 `@PreAuthorize("hasAnyAuthority('sys:role:save')")`，如果当前账号权限表缺少该权限，新增角色会失败。
8. 后端 CORS、JWT 固定密钥、订单事务等安全/一致性问题已在项目探索中发现，前端无法修复。

## 前端约定

- 默认后端地址：`http://localhost:8888`
- 可用环境变量覆盖：`VITE_API_BASE_URL`
- token 存储 key：`cloudrent-token`

## 权限管理四个界面对齐老前端后的接口问题

只读检查范围：老前端 `frontend/src/views/system/*` 与新前端 `frontend-temp/src/views/system/*`，以及后端 `UserController`、`DeptController`、`RoleController`、`PermissionController`。本次只记录问题，不修改业务代码。

### 用户管理

1. ~~用户列表查询契约未完全对齐。老前端使用 `POST /rental/user/{start}/{size}` 并把 `username`、`realname`、`nickname`、`phone`、`email`、`deptId` 等条件交给后端分页查询；新前端当前固定调用 `POST /rental/user/1/999`，请求体只有 `{ deptId: 0 }`，再在前端本地过滤。数据量变大后，分页、搜索结果和老前端不一致。~~ 已在新前端用户管理接入 `POST /rental/user/{start}/{size}`，查询条件交给后端处理，并补充分页展示。
2. ~~用户头像接口未接入。老前端用户表单使用 `POST /rental/oss/upload` 上传头像，并向用户保存接口传 `avatar`；新前端 `mapUser` 和 `userToApi` 都没有读写 `avatar`，只能显示本地首字头像。~~ 已在新前端接入 `POST /rental/oss/upload`，并在用户列表/新增/编辑中读写 `avatar`。
3. ~~用户保存密码字段有覆盖风险。老前端新增用户时由表单填写密码，编辑时沿用当前表单数据；新前端 `userToApi` 固定传 `password: '123456'`，编辑用户也会带上该字段。后端 `PUT /rental/user` 直接 `updateById`，存在编辑时把密码改成明文 `123456` 或破坏原密码的风险。~~ 已改为新增用户时填写并提交密码，编辑用户时不再提交 `password` 字段。
4. ~~用户绑定角色回显未对齐。老前端打开绑定角色弹窗前会调用 `GET /rental/user/role/{userId}` 获取当前角色 id 列表；新前端用户列表 `roleName` 固定为空，绑定弹窗不能回显已有角色。~~ 已接入 `GET /rental/user/role/{userId}`，打开绑定角色弹窗时回显已绑定角色。
5. ~~用户角色绑定能力降级。老前端支持多角色勾选后调用 `GET /rental/user/bind/{userId}/{roleIds}`；新前端 store 通过单个 `roleName` 找一个角色后绑定，只覆盖单角色场景。~~ 已改为多选角色 id，并按后端契约调用 `GET /rental/user/bind/{userId}/{roleIds}`。
6. ~~新增用户后无法立即绑定角色。新前端新增表单虽然有角色字段，但保存时只调用 `POST /rental/user`；后端该接口只返回成功/失败，不返回新用户 id，前端无法在同一流程里继续调用 `/rental/user/bind/{userId}/{roleIds}`。~~ 已在新增用户成功后按用户名查询新用户 id，再自动调用角色绑定接口。

### 部门管理

1. ~~部门查询接口未对齐。老前端搜索使用 `POST /rental/dept`，把 `deptName` 交给后端过滤；新前端只调用 `GET /rental/dept` 获取整棵树，再本地过滤。~~ 已在新前端部门管理接入 `POST /rental/dept`，查询按钮按 `deptName` 走后端过滤。
2. ~~删除部门前置校验缺失。老前端删除前调用 `GET /rental/dept/{id}` 判断是否存在子部门；新前端直接调用 `DELETE /rental/dept/{id}`。后端删除接口本身没有子部门校验，可能删除带子部门的数据。~~ 已在删除前调用 `GET /rental/dept/{id}`，后端返回“有”时前端拦截删除。
3. ~~部门保存字段不完整。老前端表单包含 `orderNum`、`parentName` 等字段；新前端 `deptToApi` 只传 `id`、`deptName`、`pid`、`phone`、`address`，会导致排序和上级部门名称数据无法按老前端方式维护。~~ 已补充 `parentName` 和 `orderNum` 的展示、编辑和保存。
4. ~~新前端展示字段没有后端来源。新前端部门模型里有 `leader`、`memberCount`，但当前后端部门接口未提供这些字段，只能显示默认值。~~ 已移除负责人/人数展示，改为展示后端真实字段 `orderNum`、`phone`、`address`。

### 角色管理

1. ~~角色列表查询契约未对齐。老前端列表使用 `POST /rental/role/{start}/{size}`，支持 `roleName` 和 `createrId` 查询；新前端调用 `GET /rental/role` 拉全量角色，本地处理，无法按老前端方式后端分页和搜索。~~ 已在角色管理页接入 `POST /rental/role/{start}/{size}`，查询条件按 `roleName` 提交，`createrId` 使用当前登录用户 id。
2. ~~删除角色前置校验反馈不一致。老前端删除前调用 `GET /rental/role/hasUser/{id}` 判断角色是否绑定用户；新前端直接调用 `DELETE /rental/role/{ids}`。如果后端 service 跳过有关联用户的角色，新前端可能只看到成功提示，但实际角色未删除或只部分删除。~~ 已在单个角色删除前调用 `GET /rental/role/hasUser/{id}`，后端返回“有”时提示“该角色下有用户，不能删除”并拦截删除。
3. ~~新增/编辑角色创建人未对齐。老前端保存角色时传当前登录用户的 `createrId`；新前端 `roleToApi` 固定传 `createrId: 1`。后端角色分页查询会根据 `createrId` 控制可见范围，普通用户场景下会出现数据归属不一致。~~ 已移除固定 `createrId: 1`，新增/编辑角色保存时使用当前登录用户 id，编辑已有角色时优先保留后端返回的 `createrId`。
4. 清空角色权限没有稳定接口表达。当前权限分配使用 `GET /rental/role/{roleId}/{permissionIds}`，后端用路径变量解析权限 id；当权限全部取消时，空 `permissionIds` 无法形成稳定路径，前端难以表达“清空全部权限”。经对齐确认，老前端也调用同一后端接口 `GET /rental/role/{roleId}/{permissionIds}`，空权限同样无法稳定表达；这不是新前端相对老前端的差异，且不改后端时不做前端伪修。

### 菜单管理

1. ~~上级菜单选择接口未完全对齐。老前端使用 `GET /rental/permission/tree` 获取可选上级菜单，该接口会排除按钮并补充根目录；新前端当前使用 `GET /rental/permission` 的完整权限树本地构造选项，容易把按钮或不该作为父级的节点带入选择范围。~~ 已新增 `permissionParents`，菜单上级选择改用 `GET /rental/permission/tree`。
2. ~~删除菜单前置校验缺失。老前端删除前调用 `GET /rental/permission/hasChildren/{id}`；新前端直接调用 `DELETE /rental/permission/{id}`。后端删除接口本身没有子菜单校验，可能删除带子节点的菜单。~~ 已在删除前调用 `GET /rental/permission/hasChildren/{id}`，存在子菜单时阻止删除。
3. ~~`parentLabel` 没有维护。老前端选择上级菜单时会同时设置 `pid` 和 `parentLabel`；新前端 `permissionToApi` 不传 `parentLabel`，后端保存/更新也不会自动补齐，老前端菜单列表中的“上级菜单”字段可能缺失或残留旧值。~~ 已在权限模型、映射和保存/更新 payload 中维护 `parentLabel`，父级选择变化时同步写入。
4. 图标字段语义不兼容。老前端和历史数据常用 `component`、`guide`、`el-icon-plus` 这类图标值；新前端表单使用 Element Plus 图标组件名，如 `Odometer`、`Van`。共用数据库时，同一个 `icon` 字段在新旧前端之间显示语义不一致。

### 通用问题

1. 新前端系统管理四个界面整体偏向一次性拉全量数据再本地过滤；老前端多处依赖后端分页、条件查询和删除前校验接口。要完全对齐老前端，需要把查询、回显、校验流程恢复到对应接口契约。
2. 多个保存/删除接口只返回成功/失败，不返回新实体或部分失败明细。新前端在“新增后继续绑定角色”“批量删除角色但部分被用户占用”等流程里缺少可靠的后续判断依据。

## 二次全量对齐检查补充

只读检查范围：调用多个 subagent 分别检查“车辆/业务模块”和“系统/首页/财务/权限路由”，并由主线程复核关键文件。前 4 个 subagent 因平台 429 限流失败，后续 2 个轻量 subagent 已完成；本节只追加确认的不对齐问题，不修改业务代码。

### 全局查询与分页

1. 多数业务列表从“后端分页+条件查询”退化为“固定拉 999 条再本地过滤”。旧前端各模块普遍调用 `POST /rental/*/{start}/{size}` 并传查询模型；新前端大量调用 `/1/999` 且请求体 `{}`，例如 `autoMaker`、`autoBrand`、`autoInfo`、`customer`、`order`、`violation`、`maintain`。影响：后端筛选条件失效，数据超过 999 条会漏数据，分页语义和旧前端不一致。
2. 新前端多个页面的查询按钮只是应用本地过滤快照，没有重新请求后端。旧前端点击查询会带条件重新调后端接口；新前端在大数据量或服务端特殊筛选字段场景下结果会不准。

### 车辆基础资料

1. 厂商排序字母未对齐。旧前端厂商列表展示并维护 `orderLetter`；新前端 `mapMaker` 没有映射该字段，新增/编辑也只传 `name`。影响：厂商排序字母数据无法在新前端维护。
2. 品牌查询未使用服务端条件。旧前端品牌列表按 `mid`、`brandName` 等条件调用分页接口；新前端先拉全量品牌，再按当前厂商和名称本地过滤。影响：数据量大时筛选和分页不一致。
3. 车辆状态少了“自用”。旧前端车辆状态支持 `0=未租`、`1=已租`、`2=维保`、`3=自用`；新前端 `carStatus.toUi` 只映射 `idle/renting/maintain`，`status=3` 会被当成 `idle`。影响：“自用”车辆可能被误判为空闲，并出现在出租列表。
4. 车辆新增/编辑的厂商/品牌绑定不稳。旧前端保存车辆传 `makerId`、`brandId`；新前端车辆表单主要选择 `makerName`、`brandName`，而 `carToApi` 保存依赖 `makerId`、`brandId`。影响：新增车辆可能无法正确绑定厂商/品牌。
5. 车辆图片上传未接入。旧前端车辆表单使用 `POST /rental/oss/upload` 上传图片并保存 `pic`；新前端车辆抽屉只是“点击上传车辆照片”的占位区域，没有实际上传和写入 `image/pic`。影响：车辆图片无法新增或更新。
6. 车辆租金、上牌日期等筛选字段在旧前端会转成 `lowRent/highRent`、`lowRegistrationDate/highRegistrationDate` 交给后端；新前端只在本地比较已加载数据。影响：后端范围查询能力未使用。

### 客户与租车

1. 客户校验规则不一致。旧前端客户表单对手机号、身份证等字段有必填和格式校验，状态只有白名单/黑名单；新前端主要校验姓名/电话，类型里还有 `normal`，但保存时 `normal` 会被 `customerToApi` 转成白名单。影响：可输入旧前端不允许的数据，普通客户语义保存后丢失。
2. 老客户回填接口未使用。旧前端租车时电话变化会调用 `POST /rental/customer/tel` 查老客户并回填；新前端虽然封装了 `api.customers.byPhone`，但租车流程只在本地已加载客户列表中按手机号查找。影响：老客户不在本地列表时会重复新增客户。
3. 可租车辆范围未走后端条件。旧前端租车列表直接用 `status=0` 查询未租车辆；新前端从全量车辆中过滤 `idle`。结合“自用”状态被映射为 `idle` 的问题，影响：可租车辆范围可能错误。
4. 租车页面的日期范围筛选没有参与后端查询。旧前端会把上牌日期范围转成后端查询字段；新前端租车过滤表单里有日期范围，但当前本地过滤未实际使用该条件。

### 还车与订单

1. ~~未归还订单接口未使用。旧前端车辆归还页调用 `POST /rental/order/unfinished/{start}/{size}`；新前端从 `POST /rental/order/1/999` 的全部订单里本地筛 `renting/overdue`。影响：未归还专用查询、分页和条件筛选不一致，数据量大时会漏待还订单。~~ 已在车辆归还页接入 `POST /rental/order/unfinished/{start}/{size}`，查询条件按订单编号、车牌、客户姓名、客户电话交给后端分页。
2. ~~还车默认时间和计费逻辑不一致。旧前端打开归还弹窗时默认 `returnTime` 为当前时间，并按完整时间差向上取整计算租金；新前端归还时间默认为空，`daysBetween` 只截日期且至少 1 天。影响：同日归还、跨时分秒归还的费用可能与旧前端不一致。~~ 已改为打开归还弹窗默认当前时间，并按完整时间差向上取整计算应付/实付金额。
3. ~~还车里程校验少了等于场景。旧前端要求“还车里程必须大于起租里程”；新前端只禁止小于起租里程，允许等于。影响：旧前端禁止的数据会被新前端放行。~~ 已改为 `returnMileage <= mileage` 时拦截，提示“还车里程必须大于起租里程”。
4. ~~还车更新 payload 不完整。旧前端提交完整 `saveOrder`，包含订单原字段和 `rentPayable/rentActual`；新前端只提交 `id`、`autoId`、`returnMileage`、`returnTime`、`rentPayable`、`rentActual`。影响：如果后端更新逻辑依赖其它订单字段，新前端缺少上下文。~~ 已用当前订单完整字段映射后提交 `PUT /rental/order`，包含订单编号、车辆、客户、类型、租金、押金、起租里程、归还信息和 `rentPayable/rentActual`。
5. ~~押金返还流程缺失。旧前端订单页先调用 `GET /rental/order/countViolation/{autoId}` 判断租期内是否有未处理违章，再调用 `GET /rental/order/doReturnDeposit/{orderId}`；新前端只在详情中用 `status === returned` 显示“已返还”。影响：未处理违章拦截和押金返还动作都没有对齐，押金状态展示可能错误。~~ 已在订单总览加入押金返还按钮，先调用 `GET /rental/order/countViolation/{autoId}`，无未处理违章后再调用 `GET /rental/order/doReturnDeposit/{orderId}`；展示改用后端 `depositReturn`。
6. ~~订单列表未使用后端分页/条件查询。旧前端按订单编号、车牌、客户姓名、客户电话调用后端分页查询；新前端拉全量后本地过滤。影响：查询结果和分页行为不一致。~~ 已在订单总览接入 `POST /rental/order/{start}/{size}`，查询条件交给后端分页处理。

### 违章与保养

1. ~~违章新增缺少车牌存在校验。旧前端保存违章前调用 `POST /rental/autoInfo/exist` 校验车辆是否存在；新前端直接保存。影响：可能提交不存在车辆的违章记录。~~ 已在新前端新增违章保存前调用 `POST /rental/autoInfo/exist`，后端返回 `message=none` 时阻止提交并提示车牌号不存在。
2. ~~违章日期筛选粒度不一致。旧前端使用精确到秒的 `datetimerange`，传 `lowViolationTime/highViolationTime` 给后端；新前端按 `time.slice(0, 10)` 做本地日期过滤。影响：时间粒度变粗，服务端筛选能力未使用。~~ 已将违章筛选改为 `datetimerange`，按 `YYYY-MM-DD HH:mm:ss` 传 `lowViolationTime/highViolationTime` 给 `POST /rental/violation/{start}/{size}` 后端查询。
3. ~~保养车辆来源未对齐。旧前端新增保养时从 `GET /rental/autoInfo/toBeMaintain` 获取待保养车辆下拉；新前端手输车牌。影响：可录入不应保养或不存在的车辆，也缺少旧前端的待保养车辆提示。~~ 已在新增/编辑保养弹窗调用 `GET /rental/autoInfo/toBeMaintain`，车牌改为待保养车辆下拉，并显示未保次数。
4. 保养状态是新前端自造语义。旧前端保养记录没有 `pending/done` 处理状态；新前端类型和页面有待保养/已保养，但 `mapMaintain` 始终映射为 `done`，`finish()` 也只是再次 update 当前记录。影响：待保养/完成状态无法可靠和后端数据对应。

### 财务、首页与权限路由

1. ~~权限路由机制未对齐。旧前端登录后调用 `/rental/auth/info`、`/rental/auth/menuList`，按后端菜单动态生成路由；新前端路由和菜单写死，只在路由守卫里检查 token。影响：RBAC 菜单不生效，不同角色会看到同一套菜单，后端 `sys_permission` 改动不会反映到新前端。~~ 已新增前端 auth store，登录/路由守卫会拉取 `/rental/auth/info` 与 `/rental/auth/menuList`；当前保留新前端产品固定菜单顺序和固定图标，后端菜单路径只用于过滤可见入口和路由权限，避免后端历史菜单顺序/标题/图标把侧边栏打散。
2. ~~按钮级权限缺失。旧前端把权限码存入 `sessionStorage.permissionCode`，通过 `hasPermission` 控制按钮显隐；新前端没有等价机制，操作按钮直接展示。影响：前端按钮级权限失效。~~ 已把 `/rental/auth/info` 返回的权限码写入 `sessionStorage.permissionCode`，并按旧前端权限码接入用户、部门、角色、厂商、品牌的新增/编辑/删除按钮显隐。
3. ~~系统管理路由不兼容。旧前端有 `/system/user/userList`、`/system/dept/deptList`、`/system/role/roleList`、`/system/permission/perr`；新前端只有 `/system`，内部用 Tab 切换。影响：后端菜单返回的旧路由、旧书签和直接刷新路径都不兼容。~~ 已补充旧系统管理路径路由，访问旧路径会打开新前端同一个权限管理页并自动切到对应 Tab。
4. ~~财务日报能力缺失。旧前端有 `/finance/dayReport` 和 `/finance/monthReport`，接口包含 `countDayCost/countDayRental/countDayReturn/countMonthCost/countMonthRental/countMonthReturn`；新前端只有 `/finance`，API 只封装 `dayCost/monthCost/monthRental/monthReturn`。影响：旧前端日报出租/归还图表能力未完整迁移。~~ 已补齐 `countDayRental/countDayReturn` API 封装，并新增 `/finance/dayReport`、`/finance/monthReport` 前端路由用于兼容旧路径；侧边栏仍只显示一个“财务报表”，旧日报/月报路径会归一到 `/finance` 菜单高亮，不再拆成两个菜单入口。
5. 根路径跳转不一致。旧前端 `/` 重定向 `/dashboard`；新前端 `/` 重定向 `/login`。影响：已登录用户访问根路径时入口语义和旧前端不同。
6. 登录后 redirect 不一致。旧前端支持 `?redirect=`，登录成功后回到原目标页；新前端登录成功固定跳 `/dashboard`。影响：从受保护页面跳到登录后，无法回到原页面。
7. ~~首页角色行为不一致。旧前端 Dashboard 按 `roles` 区分 admin/editor 首页；新前端 Dashboard 不按角色分流，布局底部用户信息也写死为“超级管理员/admin”。影响：非管理员用户展示不准确。~~ 已改为使用 `/rental/auth/info` 中的当前用户信息展示问候语、头像、账号和角色标签，非管理员显示业务人员角色视图提示，底部用户不再写死为 admin。

### 菜单数据归属建议

当前这一版不强制修改数据库：前端已经把侧边栏固定为“数据初始、日常业务、财务中心”的产品顺序，并用 `/rental/auth/menuList` 只做权限过滤，所以即使后端 `sys_permission` 里存在 `/finance/dayReport`、`/finance/monthReport` 两个菜单，侧边栏也不会再拆成“财务日报/财务月报”。

如果希望数据库本身也和当前新前端完全一致，推荐在 `sys_permission` 中把可见财务菜单收敛为一个“财务报表”入口 `/finance`；`/finance/dayReport`、`/finance/monthReport` 可以保留为旧路径兼容权限或隐藏路由节点，但不要作为侧边栏可见菜单挂到财务中心下。这样权限管理菜单树、老路径兼容和新前端侧边栏三者会更自洽。
