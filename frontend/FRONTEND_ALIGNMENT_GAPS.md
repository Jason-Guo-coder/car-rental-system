# 新旧前端对齐缺口记录

审计日期：2026-06-27

审计范围：

- 老前端：`frontend`
- 新前端：`frontend`

约束：

- 只对比前端代码。
- 未联网，未拉取脚本，未读取或修改后端、数据库。
- 本文只记录新前端相对老前端仍未对齐的行为、接口契约或前端流程。

不计入本文缺口：

- 左侧固定栏的顺序、图标。
- 由数据库菜单配置即可调整的菜单归属问题。
- 已经在新前端补齐且当前代码能看到对齐的旧缺口。

## 1. 权限、路由与通用框架

### 1.1 系统子路由鉴权粒度变粗（已解决）

状态：已在新前端修复。系统 Tab 访问现在按后端返回的具体系统子路径判断，`/system` 会跳到首个有权限的系统 Tab。

老前端：`/rental/auth/menuList` 返回的每个路由会动态生成，并递归校验 `meta.roles`。

新前端：只要后端菜单包含任一 `/system` 或 `/system/*`，就允许访问所有 `/system/*` 子路径，且 `System.vue` 四个 Tab 全展示。

影响：只有部门、角色等部分系统菜单权限的用户，可能直接访问用户管理、菜单管理等其它系统页。

涉及文件：

- `frontend/src/store/modules/permission.js`
- `frontend/src/stores/auth.ts`
- `frontend/src/views/System.vue`

### 1.2 菜单鉴权异常时偏向放开（已解决）

状态：已在新前端修复。后端菜单为空或无法识别时不再回退完整固定菜单，只保留固定可访问的概览入口。

老前端：后端菜单为空或过滤后为空时，不会添加对应动态路由。

新前端：`backendPaths` 为空或过滤结果为空时回退到完整 `menuConfig`。

影响：后端菜单为空、路径不识别或配置异常时，新前端可能展示并允许固定菜单入口。

涉及文件：

- `frontend/src/store/modules/permission.js`
- `frontend/src/stores/auth.ts`
- `frontend/src/utils/routeCompat.ts`

### 1.3 系统管理数据无条件预加载（已解决）

状态：已在新前端修复。系统管理数据加载已从全局布局挪到系统管理页面挂载时执行。

老前端：进入具体系统管理页面后，该页面再请求用户、部门、角色、菜单数据。

新前端：布局挂载时无条件执行 `useSystemStore().load()`，请求用户、部门、角色、权限数据。

影响：无系统管理入口的账号也会触发系统接口请求，可能出现无关错误提示或越权数据预取风险。

涉及文件：

- `frontend/src/layout/AppLayout.vue`
- `frontend/src/stores/system.ts`

### 1.4 动态菜单路由不再真正驱动前端路由（已解决）

状态：已在新前端修复。后端 `menuList` 现在驱动侧栏菜单分组、菜单顺序、可访问路径和旧路径别名；旧后端 `route_url/component` 能映射到新前端已有页面时，会生成对应菜单入口和访问权限。新前端没有实现的未知组件路径不会被强行加载。

老前端：后端菜单里的 `component` 会通过 `@/views${component}` 动态加载，数据库菜单能决定路由。

修复前新前端：路由是固定表，`routeCompat` 只识别硬编码旧路径映射和固定路径。

原影响：菜单管理里新增或修改的自定义路由字段不会生成新前端可访问页面；旧的非固定路径也不兼容。

涉及文件：

- `frontend/src/store/modules/permission.js`
- `frontend/src/router/index.ts`
- `frontend/src/utils/routeCompat.ts`

### 1.5 通用 API 封装契约不一致（已解决）

状态：已在新前端修复。`http` 封装补齐 GET params、RESTful 参数拼接、完整 `ApiResult` 返回方法和 token 失效提示；现有业务默认取 `data` 的调用保持兼容。

老前端：`requestHttp` 返回完整 `ApiResult`，页面可判断 `res.success/res.data`；支持 GET params 序列化、RESTful 参数拼接、通用 delete 参数拼接、multipart 上传、表单登录、token 失效弹窗。

