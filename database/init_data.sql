-- ============================================================
-- 车辆租赁管理系统 数据库重建脚本
-- 清空全部业务/权限表，插入真实感模拟数据
-- 所有用户密码统一为 041009 (BCrypt strength=6)
-- ============================================================
USE car_rental_system;

SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE sys_dept;
TRUNCATE sys_role;
TRUNCATE sys_permission;
TRUNCATE sys_role_permission;
TRUNCATE sys_user;
TRUNCATE sys_user_role;
TRUNCATE auto_maker;
TRUNCATE auto_brand;
TRUNCATE auto_info;
TRUNCATE busi_rental_type;
TRUNCATE busi_customer;
TRUNCATE busi_order;
TRUNCATE busi_maintain;
TRUNCATE busi_violation;

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================
-- 1. 部门 sys_dept （租车公司组织架构）
-- ============================================================
INSERT INTO sys_dept (id, dept_name, phone, address, pid, parent_name, order_num, deleted) VALUES
(1, '宇通汽车租赁有限公司', '021-68881000', '上海市浦东新区世纪大道100号', 0, NULL, 1, 0),
(2, '综合管理部', '021-68881001', '上海市浦东新区世纪大道100号A座3楼', 1, '宇通汽车租赁有限公司', 2, 0),
(3, '运营部',     '021-68881002', '上海市浦东新区世纪大道100号A座5楼', 1, '宇通汽车租赁有限公司', 3, 0),
(4, '财务部',     '021-68881003', '上海市浦东新区世纪大道100号A座6楼', 1, '宇通汽车租赁有限公司', 4, 0),
(5, '车辆维保部', '021-68881004', '上海市浦东新区龙东大道3000号维保中心', 1, '宇通汽车租赁有限公司', 5, 0),
(6, '客户服务部', '021-68881005', '上海市浦东新区世纪大道100号A座2楼', 1, '宇通汽车租赁有限公司', 6, 0);

-- ============================================================
-- 2. 角色 sys_role
-- ============================================================
INSERT INTO sys_role (id, role_code, role_name, creater_id, create_time, update_time, remark, deleted) VALUES
(1, 'ROLE_ADMIN',      '系统管理员', 1, NOW(), NOW(), '系统超级管理员，拥有全部权限',           0),
(2, 'ROLE_OPERATOR',   '运营专员',   1, NOW(), NOW(), '负责车辆出租、归还及订单管理',           0),
(3, 'ROLE_FINANCE',    '财务专员',   1, NOW(), NOW(), '负责财务统计、报表与押金核算',           0),
(4, 'ROLE_MAINTAINER', '维保专员',   1, NOW(), NOW(), '负责车辆保养与违章处理',                 0),
(5, 'ROLE_SERVICE',    '客服专员',   1, NOW(), NOW(), '负责客户信息管理与黑白名单维护',         0);

