-- 车辆租赁管理系统 模拟数据脚本
-- 用途：修正历史用户性别 + 为空业务表填充测试数据
-- 外键均对应已有 auto_maker / auto_brand 数据
USE car_rental_system;

-- 1. 修正历史用户性别（旧 Boolean 时代 test 的 gender=0 为无效值）
UPDATE sys_user SET gender = 2 WHERE id = 2;

-- 2. 出租类型 busi_rental_type
INSERT INTO busi_rental_type (type_name, type_discout, remark, create_time, update_time, deleted) VALUES
('日租',   1.0,  '按日计费，无折扣',        NOW(), NOW(), 0),
('周租',   0.9,  '连续租满7天，享9折',      NOW(), NOW(), 0),
('月租',   0.8,  '连续租满30天，享8折',     NOW(), NOW(), 0),
('VIP会员', 0.75, 'VIP客户专享75折',         NOW(), NOW(), 0);

-- 3. 车辆信息 auto_info（maker_id/brand_id 对应已有厂商品牌）
-- info_type: 0燃油 1电动 2混动   status: 0未租 1已租 2维保 3自用
INSERT INTO auto_info
(auto_num, maker_id, brand_id, info_type, color, displacement, unit, mileage, rent, registration_date, pic, deposit, status, create_time, update_time, expected_num, actual_num, deleted) VALUES
('沪A12345', 5, 13, 0, '珍珠白', 2.0, 'L',  32000, 300, '2022-05-10', 'https://wpimg.wallstcn.com/f778738c-e4f8-4870-b634-56703b4acafe.gif', 5000, 0, NOW(), NOW(), 6, 4, 0),
('沪B66888', 4, 10, 0, '矿石灰', 2.0, 'L',  18500, 500, '2023-03-22', 'https://wpimg.wallstcn.com/f778738c-e4f8-4870-b634-56703b4acafe.gif', 8000, 1, NOW(), NOW(), 3, 3, 0),
('沪C88999', 3,  8, 0, '曜岩黑', 1.5, 'L',  9800,  600, '2023-08-15', 'https://wpimg.wallstcn.com/f778738c-e4f8-4870-b634-56703b4acafe.gif', 10000, 0, NOW(), NOW(), 2, 1, 0),
('沪D52000', 1,  1, 0, '极地白', 1.4, 'L',  56000, 150, '2021-11-01', 'https://wpimg.wallstcn.com/f778738c-e4f8-4870-b634-56703b4acafe.gif', 3000, 2, NOW(), NOW(), 11, 9, 0),
('沪E60000', 8, 19, 2, '海洋蓝', 1.5, 'L',  12000, 280, '2023-06-18', 'https://wpimg.wallstcn.com/f778738c-e4f8-4870-b634-56703b4acafe.gif', 4000, 0, NOW(), NOW(), 2, 2, 0);

-- 4. 客户 busi_customer（status: 0黑名单 1白名单；id_num 为虚构测试号）
INSERT INTO busi_customer (name, age, tel, birthday, id_num, status, create_time, update_time, deleted) VALUES
('张三', 35, '13800001111', '1990-03-12', '310101199003120011', 1, NOW(), NOW(), 0),
('李四', 28, '13900002222', '1997-07-25', '310101199707250022', 1, NOW(), NOW(), 0),
('王五', 42, '13700003333', '1983-12-08', '310101198312080033', 0, NOW(), NOW(), 0),
('赵六', 31, '13600004444', '1994-09-30', '310101199409300044', 1, NOW(), NOW(), 0);

-- 5. 订单 busi_order（auto_id=2 已租进行中；auto_id=4 维保中此处为已完成订单）
-- deposit_return: 0未返还 1已返还
INSERT INTO busi_order
(order_num, auto_id, customer_id, rental_time, type_id, rent, deposit, mileage, return_time, return_mileage, rent_payable, rent_actual, deposit_return, create_time, update_time, deleted) VALUES
('ORD20260601001', 2, 1, '2026-06-20 09:30:00', 1, 500, 8000, 18500, NULL, NULL, NULL, NULL, 0, NOW(), NOW(), 0),
('ORD20260520002', 4, 2, '2026-05-15 14:00:00', 2, 150, 3000, 54000, '2026-05-22 10:00:00', 56000, 945, 945, 1, NOW(), NOW(), 0),
('ORD20260510003', 1, 4, '2026-05-01 11:00:00', 1, 300, 5000, 30000, '2026-05-05 16:30:00', 32000, 1200, 1200, 1, NOW(), NOW(), 0);

-- 6. 保养 busi_maintain
INSERT INTO busi_maintain (auto_id, maintain_time, location, item, cost, create_time, update_time, deleted) VALUES
(4, '2026-05-23', '宇通4S店浦东店', '常规保养：机油机滤+轮胎检查', 680,  NOW(), NOW(), 0),
(1, '2026-05-06', '宇通4S店徐汇店', '更换刹车片+四轮定位',         1200, NOW(), NOW(), 0),
(3, '2026-04-18', '宇通4S店静安店', '首保：机油机滤',               450,  NOW(), NOW(), 0);

-- 7. 违章 busi_violation（status: 0未处理 1已处理）
INSERT INTO busi_violation (auto_id, violation_time, reason, location, deduct_points, fine, status, create_time, update_time, deleted) VALUES
(4, '2026-05-18 08:20:00', '违章停车',     '南京东路步行街',   0, 200, 1, NOW(), NOW(), 0),
(1, '2026-05-03 19:45:00', '超速20%以下', 'G2京沪高速',       3, 200, 1, NOW(), NOW(), 0),
(2, '2026-06-21 12:10:00', '闯红灯',       '人民广场路口',     6, 200, 0, NOW(), NOW(), 0);