新前端：`http.get/post/put/delete` 默认只返回 `data`，GET 不接收 params，没有等价 `getRestFulApi`，错误处理主要是抛异常，token 失效没有老前端统一弹窗流程。

影响：旧页面或接口不能按原契约直接迁移，部分通用能力需要在业务 API 中手写。

涉及文件：

- `frontend/src/utils/request.js`
- `frontend/src/api/http.ts`
- `frontend/src/api/backend.ts`

## 2. 系统管理

### 2.1 用户批量删除缺失（已解决）

状态：已在新前端修复。用户管理复用批量删除控件和勾选控件，按钮按 `sys:user:deleteBatch` 控制，提交前会跳过超级管理员。

老前端：用户表有勾选列和“删除选中”，按钮受 `sys:user:deleteBatch` 控制。

新前端：用户表没有勾选列，也没有批量删除入口。

影响：无法按老前端方式批量删除用户，`sys:user:deleteBatch` 前端权限码没有使用场景。

涉及文件：

- `frontend/src/views/system/user/userList.vue`
- `frontend/src/views/system/UserPanel.vue`

### 2.2 角色批量删除缺失（已解决）

状态：已在新前端修复。角色管理复用批量删除控件和勾选控件，删除前逐个调用角色用户绑定校验。

老前端：角色表支持多选并调用 `DELETE /rental/role/{ids}` 批量删除。

新前端：只提供单行删除，页面没有选择列和批量删除按钮。

影响：角色批量维护能力未迁移。

涉及文件：

- `frontend/src/views/system/role/roleList.vue`
- `frontend/src/views/system/RolePanel.vue`

### 2.3 超级管理员删除前置校验缺失（已解决）

状态：已在新前端修复。用户映射保留 `isAdmin`，单删和批量删除都会在前端拦截超级管理员。

老前端：单个删除用户前判断 `row.isAdmin === 1`，超级管理员直接拦截。

新前端：`mapUser` 未保留 `isAdmin`，删除时直接调用删除接口并立即提示成功。

影响：前端不再阻止超级管理员删除操作，且失败反馈可能滞后。

涉及文件：

- `frontend/src/views/system/user/userList.vue`
- `frontend/src/views/system/UserPanel.vue`
- `frontend/src/api/backend.ts`

### 2.4 系统用户性别编码不一致（已解决）

状态：已在新前端修复。系统用户性别按旧前端 `1=男、2=女` 映射、保存和搜索。

老前端：系统用户性别按 `1=男、2=女` 处理。

新前端：映射为 `0=女、1=男`，保存和搜索也按 `0/1` 发送。

影响：旧数据中 `gender=2` 会被新前端显示为男，新增或搜索女用户的 API 条件也与老前端契约不一致。

涉及文件：

- `frontend/src/views/system/user/userList.vue`
- `frontend/src/api/backend.ts`

### 2.5 用户所属部门选择和校验未对齐（已解决）

状态：已在新前端修复。用户表单部门来源改为完整部门树，保存前必须选择部门。

老前端：新增、编辑用户必须选择部门，选择来源是完整部门树。

新前端：只提供叶子部门下拉，默认选第一个叶子部门，保存时未校验 `deptId/deptName`。

影响：不能把用户挂到非叶子部门；无部门或误选默认部门时也可能提交。

涉及文件：

- `frontend/src/views/system/user/userList.vue`
- `frontend/src/views/system/UserPanel.vue`

### 2.6 用户绑定角色的清空和反馈行为不一致（已处理）

状态：已在新前端处理。绑定角色、用户保存和删除等流程改为等待接口成功后再提示；旧后端路径不支持空角色列表，新前端改为明确提示“至少选择一个角色”。

老前端：绑定弹窗回显角色，确认后调用绑定接口并等接口成功再提示。

新前端：空角色数组时 `store.bindRole` 不调用接口；确认绑定、用户保存、删除等多处未 `await` store 方法就提示成功。

影响：无法通过新前端明确清空用户所有角色；接口失败时可能已关闭弹窗并显示成功。

涉及文件：

- `frontend/src/views/system/user/userList.vue`
- `frontend/src/views/system/UserPanel.vue`
- `frontend/src/stores/system.ts`

### 2.7 用户分页大小不一致（已解决）