-- ============================================================
-- 3. 权限菜单 sys_permission
--    type: 0根目录 1子菜单 2按钮
--    根目录 component=Layout(前端处理)，子菜单 route_url 指向真实 vue 文件
-- ============================================================
-- ---------- 权限管理 (根 id=1) ----------
INSERT INTO sys_permission (id, permission_lable, pid, parent_label, permission_code, route_path, route_name, route_url, permission_type, icon, order_num, create_time, update_time, remark, deleted) VALUES
(1,  '权限管理', 0, NULL, 'sys:manager', '/system', 'system', '/system/system', 0, 'lock', 1, NOW(), NOW(), NULL, 0),
(2,  '用户管理', 1, '权限管理', 'sys:user',       '/userList',   'userList',   '/system/user/userList',         1, 'user',      1, NOW(), NOW(), NULL, 0),
(3,  '部门管理', 1, '权限管理', 'sys:dept',       '/deptList',   'deptList',   '/system/dept/deptList',         1, 'tree',      2, NOW(), NOW(), NULL, 0),
(4,  '角色管理', 1, '权限管理', 'sys:role',       '/roleList',   'roleList',   '/system/role/roleList',         1, 'peoples',   3, NOW(), NOW(), NULL, 0),
(5,  '菜单管理', 1, '权限管理', 'sys:permission', '/permission', 'permission', '/system/permission/perr',       1, 'list',      4, NOW(), NOW(), NULL, 0),
-- 用户管理按钮
(6,  '新增',     2, '用户管理', 'sys:user:add',         NULL, NULL, NULL, 2, NULL, 1, NOW(), NOW(), NULL, 0),
(7,  '修改',     2, '用户管理', 'sys:user:edit',        NULL, NULL, NULL, 2, NULL, 2, NOW(), NOW(), NULL, 0),
(8,  '删除',     2, '用户管理', 'sys:user:delete',      NULL, NULL, NULL, 2, NULL, 3, NOW(), NOW(), NULL, 0),
(9,  '查询',     2, '用户管理', 'sys:user:select',      NULL, NULL, NULL, 2, NULL, 4, NOW(), NOW(), NULL, 0),
(10, '删除选中', 2, '用户管理', 'sys:user:deleteBatch', NULL, NULL, NULL, 2, NULL, 5, NOW(), NOW(), NULL, 0),
-- 部门管理按钮
(11, '新增', 2, '部门管理', 'sys:dept:add',    NULL, NULL, NULL, 2, NULL, 1, NOW(), NOW(), NULL, 0),
(12, '修改', 2, '部门管理', 'sys:dept:edit',   NULL, NULL, NULL, 2, NULL, 2, NOW(), NOW(), NULL, 0),
(13, '删除', 2, '部门管理', 'sys:dept:delete', NULL, NULL, NULL, 2, NULL, 3, NOW(), NOW(), NULL, 0),
(14, '查询', 2, '部门管理', 'sys:dept:select', NULL, NULL, NULL, 2, NULL, 4, NOW(), NOW(), NULL, 0),
-- 角色管理按钮 (新增码=sys:role:save，与后端 @PreAuthorize 对齐)
(15, '新增',     2, '角色管理', 'sys:role:save',   NULL, NULL, NULL, 2, NULL, 1, NOW(), NOW(), NULL, 0),
(16, '修改',     2, '角色管理', 'sys:role:edit',   NULL, NULL, NULL, 2, NULL, 2, NOW(), NOW(), NULL, 0),
(17, '删除',     2, '角色管理', 'sys:role:delete', NULL, NULL, NULL, 2, NULL, 3, NOW(), NOW(), NULL, 0),
(18, '查询',     2, '角色管理', 'sys:role:select', NULL, NULL, NULL, 2, NULL, 4, NOW(), NOW(), NULL, 0),
-- 菜单管理按钮
(19, '新增', 2, '菜单管理', 'sys:permission:add',    NULL, NULL, NULL, 2, NULL, 1, NOW(), NOW(), NULL, 0),
(20, '修改', 2, '菜单管理', 'sys:permission:edit',   NULL, NULL, NULL, 2, NULL, 2, NOW(), NOW(), NULL, 0),
(21, '删除', 2, '菜单管理', 'sys:permission:delete', NULL, NULL, NULL, 2, NULL, 3, NOW(), NOW(), NULL, 0),
(22, '查询', 2, '菜单管理', 'sys:permission:select', NULL, NULL, NULL, 2, NULL, 4, NOW(), NOW(), NULL, 0);

