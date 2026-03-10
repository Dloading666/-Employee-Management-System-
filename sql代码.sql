/*
 Navicat Premium Data Transfer

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 80027
 Source Host           : localhost:3306
 Source Schema         : ems-db

 Target Server Type    : MySQL
 Target Server Version : 80027
 File Encoding         : 65001

 Date: 19/06/2025 10:08:43
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for emp
-- ----------------------------
DROP TABLE IF EXISTS `emp`;
CREATE TABLE `emp`  (
                        `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '员工Id',
                        `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '姓名',
                        `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '工号',
                        `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '电子邮箱',
                        `mobile` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '手机号',
                        `id_card` varchar(18) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '身份证号',
                        `birthday` date NULL DEFAULT NULL COMMENT '出生日期',
                        `sex` int(0) NULL DEFAULT NULL COMMENT '性别(0-未知 1-男 2-女)',
                        `nation_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '民族',
                        `political_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '政治面貌',
                        `native_place` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '籍贯',
                        `graduate_school` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '毕业院校',
                        `major_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '专业',
                        `highest_education_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '最高学历',
                        `highest_degree_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '最高学位',
                        `habitation` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '现居住地',
                        `marital_status` int(0) NULL DEFAULT NULL COMMENT '婚姻状态(0-未知 1-未婚 2-已婚 3-离异 )',
                        `entry_date` date NULL DEFAULT NULL COMMENT '入职日期',
                        `leave_date` date NULL DEFAULT NULL COMMENT '离职日期',
                        `dept_id` bigint(0) NULL DEFAULT NULL COMMENT '任职部门Id',
                        `post_level_id` bigint(0) NULL DEFAULT NULL COMMENT '岗位岗级Id',
                        `user_id` bigint(0) NULL DEFAULT NULL COMMENT '绑定用户Id',
                        `role_type` int(0) NULL DEFAULT NULL COMMENT '角色类型',
                        `status` int(0) NULL DEFAULT NULL COMMENT '状态(0-在职 1-离职)',
                        PRIMARY KEY (`id`) USING BTREE,
                        INDEX `user_id`(`user_id`) USING BTREE,
                        INDEX `dept_id`(`dept_id`) USING BTREE,
                        INDEX `post_level_id`(`post_level_id`) USING BTREE,
                        CONSTRAINT `emp_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
                        CONSTRAINT `emp_ibfk_2` FOREIGN KEY (`dept_id`) REFERENCES `sys_dept` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
                        CONSTRAINT `emp_ibfk_3` FOREIGN KEY (`post_level_id`) REFERENCES `emp_post_level` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 48 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '员工信息表';

-- ----------------------------
-- Records of emp
-- ----------------------------
BEGIN;
INSERT INTO `emp` VALUES (1, '付祥明', '001', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 0), (2, '刘备', '002', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 2, 2, 0), (3, '张飞', '003', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4, NULL, 3, 3, 0), (4, '关羽', '004', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4, NULL, 4, 3, 0), (6, '赵云', '006', '3230245591@qq.com', '18050688988', '350626200409253014', NULL, NULL, '汉族', '', '', '', '', '', '', '', NULL, NULL, NULL, 5, NULL, 6, 3, 0), (10, '吴少然', '007', '3230245591@qq.com', '18050656775', '350626200409253015', NULL, NULL, '汉族', '', '', '', '', '', '', '', NULL, NULL, NULL, 2, 2, 2, NULL, 0), (11, '诸葛亮', '011', 'zhugeliang@shu.com', '13800138011', '510101198001011234', '1980-01-01', 1, '汉族', '1', '山东', '北京大学', '计算机', '11', '201', '成都市武侯区', 2, '2010-01-01', NULL, 1, 5, 11, 1, 0), (12, '庞统', '012', 'pangtong@shu.com', '13800138012', '510101198102021234', '1981-02-02', 1, '汉族', '1', '湖北', '清华大学', '软件工程', '11', '201', '成都市锦江区', 1, '2011-02-02', NULL, 1, 4, 12, 2, 0), (13, '马超', '013', 'machao@shu.com', '13800138013', '510101198203031234', '1982-03-03', 1, '回族', '3', '甘肃', '复旦大学', '网络工程', '14', '205', '成都市青羊区', 1, '2012-03-03', NULL, 4, 3, 13, 3, 0), (15, '魏延', '015', 'weiyan@shu.com', '13800138015', '510101198405051234', '1984-05-05', 1, '汉族', '1', '湖南', '上海交大', '大数据', '11', '201', '成都市成华区', 1, '2014-05-05', NULL, 4, 1, 15, 3, 0), (16, '法正', '016', 'fazheng@shu.com', '13800138016', '510101198506061234', '1985-06-06', 1, '汉族', '1', '陕西', '南京大学', '信息安全', '11', '201', '成都市高新区', 2, '2015-06-06', NULL, 1, 5, 16, 2, 0), (17, '徐庶', '017', 'xushu@shu.com', '13800138017', '510101198607071234', '1986-07-07', 1, '汉族', '1', '河北', '武汉大学', '云计算', '11', '201', '成都市天府新区', 1, '2016-07-07', NULL, 2, 4, 17, 3, 0), (18, '孙尚香', '018', 'sunshangxiang@wu.com', '13800138018', '510101198708081234', '1987-08-08', 2, '汉族', '1', '江苏', '中山大学', '物联网', '11', '201', '成都市双流区', 2, '2017-08-08', NULL, 3, 3, 18, 3, 0), (19, '姜维', '019', 'jiangwei@shu.com', '13800138019', '510101198809091234', '1988-09-09', 1, '汉族', '1', '甘肃', '华中科大', '区块链', '11', '201', '成都市温江区', 1, '2018-09-09', NULL, 5, 2, 19, 3, 0), (20, '马岱', '020', 'madai@shu.com', '13800138020', '510101198910101234', '1989-10-10', 1, '回族', '3', '甘肃', '四川大学', '前端开发', '14', '205', '成都市郫都区', 1, '2019-10-10', NULL, 4, 1, 20, 3, 0), (46, '陈松包', '15', '3230245591@qq.com', '18050656775', '350626200409253014', '2025-06-18', 1, '汉族', '群众', '福建省漳州市', '重庆工程学院', '软件工程', '本科', '', '重庆', 1, '2025-06-18', NULL, 1, 1, 15, 3, 0), (47, '吴少彬', '26', '3230245591@qq.com', '18050656775', '350626200409253014', '2025-06-18', 1, '汉族', '群众', '福建省漳州市', '重庆工程学院', '软件工程', '本科', '', '重庆', 1, '2025-06-18', NULL, 1, 1, 15, 3, 0);
COMMIT;

-- ----------------------------
-- Table structure for emp_attendance_record
-- ----------------------------
DROP TABLE IF EXISTS `emp_attendance_record`;
CREATE TABLE `emp_attendance_record`  (
                                          `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '考勤记录ID',
                                          `user_id` bigint(0) NOT NULL COMMENT '用户ID',
                                          `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '员工姓名（冗余，方便查询）',
                                          `attendance_date` date NOT NULL COMMENT '考勤日期',
                                          `check_in_time` time(0) NULL DEFAULT NULL COMMENT '签到时间',
                                          `check_out_time` time(0) NULL DEFAULT NULL COMMENT '签退时间',
                                          `work_hours` decimal(4, 2) NULL DEFAULT 0.00 COMMENT '工作时长(小时)',
                                          `status` int(0) NULL DEFAULT 0 COMMENT '状态 0-正常 1-迟到 2-早退 3-缺勤',
                                          `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
                                          `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
                                          `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
                                          PRIMARY KEY (`id`) USING BTREE,
                                          INDEX `idx_user_date`(`user_id`, `attendance_date`) USING BTREE,
                                          CONSTRAINT `fk_att_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 20 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '员工考勤记录';

-- ----------------------------
-- Records of emp_attendance_record
-- ----------------------------
BEGIN;
INSERT INTO `emp_attendance_record` VALUES (1, 1, '付祥明', '2025-06-17', '09:00:00', '18:00:00', NULL, 0, '正常', '2025-06-17 11:13:09', '2025-06-17 14:42:23'), (2, 2, '刘备', '2025-03-01', '09:18:00', '18:02:00', 7.73, 1, '迟到18分钟', '2025-06-17 11:13:09', '2025-06-17 11:13:09'), (3, 3, '张飞', '2025-03-01', '11:16:59', '11:17:01', 0.00, 3, '缺勤（未打卡）', '2025-06-17 11:13:09', '2025-06-17 11:17:03'), (4, 9, '吴少然', '2025-06-18', '09:35:00', '11:35:00', NULL, 2, '11', '2025-06-17 11:35:08', '2025-06-17 15:31:56'), (6, 9, '吴少然', '2025-06-18', '09:19:00', '15:19:00', NULL, 0, '', '2025-06-18 09:19:38', '2025-06-18 09:19:38'), (7, 5, '黄忠', '2025-06-18', '09:21:00', '11:21:00', NULL, 1, '', '2025-06-18 09:21:27', '2025-06-18 09:21:27'), (9, 3, '张飞', '2025-06-18', NULL, NULL, NULL, 3, '', '2025-06-18 09:35:41', '2025-06-18 09:35:41'), (10, 3, '张飞', '2025-06-18', '08:42:00', '12:42:00', NULL, 0, '', '2025-06-19 08:42:24', '2025-06-19 08:42:24'), (11, 9, '吴少然', '2025-06-19', '08:42:00', '10:42:00', NULL, 2, '', '2025-06-19 08:42:42', '2025-06-19 08:42:42'), (12, 5, '黄忠', '2025-06-19', NULL, NULL, NULL, 3, '', '2025-06-19 08:43:10', '2025-06-19 08:43:10'), (13, 2, '刘备', '2025-06-19', '09:43:00', '12:43:00', NULL, 1, '', '2025-06-19 08:43:30', '2025-06-19 08:43:30'), (19, 21, '吴少彬', '2025-06-19', '09:26:00', '11:26:00', NULL, 2, '', '2025-06-19 09:26:13', '2025-06-19 09:26:13');
COMMIT;

-- ----------------------------
-- Table structure for emp_leave_record
-- ----------------------------
DROP TABLE IF EXISTS `emp_leave_record`;
CREATE TABLE `emp_leave_record`  (
                                     `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '请假记录Id',
                                     `user_id` bigint(0) NULL DEFAULT NULL COMMENT '请假人Id',
                                     `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
                                     `leave_start_time` datetime(0) NULL DEFAULT NULL COMMENT '请假开始时间',
                                     `leave_end_time` datetime(0) NULL DEFAULT NULL COMMENT '请假结束时间',
                                     `leave_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '请假事由',
                                     `leave_type_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '请假类型',
                                     `approve_user_id` bigint(0) NULL DEFAULT NULL COMMENT '审批人Id',
                                     `approve_time` datetime(0) NULL DEFAULT NULL COMMENT '审批时间',
                                     `approve_content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '审批意见',
                                     `status` int(0) NULL DEFAULT NULL COMMENT '审批状态(0-待提交 1-待审核 2-审批通过 3-驳回 9-销假)',
                                     `real_end_time` datetime(0) NULL DEFAULT NULL COMMENT '销假时间',
                                     PRIMARY KEY (`id`) USING BTREE,
                                     INDEX `user_id`(`user_id`) USING BTREE,
                                     INDEX `approve_user_id`(`approve_user_id`) USING BTREE,
                                     CONSTRAINT `emp_leave_record_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
                                     CONSTRAINT `emp_leave_record_ibfk_2` FOREIGN KEY (`approve_user_id`) REFERENCES `sys_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '员工请假记录';

-- ----------------------------
-- Records of emp_leave_record
-- ----------------------------
BEGIN;
INSERT INTO `emp_leave_record` VALUES (1, 1, '2024-06-01 09:00:00', '2024-06-05 09:00:00', '2024-06-07 18:00:00', '家中有事', '事假', 2, '2024-06-02 10:00:00', '同意', 2, NULL), (2, 2, '2024-06-03 08:30:00', '2024-06-10 09:00:00', '2024-06-12 18:00:00', '身体不适', '病假', 1, '2025-06-18 15:13:23', '批准', 3, NULL), (3, 3, '2024-06-05 10:00:00', '2024-06-15 09:00:00', '2024-06-15 18:00:00', '外出办事', '事假', 1, '2025-06-18 19:19:18', '同意', 2, NULL), (7, 9, '2025-06-17 16:01:25', '2025-06-17 16:01:00', '2025-06-18 16:01:00', '生病', '病假', 1, '2025-06-18 19:19:18', NULL, 2, NULL), (8, 9, '2025-06-18 10:37:13', '2025-06-18 10:37:00', '2025-06-19 10:37:00', '考科二', '事假', 1, '2025-06-18 15:10:31', NULL, 2, NULL), (9, 9, '2025-06-18 19:21:01', '2025-06-18 19:20:00', '2025-06-19 19:20:00', '睡觉', '事假', 1, '2025-06-18 19:21:20', NULL, 2, NULL);
COMMIT;

-- ----------------------------
-- Table structure for emp_post_level
-- ----------------------------
DROP TABLE IF EXISTS `emp_post_level`;
CREATE TABLE `emp_post_level`  (
                                   `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '岗位岗级Id',
                                   `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '岗位名称',
                                   `level` int(0) NULL DEFAULT NULL COMMENT '岗级',
                                   `salary` decimal(9, 2) NULL DEFAULT NULL COMMENT '岗位工资',
                                   `sort_code` int(0) NULL DEFAULT NULL COMMENT '排序码',
                                   `status` int(0) NULL DEFAULT NULL COMMENT '状态(0-正常 1-禁用)',
                                   PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '岗位岗级表';

-- ----------------------------
-- Records of emp_post_level
-- ----------------------------
BEGIN;
INSERT INTO `emp_post_level` VALUES (1, '程序员1', 1, 2600.00, 10, 0), (2, '程序员2', 2, 3500.00, 20, 0), (3, '程序员3', 3, 5000.00, 30, 0), (4, '项目经理1', 1, 6000.00, 40, 0), (5, '项目经理2', 2, 7500.00, 50, 0), (8, '项目经理3', 3, 9000.00, 60, 1), (9, '高级程序员1', 4, 6500.00, 70, 0), (10, '高级程序员2', 5, 8000.00, 80, 0), (11, '高级程序员3', 6, 10000.00, 90, 0), (12, '技术总监1', 1, 12000.00, 100, 0), (13, '技术总监2', 2, 15000.00, 110, 0), (14, '技术总监3', 3, 18000.00, 120, 0), (15, '产品经理1', 1, 7000.00, 130, 0), (16, '产品经理2', 2, 9000.00, 140, 0), (17, '产品经理3', 3, 11000.00, 150, 0), (18, 'UI设计师', 1, 6000.00, 160, 0);
COMMIT;

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept`  (
                             `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '部门Id',
                             `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '部门名称',
                             `manager_user_id` bigint(0) NULL DEFAULT NULL COMMENT '负责人Id',
                             `parent_id` bigint(0) NULL DEFAULT NULL COMMENT '上级部门Id',
                             `sort_code` int(0) NULL DEFAULT NULL COMMENT '排序码',
                             `status` int(0) NULL DEFAULT NULL COMMENT '状态(0-正常 1-禁用)',
                             PRIMARY KEY (`id`) USING BTREE,
                             INDEX `manager_user_id`(`manager_user_id`) USING BTREE,
                             CONSTRAINT `sys_dept_ibfk_1` FOREIGN KEY (`manager_user_id`) REFERENCES `sys_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '部门表';

-- ----------------------------
-- Records of sys_dept
-- ----------------------------
BEGIN;
INSERT INTO `sys_dept` VALUES (1, '技术部', 2, 1, 10, 0), (2, '财务部', 2, 1, 20, 0), (3, '商务部', 1, 1, 30, 0), (4, '开发一部', 2, 1, 10, 0), (5, '开发二部', 2, 1, 20, 0), (6, '测试部', 2, 1, 30, 0), (18, '开发四部', 1, 1, 30, 1);
COMMIT;

-- ----------------------------
-- Table structure for sys_dict
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict`;
CREATE TABLE `sys_dict`  (
                             `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '字典项Id',
                             `dict_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '字典类别',
                             `dict_item_key` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '字典项编码',
                             `dict_item_value` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '字典项值',
                             `sort_code` int(0) NULL DEFAULT NULL COMMENT '排序码',
                             `status` int(0) NULL DEFAULT NULL COMMENT '状态(0-正常 1-禁用)',
                             PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 214 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统字典';

-- ----------------------------
-- Records of sys_dict
-- ----------------------------
BEGIN;
INSERT INTO `sys_dict` VALUES (1, '政治面貌', '1', '中共党员', 10, 0), (2, '政治面貌', '2', '中共预备党员', 20, 0), (3, '政治面貌', '3', '共青团员', 30, 0), (4, '政治面貌', '4', '中国国民党革命委员会（民革）党员', 40, 0), (5, '政治面貌', '5', '中国民主同盟（民盟）党员', 50, 0), (6, '政治面貌', '6', '中国民主建国会（民建）党员', 60, 0), (7, '政治面貌', '7', '中国民主促进会（民进）会员', 70, 0), (8, '政治面貌', '8', '中国农工民主党（农工党）党员', 80, 0), (9, '政治面貌', '9', '中国致公党（致公党）党员', 90, 0), (10, '政治面貌', '10', '九三学社社员', 100, 0), (11, '政治面貌', '11', '台湾民主自治同盟(台盟)党员', 110, 0), (12, '政治面貌', '12', '无党派民主人士', 120, 0), (13, '政治面貌', '13', '群众', 130, 0), (16, '民族', '01', '汉族', 10, 0), (18, '民族', '02', '蒙古族', 20, 0), (20, '民族', '03', '回族', 30, 0), (22, '民族', '04', '藏族', 40, 0), (24, '民族', '05', '维吾尔族', 50, 0), (27, '民族', '06', '苗族', 60, 0), (29, '民族', '07', '彝族', 70, 0), (30, '民族', '08', '壮族', 80, 0), (32, '民族', '09', '布依族', 90, 0), (34, '民族', '10', '朝鲜族', 100, 0), (37, '民族', '11', '满族', 110, 0), (40, '民族', '12', '侗族', 120, 0), (43, '民族', '13', '瑶族', 130, 0), (44, '民族', '14', '白族', 140, 0), (46, '民族', '15', '土家族', 150, 0), (48, '民族', '16', '哈尼族', 160, 0), (49, '民族', '17', '哈萨克族', 170, 0), (52, '民族', '18', '傣族', 180, 0), (55, '民族', '19', '黎族', 190, 0), (57, '民族', '20', '傈僳族', 200, 0), (58, '民族', '21', '佤族', 210, 0), (60, '民族', '22', '畲族', 220, 0), (62, '民族', '23', '高山族', 230, 0), (63, '民族', '24', '拉祜族', 240, 0), (66, '民族', '25', '水族', 250, 0), (67, '民族', '26', '东乡族', 260, 0), (69, '民族', '27', '纳西族', 270, 0), (71, '民族', '28', '景颇族', 280, 0), (73, '民族', '29', '柯尔克孜族', 290, 0), (75, '民族', '30', '土族', 300, 0), (77, '民族', '31', '达斡尔族', 310, 0), (80, '民族', '32', '仫佬族', 320, 0), (82, '民族', '33', '羌族', 330, 0), (83, '民族', '34', '布朗族', 340, 0), (85, '民族', '35', '撒拉族', 350, 0), (86, '民族', '36', '毛难族', 360, 0), (89, '民族', '37', '仡佬族', 370, 0), (91, '民族', '38', '锡伯族', 380, 0), (93, '民族', '39', '阿昌族', 390, 0), (95, '民族', '40', '普米族', 400, 0), (97, '民族', '41', '塔吉克族', 410, 0), (98, '民族', '42', '怒族', 420, 0), (101, '民族', '43', '乌孜别克族', 430, 0), (103, '民族', '44', '俄罗斯族', 440, 0), (105, '民族', '45', '鄂温克族', 450, 0), (108, '民族', '46', '崩龙族', 460, 0), (110, '民族', '47', '保安族', 470, 0), (112, '民族', '48', '裕固族', 480, 0), (114, '民族', '49', '京族', 490, 0), (117, '民族', '50', '塔塔尔族', 500, 0), (119, '民族', '51', '独龙族', 510, 0), (120, '民族', '52', '鄂伦春族', 520, 0), (123, '民族', '53', '赫哲族', 530, 0), (124, '民族', '54', '门巴族', 540, 0), (125, '民族', '55', '珞巴族', 550, 0), (126, '民族', '56', '基诺族', 560, 0), (127, '民族', '97', '其他', 970, 0), (128, '学历', '11', '博士研究生毕业', 110, 0), (129, '学历', '12', '博士研究生结业', 120, 0), (130, '学历', '13', '博士研究生肄业', 130, 0), (131, '学历', '14', '硕士研究生毕业', 140, 0), (132, '学历', '15', '硕士研究生结业', 150, 0), (133, '学历', '16', '硕士研究生肄业', 160, 0), (134, '学历', '17', '研究生班毕业', 170, 0), (135, '学历', '18', '研究生班结业', 180, 0), (136, '学历', '19', '研究生班肄业', 190, 0), (137, '学历', '21', '大学本科毕业', 210, 0), (138, '学历', '22', '大学本科结业', 220, 0), (139, '学历', '23', '大学本科肄业', 230, 0), (140, '学历', '28', '大学普通班毕业', 280, 0), (141, '学历', '31', '大学专科毕业', 310, 0), (142, '学历', '32', '大学专科结业', 320, 0), (143, '学历', '33', '大学专科肄业', 330, 0), (144, '学历', '41', '中等专科毕业', 410, 0), (145, '学历', '42', '中等专科结业', 420, 0), (146, '学历', '43', '中等专科肄业', 430, 0), (147, '学历', '44', '职业高中毕业', 440, 0), (148, '学历', '45', '职业高中结业', 450, 0), (149, '学历', '46', '职业高中肄业', 460, 0), (150, '学历', '47', '技工学校毕业', 470, 0), (151, '学历', '48', '技工学校结业', 480, 0), (152, '学历', '49', '技工学校肄业', 490, 0), (153, '学历', '61', '普通高中毕业', 610, 0), (154, '学历', '62', '普通高中结业', 620, 0), (155, '学历', '63', '普通高中肄业', 630, 0), (156, '学历', '71', '初中毕业', 710, 0), (157, '学历', '73', '初中肄业', 730, 0), (158, '学历', '81', '小学毕业', 810, 0), (159, '学历', '82', '小学肄业', 820, 0), (160, '学历', '90', '其他', 900, 0), (161, '学位', '201', '哲学博士学位', 2010, 0), (162, '学位', '202', '经济学博士学位', 2020, 0), (163, '学位', '203', '法学博士学位', 2030, 0), (164, '学位', '204', '	教育学博士学位', 2040, 0), (165, '学位', '205', '文学博士学位', 2050, 0), (166, '学位', '206', '历史学博士学位', 2060, 0), (167, '学位', '207', '理学博士学位', 2070, 0), (168, '学位', '208', '工学博士学位', 2080, 0), (169, '学位', '209', '农学博士学位', 2090, 0), (170, '学位', '210', '医学博士学位', 2100, 0), (171, '学位', '211', '军事学博士学位', 2110, 0), (172, '学位', '212', '管理学博士学位', 2120, 0), (173, '学位', '245', '临床医学博士专业学位', 2450, 0), (174, '学位', '248', '兽医博士专业学位', 2480, 0), (175, '学位', '250', '口腔医学博士专业学位', 2500, 0), (176, '学位', '301', '哲学硕士学位', 3010, 0), (177, '学位', '302', '经济学硕士学位', 3020, 0), (178, '学位', '303', '法学硕士学位', 3030, 0), (179, '学位', '304', '教育学硕士学位', 3040, 0), (180, '学位', '305', '文学硕士学位', 3050, 0), (181, '学位', '306', '历史学硕士学位', 3060, 0), (182, '学位', '307', '理学硕士学位', 3070, 0), (183, '学位', '308', '工学硕士学位', 3080, 0), (184, '学位', '309', '农学硕士学位', 3090, 0), (185, '学位', '310', '医学硕士学位', 3100, 0), (186, '学位', '311', '军事学硕士学位', 3110, 0), (187, '学位', '312', '管理学硕士学位', 3120, 0), (188, '学位', '341', '管理学硕士学位', 3410, 0), (189, '学位', '342', '教育硕士专业学位', 3420, 0), (190, '学位', '343', '工程硕士专业学位', 3430, 0), (191, '学位', '344', '建筑学硕士专业学位', 3440, 0), (192, '学位', '345', '临床学硕士专业学位', 3450, 0), (193, '学位', '346', '工商管理硕士专业学位', 3460, 0), (194, '学位', '347', '农业推广硕士专业学位', 3470, 0), (195, '学位', '348', '兽医硕士专业学位', 3480, 0), (196, '学位', '349', '公共管理硕士专业学位', 3490, 0), (197, '学位', '350', '口腔医学硕士专业学位', 3500, 0), (198, '学位', '351', '公共卫生硕士专业学位', 3510, 0), (199, '学位', '352', '军事硕士专业学位', 3520, 0), (200, '学位', '401', '哲学学士学位', 4010, 0), (201, '学位', '402', '经济学学士学位', 4020, 0), (202, '学位', '403', '法学学士学位', 4030, 0), (203, '学位', '404', '教育学学士学位', 4040, 0), (204, '学位', '405', '文学学士学位', 4050, 0), (205, '学位', '406', '历史学学士学位', 4060, 0), (206, '学位', '407', '理学学士学位', 4070, 0), (207, '学位', '408', '工学学士学位', 4080, 0), (208, '学位', '409', '农学学士学位', 4090, 0), (209, '学位', '410', '医学学士学位', 4100, 0), (210, '学位', '411', '军事学学士学位', 4110, 0), (211, '学位', '412', '管理学学士学位', 4120, 0), (213, '学位', '444', '建筑学学士专业学位', 4440, 0);
COMMIT;

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
                             `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '用户Id',
                             `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '用户名',
                             `account` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '登录账户',
                             `password` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '登录密码',
                             `status` int(0) NULL DEFAULT NULL COMMENT '状态(0-正常 1-禁用)',
                             PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 22 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户信息表';

-- ----------------------------
-- Records of sys_user
-- ----------------------------
BEGIN;
INSERT INTO `sys_user` VALUES (1, '付祥明', 'admin', '123456', 0), (2, '刘备', 'lb', '123456', 0), (3, '张飞', 'zf', '123456', 0), (4, '关羽', 'gy', '123456', 0), (5, '黄忠', 'hz', '123456', 0), (6, '赵云', 'zy', '123456', 0), (9, '吴少然', 'wsr', '123456', 0), (11, '诸葛亮', 'zgl', '123456', 0), (12, '庞统', 'pt', '123456', 0), (13, '马超', 'mc', '123456', 0), (14, '黄月英', 'hyy', '123456', 0), (15, '魏延', 'wy', '123456', 0), (16, '法正', 'fz', '123456', 0), (17, '徐庶', 'xs', '123456', 0), (18, '孙尚香', 'ssx', '123456', 0), (19, '姜维', 'jw', '123456', 0), (20, '马岱', 'md', '123456', 0), (21, '吴少彬', 'wsb', '123456', 1);
COMMIT;

-- ----------------------------
-- Table structure for emp_salary
-- ----------------------------
DROP TABLE IF EXISTS `emp_salary`;
CREATE TABLE `emp_salary`  (
                               `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '薪资记录ID',
                               `user_id` bigint(0) NOT NULL COMMENT '用户ID',
                               `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '员工姓名',
                               `pay_month` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '发放月份（格式：YYYY-MM）',
                               `amount` decimal(10, 2) NOT NULL COMMENT '发放金额',
                               `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
                               `create_time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
                               PRIMARY KEY (`id`) USING BTREE,
                               INDEX `idx_user_id`(`user_id`) USING BTREE,
                               CONSTRAINT `fk_emp_salary_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '员工薪资发放记录';

SET FOREIGN_KEY_CHECKS = 1;