状态：已在新前端修复。用户管理每页改为 `5` 条。

老前端：用户管理每页 `5` 条。

新前端：用户管理每页 `10` 条。

影响：分页页数、接口分页参数和老前端展示结果不一致。

涉及文件：

- `frontend/src/views/system/user/userList.vue`
- `frontend/src/views/system/UserPanel.vue`

### 2.8 部门树展示只支持固定两层（已解决）

状态：已在新前端修复。部门管理现在递归展示任意层级，搜索结果不是完整根树时也按返回节点展示。

老前端：`el-table` 树表直接渲染后端返回的任意层级 `children`。

新前端：把 `deptTree[0]` 当根，只渲染 `root.children` 和每个公司的直接 `children`。

影响：三层以上部门不可见或不可操作；部门搜索返回非完整根树时，页面可能误把第一条结果当根。

涉及文件：

- `frontend/src/views/system/dept/deptList.vue`
- `frontend/src/views/system/DeptPanel.vue`

### 2.9 角色权限分配树未使用接口返回的可分配树（已解决）

状态：已在新前端修复。打开权限分配时使用 `/rental/role/permissionTrees` 返回的 `permissionList` 渲染权限树。

老前端：打开权限分配时使用 `/rental/role/permissionTrees` 返回的 `permissionList` 和 `checkedList`。

新前端：接口也取了 `permissionList`，但页面树实际绑定的是全量 `store.permissions`。

影响：权限分配范围可能大于老前端，当前用户不应分配的权限也可能出现在树里。

涉及文件：

- `frontend/src/views/system/role/roleList.vue`
- `frontend/src/views/system/RolePanel.vue`
- `frontend/src/api/backend.ts`

### 2.10 菜单/权限字段与前置校验未对齐（已解决）

状态：已在新前端修复。列表补充上级菜单，表单校验上级菜单、菜单名称、菜单类型和权限标识，按钮类型不再显示或提交组件路径。

老前端：列表显示“上级菜单”；表单要求上级菜单、菜单名称、菜单类型、权限标识；按钮类型不显示组件路径。

新前端：列表不显示上级菜单；保存只校验菜单名称；权限标识可为空；按钮类型仍显示并提交组件路径。

影响：可保存老前端会拦截的菜单或按钮权限数据，后续按钮权限码和菜单层级排查更困难。

涉及文件：

- `frontend/src/views/system/permission/perr.vue`
- `frontend/src/views/system/MenuPanel.vue`

## 3. 基础资料与车辆信息

### 3.1 基础资料列表缺少服务端分页（已处理）

状态：已在新前端处理。车辆、出租类型、客户、违章、保养等高频列表已接服务端分页和浮动分页控件；厂商品牌保持新前端卡片式布局，查询和批量维护能力已补齐。

老前端：厂商、品牌、出租类型、车辆信息都用 `start/size + 查询条件` 请求服务端分页，并显示总数和翻页。

新前端：多处一次拉取全量或 `size=999`，页面内本地过滤，相关页面没有分页控件。

影响：数据量超过默认拉取上限时不可达；筛选、总数与服务端真实分页不一致。

涉及文件：

- `frontend/src/views/auto/maker/makerList.vue`
- `frontend/src/views/auto/brand/brandList.vue`
- `frontend/src/views/auto/rentalType/rentalTypeList.vue`
- `frontend/src/views/auto/info/autoInfoList.vue`
- `frontend/src/views/MakerBrand.vue`
- `frontend/src/views/RentalType.vue`
- `frontend/src/views/CarInfo.vue`
- `frontend/src/api/backend.ts`

### 3.2 品牌管理不能按旧版方式跨厂商查询（已解决）

状态：已在新前端修复。品牌区支持全部厂商/指定厂商查询，并在品牌卡片显示所属厂商。

老前端：品牌页有“厂商名称 + 品牌名称”查询表单，厂商可不选，表格展示所有品牌及厂商名称。

新前端：品牌区绑定当前选中的厂商，只搜索当前厂商下品牌；没有“全部厂商”品牌表格视图。

影响：无法在一个品牌列表中跨厂商查找或核对品牌，重复品牌名时也缺少旧版表格上下文。

涉及文件：