-- ---------- 数据初始 (根 id=30) ----------
INSERT INTO sys_permission (id, permission_lable, pid, parent_label, permission_code, route_path, route_name, route_url, permission_type, icon, order_num, create_time, update_time, remark, deleted) VALUES
(30, '数据初始', 0, NULL, 'auto:manager', '/auto', 'auto', '/auto/auto', 0, 'component', 2, NOW(), NOW(), NULL, 0),
(31, '车辆厂商', 30, '数据初始', 'auto:maker',      '/makerList',      'makerList',      '/auto/maker/makerList',           1, 'guide', 1, NOW(), NOW(), NULL, 0),
(32, '车辆品牌', 30, '数据初始', 'auto:brand',      '/brandList',      'brandList',      '/auto/brand/brandList',           1, 'tab',   2, NOW(), NOW(), NULL, 0),
(33, '出租类型', 30, '数据初始', 'auto:rentalType', '/rentalTypeList', 'rentalTypeList', '/auto/rentalType/rentalTypeList', 1, 'form',  3, NOW(), NOW(), NULL, 0),
-- 车辆厂商按钮
(34, '新增', 2, '车辆厂商', 'auto:maker:add',    NULL, NULL, NULL, 2, NULL, 1, NOW(), NOW(), NULL, 0),
(35, '修改', 2, '车辆厂商', 'auto:maker:edit',   NULL, NULL, NULL, 2, NULL, 2, NOW(), NOW(), NULL, 0),
(36, '删除', 2, '车辆厂商', 'auto:maker:delete', NULL, NULL, NULL, 2, NULL, 3, NOW(), NOW(), NULL, 0),
(37, '查询', 2, '车辆厂商', 'auto:maker:select', NULL, NULL, NULL, 2, NULL, 4, NOW(), NOW(), NULL, 0),
-- 车辆品牌按钮
(38, '新增', 2, '车辆品牌', 'auto:brand:add',    NULL, NULL, NULL, 2, NULL, 1, NOW(), NOW(), NULL, 0),
(39, '修改', 2, '车辆品牌', 'auto:brand:edit',   NULL, NULL, NULL, 2, NULL, 2, NOW(), NOW(), NULL, 0),
(40, '删除', 2, '车辆品牌', 'auto:brand:delete', NULL, NULL, NULL, 2, NULL, 3, NOW(), NOW(), NULL, 0),
(41, '查询', 2, '车辆品牌', 'auto:brand:select', NULL, NULL, NULL, 2, NULL, 4, NOW(), NOW(), NULL, 0),
-- 出租类型按钮
(42, '新增', 2, '出租类型', 'auto:rentalType:add',    NULL, NULL, NULL, 2, NULL, 1, NOW(), NOW(), NULL, 0),
(43, '修改', 2, '出租类型', 'auto:rentalType:edit',   NULL, NULL, NULL, 2, NULL, 2, NOW(), NOW(), NULL, 0),
(44, '删除', 2, '出租类型', 'auto:rentalType:delete', NULL, NULL, NULL, 2, NULL, 3, NOW(), NOW(), NULL, 0),
(45, '查询', 2, '出租类型', 'auto:rentalType:select', NULL, NULL, NULL, 2, NULL, 4, NOW(), NOW(), NULL, 0);

-- ---------- 日常业务 (根 id=60) ----------
INSERT INTO sys_permission (id, permission_lable, pid, parent_label, permission_code, route_path, route_name, route_url, permission_type, icon, order_num, create_time, update_time, remark, deleted) VALUES
(60, '日常业务', 0, NULL, 'busi:manager', '/busi', 'busi', '/busi/busi', 0, 'shopping', 3, NOW(), NOW(), NULL, 0),
(61, '汽车出租', 60, '日常业务', 'busi:rental', '/rentalList', 'rentalList', '/busi/rental/rentalList', 1, 'money', 1, NOW(), NOW(), NULL, 0),
-- 汽车出租按钮
(62, '出租', 2, '汽车出租', 'busi:rental:rent',   NULL, NULL, NULL, 2, NULL, 1, NOW(), NOW(), NULL, 0),
(63, '归还', 2, '汽车出租', 'busi:rental:return', NULL, NULL, NULL, 2, NULL, 2, NOW(), NOW(), NULL, 0);

-- ============================================================
-- 4. 用户 sys_user （真实人名，密码统一 041009）
--    gender: 1男 2女   is_admin: 1是 0否
-- ============================================================
INSERT INTO sys_user (id, username, password, is_account_non_expired, is_account_non_locked, is_credentials_non_expired, is_enabled, realname, nickname, dept_id, dept_name, gender, phone, email, avatar, is_admin, create_time, update_time, deleted) VALUES
(1, 'admin',    '$2a$06$rtw5tHzBKCupQnTEcXeHYOLWDmo5NpP2qYAmooCeZX9argF8EuUwa', 1,1,1,1, '王建国', '老王',   2, '综合管理部', 1, '13801380001', 'wangjianguo@yutong-rental.com', 'https://wpimg.wallstcn.com/f778738c-e4f8-4870-b634-56703b4acafe.gif', 1, NOW(), NOW(), 0),
(2, 'liyun',    '$2a$06$rtw5tHzBKCupQnTEcXeHYOLWDmo5NpP2qYAmooCeZX9argF8EuUwa', 1,1,1,1, '李芸',   '芸芸',   3, '运营部',     2, '13801380002', 'liyun@yutong-rental.com',       'https://wpimg.wallstcn.com/f778738c-e4f8-4870-b634-56703b4acafe.gif', 0, NOW(), NOW(), 0),
(3, 'zhaominghui','$2a$06$rtw5tHzBKCupQnTEcXeHYOLWDmo5NpP2qYAmooCeZX9argF8EuUwa', 1,1,1,1, '赵明辉', '老赵',   4, '财务部',     1, '13801380003', 'zhaominghui@yutong-rental.com', 'https://wpimg.wallstcn.com/f778738c-e4f8-4870-b634-56703b4acafe.gif', 0, NOW(), NOW(), 0),
(4, 'chenqiang','$2a$06$rtw5tHzBKCupQnTEcXeHYOLWDmo5NpP2qYAmooCeZX9argF8EuUwa', 1,1,1,1, '陈强',   '强哥',   5, '车辆维保部', 1, '13801380004', 'chenqiang@yutong-rental.com',   'https://wpimg.wallstcn.com/f778738c-e4f8-4870-b634-56703b4acafe.gif', 0, NOW(), NOW(), 0),
(5, 'sunjiao',  '$2a$06$rtw5tHzBKCupQnTEcXeHYOLWDmo5NpP2qYAmooCeZX9argF8EuUwa', 1,1,1,1, '孙娇',   '小孙',   6, '客户服务部', 2, '13801380005', 'sunjiao@yutong-rental.com',     'https://wpimg.wallstcn.com/f778738c-e4f8-4870-b634-56703b4acafe.gif', 0, NOW(), NOW(), 0);

