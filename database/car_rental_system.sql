/*
 Navicat Premium Dump SQL

 Source Server         : main
 Source Server Type    : MySQL
 Source Server Version : 90300 (9.3.0)
 Source Host           : localhost:3306
 Source Schema         : car_rental_system

 Target Server Type    : MySQL
 Target Server Version : 90300 (9.3.0)
 File Encoding         : 65001

 Date: 27/06/2026 23:43:59
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for auto_brand
-- ----------------------------
DROP TABLE IF EXISTS `auto_brand`;
CREATE TABLE `auto_brand` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '品牌id',
  `mid` int DEFAULT NULL COMMENT '厂商id',
  `brand_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '品牌名称',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of auto_brand
-- ----------------------------
BEGIN;
INSERT INTO `auto_brand` (`id`, `mid`, `brand_name`, `deleted`) VALUES (1, 1, '迈腾', 0);
INSERT INTO `auto_brand` (`id`, `mid`, `brand_name`, `deleted`) VALUES (2, 1, '速腾', 0);
INSERT INTO `auto_brand` (`id`, `mid`, `brand_name`, `deleted`) VALUES (3, 1, '宝来', 0);
INSERT INTO `auto_brand` (`id`, `mid`, `brand_name`, `deleted`) VALUES (4, 2, '帕萨特', 0);
INSERT INTO `auto_brand` (`id`, `mid`, `brand_name`, `deleted`) VALUES (5, 2, '朗逸', 0);
INSERT INTO `auto_brand` (`id`, `mid`, `brand_name`, `deleted`) VALUES (6, 2, '途观L', 0);
INSERT INTO `auto_brand` (`id`, `mid`, `brand_name`, `deleted`) VALUES (7, 3, '君威', 0);
INSERT INTO `auto_brand` (`id`, `mid`, `brand_name`, `deleted`) VALUES (8, 3, '昂科威', 0);
INSERT INTO `auto_brand` (`id`, `mid`, `brand_name`, `deleted`) VALUES (9, 3, 'GL8', 0);
INSERT INTO `auto_brand` (`id`, `mid`, `brand_name`, `deleted`) VALUES (10, 4, '凯美瑞', 0);
INSERT INTO `auto_brand` (`id`, `mid`, `brand_name`, `deleted`) VALUES (11, 4, '汉兰达', 0);
INSERT INTO `auto_brand` (`id`, `mid`, `brand_name`, `deleted`) VALUES (12, 4, '雷凌', 0);
INSERT INTO `auto_brand` (`id`, `mid`, `brand_name`, `deleted`) VALUES (13, 5, '轩逸', 0);
INSERT INTO `auto_brand` (`id`, `mid`, `brand_name`, `deleted`) VALUES (14, 5, '天籁', 0);
INSERT INTO `auto_brand` (`id`, `mid`, `brand_name`, `deleted`) VALUES (15, 5, '奇骏', 0);
INSERT INTO `auto_brand` (`id`, `mid`, `brand_name`, `deleted`) VALUES (16, 6, '宝马3系', 0);
INSERT INTO `auto_brand` (`id`, `mid`, `brand_name`, `deleted`) VALUES (17, 6, '宝马5系', 0);
INSERT INTO `auto_brand` (`id`, `mid`, `brand_name`, `deleted`) VALUES (18, 6, '宝马X3', 0);
INSERT INTO `auto_brand` (`id`, `mid`, `brand_name`, `deleted`) VALUES (19, 7, '奔驰C级', 0);
INSERT INTO `auto_brand` (`id`, `mid`, `brand_name`, `deleted`) VALUES (20, 7, '奔驰E级', 0);
INSERT INTO `auto_brand` (`id`, `mid`, `brand_name`, `deleted`) VALUES (21, 7, '奔驰GLC', 0);
INSERT INTO `auto_brand` (`id`, `mid`, `brand_name`, `deleted`) VALUES (22, 8, '汉EV', 0);
INSERT INTO `auto_brand` (`id`, `mid`, `brand_name`, `deleted`) VALUES (23, 8, '宋PLUS DM-i', 0);
INSERT INTO `auto_brand` (`id`, `mid`, `brand_name`, `deleted`) VALUES (24, 8, '海豹', 0);
INSERT INTO `auto_brand` (`id`, `mid`, `brand_name`, `deleted`) VALUES (25, 9, 'Model 3', 0);
INSERT INTO `auto_brand` (`id`, `mid`, `brand_name`, `deleted`) VALUES (26, 9, 'Model Y', 0);
INSERT INTO `auto_brand` (`id`, `mid`, `brand_name`, `deleted`) VALUES (27, 10, '奥迪A4L', 0);
INSERT INTO `auto_brand` (`id`, `mid`, `brand_name`, `deleted`) VALUES (28, 10, '奥迪A6L', 0);
INSERT INTO `auto_brand` (`id`, `mid`, `brand_name`, `deleted`) VALUES (29, 10, '奥迪Q5L', 0);
INSERT INTO `auto_brand` (`id`, `mid`, `brand_name`, `deleted`) VALUES (30, 11, '福克斯', 0);
INSERT INTO `auto_brand` (`id`, `mid`, `brand_name`, `deleted`) VALUES (31, 11, '蒙迪欧', 0);
INSERT INTO `auto_brand` (`id`, `mid`, `brand_name`, `deleted`) VALUES (32, 11, '探险者', 0);
INSERT INTO `auto_brand` (`id`, `mid`, `brand_name`, `deleted`) VALUES (33, 12, '捷豹XFL', 0);
INSERT INTO `auto_brand` (`id`, `mid`, `brand_name`, `deleted`) VALUES (34, 12, '揽胜极光', 0);
INSERT INTO `auto_brand` (`id`, `mid`, `brand_name`, `deleted`) VALUES (35, 12, '发现运动版', 0);
INSERT INTO `auto_brand` (`id`, `mid`, `brand_name`, `deleted`) VALUES (36, 13, 'Macan', 0);
INSERT INTO `auto_brand` (`id`, `mid`, `brand_name`, `deleted`) VALUES (37, 13, 'Cayenne', 0);
INSERT INTO `auto_brand` (`id`, `mid`, `brand_name`, `deleted`) VALUES (38, 14, 'Ghibli', 0);
INSERT INTO `auto_brand` (`id`, `mid`, `brand_name`, `deleted`) VALUES (39, 14, 'Levante', 0);
INSERT INTO `auto_brand` (`id`, `mid`, `brand_name`, `deleted`) VALUES (40, 15, '古思特', 0);
INSERT INTO `auto_brand` (`id`, `mid`, `brand_name`, `deleted`) VALUES (41, 16, 'AION Y', 0);
INSERT INTO `auto_brand` (`id`, `mid`, `brand_name`, `deleted`) VALUES (42, 16, 'AION S Plus', 0);
COMMIT;

-- ----------------------------
-- Table structure for auto_info
-- ----------------------------
DROP TABLE IF EXISTS `auto_info`;
CREATE TABLE `auto_info` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '车辆信息id',
  `auto_num` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '车牌号码',
  `maker_id` int DEFAULT NULL COMMENT '厂商id',
  `brand_id` int DEFAULT NULL COMMENT '品牌id',
  `info_type` tinyint(1) DEFAULT NULL COMMENT '车辆类型 0 燃油车  1 电动车  2 混动车',
  `color` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '车辆颜色 ',
  `displacement` double DEFAULT NULL COMMENT '汽车排量',
  `unit` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '排量计量单位',
  `mileage` int DEFAULT NULL COMMENT '行驶里程',
  `rent` int DEFAULT NULL COMMENT '日租金额',
  `registration_date` date DEFAULT NULL COMMENT '上牌日期',
  `pic` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '车辆图片',
  `deposit` int DEFAULT NULL COMMENT '押金 ',
  `status` tinyint(1) DEFAULT NULL COMMENT '状态 0-未租   1 -已租   2-维保   3-自用',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `expected_num` int DEFAULT NULL COMMENT '应保次数',
  `actual_num` int DEFAULT NULL COMMENT '实保次数',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of auto_info
-- ----------------------------
BEGIN;
INSERT INTO `auto_info` (`id`, `auto_num`, `maker_id`, `brand_id`, `info_type`, `color`, `displacement`, `unit`, `mileage`, `rent`, `registration_date`, `pic`, `deposit`, `status`, `create_time`, `update_time`, `expected_num`, `actual_num`, `deleted`) VALUES (1, '沪A7R001', 1, 1, 0, '#FFFFFF', 1.4, 'T', 10350, 180, '2021-02-02', '', 3000, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 2, 2, 0);
INSERT INTO `auto_info` (`id`, `auto_num`, `maker_id`, `brand_id`, `info_type`, `color`, `displacement`, `unit`, `mileage`, `rent`, `registration_date`, `pic`, `deposit`, `status`, `create_time`, `update_time`, `expected_num`, `actual_num`, `deleted`) VALUES (2, '沪A7R002', 1, 2, 0, '#E11D48', 1.5, 'T', 12700, 220, '2022-03-03', '', 4000, 3, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 2, 2, 0);
INSERT INTO `auto_info` (`id`, `auto_num`, `maker_id`, `brand_id`, `info_type`, `color`, `displacement`, `unit`, `mileage`, `rent`, `registration_date`, `pic`, `deposit`, `status`, `create_time`, `update_time`, `expected_num`, `actual_num`, `deleted`) VALUES (3, '沪A7R003', 1, 3, 0, '#2563EB', 1.6, 'L', 15050, 260, '2023-04-04', '', 4500, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 3, 2, 0);
INSERT INTO `auto_info` (`id`, `auto_num`, `maker_id`, `brand_id`, `info_type`, `color`, `displacement`, `unit`, `mileage`, `rent`, `registration_date`, `pic`, `deposit`, `status`, `create_time`, `update_time`, `expected_num`, `actual_num`, `deleted`) VALUES (4, '沪A7R004', 2, 4, 0, '#10B981', 2, 'T', 17400, 300, '2024-05-05', '', 5500, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 3, 1, 0);
INSERT INTO `auto_info` (`id`, `auto_num`, `maker_id`, `brand_id`, `info_type`, `color`, `displacement`, `unit`, `mileage`, `rent`, `registration_date`, `pic`, `deposit`, `status`, `create_time`, `update_time`, `expected_num`, `actual_num`, `deleted`) VALUES (5, '沪A7R005', 2, 5, 0, '#F59E0B', 2.5, 'T', 19750, 350, '2025-06-06', '', 6500, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 3, 3, 0);
INSERT INTO `auto_info` (`id`, `auto_num`, `maker_id`, `brand_id`, `info_type`, `color`, `displacement`, `unit`, `mileage`, `rent`, `registration_date`, `pic`, `deposit`, `status`, `create_time`, `update_time`, `expected_num`, `actual_num`, `deleted`) VALUES (6, '沪A7R006', 2, 6, 0, '#6B7280', 3, 'L', 22100, 420, '2020-07-07', '', 7500, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 4, 3, 0);
INSERT INTO `auto_info` (`id`, `auto_num`, `maker_id`, `brand_id`, `info_type`, `color`, `displacement`, `unit`, `mileage`, `rent`, `registration_date`, `pic`, `deposit`, `status`, `create_time`, `update_time`, `expected_num`, `actual_num`, `deleted`) VALUES (7, '沪A7R007', 3, 7, 0, '#111827', 1.2, 'T', 18150, 480, '2021-08-08', '', 8500, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 3, 3, 0);
INSERT INTO `auto_info` (`id`, `auto_num`, `maker_id`, `brand_id`, `info_type`, `color`, `displacement`, `unit`, `mileage`, `rent`, `registration_date`, `pic`, `deposit`, `status`, `create_time`, `update_time`, `expected_num`, `actual_num`, `deleted`) VALUES (8, '沪A7R008', 3, 8, 0, '#7C3AED', 1.4, 'T', 20500, 560, '2022-09-09', '', 10000, 2, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 4, 2, 0);
INSERT INTO `auto_info` (`id`, `auto_num`, `maker_id`, `brand_id`, `info_type`, `color`, `displacement`, `unit`, `mileage`, `rent`, `registration_date`, `pic`, `deposit`, `status`, `create_time`, `update_time`, `expected_num`, `actual_num`, `deleted`) VALUES (9, '沪A7R009', 3, 9, 0, '#14B8A6', 1.5, 'L', 22850, 680, '2023-10-10', '', 12000, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 4, 3, 0);
INSERT INTO `auto_info` (`id`, `auto_num`, `maker_id`, `brand_id`, `info_type`, `color`, `displacement`, `unit`, `mileage`, `rent`, `registration_date`, `pic`, `deposit`, `status`, `create_time`, `update_time`, `expected_num`, `actual_num`, `deleted`) VALUES (10, '沪A7R010', 4, 10, 2, '#DC2626', 1.5, 'L', 25200, 880, '2024-11-11', '', 16000, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 5, 5, 0);
INSERT INTO `auto_info` (`id`, `auto_num`, `maker_id`, `brand_id`, `info_type`, `color`, `displacement`, `unit`, `mileage`, `rent`, `registration_date`, `pic`, `deposit`, `status`, `create_time`, `update_time`, `expected_num`, `actual_num`, `deleted`) VALUES (11, '沪A7R011', 4, 11, 0, '#94A3B8', 2, 'T', 27550, 1280, '2025-12-12', '', 23000, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 5, 5, 0);
INSERT INTO `auto_info` (`id`, `auto_num`, `maker_id`, `brand_id`, `info_type`, `color`, `displacement`, `unit`, `mileage`, `rent`, `registration_date`, `pic`, `deposit`, `status`, `create_time`, `update_time`, `expected_num`, `actual_num`, `deleted`) VALUES (12, '沪A7R012', 4, 12, 2, '#1F2937', 1.5, 'L', 29900, 160, '2020-01-13', '', 3000, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 5, 3, 0);
INSERT INTO `auto_info` (`id`, `auto_num`, `maker_id`, `brand_id`, `info_type`, `color`, `displacement`, `unit`, `mileage`, `rent`, `registration_date`, `pic`, `deposit`, `status`, `create_time`, `update_time`, `expected_num`, `actual_num`, `deleted`) VALUES (13, '沪A7R013', 5, 13, 0, '#FFFFFF', 3, 'T', 32250, 180, '2021-02-14', '', 3000, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 6, 6, 0);
INSERT INTO `auto_info` (`id`, `auto_num`, `maker_id`, `brand_id`, `info_type`, `color`, `displacement`, `unit`, `mileage`, `rent`, `registration_date`, `pic`, `deposit`, `status`, `create_time`, `update_time`, `expected_num`, `actual_num`, `deleted`) VALUES (14, '沪A7R014', 5, 14, 0, '#E11D48', 1.2, 'T', 28300, 220, '2022-03-15', '', 4000, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 5, 5, 0);
INSERT INTO `auto_info` (`id`, `auto_num`, `maker_id`, `brand_id`, `info_type`, `color`, `displacement`, `unit`, `mileage`, `rent`, `registration_date`, `pic`, `deposit`, `status`, `create_time`, `update_time`, `expected_num`, `actual_num`, `deleted`) VALUES (15, '沪A7R015', 5, 15, 0, '#2563EB', 1.4, 'L', 30650, 260, '2023-04-16', '', 4500, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 6, 5, 0);
INSERT INTO `auto_info` (`id`, `auto_num`, `maker_id`, `brand_id`, `info_type`, `color`, `displacement`, `unit`, `mileage`, `rent`, `registration_date`, `pic`, `deposit`, `status`, `create_time`, `update_time`, `expected_num`, `actual_num`, `deleted`) VALUES (16, '沪A7R016', 6, 16, 0, '#10B981', 1.5, 'T', 33000, 300, '2024-05-17', '', 5500, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 6, 4, 0);
INSERT INTO `auto_info` (`id`, `auto_num`, `maker_id`, `brand_id`, `info_type`, `color`, `displacement`, `unit`, `mileage`, `rent`, `registration_date`, `pic`, `deposit`, `status`, `create_time`, `update_time`, `expected_num`, `actual_num`, `deleted`) VALUES (17, '沪A7R017', 6, 17, 0, '#F59E0B', 1.6, 'T', 35350, 350, '2025-06-18', '', 6500, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 7, 7, 0);
INSERT INTO `auto_info` (`id`, `auto_num`, `maker_id`, `brand_id`, `info_type`, `color`, `displacement`, `unit`, `mileage`, `rent`, `registration_date`, `pic`, `deposit`, `status`, `create_time`, `update_time`, `expected_num`, `actual_num`, `deleted`) VALUES (18, '沪A7R018', 6, 18, 0, '#6B7280', 2, 'L', 37700, 420, '2020-07-19', '', 7500, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 7, 6, 0);
INSERT INTO `auto_info` (`id`, `auto_num`, `maker_id`, `brand_id`, `info_type`, `color`, `displacement`, `unit`, `mileage`, `rent`, `registration_date`, `pic`, `deposit`, `status`, `create_time`, `update_time`, `expected_num`, `actual_num`, `deleted`) VALUES (19, '沪A7R019', 7, 19, 0, '#111827', 2.5, 'T', 40050, 480, '2021-08-20', '', 8500, 2, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 8, 8, 0);
INSERT INTO `auto_info` (`id`, `auto_num`, `maker_id`, `brand_id`, `info_type`, `color`, `displacement`, `unit`, `mileage`, `rent`, `registration_date`, `pic`, `deposit`, `status`, `create_time`, `update_time`, `expected_num`, `actual_num`, `deleted`) VALUES (20, '沪A7R020', 7, 20, 0, '#7C3AED', 3, 'T', 42400, 560, '2022-09-21', '', 10000, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 8, 6, 0);
INSERT INTO `auto_info` (`id`, `auto_num`, `maker_id`, `brand_id`, `info_type`, `color`, `displacement`, `unit`, `mileage`, `rent`, `registration_date`, `pic`, `deposit`, `status`, `create_time`, `update_time`, `expected_num`, `actual_num`, `deleted`) VALUES (21, '沪A7R021', 7, 21, 0, '#14B8A6', 1.2, 'L', 38450, 680, '2023-10-22', '', 12000, 3, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 7, 6, 0);
INSERT INTO `auto_info` (`id`, `auto_num`, `maker_id`, `brand_id`, `info_type`, `color`, `displacement`, `unit`, `mileage`, `rent`, `registration_date`, `pic`, `deposit`, `status`, `create_time`, `update_time`, `expected_num`, `actual_num`, `deleted`) VALUES (22, '沪A7R022', 8, 22, 1, '#DC2626', 0, 'kWh', 40800, 880, '2024-11-23', '', 16000, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 8, 8, 0);
INSERT INTO `auto_info` (`id`, `auto_num`, `maker_id`, `brand_id`, `info_type`, `color`, `displacement`, `unit`, `mileage`, `rent`, `registration_date`, `pic`, `deposit`, `status`, `create_time`, `update_time`, `expected_num`, `actual_num`, `deleted`) VALUES (23, '沪A7R023', 8, 23, 2, '#94A3B8', 1.5, 'L', 43150, 1280, '2025-12-24', '', 23000, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 8, 8, 0);
INSERT INTO `auto_info` (`id`, `auto_num`, `maker_id`, `brand_id`, `info_type`, `color`, `displacement`, `unit`, `mileage`, `rent`, `registration_date`, `pic`, `deposit`, `status`, `create_time`, `update_time`, `expected_num`, `actual_num`, `deleted`) VALUES (24, '沪A7R024', 8, 24, 1, '#1F2937', 0, 'kWh', 45500, 160, '2020-01-25', '', 3000, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 9, 7, 0);
INSERT INTO `auto_info` (`id`, `auto_num`, `maker_id`, `brand_id`, `info_type`, `color`, `displacement`, `unit`, `mileage`, `rent`, `registration_date`, `pic`, `deposit`, `status`, `create_time`, `update_time`, `expected_num`, `actual_num`, `deleted`) VALUES (25, '沪A7R025', 9, 25, 1, '#FFFFFF', 0, 'kWh', 47850, 180, '2021-02-26', '', 3000, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 9, 9, 0);
INSERT INTO `auto_info` (`id`, `auto_num`, `maker_id`, `brand_id`, `info_type`, `color`, `displacement`, `unit`, `mileage`, `rent`, `registration_date`, `pic`, `deposit`, `status`, `create_time`, `update_time`, `expected_num`, `actual_num`, `deleted`) VALUES (26, '沪A7R026', 9, 26, 1, '#E11D48', 0, 'kWh', 50200, 220, '2022-03-01', '', 4000, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 10, 10, 0);
INSERT INTO `auto_info` (`id`, `auto_num`, `maker_id`, `brand_id`, `info_type`, `color`, `displacement`, `unit`, `mileage`, `rent`, `registration_date`, `pic`, `deposit`, `status`, `create_time`, `update_time`, `expected_num`, `actual_num`, `deleted`) VALUES (27, '沪A7R027', 10, 27, 0, '#2563EB', 3, 'L', 52550, 440, '2023-04-02', '', 8000, 2, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 10, 9, 0);
INSERT INTO `auto_info` (`id`, `auto_num`, `maker_id`, `brand_id`, `info_type`, `color`, `displacement`, `unit`, `mileage`, `rent`, `registration_date`, `pic`, `deposit`, `status`, `create_time`, `update_time`, `expected_num`, `actual_num`, `deleted`) VALUES (28, '沪A7R028', 10, 28, 0, '#10B981', 1.2, 'T', 48600, 480, '2024-05-03', '', 8500, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 9, 7, 0);
INSERT INTO `auto_info` (`id`, `auto_num`, `maker_id`, `brand_id`, `info_type`, `color`, `displacement`, `unit`, `mileage`, `rent`, `registration_date`, `pic`, `deposit`, `status`, `create_time`, `update_time`, `expected_num`, `actual_num`, `deleted`) VALUES (29, '沪A7R029', 10, 29, 0, '#F59E0B', 1.4, 'T', 50950, 530, '2025-06-04', '', 9500, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 10, 10, 0);
INSERT INTO `auto_info` (`id`, `auto_num`, `maker_id`, `brand_id`, `info_type`, `color`, `displacement`, `unit`, `mileage`, `rent`, `registration_date`, `pic`, `deposit`, `status`, `create_time`, `update_time`, `expected_num`, `actual_num`, `deleted`) VALUES (30, '沪A7R030', 11, 30, 0, '#6B7280', 1.5, 'L', 53300, 600, '2020-07-05', '', 11000, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 10, 9, 0);
INSERT INTO `auto_info` (`id`, `auto_num`, `maker_id`, `brand_id`, `info_type`, `color`, `displacement`, `unit`, `mileage`, `rent`, `registration_date`, `pic`, `deposit`, `status`, `create_time`, `update_time`, `expected_num`, `actual_num`, `deleted`) VALUES (31, '沪A7R031', 11, 31, 0, '#111827', 1.6, 'T', 55650, 660, '2021-08-06', '', 12000, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 11, 11, 0);
INSERT INTO `auto_info` (`id`, `auto_num`, `maker_id`, `brand_id`, `info_type`, `color`, `displacement`, `unit`, `mileage`, `rent`, `registration_date`, `pic`, `deposit`, `status`, `create_time`, `update_time`, `expected_num`, `actual_num`, `deleted`) VALUES (32, '沪A7R032', 11, 32, 0, '#7C3AED', 2, 'T', 58000, 740, '2022-09-07', '', 13500, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 11, 9, 0);
INSERT INTO `auto_info` (`id`, `auto_num`, `maker_id`, `brand_id`, `info_type`, `color`, `displacement`, `unit`, `mileage`, `rent`, `registration_date`, `pic`, `deposit`, `status`, `create_time`, `update_time`, `expected_num`, `actual_num`, `deleted`) VALUES (33, '沪A7R033', 12, 33, 0, '#14B8A6', 2.5, 'L', 60350, 860, '2023-10-08', '', 15500, 2, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 12, 11, 0);
INSERT INTO `auto_info` (`id`, `auto_num`, `maker_id`, `brand_id`, `info_type`, `color`, `displacement`, `unit`, `mileage`, `rent`, `registration_date`, `pic`, `deposit`, `status`, `create_time`, `update_time`, `expected_num`, `actual_num`, `deleted`) VALUES (34, '沪A7R034', 12, 34, 0, '#DC2626', 3, 'T', 62700, 1060, '2024-11-09', '', 19000, 3, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 12, 12, 0);
INSERT INTO `auto_info` (`id`, `auto_num`, `maker_id`, `brand_id`, `info_type`, `color`, `displacement`, `unit`, `mileage`, `rent`, `registration_date`, `pic`, `deposit`, `status`, `create_time`, `update_time`, `expected_num`, `actual_num`, `deleted`) VALUES (35, '沪A7R035', 12, 35, 0, '#94A3B8', 1.2, 'T', 58750, 1460, '2025-12-10', '', 26500, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 11, 11, 0);
INSERT INTO `auto_info` (`id`, `auto_num`, `maker_id`, `brand_id`, `info_type`, `color`, `displacement`, `unit`, `mileage`, `rent`, `registration_date`, `pic`, `deposit`, `status`, `create_time`, `update_time`, `expected_num`, `actual_num`, `deleted`) VALUES (36, '沪A7R036', 13, 36, 0, '#1F2937', 1.4, 'L', 61100, 660, '2020-01-11', '', 20000, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 12, 10, 0);
INSERT INTO `auto_info` (`id`, `auto_num`, `maker_id`, `brand_id`, `info_type`, `color`, `displacement`, `unit`, `mileage`, `rent`, `registration_date`, `pic`, `deposit`, `status`, `create_time`, `update_time`, `expected_num`, `actual_num`, `deleted`) VALUES (37, '沪A7R037', 13, 37, 0, '#FFFFFF', 1.5, 'T', 63450, 680, '2021-02-12', '', 20500, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 12, 12, 0);
INSERT INTO `auto_info` (`id`, `auto_num`, `maker_id`, `brand_id`, `info_type`, `color`, `displacement`, `unit`, `mileage`, `rent`, `registration_date`, `pic`, `deposit`, `status`, `create_time`, `update_time`, `expected_num`, `actual_num`, `deleted`) VALUES (38, '沪A7R038', 14, 38, 0, '#E11D48', 1.6, 'T', 65800, 720, '2022-03-13', '', 21500, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 13, 13, 0);
INSERT INTO `auto_info` (`id`, `auto_num`, `maker_id`, `brand_id`, `info_type`, `color`, `displacement`, `unit`, `mileage`, `rent`, `registration_date`, `pic`, `deposit`, `status`, `create_time`, `update_time`, `expected_num`, `actual_num`, `deleted`) VALUES (39, '沪A7R039', 14, 39, 0, '#2563EB', 2, 'L', 68150, 760, '2023-04-14', '', 23000, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 13, 12, 0);
INSERT INTO `auto_info` (`id`, `auto_num`, `maker_id`, `brand_id`, `info_type`, `color`, `displacement`, `unit`, `mileage`, `rent`, `registration_date`, `pic`, `deposit`, `status`, `create_time`, `update_time`, `expected_num`, `actual_num`, `deleted`) VALUES (40, '沪A7R040', 15, 40, 0, '#10B981', 2.5, 'T', 70500, 800, '2024-05-15', '', 24000, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 14, 12, 0);
INSERT INTO `auto_info` (`id`, `auto_num`, `maker_id`, `brand_id`, `info_type`, `color`, `displacement`, `unit`, `mileage`, `rent`, `registration_date`, `pic`, `deposit`, `status`, `create_time`, `update_time`, `expected_num`, `actual_num`, `deleted`) VALUES (41, '沪A7R041', 16, 41, 1, '#F59E0B', 0, 'kWh', 72850, 850, '2025-06-16', '', 25500, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 14, 14, 0);
INSERT INTO `auto_info` (`id`, `auto_num`, `maker_id`, `brand_id`, `info_type`, `color`, `displacement`, `unit`, `mileage`, `rent`, `registration_date`, `pic`, `deposit`, `status`, `create_time`, `update_time`, `expected_num`, `actual_num`, `deleted`) VALUES (42, '沪A7R042', 16, 42, 1, '#6B7280', 0, 'kWh', 68900, 920, '2020-07-17', '', 27500, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 13, 12, 0);
INSERT INTO `auto_info` (`id`, `auto_num`, `maker_id`, `brand_id`, `info_type`, `color`, `displacement`, `unit`, `mileage`, `rent`, `registration_date`, `pic`, `deposit`, `status`, `create_time`, `update_time`, `expected_num`, `actual_num`, `deleted`) VALUES (43, '沪A7R043', 1, 1, 0, '#111827', 1.4, 'T', 71250, 180, '2021-08-18', '', 3000, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 14, 14, 0);
INSERT INTO `auto_info` (`id`, `auto_num`, `maker_id`, `brand_id`, `info_type`, `color`, `displacement`, `unit`, `mileage`, `rent`, `registration_date`, `pic`, `deposit`, `status`, `create_time`, `update_time`, `expected_num`, `actual_num`, `deleted`) VALUES (44, '沪A7R044', 2, 5, 0, '#7C3AED', 2.5, 'T', 76300, 350, '2022-09-19', '', 6500, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 15, 13, 0);
INSERT INTO `auto_info` (`id`, `auto_num`, `maker_id`, `brand_id`, `info_type`, `color`, `displacement`, `unit`, `mileage`, `rent`, `registration_date`, `pic`, `deposit`, `status`, `create_time`, `update_time`, `expected_num`, `actual_num`, `deleted`) VALUES (45, '沪A7R045', 3, 8, 0, '#14B8A6', 1.4, 'T', 74150, 560, '2023-10-20', '', 10000, 2, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 14, 13, 0);
INSERT INTO `auto_info` (`id`, `auto_num`, `maker_id`, `brand_id`, `info_type`, `color`, `displacement`, `unit`, `mileage`, `rent`, `registration_date`, `pic`, `deposit`, `status`, `create_time`, `update_time`, `expected_num`, `actual_num`, `deleted`) VALUES (46, '沪A7R046', 4, 10, 2, '#DC2626', 1.5, 'L', 77400, 880, '2024-11-21', '', 16000, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 15, 15, 0);
INSERT INTO `auto_info` (`id`, `auto_num`, `maker_id`, `brand_id`, `info_type`, `color`, `displacement`, `unit`, `mileage`, `rent`, `registration_date`, `pic`, `deposit`, `status`, `create_time`, `update_time`, `expected_num`, `actual_num`, `deleted`) VALUES (47, '沪A7R047', 5, 14, 0, '#94A3B8', 1.2, 'T', 76150, 220, '2025-12-22', '', 4000, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 15, 15, 0);
INSERT INTO `auto_info` (`id`, `auto_num`, `maker_id`, `brand_id`, `info_type`, `color`, `displacement`, `unit`, `mileage`, `rent`, `registration_date`, `pic`, `deposit`, `status`, `create_time`, `update_time`, `expected_num`, `actual_num`, `deleted`) VALUES (48, '沪A7R048', 6, 17, 0, '#1F2937', 1.6, 'T', 80300, 350, '2020-01-23', '', 6500, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 16, 14, 0);
INSERT INTO `auto_info` (`id`, `auto_num`, `maker_id`, `brand_id`, `info_type`, `color`, `displacement`, `unit`, `mileage`, `rent`, `registration_date`, `pic`, `deposit`, `status`, `create_time`, `update_time`, `expected_num`, `actual_num`, `deleted`) VALUES (49, '沪A7R049', 7, 20, 0, '#FFFFFF', 3, 'T', 84450, 560, '2021-02-24', '', 10000, 3, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 16, 16, 0);
INSERT INTO `auto_info` (`id`, `auto_num`, `maker_id`, `brand_id`, `info_type`, `color`, `displacement`, `unit`, `mileage`, `rent`, `registration_date`, `pic`, `deposit`, `status`, `create_time`, `update_time`, `expected_num`, `actual_num`, `deleted`) VALUES (50, '沪A7R050', 8, 23, 2, '#E11D48', 1.5, 'L', 82300, 1280, '2022-03-25', '', 23000, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 16, 16, 0);
INSERT INTO `auto_info` (`id`, `auto_num`, `maker_id`, `brand_id`, `info_type`, `color`, `displacement`, `unit`, `mileage`, `rent`, `registration_date`, `pic`, `deposit`, `status`, `create_time`, `update_time`, `expected_num`, `actual_num`, `deleted`) VALUES (51, '沪A7R051', 9, 26, 1, '#2563EB', 0, 'kWh', 86450, 220, '2023-04-26', '', 4000, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 17, 16, 0);
INSERT INTO `auto_info` (`id`, `auto_num`, `maker_id`, `brand_id`, `info_type`, `color`, `displacement`, `unit`, `mileage`, `rent`, `registration_date`, `pic`, `deposit`, `status`, `create_time`, `update_time`, `expected_num`, `actual_num`, `deleted`) VALUES (52, '沪A7R052', 10, 29, 0, '#10B981', 1.4, 'T', 84300, 530, '2024-05-01', '', 9500, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 16, 14, 0);
INSERT INTO `auto_info` (`id`, `auto_num`, `maker_id`, `brand_id`, `info_type`, `color`, `displacement`, `unit`, `mileage`, `rent`, `registration_date`, `pic`, `deposit`, `status`, `create_time`, `update_time`, `expected_num`, `actual_num`, `deleted`) VALUES (53, '沪A7R053', 11, 32, 0, '#F59E0B', 2, 'T', 88450, 740, '2025-06-02', '', 13500, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 17, 17, 0);
INSERT INTO `auto_info` (`id`, `auto_num`, `maker_id`, `brand_id`, `info_type`, `color`, `displacement`, `unit`, `mileage`, `rent`, `registration_date`, `pic`, `deposit`, `status`, `create_time`, `update_time`, `expected_num`, `actual_num`, `deleted`) VALUES (54, '沪A7R054', 12, 35, 0, '#6B7280', 1.2, 'T', 86300, 1460, '2020-07-03', '', 26500, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 17, 16, 0);
INSERT INTO `auto_info` (`id`, `auto_num`, `maker_id`, `brand_id`, `info_type`, `color`, `displacement`, `unit`, `mileage`, `rent`, `registration_date`, `pic`, `deposit`, `status`, `create_time`, `update_time`, `expected_num`, `actual_num`, `deleted`) VALUES (55, '沪A7R055', 13, 37, 0, '#111827', 1.5, 'T', 89550, 680, '2021-08-04', '', 20500, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 17, 17, 0);
INSERT INTO `auto_info` (`id`, `auto_num`, `maker_id`, `brand_id`, `info_type`, `color`, `displacement`, `unit`, `mileage`, `rent`, `registration_date`, `pic`, `deposit`, `status`, `create_time`, `update_time`, `expected_num`, `actual_num`, `deleted`) VALUES (56, '沪A7R056', 16, 41, 1, '#7C3AED', 0, 'kWh', 94600, 850, '2022-09-05', '', 25500, 2, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 18, 16, 0);
COMMIT;

-- ----------------------------
-- Table structure for auto_maker
-- ----------------------------
DROP TABLE IF EXISTS `auto_maker`;
CREATE TABLE `auto_maker` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '厂商id',
  `name` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '厂商名称',
  `order_letter` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '排序字母',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of auto_maker
-- ----------------------------
BEGIN;
INSERT INTO `auto_maker` (`id`, `name`, `order_letter`, `deleted`) VALUES (1, '一汽大众', 'YQDZ', 0);
INSERT INTO `auto_maker` (`id`, `name`, `order_letter`, `deleted`) VALUES (2, '上汽大众', 'SQDZ', 0);
INSERT INTO `auto_maker` (`id`, `name`, `order_letter`, `deleted`) VALUES (3, '上汽通用别克', 'SQTYBK', 0);
INSERT INTO `auto_maker` (`id`, `name`, `order_letter`, `deleted`) VALUES (4, '广汽丰田', 'GQFT', 0);
INSERT INTO `auto_maker` (`id`, `name`, `order_letter`, `deleted`) VALUES (5, '东风日产', 'DFRC', 0);
INSERT INTO `auto_maker` (`id`, `name`, `order_letter`, `deleted`) VALUES (6, '华晨宝马', 'HCBM', 0);
INSERT INTO `auto_maker` (`id`, `name`, `order_letter`, `deleted`) VALUES (7, '北京奔驰', 'BJBC', 0);
INSERT INTO `auto_maker` (`id`, `name`, `order_letter`, `deleted`) VALUES (8, '比亚迪', 'BYD', 0);
INSERT INTO `auto_maker` (`id`, `name`, `order_letter`, `deleted`) VALUES (9, '特斯拉中国', 'TSL', 0);
INSERT INTO `auto_maker` (`id`, `name`, `order_letter`, `deleted`) VALUES (10, '一汽奥迪', 'YQAD', 0);
INSERT INTO `auto_maker` (`id`, `name`, `order_letter`, `deleted`) VALUES (11, '长安福特', 'CAFD', 0);
INSERT INTO `auto_maker` (`id`, `name`, `order_letter`, `deleted`) VALUES (12, '奇瑞捷豹路虎', 'QJBLH', 0);
INSERT INTO `auto_maker` (`id`, `name`, `order_letter`, `deleted`) VALUES (13, '保时捷中国', 'BSJ', 0);
INSERT INTO `auto_maker` (`id`, `name`, `order_letter`, `deleted`) VALUES (14, '玛莎拉蒂中国', 'MSLD', 0);
INSERT INTO `auto_maker` (`id`, `name`, `order_letter`, `deleted`) VALUES (15, '劳斯莱斯中国', 'LSLS', 0);
INSERT INTO `auto_maker` (`id`, `name`, `order_letter`, `deleted`) VALUES (16, '广汽埃安', 'GQEA', 0);
COMMIT;

-- ----------------------------
-- Table structure for busi_customer
-- ----------------------------
DROP TABLE IF EXISTS `busi_customer`;
CREATE TABLE `busi_customer` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '客户id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '客户姓名',
  `age` int DEFAULT NULL COMMENT '客户年龄',
  `gender` tinyint(1) DEFAULT NULL COMMENT '客户性别',
  `tel` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '手机号码',
  `birthday` date DEFAULT NULL COMMENT '出生日期',
  `id_num` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '身份证号码',
  `status` tinyint(1) DEFAULT '1' COMMENT '客户状态 0 黑名单 1白名单',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of busi_customer
-- ----------------------------
BEGIN;
INSERT INTO `busi_customer` (`id`, `name`, `age`, `gender`, `tel`, `birthday`, `id_num`, `status`, `create_time`, `update_time`, `deleted`) VALUES (1, '刘德海', 39, 1, '13912010001', '1987-05-12', '31010219870512017', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_customer` (`id`, `name`, `age`, `gender`, `tel`, `birthday`, `id_num`, `status`, `create_time`, `update_time`, `deleted`) VALUES (2, '周婷婷', 30, 0, '13912010002', '1996-11-23', '31010319961123028', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_customer` (`id`, `name`, `age`, `gender`, `tel`, `birthday`, `id_num`, `status`, `create_time`, `update_time`, `deleted`) VALUES (3, '吴志强', 46, 1, '13912010003', '1980-02-08', '31010419800208037', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_customer` (`id`, `name`, `age`, `gender`, `tel`, `birthday`, `id_num`, `status`, `create_time`, `update_time`, `deleted`) VALUES (4, '林晓梅', 34, 0, '13912010004', '1992-08-19', '31010519920819048', 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_customer` (`id`, `name`, `age`, `gender`, `tel`, `birthday`, `id_num`, `status`, `create_time`, `update_time`, `deleted`) VALUES (5, '郑国平', 52, 1, '13912010005', '1974-12-30', '31010619741230057', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_customer` (`id`, `name`, `age`, `gender`, `tel`, `birthday`, `id_num`, `status`, `create_time`, `update_time`, `deleted`) VALUES (6, '黄丽华', 28, 0, '13912010006', '1998-06-15', '31010719980615068', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_customer` (`id`, `name`, `age`, `gender`, `tel`, `birthday`, `id_num`, `status`, `create_time`, `update_time`, `deleted`) VALUES (7, '陈建军', 42, 1, '13912010007', '1984-03-21', '31010819840321077', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_customer` (`id`, `name`, `age`, `gender`, `tel`, `birthday`, `id_num`, `status`, `create_time`, `update_time`, `deleted`) VALUES (8, '杨秀英', 37, 0, '13912010008', '1989-09-09', '31010919890909088', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_customer` (`id`, `name`, `age`, `gender`, `tel`, `birthday`, `id_num`, `status`, `create_time`, `update_time`, `deleted`) VALUES (9, '徐海涛', 33, 1, '13912010009', '1993-07-07', '31011019930707097', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_customer` (`id`, `name`, `age`, `gender`, `tel`, `birthday`, `id_num`, `status`, `create_time`, `update_time`, `deleted`) VALUES (10, '孙丽娟', 49, 0, '13912010010', '1977-01-25', '31011119770125108', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_customer` (`id`, `name`, `age`, `gender`, `tel`, `birthday`, `id_num`, `status`, `create_time`, `update_time`, `deleted`) VALUES (11, '马文斌', 26, 1, '13912010011', '2000-10-18', '31011220001018117', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_customer` (`id`, `name`, `age`, `gender`, `tel`, `birthday`, `id_num`, `status`, `create_time`, `update_time`, `deleted`) VALUES (12, '高雪梅', 40, 0, '13912010012', '1986-04-04', '31011319860404128', 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_customer` (`id`, `name`, `age`, `gender`, `tel`, `birthday`, `id_num`, `status`, `create_time`, `update_time`, `deleted`) VALUES (13, '罗永强', 45, 1, '13912010013', '1981-11-30', '31011419811130137', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_customer` (`id`, `name`, `age`, `gender`, `tel`, `birthday`, `id_num`, `status`, `create_time`, `update_time`, `deleted`) VALUES (14, '何敏', 31, 0, '13912010014', '1995-02-14', '31011519950214148', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_customer` (`id`, `name`, `age`, `gender`, `tel`, `birthday`, `id_num`, `status`, `create_time`, `update_time`, `deleted`) VALUES (15, '邓超', 36, 1, '13912010015', '1990-12-01', '31011619901201157', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_customer` (`id`, `name`, `age`, `gender`, `tel`, `birthday`, `id_num`, `status`, `create_time`, `update_time`, `deleted`) VALUES (16, '陆佳宁', 27, 0, '13912010016', '1999-03-06', '31010119990306168', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_customer` (`id`, `name`, `age`, `gender`, `tel`, `birthday`, `id_num`, `status`, `create_time`, `update_time`, `deleted`) VALUES (17, '曹远航', 38, 1, '13912010017', '1988-07-16', '31010219880716177', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_customer` (`id`, `name`, `age`, `gender`, `tel`, `birthday`, `id_num`, `status`, `create_time`, `update_time`, `deleted`) VALUES (18, '梁思雨', 32, 0, '13912010018', '1994-09-28', '31010319940928188', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_customer` (`id`, `name`, `age`, `gender`, `tel`, `birthday`, `id_num`, `status`, `create_time`, `update_time`, `deleted`) VALUES (19, '袁博文', 43, 1, '13912010019', '1983-01-11', '31010419830111197', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_customer` (`id`, `name`, `age`, `gender`, `tel`, `birthday`, `id_num`, `status`, `create_time`, `update_time`, `deleted`) VALUES (20, '潘雅雯', 29, 0, '13912010020', '1997-12-22', '31010519971222208', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_customer` (`id`, `name`, `age`, `gender`, `tel`, `birthday`, `id_num`, `status`, `create_time`, `update_time`, `deleted`) VALUES (21, '韩立新', 47, 1, '13912010021', '1979-04-30', '31010619790430217', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_customer` (`id`, `name`, `age`, `gender`, `tel`, `birthday`, `id_num`, `status`, `create_time`, `update_time`, `deleted`) VALUES (22, '钱晓彤', 35, 0, '13912010022', '1991-06-03', '31010719910603228', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_customer` (`id`, `name`, `age`, `gender`, `tel`, `birthday`, `id_num`, `status`, `create_time`, `update_time`, `deleted`) VALUES (23, '杜明哲', 41, 1, '13912010023', '1985-08-18', '31010819850818237', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_customer` (`id`, `name`, `age`, `gender`, `tel`, `birthday`, `id_num`, `status`, `create_time`, `update_time`, `deleted`) VALUES (24, '沈佳琪', 25, 0, '13912010024', '2001-02-09', '31010920010209248', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_customer` (`id`, `name`, `age`, `gender`, `tel`, `birthday`, `id_num`, `status`, `create_time`, `update_time`, `deleted`) VALUES (25, '魏建平', 50, 1, '13912010025', '1976-10-02', '31011019761002257', 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_customer` (`id`, `name`, `age`, `gender`, `tel`, `birthday`, `id_num`, `status`, `create_time`, `update_time`, `deleted`) VALUES (26, '叶子涵', 28, 0, '13912010026', '1998-05-27', '31011119980527268', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_customer` (`id`, `name`, `age`, `gender`, `tel`, `birthday`, `id_num`, `status`, `create_time`, `update_time`, `deleted`) VALUES (27, '蒋一帆', 34, 1, '13912010027', '1992-03-17', '31011219920317277', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_customer` (`id`, `name`, `age`, `gender`, `tel`, `birthday`, `id_num`, `status`, `create_time`, `update_time`, `deleted`) VALUES (28, '顾晓琳', 40, 0, '13912010028', '1986-07-05', '31011319860705288', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_customer` (`id`, `name`, `age`, `gender`, `tel`, `birthday`, `id_num`, `status`, `create_time`, `update_time`, `deleted`) VALUES (29, '任宏宇', 36, 1, '13912010029', '1990-11-19', '31011419901119297', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_customer` (`id`, `name`, `age`, `gender`, `tel`, `birthday`, `id_num`, `status`, `create_time`, `update_time`, `deleted`) VALUES (30, '范雨欣', 31, 0, '13912010030', '1995-01-31', '31011519950131308', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_customer` (`id`, `name`, `age`, `gender`, `tel`, `birthday`, `id_num`, `status`, `create_time`, `update_time`, `deleted`) VALUES (31, '谢东来', 44, 1, '13912010031', '1982-12-08', '31011619821208317', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_customer` (`id`, `name`, `age`, `gender`, `tel`, `birthday`, `id_num`, `status`, `create_time`, `update_time`, `deleted`) VALUES (32, '彭露', 27, 0, '13912010032', '1999-08-12', '31010119990812328', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_customer` (`id`, `name`, `age`, `gender`, `tel`, `birthday`, `id_num`, `status`, `create_time`, `update_time`, `deleted`) VALUES (33, '唐启明', 48, 1, '13912010033', '1978-02-24', '31010219780224337', 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_customer` (`id`, `name`, `age`, `gender`, `tel`, `birthday`, `id_num`, `status`, `create_time`, `update_time`, `deleted`) VALUES (34, '贺婉婷', 33, 0, '13912010034', '1993-04-20', '31010319930420348', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_customer` (`id`, `name`, `age`, `gender`, `tel`, `birthday`, `id_num`, `status`, `create_time`, `update_time`, `deleted`) VALUES (35, '朱晨阳', 37, 1, '13912010035', '1989-06-26', '31010419890626357', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_customer` (`id`, `name`, `age`, `gender`, `tel`, `birthday`, `id_num`, `status`, `create_time`, `update_time`, `deleted`) VALUES (36, '宋洁', 41, 0, '13912010036', '1985-09-14', '31010519850914368', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_customer` (`id`, `name`, `age`, `gender`, `tel`, `birthday`, `id_num`, `status`, `create_time`, `update_time`, `deleted`) VALUES (37, '田宇轩', 30, 1, '13912010037', '1996-10-06', '31010619961006377', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_customer` (`id`, `name`, `age`, `gender`, `tel`, `birthday`, `id_num`, `status`, `create_time`, `update_time`, `deleted`) VALUES (38, '邱若兰', 35, 0, '13912010038', '1991-03-29', '31010719910329388', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_customer` (`id`, `name`, `age`, `gender`, `tel`, `birthday`, `id_num`, `status`, `create_time`, `update_time`, `deleted`) VALUES (39, '程浩然', 39, 1, '13912010039', '1987-08-01', '31010819870801397', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_customer` (`id`, `name`, `age`, `gender`, `tel`, `birthday`, `id_num`, `status`, `create_time`, `update_time`, `deleted`) VALUES (40, '姜曼', 26, 0, '13912010040', '2000-12-17', '31010920001217408', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_customer` (`id`, `name`, `age`, `gender`, `tel`, `birthday`, `id_num`, `status`, `create_time`, `update_time`, `deleted`) VALUES (41, '邵俊杰', 42, 1, '13912010041', '1984-05-09', '31011019840509417', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_customer` (`id`, `name`, `age`, `gender`, `tel`, `birthday`, `id_num`, `status`, `create_time`, `update_time`, `deleted`) VALUES (42, '邹静怡', 29, 0, '13912010042', '1997-07-23', '31011119970723428', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_customer` (`id`, `name`, `age`, `gender`, `tel`, `birthday`, `id_num`, `status`, `create_time`, `update_time`, `deleted`) VALUES (43, '方志远', 51, 1, '13912010043', '1975-11-05', '31011219751105437', 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_customer` (`id`, `name`, `age`, `gender`, `tel`, `birthday`, `id_num`, `status`, `create_time`, `update_time`, `deleted`) VALUES (44, '郝诗涵', 32, 0, '13912010044', '1994-02-16', '31011319940216448', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_customer` (`id`, `name`, `age`, `gender`, `tel`, `birthday`, `id_num`, `status`, `create_time`, `update_time`, `deleted`) VALUES (45, '熊凯', 38, 1, '13912010045', '1988-09-25', '31011419880925457', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_customer` (`id`, `name`, `age`, `gender`, `tel`, `birthday`, `id_num`, `status`, `create_time`, `update_time`, `deleted`) VALUES (46, '施悦', 30, 0, '13912010046', '1996-04-11', '31011519960411468', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_customer` (`id`, `name`, `age`, `gender`, `tel`, `birthday`, `id_num`, `status`, `create_time`, `update_time`, `deleted`) VALUES (47, '孟凡超', 45, 1, '13912010047', '1981-01-20', '31011619810120477', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_customer` (`id`, `name`, `age`, `gender`, `tel`, `birthday`, `id_num`, `status`, `create_time`, `update_time`, `deleted`) VALUES (48, '康美玲', 36, 0, '13912010048', '1990-06-08', '31010119900608488', 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
COMMIT;

-- ----------------------------
-- Table structure for busi_maintain
-- ----------------------------
DROP TABLE IF EXISTS `busi_maintain`;
CREATE TABLE `busi_maintain` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '保养id',
  `auto_id` int DEFAULT NULL COMMENT '车辆id',
  `auto_num` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '车牌号码',
  `maintain_time` date DEFAULT NULL COMMENT '维保时间',
  `location` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '维保地点',
  `item` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '维保项目',
  `cost` int DEFAULT NULL COMMENT '维保费用',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of busi_maintain
-- ----------------------------
BEGIN;
INSERT INTO `busi_maintain` (`id`, `auto_id`, `auto_num`, `maintain_time`, `location`, `item`, `cost`, `create_time`, `update_time`, `deleted`) VALUES (1, 7, '沪A7R007', '2026-06-27', '宇通自营维保中心', '常规保养：机油机滤', 520, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_maintain` (`id`, `auto_id`, `auto_num`, `maintain_time`, `location`, `item`, `cost`, `create_time`, `update_time`, `deleted`) VALUES (2, 12, '沪A7R012', '2026-06-27', '上海大众4S店浦东店', '四轮定位 + 轮胎换位', 800, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_maintain` (`id`, `auto_id`, `auto_num`, `maintain_time`, `location`, `item`, `cost`, `create_time`, `update_time`, `deleted`) VALUES (3, 17, '沪A7R017', '2026-06-26', '新能源三电服务站', '三电系统检测 + 软件升级', 1000, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_maintain` (`id`, `auto_id`, `auto_num`, `maintain_time`, `location`, `item`, `cost`, `create_time`, `update_time`, `deleted`) VALUES (4, 22, '沪A7R022', '2026-06-25', '宝马授权服务中心', '制动系统检查 + 更换刹车油', 1540, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_maintain` (`id`, `auto_id`, `auto_num`, `maintain_time`, `location`, `item`, `cost`, `create_time`, `update_time`, `deleted`) VALUES (5, 27, '沪A7R027', '2026-06-24', '奔驰授权服务中心', 'A保 + 全车检测', 1860, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_maintain` (`id`, `auto_id`, `auto_num`, `maintain_time`, `location`, `item`, `cost`, `create_time`, `update_time`, `deleted`) VALUES (6, 32, '沪A7R032', '2026-06-22', '比亚迪服务中心', '电池健康检测', 620, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_maintain` (`id`, `auto_id`, `auto_num`, `maintain_time`, `location`, `item`, `cost`, `create_time`, `update_time`, `deleted`) VALUES (7, 37, '沪A7R037', '2026-06-20', '特斯拉服务中心', '空调滤芯 + 轮胎换位', 680, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_maintain` (`id`, `auto_id`, `auto_num`, `maintain_time`, `location`, `item`, `cost`, `create_time`, `update_time`, `deleted`) VALUES (8, 42, '沪A7R042', '2026-06-18', '广汽丰田4S店', '更换刹车片', 1220, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_maintain` (`id`, `auto_id`, `auto_num`, `maintain_time`, `location`, `item`, `cost`, `create_time`, `update_time`, `deleted`) VALUES (9, 47, '沪A7R047', '2026-06-15', '豪华车专修中心', '底盘检查 + 易损件更换', 2560, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_maintain` (`id`, `auto_id`, `auto_num`, `maintain_time`, `location`, `item`, `cost`, `create_time`, `update_time`, `deleted`) VALUES (10, 52, '沪A7R052', '2026-06-12', '宇通钣喷中心', '轻微剐蹭修复', 1980, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_maintain` (`id`, `auto_id`, `auto_num`, `maintain_time`, `location`, `item`, `cost`, `create_time`, `update_time`, `deleted`) VALUES (11, 1, '沪A7R001', '2026-06-09', '宇通自营维保中心', '常规保养：机油机滤', 520, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_maintain` (`id`, `auto_id`, `auto_num`, `maintain_time`, `location`, `item`, `cost`, `create_time`, `update_time`, `deleted`) VALUES (12, 6, '沪A7R006', '2026-06-06', '上海大众4S店浦东店', '四轮定位 + 轮胎换位', 800, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_maintain` (`id`, `auto_id`, `auto_num`, `maintain_time`, `location`, `item`, `cost`, `create_time`, `update_time`, `deleted`) VALUES (13, 11, '沪A7R011', '2026-06-03', '新能源三电服务站', '三电系统检测 + 软件升级', 1000, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_maintain` (`id`, `auto_id`, `auto_num`, `maintain_time`, `location`, `item`, `cost`, `create_time`, `update_time`, `deleted`) VALUES (14, 16, '沪A7R016', '2026-05-29', '宝马授权服务中心', '制动系统检查 + 更换刹车油', 1540, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_maintain` (`id`, `auto_id`, `auto_num`, `maintain_time`, `location`, `item`, `cost`, `create_time`, `update_time`, `deleted`) VALUES (15, 21, '沪A7R021', '2026-05-25', '奔驰授权服务中心', 'A保 + 全车检测', 1860, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_maintain` (`id`, `auto_id`, `auto_num`, `maintain_time`, `location`, `item`, `cost`, `create_time`, `update_time`, `deleted`) VALUES (16, 26, '沪A7R026', '2026-05-21', '比亚迪服务中心', '电池健康检测', 620, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_maintain` (`id`, `auto_id`, `auto_num`, `maintain_time`, `location`, `item`, `cost`, `create_time`, `update_time`, `deleted`) VALUES (17, 31, '沪A7R031', '2026-05-17', '特斯拉服务中心', '空调滤芯 + 轮胎换位', 680, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_maintain` (`id`, `auto_id`, `auto_num`, `maintain_time`, `location`, `item`, `cost`, `create_time`, `update_time`, `deleted`) VALUES (18, 36, '沪A7R036', '2026-05-12', '广汽丰田4S店', '更换刹车片', 1220, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_maintain` (`id`, `auto_id`, `auto_num`, `maintain_time`, `location`, `item`, `cost`, `create_time`, `update_time`, `deleted`) VALUES (19, 41, '沪A7R041', '2026-05-08', '豪华车专修中心', '底盘检查 + 易损件更换', 2560, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_maintain` (`id`, `auto_id`, `auto_num`, `maintain_time`, `location`, `item`, `cost`, `create_time`, `update_time`, `deleted`) VALUES (20, 46, '沪A7R046', '2026-05-02', '宇通钣喷中心', '轻微剐蹭修复', 1980, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_maintain` (`id`, `auto_id`, `auto_num`, `maintain_time`, `location`, `item`, `cost`, `create_time`, `update_time`, `deleted`) VALUES (21, 51, '沪A7R051', '2026-04-28', '宇通自营维保中心', '常规保养：机油机滤', 520, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_maintain` (`id`, `auto_id`, `auto_num`, `maintain_time`, `location`, `item`, `cost`, `create_time`, `update_time`, `deleted`) VALUES (22, 56, '沪A7R056', '2026-04-22', '上海大众4S店浦东店', '四轮定位 + 轮胎换位', 800, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_maintain` (`id`, `auto_id`, `auto_num`, `maintain_time`, `location`, `item`, `cost`, `create_time`, `update_time`, `deleted`) VALUES (23, 5, '沪A7R005', '2026-04-16', '新能源三电服务站', '三电系统检测 + 软件升级', 1000, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_maintain` (`id`, `auto_id`, `auto_num`, `maintain_time`, `location`, `item`, `cost`, `create_time`, `update_time`, `deleted`) VALUES (24, 10, '沪A7R010', '2026-04-10', '宝马授权服务中心', '制动系统检查 + 更换刹车油', 1540, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_maintain` (`id`, `auto_id`, `auto_num`, `maintain_time`, `location`, `item`, `cost`, `create_time`, `update_time`, `deleted`) VALUES (25, 15, '沪A7R015', '2026-03-28', '奔驰授权服务中心', 'A保 + 全车检测', 1860, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_maintain` (`id`, `auto_id`, `auto_num`, `maintain_time`, `location`, `item`, `cost`, `create_time`, `update_time`, `deleted`) VALUES (26, 20, '沪A7R020', '2026-03-15', '比亚迪服务中心', '电池健康检测', 620, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_maintain` (`id`, `auto_id`, `auto_num`, `maintain_time`, `location`, `item`, `cost`, `create_time`, `update_time`, `deleted`) VALUES (27, 25, '沪A7R025', '2026-02-22', '特斯拉服务中心', '空调滤芯 + 轮胎换位', 680, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_maintain` (`id`, `auto_id`, `auto_num`, `maintain_time`, `location`, `item`, `cost`, `create_time`, `update_time`, `deleted`) VALUES (28, 30, '沪A7R030', '2026-02-08', '广汽丰田4S店', '更换刹车片', 1220, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_maintain` (`id`, `auto_id`, `auto_num`, `maintain_time`, `location`, `item`, `cost`, `create_time`, `update_time`, `deleted`) VALUES (29, 35, '沪A7R035', '2026-01-20', '豪华车专修中心', '底盘检查 + 易损件更换', 2560, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_maintain` (`id`, `auto_id`, `auto_num`, `maintain_time`, `location`, `item`, `cost`, `create_time`, `update_time`, `deleted`) VALUES (30, 40, '沪A7R040', '2026-01-05', '宇通钣喷中心', '轻微剐蹭修复', 1980, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_maintain` (`id`, `auto_id`, `auto_num`, `maintain_time`, `location`, `item`, `cost`, `create_time`, `update_time`, `deleted`) VALUES (31, 45, '沪A7R045', '2025-12-18', '宇通自营维保中心', '常规保养：机油机滤', 520, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_maintain` (`id`, `auto_id`, `auto_num`, `maintain_time`, `location`, `item`, `cost`, `create_time`, `update_time`, `deleted`) VALUES (32, 50, '沪A7R050', '2025-12-03', '上海大众4S店浦东店', '四轮定位 + 轮胎换位', 800, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_maintain` (`id`, `auto_id`, `auto_num`, `maintain_time`, `location`, `item`, `cost`, `create_time`, `update_time`, `deleted`) VALUES (33, 55, '沪A7R055', '2025-11-22', '新能源三电服务站', '三电系统检测 + 软件升级', 1000, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_maintain` (`id`, `auto_id`, `auto_num`, `maintain_time`, `location`, `item`, `cost`, `create_time`, `update_time`, `deleted`) VALUES (34, 4, '沪A7R004', '2025-11-06', '宝马授权服务中心', '制动系统检查 + 更换刹车油', 1540, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_maintain` (`id`, `auto_id`, `auto_num`, `maintain_time`, `location`, `item`, `cost`, `create_time`, `update_time`, `deleted`) VALUES (35, 9, '沪A7R009', '2025-10-18', '奔驰授权服务中心', 'A保 + 全车检测', 1860, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_maintain` (`id`, `auto_id`, `auto_num`, `maintain_time`, `location`, `item`, `cost`, `create_time`, `update_time`, `deleted`) VALUES (36, 14, '沪A7R014', '2025-10-02', '比亚迪服务中心', '电池健康检测', 620, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_maintain` (`id`, `auto_id`, `auto_num`, `maintain_time`, `location`, `item`, `cost`, `create_time`, `update_time`, `deleted`) VALUES (37, 19, '沪A7R019', '2025-09-15', '特斯拉服务中心', '空调滤芯 + 轮胎换位', 680, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_maintain` (`id`, `auto_id`, `auto_num`, `maintain_time`, `location`, `item`, `cost`, `create_time`, `update_time`, `deleted`) VALUES (38, 24, '沪A7R024', '2025-09-01', '广汽丰田4S店', '更换刹车片', 1220, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_maintain` (`id`, `auto_id`, `auto_num`, `maintain_time`, `location`, `item`, `cost`, `create_time`, `update_time`, `deleted`) VALUES (39, 29, '沪A7R029', '2025-08-18', '豪华车专修中心', '底盘检查 + 易损件更换', 2560, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_maintain` (`id`, `auto_id`, `auto_num`, `maintain_time`, `location`, `item`, `cost`, `create_time`, `update_time`, `deleted`) VALUES (40, 34, '沪A7R034', '2025-08-04', '宇通钣喷中心', '轻微剐蹭修复', 1980, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
COMMIT;

-- ----------------------------
-- Table structure for busi_order
-- ----------------------------
DROP TABLE IF EXISTS `busi_order`;
CREATE TABLE `busi_order` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '订单id',
  `order_num` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '订单编号',
  `auto_id` int DEFAULT NULL COMMENT '关联车辆id',
  `customer_id` int DEFAULT NULL COMMENT '客户id',
  `rental_time` datetime DEFAULT NULL COMMENT '出租时间',
  `type_id` int DEFAULT NULL COMMENT '出租类型',
  `rent` int DEFAULT NULL COMMENT '日租金额',
  `deposit` int DEFAULT NULL COMMENT '押金',
  `mileage` int DEFAULT NULL COMMENT '起租里程',
  `return_time` datetime DEFAULT NULL COMMENT '归还时间',
  `return_mileage` int DEFAULT NULL COMMENT '归还里程',
  `rent_payable` int DEFAULT NULL COMMENT '应付租金',
  `rent_actual` int DEFAULT NULL COMMENT '实付租金',
  `deposit_return` tinyint(1) DEFAULT NULL COMMENT '押金返还状态 0 未返还  1已返还',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of busi_order
-- ----------------------------
BEGIN;
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (1, 'CR202606250001', 3, 1, '2026-06-25 08:30:00', 1, 260, 4500, 15050, NULL, NULL, NULL, NULL, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (2, 'CR202606250002', 5, 3, '2026-06-25 09:15:00', 2, 350, 6500, 19750, NULL, NULL, NULL, NULL, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (3, 'CR202606250003', 10, 5, '2026-06-25 10:40:00', 1, 880, 16000, 25200, NULL, NULL, NULL, NULL, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (4, 'CR202606250004', 12, 7, '2026-06-25 13:00:00', 4, 160, 3000, 29900, NULL, NULL, NULL, NULL, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (5, 'CR202606250005', 14, 9, '2026-06-25 15:30:00', 8, 220, 4000, 28300, NULL, NULL, NULL, NULL, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (6, 'CR202606260006', 17, 11, '2026-06-26 09:00:00', 1, 350, 6500, 35350, NULL, NULL, NULL, NULL, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (7, 'CR202606260007', 24, 14, '2026-06-26 11:20:00', 6, 160, 3000, 45500, NULL, NULL, NULL, NULL, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (8, 'CR202606260008', 29, 18, '2026-06-26 14:10:00', 5, 530, 9500, 50950, NULL, NULL, NULL, NULL, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (9, 'CR202606270009', 36, 22, '2026-06-27 08:45:00', 7, 660, 20000, 61100, NULL, NULL, NULL, NULL, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (10, 'CR202606270010', 40, 26, '2026-06-27 09:30:00', 4, 800, 24000, 70500, NULL, NULL, NULL, NULL, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (11, 'CR202606270011', 47, 31, '2026-06-27 11:00:00', 2, 220, 4000, 76150, NULL, NULL, NULL, NULL, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (12, 'CR202606270012', 53, 37, '2026-06-27 13:20:00', 1, 740, 13500, 88450, NULL, NULL, NULL, NULL, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (13, 'CR202606220013', 36, 18, '2026-06-22 08:00:00', 6, 660, 20000, 60540, '2026-06-27 15:40:00', 61088, 3960, 3762, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (14, 'CR202606200014', 46, 25, '2026-06-20 17:00:00', 8, 880, 16000, 76745, '2026-06-27 18:05:00', 77376, 7040, 5984, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (15, 'CR202606190015', 50, 28, '2026-06-19 16:00:00', 8, 1280, 23000, 81550, '2026-06-26 18:05:00', 82264, 10240, 8704, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (16, 'CR202606170016', 4, 35, '2026-06-17 07:00:00', 2, 300, 5500, 16555, '2026-06-26 10:35:00', 17400, 3000, 2700, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (17, 'CR202606240017', 14, 42, '2026-06-24 09:00:00', 4, 220, 4000, 27360, '2026-06-26 13:10:00', 28288, 660, 495, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (18, 'CR202606220018', 24, 1, '2026-06-22 10:00:00', 6, 160, 3000, 45320, '2026-06-26 15:40:00', 45476, 800, 760, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (19, 'CR202606200019', 34, 8, '2026-06-20 12:00:00', 8, 1060, 19000, 62425, '2026-06-26 18:05:00', 62664, 7420, 6307, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (20, 'CR202606220020', 29, 5, '2026-06-22 07:00:00', 5, 530, 9500, 50580, '2026-06-25 14:25:00', 50950, 2120, 1484, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (21, 'CR202606200021', 39, 12, '2026-06-20 15:00:00', 7, 760, 23000, 67685, '2026-06-25 16:55:00', 68138, 4560, 5016, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (22, 'CR202606180022', 49, 19, '2026-06-18 07:00:00', 1, 560, 10000, 83890, '2026-06-25 09:20:00', 84426, 4480, 4480, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (23, 'CR202606160023', 3, 26, '2026-06-16 08:00:00', 3, 260, 4500, 14395, '2026-06-25 11:45:00', 15014, 2600, 2080, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (24, 'CR202606230024', 13, 33, '2026-06-23 10:00:00', 5, 180, 3000, 31500, '2026-06-25 14:25:00', 32250, 540, 378, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (25, 'CR202606210025', 23, 40, '2026-06-21 11:00:00', 7, 1280, 23000, 42305, '2026-06-25 16:55:00', 43138, 6400, 7040, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (26, 'CR202606150026', 15, 35, '2026-06-15 05:00:00', 3, 260, 4500, 29710, '2026-06-24 11:45:00', 30626, 2600, 2080, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (27, 'CR202606220027', 25, 42, '2026-06-22 07:00:00', 5, 180, 3000, 47670, '2026-06-24 14:25:00', 47814, 540, 378, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (28, 'CR202606200028', 35, 1, '2026-06-20 15:00:00', 7, 1460, 26500, 58475, '2026-06-24 16:55:00', 58750, 7300, 8030, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (29, 'CR202606180029', 45, 8, '2026-06-18 07:00:00', 1, 560, 10000, 73780, '2026-06-24 09:20:00', 74138, 3920, 3920, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (30, 'CR202606160030', 55, 15, '2026-06-16 08:00:00', 3, 680, 20500, 89085, '2026-06-24 11:45:00', 89526, 6120, 4896, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (31, 'CR202606180031', 50, 12, '2026-06-18 14:00:00', 8, 1280, 23000, 81740, '2026-06-23 18:05:00', 82264, 7680, 6528, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (32, 'CR202606160032', 4, 19, '2026-06-16 05:00:00', 2, 300, 5500, 16745, '2026-06-23 10:35:00', 17400, 2400, 2160, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (33, 'CR202606140033', 14, 26, '2026-06-14 07:00:00', 4, 220, 4000, 27550, '2026-06-23 13:10:00', 28288, 2200, 1650, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (34, 'CR202606210034', 24, 33, '2026-06-21 08:00:00', 6, 160, 3000, 44655, '2026-06-23 15:40:00', 45476, 480, 456, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (35, 'CR202606130035', 22, 32, '2026-06-13 12:00:00', 4, 880, 16000, 39860, '2026-06-22 13:10:00', 40764, 8800, 6600, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (36, 'CR202606200036', 32, 39, '2026-06-20 13:00:00', 6, 740, 13500, 57820, '2026-06-22 15:40:00', 58000, 2220, 2109, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (37, 'CR202606180037', 42, 46, '2026-06-18 15:00:00', 8, 920, 27500, 68625, '2026-06-22 18:05:00', 68888, 4600, 3910, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (38, 'CR202606160038', 52, 5, '2026-06-16 06:00:00', 2, 530, 9500, 83930, '2026-06-22 10:35:00', 84276, 3710, 3339, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (39, 'CR202606140039', 6, 12, '2026-06-14 08:00:00', 4, 420, 7500, 21635, '2026-06-22 13:10:00', 22064, 3780, 2835, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (40, 'CR202606160040', 1, 9, '2026-06-16 03:00:00', 1, 180, 3000, 9790, '2026-06-21 09:20:00', 10350, 1080, 1080, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (41, 'CR202606140041', 11, 16, '2026-06-14 04:00:00', 3, 1280, 23000, 26895, '2026-06-21 11:45:00', 27538, 10240, 8192, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (42, 'CR202606120042', 21, 23, '2026-06-12 13:00:00', 5, 680, 12000, 37700, '2026-06-21 14:25:00', 38426, 6800, 4760, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (43, 'CR202606190043', 31, 30, '2026-06-19 14:00:00', 7, 660, 12000, 54805, '2026-06-21 16:55:00', 55614, 1980, 2178, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (44, 'CR202606110044', 29, 29, '2026-06-11 11:00:00', 5, 530, 9500, 50010, '2026-06-20 14:25:00', 50950, 5300, 3710, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (45, 'CR202606180045', 39, 36, '2026-06-18 12:00:00', 7, 760, 23000, 67970, '2026-06-20 16:55:00', 68138, 2280, 2508, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (46, 'CR202606160046', 49, 43, '2026-06-16 04:00:00', 1, 560, 10000, 84175, '2026-06-20 09:20:00', 84426, 2800, 2800, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (47, 'CR202606140047', 3, 2, '2026-06-14 05:00:00', 3, 260, 4500, 14680, '2026-06-20 11:45:00', 15014, 1820, 1456, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (48, 'CR202606150048', 1, 1, '2026-06-15 02:00:00', 1, 180, 3000, 9885, '2026-06-19 09:20:00', 10350, 900, 900, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (49, 'CR202606130049', 11, 8, '2026-06-13 10:00:00', 3, 1280, 23000, 26990, '2026-06-19 11:45:00', 27538, 8960, 7168, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (50, 'CR202606110050', 21, 15, '2026-06-11 12:00:00', 5, 680, 12000, 37795, '2026-06-19 14:25:00', 38426, 6120, 4284, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (51, 'CR202606180051', 31, 22, '2026-06-18 13:00:00', 7, 660, 12000, 54900, '2026-06-19 16:55:00', 55614, 1320, 1452, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (52, 'CR202606100052', 29, 21, '2026-06-10 10:00:00', 5, 530, 9500, 50105, '2026-06-18 14:25:00', 50950, 4770, 3339, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (53, 'CR202606170053', 39, 28, '2026-06-17 11:00:00', 7, 760, 23000, 67210, '2026-06-18 16:55:00', 68138, 1520, 1672, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (54, 'CR202606150054', 49, 35, '2026-06-15 03:00:00', 1, 560, 10000, 84270, '2026-06-18 09:20:00', 84426, 2240, 2240, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (55, 'CR202606130055', 3, 42, '2026-06-13 04:00:00', 3, 260, 4500, 14775, '2026-06-18 11:45:00', 15014, 1560, 1248, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (56, 'CR202606140056', 1, 41, '2026-06-14 08:00:00', 1, 180, 3000, 9980, '2026-06-17 09:20:00', 10350, 720, 720, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (57, 'CR202606120057', 11, 48, '2026-06-12 09:00:00', 3, 1280, 23000, 27085, '2026-06-17 11:45:00', 27538, 7680, 6144, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (58, 'CR202606100058', 21, 7, '2026-06-10 11:00:00', 5, 680, 12000, 37890, '2026-06-17 14:25:00', 38426, 5440, 3808, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (59, 'CR202606100059', 22, 8, '2026-06-10 09:00:00', 4, 880, 16000, 40145, '2026-06-16 13:10:00', 40764, 6160, 4620, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (60, 'CR202606080060', 32, 15, '2026-06-08 10:00:00', 6, 740, 13500, 57250, '2026-06-16 15:40:00', 58000, 6660, 6327, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (61, 'CR202606150061', 42, 22, '2026-06-15 12:00:00', 8, 920, 27500, 68055, '2026-06-16 18:05:00', 68888, 1840, 1564, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (62, 'CR202606060062', 43, 23, '2026-06-06 09:00:00', 7, 180, 3000, 70310, '2026-06-15 16:55:00', 71226, 1800, 1980, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (63, 'CR202606130063', 53, 30, '2026-06-13 08:00:00', 1, 740, 13500, 88270, '2026-06-15 09:20:00', 88414, 2220, 2220, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (64, 'CR202606110064', 7, 37, '2026-06-11 09:00:00', 3, 480, 8500, 17875, '2026-06-15 11:45:00', 18150, 2400, 1920, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (65, 'CR202606110065', 8, 38, '2026-06-11 07:00:00', 2, 560, 10000, 20130, '2026-06-14 10:35:00', 20488, 2240, 2016, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (66, 'CR202606090066', 18, 45, '2026-06-09 09:00:00', 4, 420, 7500, 37235, '2026-06-14 13:10:00', 37676, 2520, 1890, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (67, 'CR202606070067', 28, 4, '2026-06-07 10:00:00', 6, 480, 8500, 48040, '2026-06-14 15:40:00', 48564, 3840, 3648, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (68, 'CR202606060068', 29, 5, '2026-06-06 08:00:00', 5, 530, 9500, 50295, '2026-06-12 14:25:00', 50950, 3710, 2597, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (69, 'CR202606040069', 39, 12, '2026-06-04 09:00:00', 7, 760, 23000, 67400, '2026-06-12 16:55:00', 68138, 6840, 7524, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (70, 'CR202606110070', 49, 19, '2026-06-11 08:00:00', 1, 560, 10000, 83605, '2026-06-12 09:20:00', 84426, 1120, 1120, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (71, 'CR202606010071', 50, 20, '2026-06-01 16:00:00', 8, 1280, 23000, 81360, '2026-06-10 18:05:00', 82264, 12800, 10880, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (72, 'CR202606080072', 4, 27, '2026-06-08 07:00:00', 2, 300, 5500, 17220, '2026-06-10 10:35:00', 17400, 900, 810, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (73, 'CR202606060073', 14, 34, '2026-06-06 09:00:00', 4, 220, 4000, 28025, '2026-06-10 13:10:00', 28288, 1100, 825, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (74, 'CR202606050074', 15, 35, '2026-06-05 06:00:00', 3, 260, 4500, 30280, '2026-06-08 11:45:00', 30626, 1040, 832, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (75, 'CR202606030075', 25, 42, '2026-06-03 08:00:00', 5, 180, 3000, 47385, '2026-06-08 14:25:00', 47814, 1080, 756, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (76, 'CR202606010076', 35, 1, '2026-06-01 09:00:00', 7, 1460, 26500, 58190, '2026-06-08 16:55:00', 58750, 11680, 12848, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (77, 'CR202605300077', 36, 2, '2026-05-30 14:00:00', 6, 660, 20000, 60445, '2026-06-05 15:40:00', 61088, 4620, 4389, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (78, 'CR202605280078', 46, 9, '2026-05-28 16:00:00', 8, 880, 16000, 76650, '2026-06-05 18:05:00', 77376, 7920, 6732, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (79, 'CR202606040079', 56, 16, '2026-06-04 07:00:00', 2, 850, 25500, 93755, '2026-06-05 10:35:00', 94564, 1700, 1530, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (80, 'CR202605250080', 1, 17, '2026-05-25 05:00:00', 1, 180, 3000, 9410, '2026-06-03 09:20:00', 10350, 1800, 1800, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (81, 'CR202606010081', 11, 24, '2026-06-01 06:00:00', 3, 1280, 23000, 27370, '2026-06-03 11:45:00', 27538, 3840, 3072, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (82, 'CR202605300082', 21, 31, '2026-05-30 08:00:00', 5, 680, 12000, 38175, '2026-06-03 14:25:00', 38426, 3400, 2380, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (83, 'CR202605290083', 22, 32, '2026-05-29 06:00:00', 4, 880, 16000, 40430, '2026-06-01 13:10:00', 40764, 3520, 2640, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (84, 'CR202605270084', 32, 39, '2026-05-27 14:00:00', 6, 740, 13500, 57535, '2026-06-01 15:40:00', 58000, 4440, 4218, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (85, 'CR202605230085', 36, 42, '2026-05-23 13:00:00', 6, 660, 20000, 60540, '2026-05-28 15:40:00', 61088, 3960, 3762, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (86, 'CR202605210086', 46, 1, '2026-05-21 15:00:00', 8, 880, 16000, 76745, '2026-05-28 18:05:00', 77376, 7040, 5984, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (87, 'CR202605190087', 56, 8, '2026-05-19 06:00:00', 2, 850, 25500, 93850, '2026-05-28 10:35:00', 94564, 8500, 7650, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (88, 'CR202605120088', 1, 9, '2026-05-12 04:00:00', 1, 180, 3000, 9505, '2026-05-20 09:20:00', 10350, 1620, 1620, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (89, 'CR202605190089', 11, 16, '2026-05-19 05:00:00', 3, 1280, 23000, 26610, '2026-05-20 11:45:00', 27538, 2560, 2048, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (90, 'CR202605170090', 21, 23, '2026-05-17 07:00:00', 5, 680, 12000, 38270, '2026-05-20 14:25:00', 38426, 2720, 1904, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (91, 'CR202605100091', 22, 24, '2026-05-10 12:00:00', 4, 880, 16000, 40525, '2026-05-12 13:10:00', 40764, 2640, 1980, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (92, 'CR202605080092', 32, 31, '2026-05-08 13:00:00', 6, 740, 13500, 57630, '2026-05-12 15:40:00', 58000, 3700, 3515, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (93, 'CR202605060093', 42, 38, '2026-05-06 15:00:00', 8, 920, 27500, 68435, '2026-05-12 18:05:00', 68888, 6440, 5474, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (94, 'CR202604300094', 43, 39, '2026-04-30 12:00:00', 7, 180, 3000, 70690, '2026-05-05 16:55:00', 71226, 1080, 1188, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (95, 'CR202604280095', 53, 46, '2026-04-28 04:00:00', 1, 740, 13500, 87795, '2026-05-05 09:20:00', 88414, 5920, 5920, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (96, 'CR202604180096', 1, 1, '2026-04-18 03:00:00', 1, 180, 3000, 9600, '2026-04-25 09:20:00', 10350, 1440, 1440, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (97, 'CR202604160097', 11, 8, '2026-04-16 04:00:00', 3, 1280, 23000, 26705, '2026-04-25 11:45:00', 27538, 12800, 10240, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (98, 'CR202604230098', 21, 15, '2026-04-23 13:00:00', 5, 680, 12000, 37510, '2026-04-25 14:25:00', 38426, 2040, 1428, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (99, 'CR202604090099', 22, 16, '2026-04-09 11:00:00', 4, 880, 16000, 40620, '2026-04-10 13:10:00', 40764, 1760, 1320, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (100, 'CR202604070100', 32, 23, '2026-04-07 12:00:00', 6, 740, 13500, 57725, '2026-04-10 15:40:00', 58000, 2960, 2812, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (101, 'CR202603150101', 36, 26, '2026-03-15 11:00:00', 6, 660, 20000, 60730, '2026-03-18 15:40:00', 61088, 2640, 2508, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (102, 'CR202603130102', 46, 33, '2026-03-13 13:00:00', 8, 880, 16000, 76935, '2026-03-18 18:05:00', 77376, 5280, 4488, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (103, 'CR202602070103', 50, 36, '2026-02-07 12:00:00', 8, 1280, 23000, 81740, '2026-02-12 18:05:00', 82264, 7680, 6528, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (104, 'CR202602050104', 4, 43, '2026-02-05 03:00:00', 2, 300, 5500, 16745, '2026-02-12 10:35:00', 17400, 2400, 2160, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (105, 'CR202601010105', 8, 46, '2026-01-01 09:00:00', 2, 560, 10000, 19750, '2026-01-08 10:35:00', 20488, 4480, 4032, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (106, 'CR202512300106', 18, 5, '2025-12-30 11:00:00', 4, 420, 7500, 36855, '2026-01-08 13:10:00', 37676, 4200, 3150, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (107, 'CR202512110107', 22, 8, '2025-12-11 10:00:00', 4, 880, 16000, 39860, '2025-12-20 13:10:00', 40764, 8800, 6600, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_order` (`id`, `order_num`, `auto_id`, `customer_id`, `rental_time`, `type_id`, `rent`, `deposit`, `mileage`, `return_time`, `return_mileage`, `rent_payable`, `rent_actual`, `deposit_return`, `create_time`, `update_time`, `deleted`) VALUES (108, 'CR202512180108', 32, 15, '2025-12-18 11:00:00', 6, 740, 13500, 57820, '2025-12-20 15:40:00', 58000, 2220, 2109, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
COMMIT;

-- ----------------------------
-- Table structure for busi_rental_type
-- ----------------------------
DROP TABLE IF EXISTS `busi_rental_type`;
CREATE TABLE `busi_rental_type` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '出租类型id',
  `type_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '出租类型名称',
  `type_discount` double DEFAULT NULL COMMENT '享受折扣',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '备注',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of busi_rental_type
-- ----------------------------
BEGIN;
INSERT INTO `busi_rental_type` (`id`, `type_name`, `type_discount`, `remark`, `create_time`, `update_time`, `deleted`) VALUES (1, '日租', 1, '按日计费，不享受折扣', '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_rental_type` (`id`, `type_name`, `type_discount`, `remark`, `create_time`, `update_time`, `deleted`) VALUES (2, '周租', 0.9, '连续租满7天，享受9折优惠', '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_rental_type` (`id`, `type_name`, `type_discount`, `remark`, `create_time`, `update_time`, `deleted`) VALUES (3, '月租', 0.8, '连续租满30天，享受8折优惠', '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_rental_type` (`id`, `type_name`, `type_discount`, `remark`, `create_time`, `update_time`, `deleted`) VALUES (4, 'VIP会员', 0.75, 'VIP会员专享7.5折', '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_rental_type` (`id`, `type_name`, `type_discount`, `remark`, `create_time`, `update_time`, `deleted`) VALUES (5, '企业长租', 0.7, '企业客户长期合作专享7折', '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_rental_type` (`id`, `type_name`, `type_discount`, `remark`, `create_time`, `update_time`, `deleted`) VALUES (6, '节假日套餐', 0.95, '节假日期间短租优惠', '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_rental_type` (`id`, `type_name`, `type_discount`, `remark`, `create_time`, `update_time`, `deleted`) VALUES (7, '接送短租', 1.1, '含门店接送服务，按服务价计费', '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_rental_type` (`id`, `type_name`, `type_discount`, `remark`, `create_time`, `update_time`, `deleted`) VALUES (8, '新能源专享', 0.85, '新能源车型专享折扣', '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
COMMIT;

-- ----------------------------
-- Table structure for busi_violation
-- ----------------------------
DROP TABLE IF EXISTS `busi_violation`;
CREATE TABLE `busi_violation` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '违章id',
  `auto_id` int DEFAULT NULL COMMENT '车辆id',
  `auto_num` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '车牌号码',
  `violation_time` datetime DEFAULT NULL COMMENT '违章时间',
  `reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '违章事由',
  `location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '违章地点',
  `deduct_points` int DEFAULT NULL COMMENT '扣分',
  `fine` int DEFAULT NULL COMMENT '罚款',
  `status` tinyint(1) DEFAULT NULL COMMENT '是否处理 0 -未处理  1-已处理',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of busi_violation
-- ----------------------------
BEGIN;
INSERT INTO `busi_violation` (`id`, `auto_id`, `auto_num`, `violation_time`, `reason`, `location`, `deduct_points`, `fine`, `status`, `create_time`, `update_time`, `deleted`) VALUES (1, 2, '沪A7R002', '2026-06-27 09:18:00', '违反禁止标线指示', '上海市浦东新区世纪大道', 3, 200, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_violation` (`id`, `auto_id`, `auto_num`, `violation_time`, `reason`, `location`, `deduct_points`, `fine`, `status`, `create_time`, `update_time`, `deleted`) VALUES (2, 6, '沪A7R006', '2026-06-26 18:40:00', '违法停车', 'G15沈海高速上海段', 0, 200, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_violation` (`id`, `auto_id`, `auto_num`, `violation_time`, `reason`, `location`, `deduct_points`, `fine`, `status`, `create_time`, `update_time`, `deleted`) VALUES (3, 10, '沪A7R010', '2026-06-25 12:10:00', '机动车超速20%以下', '上海市黄浦区南京东路', 3, 200, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_violation` (`id`, `auto_id`, `auto_num`, `violation_time`, `reason`, `location`, `deduct_points`, `fine`, `status`, `create_time`, `update_time`, `deleted`) VALUES (4, 14, '沪A7R014', '2026-06-24 17:55:00', '闯红灯', '上海市徐汇区漕溪北路', 6, 200, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_violation` (`id`, `auto_id`, `auto_num`, `violation_time`, `reason`, `location`, `deduct_points`, `fine`, `status`, `create_time`, `update_time`, `deleted`) VALUES (5, 18, '沪A7R018', '2026-06-23 09:15:00', '未按规定车道行驶', '上海市静安区延安中路', 2, 100, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_violation` (`id`, `auto_id`, `auto_num`, `violation_time`, `reason`, `location`, `deduct_points`, `fine`, `status`, `create_time`, `update_time`, `deleted`) VALUES (6, 22, '沪A7R022', '2026-06-22 14:20:00', '夜间不按规定使用灯光', 'S20外环高速', 1, 100, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_violation` (`id`, `auto_id`, `auto_num`, `violation_time`, `reason`, `location`, `deduct_points`, `fine`, `status`, `create_time`, `update_time`, `deleted`) VALUES (7, 26, '沪A7R026', '2026-06-21 21:00:00', '机动车超速50%以上', '上海市虹口区四川北路', 12, 1000, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_violation` (`id`, `auto_id`, `auto_num`, `violation_time`, `reason`, `location`, `deduct_points`, `fine`, `status`, `create_time`, `update_time`, `deleted`) VALUES (8, 30, '沪A7R030', '2026-06-20 10:30:00', '占用公交专用道', '上海市杨浦区四平路', 3, 200, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_violation` (`id`, `auto_id`, `auto_num`, `violation_time`, `reason`, `location`, `deduct_points`, `fine`, `status`, `create_time`, `update_time`, `deleted`) VALUES (9, 34, '沪A7R034', '2026-06-19 08:00:00', '违反禁止标线指示', '上海市浦东新区世纪大道', 3, 200, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_violation` (`id`, `auto_id`, `auto_num`, `violation_time`, `reason`, `location`, `deduct_points`, `fine`, `status`, `create_time`, `update_time`, `deleted`) VALUES (10, 38, '沪A7R038', '2026-06-18 18:30:00', '违法停车', 'G15沈海高速上海段', 0, 200, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_violation` (`id`, `auto_id`, `auto_num`, `violation_time`, `reason`, `location`, `deduct_points`, `fine`, `status`, `create_time`, `update_time`, `deleted`) VALUES (11, 42, '沪A7R042', '2026-06-17 16:45:00', '机动车超速20%以下', '上海市黄浦区南京东路', 3, 200, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_violation` (`id`, `auto_id`, `auto_num`, `violation_time`, `reason`, `location`, `deduct_points`, `fine`, `status`, `create_time`, `update_time`, `deleted`) VALUES (12, 46, '沪A7R046', '2026-06-16 11:20:00', '闯红灯', '上海市徐汇区漕溪北路', 6, 200, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_violation` (`id`, `auto_id`, `auto_num`, `violation_time`, `reason`, `location`, `deduct_points`, `fine`, `status`, `create_time`, `update_time`, `deleted`) VALUES (13, 50, '沪A7R050', '2026-06-14 19:10:00', '未按规定车道行驶', '上海市静安区延安中路', 2, 100, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_violation` (`id`, `auto_id`, `auto_num`, `violation_time`, `reason`, `location`, `deduct_points`, `fine`, `status`, `create_time`, `update_time`, `deleted`) VALUES (14, 54, '沪A7R054', '2026-06-12 07:55:00', '夜间不按规定使用灯光', 'S20外环高速', 1, 100, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_violation` (`id`, `auto_id`, `auto_num`, `violation_time`, `reason`, `location`, `deduct_points`, `fine`, `status`, `create_time`, `update_time`, `deleted`) VALUES (15, 2, '沪A7R002', '2026-06-09 13:35:00', '机动车超速50%以上', '上海市虹口区四川北路', 12, 1000, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_violation` (`id`, `auto_id`, `auto_num`, `violation_time`, `reason`, `location`, `deduct_points`, `fine`, `status`, `create_time`, `update_time`, `deleted`) VALUES (16, 6, '沪A7R006', '2026-06-05 20:05:00', '占用公交专用道', '上海市杨浦区四平路', 3, 200, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_violation` (`id`, `auto_id`, `auto_num`, `violation_time`, `reason`, `location`, `deduct_points`, `fine`, `status`, `create_time`, `update_time`, `deleted`) VALUES (17, 10, '沪A7R010', '2026-05-28 09:25:00', '违反禁止标线指示', '上海市浦东新区世纪大道', 3, 200, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_violation` (`id`, `auto_id`, `auto_num`, `violation_time`, `reason`, `location`, `deduct_points`, `fine`, `status`, `create_time`, `update_time`, `deleted`) VALUES (18, 14, '沪A7R014', '2026-05-20 17:12:00', '违法停车', 'G15沈海高速上海段', 0, 200, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_violation` (`id`, `auto_id`, `auto_num`, `violation_time`, `reason`, `location`, `deduct_points`, `fine`, `status`, `create_time`, `update_time`, `deleted`) VALUES (19, 18, '沪A7R018', '2026-05-11 15:44:00', '机动车超速20%以下', '上海市黄浦区南京东路', 3, 200, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_violation` (`id`, `auto_id`, `auto_num`, `violation_time`, `reason`, `location`, `deduct_points`, `fine`, `status`, `create_time`, `update_time`, `deleted`) VALUES (20, 22, '沪A7R022', '2026-05-03 08:16:00', '闯红灯', '上海市徐汇区漕溪北路', 6, 200, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_violation` (`id`, `auto_id`, `auto_num`, `violation_time`, `reason`, `location`, `deduct_points`, `fine`, `status`, `create_time`, `update_time`, `deleted`) VALUES (21, 26, '沪A7R026', '2026-04-25 11:08:00', '未按规定车道行驶', '上海市静安区延安中路', 2, 100, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_violation` (`id`, `auto_id`, `auto_num`, `violation_time`, `reason`, `location`, `deduct_points`, `fine`, `status`, `create_time`, `update_time`, `deleted`) VALUES (22, 30, '沪A7R030', '2026-04-09 22:30:00', '夜间不按规定使用灯光', 'S20外环高速', 1, 100, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_violation` (`id`, `auto_id`, `auto_num`, `violation_time`, `reason`, `location`, `deduct_points`, `fine`, `status`, `create_time`, `update_time`, `deleted`) VALUES (23, 34, '沪A7R034', '2026-03-18 10:11:00', '机动车超速50%以上', '上海市虹口区四川北路', 12, 1000, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_violation` (`id`, `auto_id`, `auto_num`, `violation_time`, `reason`, `location`, `deduct_points`, `fine`, `status`, `create_time`, `update_time`, `deleted`) VALUES (24, 38, '沪A7R038', '2026-02-12 14:19:00', '占用公交专用道', '上海市杨浦区四平路', 3, 200, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_violation` (`id`, `auto_id`, `auto_num`, `violation_time`, `reason`, `location`, `deduct_points`, `fine`, `status`, `create_time`, `update_time`, `deleted`) VALUES (25, 42, '沪A7R042', '2026-01-08 18:28:00', '违反禁止标线指示', '上海市浦东新区世纪大道', 3, 200, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_violation` (`id`, `auto_id`, `auto_num`, `violation_time`, `reason`, `location`, `deduct_points`, `fine`, `status`, `create_time`, `update_time`, `deleted`) VALUES (26, 46, '沪A7R046', '2025-12-20 08:45:00', '违法停车', 'G15沈海高速上海段', 0, 200, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_violation` (`id`, `auto_id`, `auto_num`, `violation_time`, `reason`, `location`, `deduct_points`, `fine`, `status`, `create_time`, `update_time`, `deleted`) VALUES (27, 50, '沪A7R050', '2025-11-16 13:06:00', '机动车超速20%以下', '上海市黄浦区南京东路', 3, 200, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_violation` (`id`, `auto_id`, `auto_num`, `violation_time`, `reason`, `location`, `deduct_points`, `fine`, `status`, `create_time`, `update_time`, `deleted`) VALUES (28, 54, '沪A7R054', '2025-10-02 19:52:00', '闯红灯', '上海市徐汇区漕溪北路', 6, 200, 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_violation` (`id`, `auto_id`, `auto_num`, `violation_time`, `reason`, `location`, `deduct_points`, `fine`, `status`, `create_time`, `update_time`, `deleted`) VALUES (29, 2, '沪A7R002', '2025-09-15 16:31:00', '未按规定车道行驶', '上海市静安区延安中路', 2, 100, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `busi_violation` (`id`, `auto_id`, `auto_num`, `violation_time`, `reason`, `location`, `deduct_points`, `fine`, `status`, `create_time`, `update_time`, `deleted`) VALUES (30, 6, '沪A7R006', '2025-08-04 12:42:00', '夜间不按规定使用灯光', 'S20外环高速', 1, 100, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
COMMIT;

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `dept_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '部门名称',
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '联系电话',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '部门地址',
  `pid` int DEFAULT NULL COMMENT '上级部门id',
  `parent_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '上级部门名称',
  `order_num` int DEFAULT '0' COMMENT '排序号',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of sys_dept
-- ----------------------------
BEGIN;
INSERT INTO `sys_dept` (`id`, `dept_name`, `phone`, `address`, `pid`, `parent_name`, `order_num`, `deleted`) VALUES (1, 'CloudRent汽车租赁集团', '021-68881000', '上海市浦东新区世纪大道100号', 0, NULL, 1, 0);
INSERT INTO `sys_dept` (`id`, `dept_name`, `phone`, `address`, `pid`, `parent_name`, `order_num`, `deleted`) VALUES (2, '总经办', '021-68881001', '上海市浦东新区世纪大道100号A座20楼', 1, 'CloudRent汽车租赁集团', 1, 0);
INSERT INTO `sys_dept` (`id`, `dept_name`, `phone`, `address`, `pid`, `parent_name`, `order_num`, `deleted`) VALUES (3, '综合管理部', '021-68881002', '上海市浦东新区世纪大道100号A座18楼', 1, 'CloudRent汽车租赁集团', 2, 0);
INSERT INTO `sys_dept` (`id`, `dept_name`, `phone`, `address`, `pid`, `parent_name`, `order_num`, `deleted`) VALUES (4, '运营中心', '021-68881003', '上海市浦东新区世纪大道100号A座12楼', 1, 'CloudRent汽车租赁集团', 3, 0);
INSERT INTO `sys_dept` (`id`, `dept_name`, `phone`, `address`, `pid`, `parent_name`, `order_num`, `deleted`) VALUES (5, '门店运营一组', '021-68881004', '上海市黄浦区南京东路88号', 4, '运营中心', 1, 0);
INSERT INTO `sys_dept` (`id`, `dept_name`, `phone`, `address`, `pid`, `parent_name`, `order_num`, `deleted`) VALUES (6, '门店运营二组', '021-68881005', '上海市徐汇区漕溪北路66号', 4, '运营中心', 2, 0);
INSERT INTO `sys_dept` (`id`, `dept_name`, `phone`, `address`, `pid`, `parent_name`, `order_num`, `deleted`) VALUES (7, '客户服务部', '021-68881006', '上海市浦东新区世纪大道100号A座8楼', 4, '运营中心', 3, 0);
INSERT INTO `sys_dept` (`id`, `dept_name`, `phone`, `address`, `pid`, `parent_name`, `order_num`, `deleted`) VALUES (8, '车辆管理中心', '021-68881007', '上海市浦东新区龙东大道3000号', 1, 'CloudRent汽车租赁集团', 4, 0);
INSERT INTO `sys_dept` (`id`, `dept_name`, `phone`, `address`, `pid`, `parent_name`, `order_num`, `deleted`) VALUES (9, '车队调度部', '021-68881008', '上海市浦东新区龙东大道3000号1号楼', 8, '车辆管理中心', 1, 0);
INSERT INTO `sys_dept` (`id`, `dept_name`, `phone`, `address`, `pid`, `parent_name`, `order_num`, `deleted`) VALUES (10, '车辆维保部', '021-68881009', '上海市浦东新区龙东大道3000号维修车间', 8, '车辆管理中心', 2, 0);
INSERT INTO `sys_dept` (`id`, `dept_name`, `phone`, `address`, `pid`, `parent_name`, `order_num`, `deleted`) VALUES (11, '财务中心', '021-68881010', '上海市浦东新区世纪大道100号A座16楼', 1, 'CloudRent汽车租赁集团', 5, 0);
INSERT INTO `sys_dept` (`id`, `dept_name`, `phone`, `address`, `pid`, `parent_name`, `order_num`, `deleted`) VALUES (12, '结算组', '021-68881011', '上海市浦东新区世纪大道100号A座16楼', 11, '财务中心', 1, 0);
INSERT INTO `sys_dept` (`id`, `dept_name`, `phone`, `address`, `pid`, `parent_name`, `order_num`, `deleted`) VALUES (13, '风控稽核部', '021-68881012', '上海市浦东新区世纪大道100号A座15楼', 1, 'CloudRent汽车租赁集团', 6, 0);
INSERT INTO `sys_dept` (`id`, `dept_name`, `phone`, `address`, `pid`, `parent_name`, `order_num`, `deleted`) VALUES (14, '信息技术部', '021-68881013', '上海市浦东新区世纪大道100号A座10楼', 1, 'CloudRent汽车租赁集团', 7, 0);
COMMIT;

-- ----------------------------
-- Table structure for sys_permission
-- ----------------------------
DROP TABLE IF EXISTS `sys_permission`;
CREATE TABLE `sys_permission` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '权限id',
  `permission_lable` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '权限名称',
  `pid` int DEFAULT NULL COMMENT '父权限id',
  `parent_label` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '父权限名称',
  `permission_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '权限标识',
  `route_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '权限路由地址',
  `route_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '权限路由名称',
  `route_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '权限路径',
  `permission_type` tinyint(1) DEFAULT NULL COMMENT '权限类型 权限类型 0-根目录  1-子目录  2-按钮级别',
  `icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '图标地址',
  `order_num` int DEFAULT NULL COMMENT '排序',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '备注',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=80 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of sys_permission
-- ----------------------------
BEGIN;
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (1, '数据初始', 0, '根目录', 'auto:manager', '/auto', 'auto', '/auto/auto', 0, 'OfficeBuilding', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (2, '概览', 1, '数据初始', 'dashboard:view', '/dashboard', 'dashboard', '/dashboard', 1, 'Odometer', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (3, '车辆信息', 1, '数据初始', 'auto:info', '/autoInfoList', 'autoInfoList', '/auto/info/autoInfoList', 1, 'Van', 2, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (4, '厂商品牌', 1, '数据初始', 'auto:makerBrand', '/makerList', 'makerList', '/auto/maker/makerList', 1, 'OfficeBuilding', 3, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (5, '出租类型', 1, '数据初始', 'auto:rentalType', '/rentalTypeList', 'rentalTypeList', '/auto/rentalType/rentalTypeList', 1, 'PriceTag', 4, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (20, '日常业务', 0, '根目录', 'busi:manager', '/busi', 'busi', '/busi/busi', 0, 'Tickets', 2, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (21, '汽车出租', 20, '日常业务', 'busi:rental', '/rentalList', 'rentalList', '/busi/rental/rentalList', 1, 'Key', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (22, '车辆归还', 20, '日常业务', 'busi:return', '/returnList', 'returnList', '/busi/rental/returnList', 1, 'RefreshLeft', 2, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (23, '订单总览', 20, '日常业务', 'busi:order', '/orderList', 'orderList', '/busi/rental/orderList', 1, 'Tickets', 3, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (24, '客户管理', 20, '日常业务', 'busi:customer', '/customerList', 'customerList', '/busi/customer/customerList', 1, 'User', 4, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (25, '违章处理', 20, '日常业务', 'busi:violation', '/violationList', 'violationList', '/busi/violation/violationList', 1, 'Warning', 5, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (26, '车辆保养', 20, '日常业务', 'busi:maintain', '/maintainList', 'maintainList', '/busi/maintain/maintainList', 1, 'Tools', 6, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (40, '财务中心', 0, '根目录', 'finance:manager', '/financeCenter', 'financeCenter', '/finance/finance', 0, 'TrendCharts', 3, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (41, '财务报表', 40, '财务中心', 'finance:report', '/finance', 'finance', '/finance', 1, 'TrendCharts', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (60, '系统管理', 0, '根目录', 'sys:manager', '/system', 'system', '/system/system', 0, 'Setting', 4, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (61, '权限管理', 60, '系统管理', 'sys:permissionCenter', '/system', 'permissionCenter', '/system/system', 1, 'Setting', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (62, '用户管理', 61, '权限管理', 'sys:user', '/userList', 'userList', '/system/user/userList', 1, 'User', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (63, '部门管理', 61, '权限管理', 'sys:dept', '/deptList', 'deptList', '/system/dept/deptList', 1, 'OfficeBuilding', 2, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (64, '角色管理', 61, '权限管理', 'sys:role', '/roleList', 'roleList', '/system/role/roleList', 1, 'UserFilled', 3, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (65, '菜单管理', 61, '权限管理', 'sys:permission', '/permission', 'permission', '/system/permission/perr', 1, 'Setting', 4, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (100, '新增', 3, '车辆信息', 'auto:info:add', NULL, NULL, NULL, 2, NULL, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (101, '修改', 3, '车辆信息', 'auto:info:edit', NULL, NULL, NULL, 2, NULL, 2, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (102, '删除', 3, '车辆信息', 'auto:info:delete', NULL, NULL, NULL, 2, NULL, 3, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (103, '查询', 3, '车辆信息', 'auto:info:select', NULL, NULL, NULL, 2, NULL, 4, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (104, '新增', 4, '厂商品牌', 'auto:maker:add', NULL, NULL, NULL, 2, NULL, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (105, '修改', 4, '厂商品牌', 'auto:maker:edit', NULL, NULL, NULL, 2, NULL, 2, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (106, '删除', 4, '厂商品牌', 'auto:maker:delete', NULL, NULL, NULL, 2, NULL, 3, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (107, '查询', 4, '厂商品牌', 'auto:maker:select', NULL, NULL, NULL, 2, NULL, 4, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (108, '新增', 4, '厂商品牌', 'auto:brand:add', NULL, NULL, NULL, 2, NULL, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (109, '修改', 4, '厂商品牌', 'auto:brand:edit', NULL, NULL, NULL, 2, NULL, 2, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (110, '删除', 4, '厂商品牌', 'auto:brand:delete', NULL, NULL, NULL, 2, NULL, 3, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (111, '查询', 4, '厂商品牌', 'auto:brand:select', NULL, NULL, NULL, 2, NULL, 4, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (112, '新增', 5, '出租类型', 'auto:rentalType:add', NULL, NULL, NULL, 2, NULL, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (113, '修改', 5, '出租类型', 'auto:rentalType:edit', NULL, NULL, NULL, 2, NULL, 2, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (114, '删除', 5, '出租类型', 'auto:rentalType:delete', NULL, NULL, NULL, 2, NULL, 3, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (115, '查询', 5, '出租类型', 'auto:rentalType:select', NULL, NULL, NULL, 2, NULL, 4, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (116, '出租', 21, '汽车出租', 'busi:rental:rent', NULL, NULL, NULL, 2, NULL, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (117, '查询', 21, '汽车出租', 'busi:rental:select', NULL, NULL, NULL, 2, NULL, 2, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (118, '归还', 22, '车辆归还', 'busi:return:return', NULL, NULL, NULL, 2, NULL, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (119, '查询', 22, '车辆归还', 'busi:return:select', NULL, NULL, NULL, 2, NULL, 2, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (120, '查询', 23, '订单总览', 'busi:order:select', NULL, NULL, NULL, 2, NULL, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (121, '详情', 23, '订单总览', 'busi:order:detail', NULL, NULL, NULL, 2, NULL, 2, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (122, '押金返还', 23, '订单总览', 'busi:order:returnDeposit', NULL, NULL, NULL, 2, NULL, 3, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (123, '删除', 23, '订单总览', 'busi:order:delete', NULL, NULL, NULL, 2, NULL, 4, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (124, '新增', 24, '客户管理', 'busi:customer:add', NULL, NULL, NULL, 2, NULL, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (125, '修改', 24, '客户管理', 'busi:customer:edit', NULL, NULL, NULL, 2, NULL, 2, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (126, '删除', 24, '客户管理', 'busi:customer:delete', NULL, NULL, NULL, 2, NULL, 3, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (127, '查询', 24, '客户管理', 'busi:customer:select', NULL, NULL, NULL, 2, NULL, 4, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (128, '新增', 25, '违章处理', 'busi:violation:add', NULL, NULL, NULL, 2, NULL, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (129, '修改', 25, '违章处理', 'busi:violation:edit', NULL, NULL, NULL, 2, NULL, 2, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (130, '删除', 25, '违章处理', 'busi:violation:delete', NULL, NULL, NULL, 2, NULL, 3, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (131, '查询', 25, '违章处理', 'busi:violation:select', NULL, NULL, NULL, 2, NULL, 4, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (132, '处理', 25, '违章处理', 'busi:violation:handle', NULL, NULL, NULL, 2, NULL, 5, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (133, '新增', 26, '车辆保养', 'busi:maintain:add', NULL, NULL, NULL, 2, NULL, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (134, '修改', 26, '车辆保养', 'busi:maintain:edit', NULL, NULL, NULL, 2, NULL, 2, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (135, '删除', 26, '车辆保养', 'busi:maintain:delete', NULL, NULL, NULL, 2, NULL, 3, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (136, '查询', 26, '车辆保养', 'busi:maintain:select', NULL, NULL, NULL, 2, NULL, 4, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (137, '查询', 41, '财务报表', 'finance:report:select', NULL, NULL, NULL, 2, NULL, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (138, '导出', 41, '财务报表', 'finance:report:export', NULL, NULL, NULL, 2, NULL, 2, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (139, '新增', 62, '用户管理', 'sys:user:add', NULL, NULL, NULL, 2, NULL, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (140, '修改', 62, '用户管理', 'sys:user:edit', NULL, NULL, NULL, 2, NULL, 2, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (141, '删除', 62, '用户管理', 'sys:user:delete', NULL, NULL, NULL, 2, NULL, 3, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (142, '查询', 62, '用户管理', 'sys:user:select', NULL, NULL, NULL, 2, NULL, 4, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (143, '删除选中', 62, '用户管理', 'sys:user:deleteBatch', NULL, NULL, NULL, 2, NULL, 5, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (144, '绑定角色', 62, '用户管理', 'sys:user:bindRole', NULL, NULL, NULL, 2, NULL, 6, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (145, '新增', 63, '部门管理', 'sys:dept:add', NULL, NULL, NULL, 2, NULL, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (146, '修改', 63, '部门管理', 'sys:dept:edit', NULL, NULL, NULL, 2, NULL, 2, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (147, '删除', 63, '部门管理', 'sys:dept:delete', NULL, NULL, NULL, 2, NULL, 3, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (148, '查询', 63, '部门管理', 'sys:dept:select', NULL, NULL, NULL, 2, NULL, 4, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (149, '新增', 64, '角色管理', 'sys:role:save', NULL, NULL, NULL, 2, NULL, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (150, '修改', 64, '角色管理', 'sys:role:edit', NULL, NULL, NULL, 2, NULL, 2, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (151, '删除', 64, '角色管理', 'sys:role:delete', NULL, NULL, NULL, 2, NULL, 3, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (152, '查询', 64, '角色管理', 'sys:role:select', NULL, NULL, NULL, 2, NULL, 4, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (153, '分配权限', 64, '角色管理', 'sys:role:bindPermission', NULL, NULL, NULL, 2, NULL, 5, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (154, '新增', 65, '菜单管理', 'sys:permission:add', NULL, NULL, NULL, 2, NULL, 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (155, '修改', 65, '菜单管理', 'sys:permission:edit', NULL, NULL, NULL, 2, NULL, 2, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (156, '删除', 65, '菜单管理', 'sys:permission:delete', NULL, NULL, NULL, 2, NULL, 3, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
INSERT INTO `sys_permission` (`id`, `permission_lable`, `pid`, `parent_label`, `permission_code`, `route_path`, `route_name`, `route_url`, `permission_type`, `icon`, `order_num`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (157, '查询', 65, '菜单管理', 'sys:permission:select', NULL, NULL, NULL, 2, NULL, 4, '2026-06-27 10:00:00', '2026-06-27 10:00:00', NULL, 0);
COMMIT;

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '角色id',
  `role_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '角色编码',
  `role_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '角色名称',
  `creater_id` int DEFAULT NULL COMMENT '创建人id',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '备注',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
BEGIN;
INSERT INTO `sys_role` (`id`, `role_code`, `role_name`, `creater_id`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (1, 'ROLE_ADMIN', '系统管理员', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', '系统超级管理员，拥有全部权限', 0);
INSERT INTO `sys_role` (`id`, `role_code`, `role_name`, `creater_id`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (2, 'ROLE_MANAGER', '业务主管', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', '负责运营、订单、客户和车辆调度', 0);
INSERT INTO `sys_role` (`id`, `role_code`, `role_name`, `creater_id`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (3, 'ROLE_RENTAL', '出租专员', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', '负责车辆出租和客户录入', 0);
INSERT INTO `sys_role` (`id`, `role_code`, `role_name`, `creater_id`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (4, 'ROLE_RETURN', '归还专员', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', '负责车辆归还、结算和押金流程', 0);
INSERT INTO `sys_role` (`id`, `role_code`, `role_name`, `creater_id`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (5, 'ROLE_FINANCE', '财务专员', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', '负责财务报表、租金和押金核算', 0);
INSERT INTO `sys_role` (`id`, `role_code`, `role_name`, `creater_id`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (6, 'ROLE_MAINTAINER', '维保专员', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', '负责车辆保养和违章处理', 0);
INSERT INTO `sys_role` (`id`, `role_code`, `role_name`, `creater_id`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (7, 'ROLE_SERVICE', '客服专员', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', '负责客户信息和黑白名单维护', 0);
INSERT INTO `sys_role` (`id`, `role_code`, `role_name`, `creater_id`, `create_time`, `update_time`, `remark`, `deleted`) VALUES (8, 'ROLE_AUDITOR', '只读审计', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', '只读查看业务数据和权限配置', 0);
COMMIT;

-- ----------------------------
-- Table structure for sys_role_permission
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_permission`;
CREATE TABLE `sys_role_permission` (
  `role_id` int NOT NULL COMMENT '角色id',
  `permission_id` int NOT NULL COMMENT '权限资源id',
  PRIMARY KEY (`role_id`,`permission_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of sys_role_permission
-- ----------------------------
BEGIN;
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 1);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 2);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 3);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 4);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 5);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 20);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 21);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 22);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 23);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 24);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 25);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 26);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 40);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 41);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 60);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 61);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 62);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 63);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 64);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 65);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 100);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 101);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 102);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 103);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 104);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 105);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 106);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 107);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 108);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 109);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 110);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 111);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 112);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 113);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 114);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 115);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 116);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 117);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 118);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 119);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 120);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 121);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 122);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 123);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 124);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 125);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 126);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 127);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 128);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 129);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 130);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 131);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 132);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 133);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 134);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 135);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 136);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 137);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 138);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 139);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 140);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 141);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 142);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 143);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 144);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 145);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 146);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 147);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 148);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 149);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 150);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 151);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 152);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 153);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 154);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 155);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 156);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 157);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (2, 1);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (2, 2);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (2, 3);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (2, 4);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (2, 5);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (2, 20);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (2, 21);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (2, 22);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (2, 23);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (2, 24);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (2, 25);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (2, 26);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (2, 40);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (2, 41);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (2, 100);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (2, 101);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (2, 102);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (2, 103);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (2, 104);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (2, 105);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (2, 106);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (2, 107);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (2, 108);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (2, 109);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (2, 110);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (2, 111);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (2, 112);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (2, 113);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (2, 114);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (2, 115);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (2, 116);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (2, 117);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (2, 118);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (2, 119);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (2, 120);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (2, 121);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (2, 122);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (2, 123);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (2, 124);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (2, 125);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (2, 126);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (2, 127);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (2, 128);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (2, 129);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (2, 130);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (2, 131);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (2, 132);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (2, 133);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (2, 134);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (2, 135);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (2, 136);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (2, 137);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (2, 138);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (3, 1);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (3, 2);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (3, 3);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (3, 4);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (3, 5);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (3, 20);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (3, 21);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (3, 23);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (3, 24);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (3, 103);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (3, 107);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (3, 111);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (3, 115);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (3, 116);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (3, 117);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (3, 120);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (3, 121);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (3, 124);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (3, 125);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (3, 127);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (4, 1);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (4, 2);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (4, 3);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (4, 20);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (4, 22);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (4, 23);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (4, 25);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (4, 103);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (4, 118);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (4, 119);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (4, 120);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (4, 121);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (4, 122);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (4, 131);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (5, 2);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (5, 20);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (5, 23);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (5, 40);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (5, 41);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (5, 120);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (5, 121);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (5, 122);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (5, 137);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (5, 138);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (6, 1);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (6, 2);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (6, 3);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (6, 20);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (6, 25);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (6, 26);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (6, 103);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (6, 128);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (6, 129);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (6, 130);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (6, 131);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (6, 132);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (6, 133);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (6, 134);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (6, 135);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (6, 136);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (7, 2);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (7, 20);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (7, 21);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (7, 23);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (7, 24);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (7, 117);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (7, 120);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (7, 121);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (7, 124);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (7, 125);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (7, 126);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (7, 127);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (8, 1);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (8, 2);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (8, 3);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (8, 4);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (8, 5);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (8, 20);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (8, 21);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (8, 22);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (8, 23);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (8, 24);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (8, 25);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (8, 26);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (8, 40);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (8, 41);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (8, 60);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (8, 61);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (8, 62);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (8, 63);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (8, 64);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (8, 65);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (8, 103);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (8, 107);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (8, 111);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (8, 115);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (8, 117);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (8, 119);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (8, 120);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (8, 127);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (8, 131);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (8, 136);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (8, 137);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (8, 142);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (8, 148);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (8, 152);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (8, 157);
COMMIT;

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '用户id',
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '用户账户',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '用户密码',
  `is_account_non_expired` tinyint(1) DEFAULT NULL COMMENT '账户是否过期',
  `is_account_non_locked` tinyint(1) DEFAULT NULL COMMENT '账户是否被锁定',
  `is_credentials_non_expired` tinyint(1) DEFAULT NULL COMMENT '密码是否过期',
  `is_enabled` tinyint(1) DEFAULT NULL COMMENT '账户是否可用',
  `realname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '用户真实姓名',
  `nickname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '用户昵称',
  `dept_id` int DEFAULT NULL COMMENT '所属部门id',
  `dept_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '所属部门名称',
  `gender` tinyint(1) DEFAULT NULL COMMENT '性别',
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '联系电话',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '邮箱',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '头像',
  `is_admin` tinyint(1) DEFAULT NULL COMMENT '是否管理员',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
BEGIN;
INSERT INTO `sys_user` (`id`, `username`, `password`, `is_account_non_expired`, `is_account_non_locked`, `is_credentials_non_expired`, `is_enabled`, `realname`, `nickname`, `dept_id`, `dept_name`, `gender`, `phone`, `email`, `avatar`, `is_admin`, `create_time`, `update_time`, `deleted`) VALUES (1, 'admin', '$2a$06$rtw5tHzBKCupQnTEcXeHYOLWDmo5NpP2qYAmooCeZX9argF8EuUwa', 1, 1, 1, 1, '王建国', '管理员', 2, '总经办', 1, '13801380001', 'admin@cloudrent.local', '', 1, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `sys_user` (`id`, `username`, `password`, `is_account_non_expired`, `is_account_non_locked`, `is_credentials_non_expired`, `is_enabled`, `realname`, `nickname`, `dept_id`, `dept_name`, `gender`, `phone`, `email`, `avatar`, `is_admin`, `create_time`, `update_time`, `deleted`) VALUES (2, 'liyun', '$2a$06$rtw5tHzBKCupQnTEcXeHYOLWDmo5NpP2qYAmooCeZX9argF8EuUwa', 1, 1, 1, 1, '李芸', '运营主管', 4, '运营中心', 2, '13801380002', 'liyun@cloudrent.local', '', 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `sys_user` (`id`, `username`, `password`, `is_account_non_expired`, `is_account_non_locked`, `is_credentials_non_expired`, `is_enabled`, `realname`, `nickname`, `dept_id`, `dept_name`, `gender`, `phone`, `email`, `avatar`, `is_admin`, `create_time`, `update_time`, `deleted`) VALUES (3, 'zhaominghui', '$2a$06$rtw5tHzBKCupQnTEcXeHYOLWDmo5NpP2qYAmooCeZX9argF8EuUwa', 1, 1, 1, 1, '赵明辉', '财务赵', 11, '财务中心', 1, '13801380003', 'zhaominghui@cloudrent.local', '', 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `sys_user` (`id`, `username`, `password`, `is_account_non_expired`, `is_account_non_locked`, `is_credentials_non_expired`, `is_enabled`, `realname`, `nickname`, `dept_id`, `dept_name`, `gender`, `phone`, `email`, `avatar`, `is_admin`, `create_time`, `update_time`, `deleted`) VALUES (4, 'chenqiang', '$2a$06$rtw5tHzBKCupQnTEcXeHYOLWDmo5NpP2qYAmooCeZX9argF8EuUwa', 1, 1, 1, 1, '陈强', '维保陈', 10, '车辆维保部', 1, '13801380004', 'chenqiang@cloudrent.local', '', 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `sys_user` (`id`, `username`, `password`, `is_account_non_expired`, `is_account_non_locked`, `is_credentials_non_expired`, `is_enabled`, `realname`, `nickname`, `dept_id`, `dept_name`, `gender`, `phone`, `email`, `avatar`, `is_admin`, `create_time`, `update_time`, `deleted`) VALUES (5, 'sunjiao', '$2a$06$rtw5tHzBKCupQnTEcXeHYOLWDmo5NpP2qYAmooCeZX9argF8EuUwa', 1, 1, 1, 1, '孙娇', '客服孙', 7, '客户服务部', 2, '13801380005', 'sunjiao@cloudrent.local', '', 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `sys_user` (`id`, `username`, `password`, `is_account_non_expired`, `is_account_non_locked`, `is_credentials_non_expired`, `is_enabled`, `realname`, `nickname`, `dept_id`, `dept_name`, `gender`, `phone`, `email`, `avatar`, `is_admin`, `create_time`, `update_time`, `deleted`) VALUES (6, 'wanghao', '$2a$06$rtw5tHzBKCupQnTEcXeHYOLWDmo5NpP2qYAmooCeZX9argF8EuUwa', 1, 1, 1, 1, '王浩', '出租王', 5, '门店运营一组', 1, '13801380006', 'wanghao@cloudrent.local', '', 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `sys_user` (`id`, `username`, `password`, `is_account_non_expired`, `is_account_non_locked`, `is_credentials_non_expired`, `is_enabled`, `realname`, `nickname`, `dept_id`, `dept_name`, `gender`, `phone`, `email`, `avatar`, `is_admin`, `create_time`, `update_time`, `deleted`) VALUES (7, 'zhoumin', '$2a$06$rtw5tHzBKCupQnTEcXeHYOLWDmo5NpP2qYAmooCeZX9argF8EuUwa', 1, 1, 1, 1, '周敏', '归还周', 6, '门店运营二组', 2, '13801380007', 'zhoumin@cloudrent.local', '', 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `sys_user` (`id`, `username`, `password`, `is_account_non_expired`, `is_account_non_locked`, `is_credentials_non_expired`, `is_enabled`, `realname`, `nickname`, `dept_id`, `dept_name`, `gender`, `phone`, `email`, `avatar`, `is_admin`, `create_time`, `update_time`, `deleted`) VALUES (8, 'fenglei', '$2a$06$rtw5tHzBKCupQnTEcXeHYOLWDmo5NpP2qYAmooCeZX9argF8EuUwa', 1, 1, 1, 1, '冯磊', '车队冯', 9, '车队调度部', 1, '13801380008', 'fenglei@cloudrent.local', '', 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `sys_user` (`id`, `username`, `password`, `is_account_non_expired`, `is_account_non_locked`, `is_credentials_non_expired`, `is_enabled`, `realname`, `nickname`, `dept_id`, `dept_name`, `gender`, `phone`, `email`, `avatar`, `is_admin`, `create_time`, `update_time`, `deleted`) VALUES (9, 'qianyu', '$2a$06$rtw5tHzBKCupQnTEcXeHYOLWDmo5NpP2qYAmooCeZX9argF8EuUwa', 1, 1, 1, 1, '钱雨', '结算钱', 12, '结算组', 2, '13801380009', 'qianyu@cloudrent.local', '', 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `sys_user` (`id`, `username`, `password`, `is_account_non_expired`, `is_account_non_locked`, `is_credentials_non_expired`, `is_enabled`, `realname`, `nickname`, `dept_id`, `dept_name`, `gender`, `phone`, `email`, `avatar`, `is_admin`, `create_time`, `update_time`, `deleted`) VALUES (10, 'huangyan', '$2a$06$rtw5tHzBKCupQnTEcXeHYOLWDmo5NpP2qYAmooCeZX9argF8EuUwa', 1, 1, 1, 1, '黄岩', '稽核黄', 13, '风控稽核部', 1, '13801380010', 'huangyan@cloudrent.local', '', 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `sys_user` (`id`, `username`, `password`, `is_account_non_expired`, `is_account_non_locked`, `is_credentials_non_expired`, `is_enabled`, `realname`, `nickname`, `dept_id`, `dept_name`, `gender`, `phone`, `email`, `avatar`, `is_admin`, `create_time`, `update_time`, `deleted`) VALUES (11, 'itliang', '$2a$06$rtw5tHzBKCupQnTEcXeHYOLWDmo5NpP2qYAmooCeZX9argF8EuUwa', 1, 1, 1, 1, '梁工', '系统梁', 14, '信息技术部', 1, '13801380011', 'itliang@cloudrent.local', '', 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `sys_user` (`id`, `username`, `password`, `is_account_non_expired`, `is_account_non_locked`, `is_credentials_non_expired`, `is_enabled`, `realname`, `nickname`, `dept_id`, `dept_name`, `gender`, `phone`, `email`, `avatar`, `is_admin`, `create_time`, `update_time`, `deleted`) VALUES (12, 'demo_locked', '$2a$06$rtw5tHzBKCupQnTEcXeHYOLWDmo5NpP2qYAmooCeZX9argF8EuUwa', 1, 0, 1, 1, '锁定用户', '锁定演示', 3, '综合管理部', 2, '13801380012', 'locked@cloudrent.local', '', 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
INSERT INTO `sys_user` (`id`, `username`, `password`, `is_account_non_expired`, `is_account_non_locked`, `is_credentials_non_expired`, `is_enabled`, `realname`, `nickname`, `dept_id`, `dept_name`, `gender`, `phone`, `email`, `avatar`, `is_admin`, `create_time`, `update_time`, `deleted`) VALUES (13, 'demo_disabled', '$2a$06$rtw5tHzBKCupQnTEcXeHYOLWDmo5NpP2qYAmooCeZX9argF8EuUwa', 1, 1, 1, 0, '停用用户', '停用演示', 3, '综合管理部', 1, '13801380013', 'disabled@cloudrent.local', '', 0, '2026-06-27 10:00:00', '2026-06-27 10:00:00', 0);
COMMIT;

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role` (
  `user_id` int NOT NULL COMMENT '用户id',
  `role_id` int NOT NULL COMMENT '角色id',
  PRIMARY KEY (`user_id`,`role_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
BEGIN;
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES (1, 1);
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES (2, 2);
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES (3, 5);
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES (4, 6);
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES (5, 7);
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES (6, 3);
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES (7, 4);
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES (8, 2);
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES (8, 6);
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES (9, 5);
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES (10, 8);
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES (11, 1);
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES (12, 8);
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES (13, 7);
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