- `frontend/src/views/auto/brand/brandList.vue`
- `frontend/src/views/MakerBrand.vue`
- `frontend/src/stores/maker.ts`

### 3.3 厂商、品牌批量删除入口缺失（已解决）

状态：已在新前端修复。厂商和品牌均复用批量删除控件与勾选控件。

老前端：厂商和品牌表格都有勾选列与批量删除按钮。

新前端：厂商品牌页只有单项删除；store 有 `removeManyMakers/removeManyBrands`，但 UI 没有选择模式或批量按钮。

影响：批量清理厂商、品牌的旧工作流不可用。

涉及文件：

- `frontend/src/views/auto/maker/makerList.vue`
- `frontend/src/views/auto/brand/brandList.vue`
- `frontend/src/views/MakerBrand.vue`
- `frontend/src/stores/maker.ts`

### 3.4 车辆查询的厂商-品牌联动未对齐（已解决）

状态：已在新前端修复。车辆查询改为厂商 ID、品牌 ID 联动并交给服务端查询。

老前端：车辆查询先选厂商 `makerId`，品牌下拉按厂商请求 `/rental/autoBrand/maker/{makerId}`，查询提交 `brandId`。

新前端：查询区厂商选择的是厂商名称，品牌是自由文本输入，不随厂商联动，也不提交 `brandId` 给服务端查询。

影响：不能精确按厂商下品牌筛选；同名品牌、部分匹配、本地数据不全时结果不可靠。

涉及文件：

- `frontend/src/views/auto/info/autoInfoList.vue`
- `frontend/src/views/CarInfo.vue`
- `frontend/src/api/backend.ts`

### 3.5 车辆新增/编辑保存厂商、品牌字段错位（已解决）

状态：已在新前端修复。车辆表单改为选择 `makerId/brandId`，并同步展示名称后保存。

老前端：车辆表单保存 `makerId`、`brandId`，品牌下拉随厂商 ID 联动。

新前端：抽屉里选择的是 `makerName`、`brandName`；保存转换仍发送 `makerId`、`brandId`，新增时这两个 ID 不会被设置，编辑时改厂商/品牌也可能保留旧 ID。

影响：新增车辆可能缺少厂商/品牌关联；编辑车辆可能保存成“显示名称变了但后端 ID 没变”。

涉及文件：

- `frontend/src/views/auto/info/autoInfoList.vue`
- `frontend/src/views/CarInfo.vue`
- `frontend/src/api/backend.ts`

### 3.6 车辆图片上传和预览缺失（已解决）

状态：已在新前端修复。车辆表格显示图片，表单接入 `/rental/oss/upload`，上传结果写入车辆图片字段。

老前端：表格显示车辆图片并支持预览；表单用 `el-upload` 上传到 `/rental/oss/upload`，带 token，并校验 JPG/PNG、2MB。

新前端：表格只显示车辆图标占位；抽屉里是静态“点击上传车辆照片”区域，没有上传控件，也没有把上传结果写入 `image/pic`。

影响：用户无法查看、上传或替换车辆图片。

涉及文件：

- `frontend/src/views/auto/info/autoInfoList.vue`
- `frontend/src/views/CarInfo.vue`
- `frontend/src/api/http.ts`

### 3.7 车辆状态字段未完整对齐（已解决）

状态：已在新前端修复。车辆筛选和表单补齐“自用”，状态文案按旧前端语义显示。

老前端：查询和表单都有 4 个状态：未租、已租、维保、自用；车辆表单可创建或修改状态。

新前端：筛选只有空闲、出租中、保养中，缺少自用；新增默认 `idle`，抽屉没有状态字段；状态文案也从“已租/维保”变成“出租中/保养中”。

影响：不能在车辆信息页筛选自用车，也不能新增或修改车辆状态；显示文案与旧前端不一致。

涉及文件：

- `frontend/src/views/auto/info/autoInfoList.vue`
- `frontend/src/views/CarInfo.vue`
- `frontend/src/utils/dict.ts`

### 3.8 车辆表单字段控件和校验弱化（已解决）

状态：已在新前端修复。车辆类型改为固定三项，排量单位拆分，里程/租金/押金改为非负数字控件，上牌日期改为日期选择器并补保存校验。