-- ============================================================
-- 5. 用户-角色 sys_user_role
-- ============================================================
INSERT INTO sys_user_role (user_id, role_id) VALUES
(1, 1),  -- 王建国 - 系统管理员
(2, 2),  -- 李芸   - 运营专员
(3, 3),  -- 赵明辉 - 财务专员
(4, 4),  -- 陈强   - 维保专员
(5, 5);  -- 孙娇   - 客服专员

-- ============================================================
-- 6. 角色-权限 sys_role_permission
-- ============================================================
-- 系统管理员(role 1)：拥有全部权限
INSERT INTO sys_role_permission (role_id, permission_id)
SELECT 1, id FROM sys_permission;

-- 运营专员(role 2)：日常业务 + 数据初始查看
INSERT INTO sys_role_permission (role_id, permission_id) VALUES
(2,60),(2,61),(2,62),(2,63),
(2,30),(2,31),(2,37),(2,32),(2,41),(2,33),(2,45);

-- 财务专员(role 3)：日常业务查看
INSERT INTO sys_role_permission (role_id, permission_id) VALUES
(3,60),(3,61),
(3,30),(3,33),(3,45);

-- 维保专员(role 4)：数据初始(车辆相关)
INSERT INTO sys_role_permission (role_id, permission_id) VALUES
(4,30),(4,31),(4,37),(4,32),(4,41);

-- 客服专员(role 5)：日常业务 + 权限管理中的用户查看
INSERT INTO sys_role_permission (role_id, permission_id) VALUES
(5,60),(5,61),(5,62),(5,63);

-- ============================================================
-- 7. 车辆厂商 auto_maker
-- ============================================================
INSERT INTO auto_maker (id, name, order_letter, deleted) VALUES
(1, '一汽大众',   'YQDZ', 0),
(2, '上汽大众',   'SQDZ', 0),
(3, '上汽通用别克','SQTYBK', 0),
(4, '广汽丰田',   'GQFT', 0),
(5, '东风日产',   'DFRC', 0),
(6, '华晨宝马',   'HCBM', 0),
(7, '北京奔驰',   'BJBC', 0),
(8, '比亚迪',     'BYD',  0),
(9, '特斯拉',     'TSL',  0);

-- ============================================================
-- 8. 车辆品牌 auto_brand (mid 关联厂商)
-- ============================================================
INSERT INTO auto_brand (id, mid, brand_name, deleted) VALUES
(1,  1, '迈腾',    0),
(2,  1, '速腾',    0),
(3,  1, '宝来',    0),
(4,  2, '帕萨特',  0),
(5,  2, '朗逸',    0),
(6,  2, '途观L',   0),
(7,  3, '君威',    0),
(8,  3, '昂科威',  0),
(9,  4, '凯美瑞',  0),
(10, 4, '汉兰达',  0),
(11, 4, '雷凌',    0),
(12, 5, '轩逸',    0),
(13, 5, '天籁',    0),
(14, 6, '宝马3系', 0),
(15, 6, '宝马5系', 0),
(16, 7, '奔驰C级', 0),
(17, 7, '奔驰E级', 0),
(18, 8, '汉EV',    0),
(19, 8, '宋PLUS',  0),
(20, 9, 'Model 3', 0),
(21, 9, 'Model Y', 0);