老前端：车辆类型固定三项；排量和排量单位分开录入；里程、租金、押金用非负数字控件；上牌日期用日期选择器；必填项有表单校验。

新前端：车辆类型来自当前列表去重；排量是文本框且没有排量单位控件，新增默认 `T`；上牌日期是普通文本框；保存前基本没有必填或范围校验。

影响：空值、非法日期、负数或错误单位更容易提交；新增车辆在空列表或缺少某类型时无法选择旧版固定类型。

涉及文件：

- `frontend/src/views/auto/info/autoInfoList.vue`
- `frontend/src/views/CarInfo.vue`

### 3.9 出租类型折扣字段语义和范围校验未对齐（已解决）

状态：已在新前端修复。出租类型折扣按 `0~1` 小数录入、筛选和校验。

老前端：折扣按 `0~1` 小数录入和筛选，使用 `el-input-number` 限制范围，新增默认 `typeDiscount: 1`。

新前端：页面显示、录入百分比，保存时再除以 100；筛选和编辑都是普通输入，没有范围校验，也没有必填校验。

影响：旧数据口径和新 UI 口径不一致，用户可提交负数、超过 100 或空折扣。

涉及文件：

- `frontend/src/views/auto/rentalType/rentalTypeList.vue`
- `frontend/src/views/RentalType.vue`
- `frontend/src/api/backend.ts`

## 4. 出租与客户

### 4.1 汽车出租列表查询/分页未对齐（已解决）

状态：已在新前端修复。汽车出租页用 `status=0` 和筛选条件请求服务端分页，并接入浮动分页控件。

老前端：用 `status: 0` 加筛选条件调用 `/rental/autoInfo/{start}/{size}`，每页 5 条，支持厂商、品牌、车牌、类型、租金区间、上牌日期范围。

新前端：应用启动时拉 `/rental/autoInfo/1/999`，出租页本地过滤 `idle` 车辆；无分页；日期范围字段在 `CarRent.vue` 中未参与过滤。

影响：大数据量会漏数据，查询结果和旧版服务端分页语义不一致。

涉及文件：

- `frontend/src/views/busi/rental/rentalList.vue`
- `frontend/src/views/CarRent.vue`
- `frontend/src/stores/car.ts`
- `frontend/src/api/backend.ts`

### 4.2 出租订单 payload 的可编辑字段降级（已解决）

状态：已在新前端修复。出租弹窗补起租里程、日租金额、押金编辑，并按表单值提交订单。

老前端：出租前可修改 `mileage`、`rent`、`deposit`，提交订单时把这些值写入 `saveOrder`。

新前端：出租弹窗不再提供起租里程、日租金额、押金编辑，payload 固定取车辆档案的 `selectedCar.mileage/dayRent/deposit`。

影响：无法按实际出租场景调整订单金额、押金和起租里程。

涉及文件：

- `frontend/src/views/busi/rental/rentalList.vue`
- `frontend/src/views/CarRent.vue`
- `frontend/src/stores/order.ts`

### 4.3 老客户电话回填未对齐（已解决）

状态：已在新前端修复。出租弹窗联系电话失焦后调用 `/rental/customer/tel` 回填老客户信息，提交时也优先按该接口查找客户。

老前端：电话变化时调用 `/rental/customer/tel`，找到老客户后立即回填姓名、身份证、年龄、性别、生日，并用 `isSaveCustomer` 决定是否新增客户。

新前端：没有电话变化回填；提交时只从本地已加载客户列表按手机号查找，`api.customers.byPhone` 已封装但未在出租流程使用。

影响：老客户信息不自动回填；本地列表未覆盖时可能重复新增客户。

涉及文件：

- `frontend/src/views/busi/rental/rentalList.vue`
- `frontend/src/api/customer.js`
- `frontend/src/views/CarRent.vue`
- `frontend/src/api/backend.ts`

### 4.4 客户管理未走旧版服务端分页查询（已解决）

状态：已在新前端修复。客户管理查询改为服务端分页，并接入浮动分页控件。

老前端：调用 `/rental/customer/{start}/{size}`，提交 `name/tel/idNum/lowAge/highAge/gender`，每页 5 条。

新前端：客户页基于 `store.list` 本地过滤；`store.load()` 默认拉 `/rental/customer/1/999`；页面无分页控件。

影响：客户查询、总数、分页与旧版不一致，超过 999 条会漏。

涉及文件：

- `frontend/src/views/busi/customer/customerList.vue`
- `frontend/src/views/Customer.vue`
- `frontend/src/stores/customer.ts`
- `frontend/src/api/backend.ts`

### 4.5 客户表单校验未对齐（已解决）

状态：已在新前端修复。客户姓名、联系电话、身份证必填，手机号和身份证格式校验，年龄/性别/生日由身份证推算后只读。

老前端：客户姓名、身份证、联系电话必填；身份证 18 位；手机号匹配 `^1[3-9]\d{9}$`；年龄、性别、生日由身份证推算并只读。

新前端：保存时只校验姓名和电话非空；身份证可空；手机号无格式校验；年龄、性别、生日可手动改。

影响：新前端可提交旧前端会拦截的客户数据。

涉及文件：

- `frontend/src/views/busi/customer/customerList.vue`
- `frontend/src/views/Customer.vue`

## 5. 订单、违章与保养

### 5.1 归还更新 payload 字段不完全等同旧前端（已解决）

状态：已在新前端修复。归还更新 payload 在核心结算字段外补传车牌、客户姓名、客户电话、出租类型、折扣等旧前端随行字段。

老前端：车辆归还时直接 `PUT /rental/order` 提交完整 `saveOrder`，包含订单原字段、展示字段和 `rentPayable/rentActual`。

新前端：`orderToApi` 只映射 `orderNum/autoId/customerId/typeId/rent/deposit/mileage/returnTime/returnMileage/rentPayable/rentActual/depositReturn`，不再带 `autoNum/customerName/customerTel/typeName/typeDiscount` 等旧对象随行字段。

影响：归还核心金额字段已映射，但请求体字段集合和旧前端不完全一致。

涉及文件：

- `frontend/src/views/busi/rental/returnList.vue`
- `frontend/src/stores/order.ts`
- `frontend/src/api/backend.ts`

### 5.2 违章列表缺少服务端分页（已解决）

状态：已在新前端修复。违章列表查询传分页参数，并接入浮动分页控件。

老前端：调用 `/rental/violation/{start}/{size}`，每页 5 条，并提交罚款区间、违章时间范围、状态等条件。

新前端：会把筛选条件发给后端，但未传分页参数；适配层默认 `/rental/violation/1/999`，页面无分页控件。

影响：筛选基本可用，但分页和总量行为仍不等同旧版，超过 999 条会漏。

涉及文件：

- `frontend/src/views/busi/violation/violationList.vue`
- `frontend/src/views/Violation.vue`
- `frontend/src/stores/violation.ts`
- `frontend/src/api/backend.ts`

### 5.3 违章编辑时车辆存在校验缺失（已解决）

状态：已在新前端修复。新增和编辑保存前都会调用车辆存在校验。

老前端：新增和编辑共用车牌输入，失焦都会调用 `/rental/autoInfo/exist`，不存在则禁用保存。

新前端：只在新增违章时校验车牌；编辑已有违章时可改成不存在的车牌并提交。

影响：编辑路径可提交旧前端会拦截的违章记录。

涉及文件：

- `frontend/src/views/busi/violation/violationList.vue`
- `frontend/src/views/Violation.vue`

### 5.4 车辆保养查询/分页未对齐（已解决）

状态：已在新前端修复。保养列表查询传车牌、项目、地点、费用区间、保养时间范围和分页参数，并接入浮动分页控件。

老前端：调用 `/rental/maintain/{start}/{size}`，提交车牌、项目、地点、费用区间、保养时间范围。

新前端：保养页本地过滤 `store.list`；`store.load()` 固定拉 `/rental/maintain/1/999`；适配层 `maintainSearchToApi` 也未映射费用区间和时间范围。

影响：服务端查询能力未用，分页缺失，费用/时间范围只对已加载数据生效。

涉及文件：

- `frontend/src/views/busi/maintain/maintainList.vue`
- `frontend/src/views/Maintain.vue`
- `frontend/src/stores/maintain.ts`
- `frontend/src/api/backend.ts`