-- ============================================================
-- 9. 出租类型 busi_rental_type
-- ============================================================
INSERT INTO busi_rental_type (id, type_name, type_discount, remark, create_time, update_time, deleted) VALUES
(1, '日租',     1.00, '按日计费，不享受折扣',       NOW(), NOW(), 0),
(2, '周租',     0.90, '连续租满7天，享受9折优惠',   NOW(), NOW(), 0),
(3, '月租',     0.80, '连续租满30天，享受8折优惠',  NOW(), NOW(), 0),
(4, 'VIP会员',  0.75, 'VIP会员专享7.5折',           NOW(), NOW(), 0),
(5, '企业长租', 0.70, '企业客户长期合作专享7折',     NOW(), NOW(), 0);

-- ============================================================
-- 10. 车辆信息 auto_info
--     info_type:0燃油 1电动 2混动  status:0未租 1已租 2维保 3自用
-- ============================================================
INSERT INTO auto_info (id, auto_num, maker_id, brand_id, info_type, color, displacement, unit, mileage, rent, registration_date, pic, deposit, status, create_time, update_time, expected_num, actual_num, deleted) VALUES
(1,  '沪A8K231', 1, 1, 0, '星空灰', 2.0, 'L',  42000, 320, '2022-04-15', 'https://wpimg.wallstcn.com/f778738c-e4f8-4870-b634-56703b4acafe.gif', 5000,  0, NOW(), NOW(), 8,  6, 0),
(2,  '沪A8K232', 2, 4, 0, '珍珠白', 1.4, 'T',  28000, 260, '2022-09-10', 'https://wpimg.wallstcn.com/f778738c-e4f8-4870-b634-56703b4acafe.gif', 4000,  1, NOW(), NOW(), 5,  5, 0),
(3,  '沪A8K233', 4, 9, 0, '铂金白', 2.5, 'L',  18500, 360, '2023-03-22', 'https://wpimg.wallstcn.com/f778738c-e4f8-4870-b634-56703b4acafe.gif', 6000,  0, NOW(), NOW(), 3,  3, 0),
(4,  '沪A8K234', 6, 14,0, '矿石灰', 2.0, 'T',  9800,  580, '2023-08-18', 'https://wpimg.wallstcn.com/f778738c-e4f8-4870-b634-56703b4acafe.gif', 10000, 1, NOW(), NOW(), 2,  2, 0),
(5,  '沪A8K235', 7, 16,0, '曜岩黑', 1.5, 'T',  15600, 620, '2023-05-30', 'https://wpimg.wallstcn.com/f778738c-e4f8-4870-b634-56703b4acafe.gif', 12000, 0, NOW(), NOW(), 3,  2, 0),
(6,  '沪A8K236', 8, 18,1, '雅顺灰', 0,   'kWh',32000, 280, '2022-11-05', 'https://wpimg.wallstcn.com/f778738c-e4f8-4870-b634-56703b4acafe.gif', 4000,  2, NOW(), NOW(), 6,  5, 0),
(7,  '沪A8K237', 9, 20,1, '中国红', 0,   'kWh',21000, 450, '2023-01-12', 'https://wpimg.wallstcn.com/f778738c-e4f8-4870-b634-56703b4acafe.gif', 8000,  0, NOW(), NOW(), 4,  4, 0),
(8,  '沪A8K238', 5, 12,0, '极光银', 1.6, 'L',  56000, 180, '2021-07-20', 'https://wpimg.wallstcn.com/f778738c-e4f8-4870-b634-56703b4acafe.gif', 3000,  3, NOW(), NOW(), 11, 9, 0),
(9,  '沪A8K239', 3, 7, 0, '深空蓝', 2.0, 'T',  33000, 300, '2022-06-08', 'https://wpimg.wallstcn.com/f778738c-e4f8-4870-b634-56703b4acafe.gif', 5000,  1, NOW(), NOW(), 7,  6, 0),
(10, '沪A8K240', 8, 19,2, '冰川蓝', 1.5, 'L',  12000, 240, '2023-09-01', 'https://wpimg.wallstcn.com/f778738c-e4f8-4870-b634-56703b4acafe.gif', 4000,  0, NOW(), NOW(), 2,  2, 0);