### 5.5 保养状态/完成操作不是旧前端行为（已解决）

状态：已在新前端修复。保养页面移除状态列、状态表单字段和“完成保养”动作，保留旧前端已有的新增、编辑、删除流程。

老前端：保养记录只有新增、编辑、删除，没有 `pending/done` 状态和“完成保养”动作。

新前端：页面新增了状态列和完成按钮，但 `mapMaintain` 始终把后端记录映射为 `done`，`finish()` 只是再次 update 当前记录。

影响：保养状态统计和完成按钮语义不稳定，也不是旧版已有业务流程。

涉及文件：

- `frontend/src/views/busi/maintain/maintainList.vue`
- `frontend/src/views/Maintain.vue`
- `frontend/src/stores/maintain.ts`
- `frontend/src/api/backend.ts`

## 6. 财务、首页与通用工具

### 6.1 财务图表工具箱缺失（已解决）

状态：已在新前端修复。日报、月报出租和归还图表补回 ECharts 原生 toolbox，支持线/柱切换、还原、保存图片。

老前端：日报、月报出租和归还图表都提供 ECharts toolbox：线/柱切换、还原、保存图片。

新前端：`FinanceReport.vue` 只绘制折线图，没有 toolbox。

影响：报表图表导出图片、切换图表类型、恢复配置等旧交互丢失。

涉及文件：

- `frontend/src/views/finance/dayReport.vue`
- `frontend/src/views/finance/monthReport.vue`
- `frontend/src/views/FinanceReport.vue`

### 6.2 Dashboard 角色首页未对齐（已解决）

状态：已在新前端修复。Dashboard 按当前账号是否 admin 分流；非 admin 只显示业务人员身份首页和可访问功能，不再展示 admin 运营统计、营收趋势、车队状态、租约和待办。

老前端：`Dashboard` 根据 `roles.includes('admin')` 切换 admin/editor 两套首页；非 admin 进入 `editorDashboard`。

新前端：非 admin 只多显示一个账号卡片，其余统计卡、营收趋势、车队状态、租约、待办仍与 admin 共用。

影响：业务人员看到的首页能力和信息范围与老前端不同。

涉及文件：

- `frontend/src/views/dashboard/index.vue`
- `frontend/src/views/dashboard/admin/index.vue`
- `frontend/src/views/dashboard/editor/index.vue`
- `frontend/src/views/Dashboard.vue`

### 6.3 Dashboard 引入非旧契约接口（已解决）

状态：已在新前端修复。Dashboard 不再优先请求 `/rental/dashboard/overview`，改为直接聚合旧后端已有业务接口生成首页数据。

老前端：Dashboard 未使用 `/rental/dashboard/overview`。

新前端：`api.dashboard.overview()` 优先请求 `/rental/dashboard/overview`，失败后再 fallback 聚合旧业务接口。

影响：新前端对旧后端会产生额外失败请求，Dashboard 数据契约变成“新 overview 或 fallback 聚合”，与老前端契约不一致。

涉及文件：

- `frontend/src/api/backend.ts`
- `frontend/src/stores/dashboard.ts`

### 6.4 Excel/PDF/Zip 导入导出与打印能力缺失（已处理）

状态：已在新前端处理。在不新增依赖、不联网的约束下，补充通用工具页并接入旧路径：Excel 全量/选中/合并表头导出使用浏览器生成 `.xls` HTML 表格文件，上传解析支持 CSV/TSV 文本表格预览，PDF 使用 `window.print()`，Zip 入口提供本地文本包导出兼容。

老前端：提供 Excel 全量导出、选中导出、合并表头导出、Excel 上传解析预览、Zip 导出、PDF `window.print()` 下载。

新前端：源码和依赖中没有 `xlsx`、`file-saver`、`jszip`，也没有对应路由或组件。

影响：旧前端通用导入、导出、打印工具页不可用。

涉及文件：

- `frontend/src/router/index.js`
- `frontend/src/views/excel/export-excel.vue`
- `frontend/src/views/excel/upload-excel.vue`
- `frontend/src/views/pdf/download.vue`
- `frontend/src/views/zip/index.vue`
- `frontend/package.json`