-- ============================================================
-- 11. 客户 busi_customer
--     gender:1男 2女  status:0黑名单 1白名单  (身份证号为虚构测试号)
-- ============================================================
INSERT INTO busi_customer (id, name, age, gender, tel, birthday, id_num, status, create_time, update_time, deleted) VALUES
(1, '刘德海', 38, 1, '13912340001', '1987-05-12', '310101198705120013', 1, NOW(), NOW(), 0),
(2, '周婷婷', 29, 2, '13912340002', '1996-11-23', '310104199611230028', 1, NOW(), NOW(), 0),
(3, '吴志强', 45, 1, '13912340003', '1980-02-08', '310108198002080517', 1, NOW(), NOW(), 0),
(4, '林晓梅', 33, 2, '13912340004', '1992-08-19', '310105199208190542', 0, NOW(), NOW(), 0),
(5, '郑国平', 51, 1, '13912340005', '1974-12-30', '310110197412300033', 1, NOW(), NOW(), 0),
(6, '黄丽华', 27, 2, '13912340006', '1998-06-15', '310115199806150264', 1, NOW(), NOW(), 0);

-- ============================================================
-- 12. 订单 busi_order
--     deposit_return:0未返还 1已返还
-- ============================================================
INSERT INTO busi_order (id, order_num, auto_id, customer_id, rental_time, type_id, rent, deposit, mileage, return_time, return_mileage, rent_payable, rent_actual, deposit_return, create_time, update_time, deleted) VALUES
(1, 'YT20260620001', 2, 1, '2026-06-20 09:30:00', 1, 260, 4000, 28000, NULL, NULL, NULL, NULL, 0, NOW(), NOW(), 0),
(2, 'YT20260618002', 4, 3, '2026-06-18 14:00:00', 2, 580, 10000,9800,  NULL, NULL, NULL, NULL, 0, NOW(), NOW(), 0),
(3, 'YT20260615003', 9, 2, '2026-06-15 10:15:00', 1, 300, 5000, 33000, NULL, NULL, NULL, NULL, 0, NOW(), NOW(), 0),
(4, 'YT20260601004', 1, 5, '2026-06-01 11:00:00', 3, 320, 5000, 38000, '2026-06-20 16:30:00', 42000, 4608, 4608, 1, NOW(), NOW(), 0),
(5, 'YT20260520005', 5, 6, '2026-05-20 09:00:00', 1, 620, 12000,13200, '2026-05-25 18:00:00', 15600, 3100, 3100, 1, NOW(), NOW(), 0),
(6, 'YT20260510006', 7, 1, '2026-05-10 13:30:00', 4, 450, 8000, 18000, '2026-05-15 12:00:00', 21000, 1687, 1687, 1, NOW(), NOW(), 0);

-- ============================================================
-- 13. 保养 busi_maintain
-- ============================================================
INSERT INTO busi_maintain (id, auto_id, maintain_time, location, item, cost, create_time, update_time, deleted) VALUES
(1, 6, '2026-06-22', '宇通自营维保中心', '三电系统检测 + 常规保养',        880,  NOW(), NOW(), 0),
(2, 1, '2026-06-21', '上海大众4S店浦东店', '更换机油机滤 + 四轮换位',        650,  NOW(), NOW(), 0),
(3, 5, '2026-05-26', '奔驰授权服务中心',   '首保 + 刹车系统检查',            1200, NOW(), NOW(), 0),
(4, 8, '2026-05-15', '宇通自营维保中心',   '更换正时皮带 + 火花塞',          1500, NOW(), NOW(), 0),
(5, 3, '2026-04-18', '广汽丰田4S店',       '常规保养：机油机滤',             480,  NOW(), NOW(), 0);

-- ============================================================
-- 14. 违章 busi_violation
--     status:0未处理 1已处理
-- ============================================================
INSERT INTO busi_violation (id, auto_id, violation_time, reason, location, deduct_points, fine, status, create_time, update_time, deleted) VALUES
(1, 1, '2026-06-10 08:25:00', '违反禁止标线指示',   '上海市浦东新区世纪大道', 3, 200, 1, NOW(), NOW(), 0),
(2, 5, '2026-05-22 19:40:00', '机动车超速20%以下',  'G15沈海高速上海段',     3, 200, 1, NOW(), NOW(), 0),
(3, 7, '2026-05-12 12:10:00', '违法停车',           '上海市黄浦区南京东路',   0, 200, 1, NOW(), NOW(), 0),
(4, 2, '2026-06-21 17:55:00', '闯红灯',             '上海市浦东新区张杨路',   6, 200, 0, NOW(), NOW(), 0),
(5, 4, '2026-06-19 09:15:00', '违反禁止标线指示',   '上海市徐汇区漕溪北路',   3, 200, 0, NOW(), NOW(), 0);
