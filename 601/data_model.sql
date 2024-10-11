/*
 Navicat Premium Dump SQL

 Source Server         : data_model
 Source Server Type    : MySQL
 Source Server Version : 80036 (8.0.36)
 Source Host           : localhost:3306
 Source Schema         : data_model

 Target Server Type    : MySQL
 Target Server Version : 80036 (8.0.36)
 File Encoding         : 65001

 Date: 11/10/2024 10:32:35
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for alembic_version
-- ----------------------------
DROP TABLE IF EXISTS `alembic_version`;
CREATE TABLE `alembic_version`  (
  `version_num` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`version_num`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of alembic_version
-- ----------------------------
INSERT INTO `alembic_version` VALUES ('bb191ea484b1');

-- ----------------------------
-- Table structure for appparams
-- ----------------------------
DROP TABLE IF EXISTS `appparams`;
CREATE TABLE `appparams`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `params` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `image_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `model_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `app_id` int NOT NULL,
  `train_time` datetime NULL DEFAULT NULL,
  `test_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `eva` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `app_id`(`app_id` ASC) USING BTREE,
  CONSTRAINT `appparams_ibfk_1` FOREIGN KEY (`app_id`) REFERENCES `model_application` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of appparams
-- ----------------------------
INSERT INTO `appparams` VALUES (1, '{\'input_size\': \'12\', \'output_size\': \'1\', \'hidden_size\': \'5\', \'num_layers\': \'3\', \'learning_rate\': \'0.01\', \'batch_size\': \'32\', \'epochs\': \'10\'}', 'results/ff7f5c83-b10f-4c68-992e-aca4c0e9d8d5.png', 'trained_model/f9562b48-7800-4218-8fac-0696834d0d65.pth', 1, '2024-02-26 17:48:57', 'results/61c82460-9332-434b-995b-e8122146e2c9.png', '{\'mae\': 28.684542, \'rmse\': 42.263504, \'mape\': 0.27278372446695964, \'r2\': 0.7268012303324263, \'mse\': 1786.2039}');
INSERT INTO `appparams` VALUES (2, '{\'input_size\': \'12\', \'output_size\': \'1\', \'hidden_size\': \'5\', \'num_layers\': \'3\'}', 'results/9c04d2b0-9c74-4931-be07-9665ad918580.png', 'trained_model/344d6764-8d98-4fb4-bccd-087ee7e0504b.pth', 81, '2024-03-05 16:30:30', 'results/beee8ad9-22db-4e76-b514-3867ef4b9999.png', '{\'mae\': 0.032468177, \'rmse\': 0.03520428, \'mape\': 0.0001645824575627392, \'r2\': 0.9999997864122049, \'mse\': 0.0012393415}');

-- ----------------------------
-- Table structure for datasets
-- ----------------------------
DROP TABLE IF EXISTS `datasets`;
CREATE TABLE `datasets`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `data_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `path` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `upload_date` datetime NULL DEFAULT NULL,
  `created_username` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `created_userrole` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 40 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of datasets
-- ----------------------------
INSERT INTO `datasets` VALUES (1, 'data.csv', '12个特征预测1个输出', 'datasets/data.csv', '2023-11-17 11:36:48', 'admin', 'admin');
INSERT INTO `datasets` VALUES (2, 'signal.csv', '信号处理，只有一个特征', 'datasets/signal.csv', '2023-11-17 11:41:33', 'admin', 'admin');
INSERT INTO `datasets` VALUES (22, 'chenhai', 'chenhaid', 'datasets/test.csv', '2023-11-16 20:47:09', 'zhangsan', 'zhangsan');
INSERT INTO `datasets` VALUES (28, '55', '22', 'datasets/score.csv', '2023-11-22 20:42:38', 'admin', 'admin');
INSERT INTO `datasets` VALUES (33, '再生烟气CO2含量', 'xx输入，1输出，预测', 'datasets/再生烟气CO2含量.csv', '2023-12-04 17:27:39', 'admin', 'admin');
INSERT INTO `datasets` VALUES (35, 'FCC3_系列', '师姐测试样版', 'datasets/FCC3_LIC1001.csv', '2023-12-07 15:51:08', 'admin', 'admin');
INSERT INTO `datasets` VALUES (36, 'mnist数据集', 'mnist数据集，压缩过的特征14*14，分3类', 'datasets/mnist_159.csv', '2023-12-08 10:58:49', 'admin', 'admin');
INSERT INTO `datasets` VALUES (38, 'signal_testHolospectrum', 'signal_testHolospectrum', 'datasets/signal_testHolospectrum.csv', '2023-12-18 17:06:02', 'admin', 'admin');
INSERT INTO `datasets` VALUES (39, '10-10', '10-10', 'datasets/AI2103A-1.csv', '2024-10-10 10:41:17', 'admin', 'admin');

-- ----------------------------
-- Table structure for model_application
-- ----------------------------
DROP TABLE IF EXISTS `model_application`;
CREATE TABLE `model_application`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `model_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `model_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `data_id` int NOT NULL,
  `params` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `network_id` int NOT NULL,
  `status` int NULL DEFAULT NULL,
  `created_username` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `create_time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `data_id`(`data_id` ASC) USING BTREE,
  INDEX `network_id`(`network_id` ASC) USING BTREE,
  CONSTRAINT `model_application_ibfk_1` FOREIGN KEY (`data_id`) REFERENCES `testdata` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `model_application_ibfk_2` FOREIGN KEY (`network_id`) REFERENCES `network` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 82 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of model_application
-- ----------------------------
INSERT INTO `model_application` VALUES (1, 'nb', '11111111', 1, '{\'input_size\': \'12\', \'output_size\': \'1\', \'hidden_size\': \'5\', \'num_layers\': \'3\', \'learning_rate\': \'0.01\', \'batch_size\': \'32\', \'epochs\': \'10\'}', 1, 1, 'admin', NULL);
INSERT INTO `model_application` VALUES (2, '信号分解', '用vmd对信号分解', 5, '{\'alpha\': \'2000\', \'tau\': \'0\', \'K\': \'3\', \'DC\': \'0\', \'init\': \'1\', \'tol\': 1e-07}', 2, 1, 'admin', NULL);
INSERT INTO `model_application` VALUES (3, 'mlp测试', '用mlp对data.csv操作', 5, '{\'input_size\': \'12\', \'output_size\': \'1\', \'hidden_size\': \'20\', \'num_layers\': \'3\', \'learning_rate\': \'0.01\', \'batch_size\': \'32\', \'epochs\': \'10\'}', 1, 0, 'admin', '2023-11-17 11:38:22');
INSERT INTO `model_application` VALUES (71, 'mlp_test', '用mlp对随机导入的4输入1输出数据测试', 16, '{\'input_size\': \'4\', \'output_size\': \'1\', \'hidden_size\': \'4\', \'num_layers\': \'2\', \'learning_rate\': \'0.01\', \'batch_size\': \'10\', \'epochs\': \'1000\'}', 1, 1, 'admin', '2023-12-05 10:19:48');
INSERT INTO `model_application` VALUES (72, 'lstm_预测', '用lstm实现预测', 1, '{\'input_size\': \'12\', \'output_size\': \'1\', \'hidden_size\': \'20\', \'num_layers\': \'1\', \'epochs\': \'10\', \'learning_rate\': \'0.001\', \'batch_size\': \'32\'}', 40, 1, 'admin', '2023-12-06 10:11:15');
INSERT INTO `model_application` VALUES (73, 'AR_test', '自回归测试_师姐项目', 18, '{\'pred_steps\': \'30\'}', 41, 1, 'admin', '2023-12-07 16:00:59');
INSERT INTO `model_application` VALUES (74, 'AR_co2', 'sys', 21, '{\'pred_steps\': \'10\'}', 41, 1, 'admin', '2023-12-08 10:40:36');
INSERT INTO `model_application` VALUES (75, '测试', 'chenhai', 19, '{\'N\': \'1\', \'Wn\': \'0.01\'}', 44, 1, 'admin', '2023-12-18 16:40:58');
INSERT INTO `model_application` VALUES (76, 'Filter_test', 'Filter_test', 19, '{\'N\': \'2\', \'Wn\': \'0.01\'}', 44, 1, 'admin', '2023-12-18 16:51:03');
INSERT INTO `model_application` VALUES (77, 'Wienerfilter', 'Wienerfilter', 19, '{\'mysize\': \'127\'}', 45, 1, 'admin', '2023-12-18 16:57:05');
INSERT INTO `model_application` VALUES (78, 'GetHolospectrum', 'GetHolospectrum', 22, '{\'sample_rate\': \'200\', \'mask_freq\': \'0.25\', \'masks_1\': \'25\', \'masks_loops\': \'12\'}', 47, 1, 'admin', '2023-12-18 17:17:32');
INSERT INTO `model_application` VALUES (81, 'TEST_new', 'chenhai', 1, '{\'input_size\': \'12\', \'output_size\': \'1\', \'hidden_size\': \'5\', \'num_layers\': \'3\', \'learning_rate\': \'0.01\', \'batch_size\': \'32\', \'epochs\': \'100\'}', 53, 1, 'admin', '2024-03-05 16:20:15');

-- ----------------------------
-- Table structure for netcat
-- ----------------------------
DROP TABLE IF EXISTS `netcat`;
CREATE TABLE `netcat`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of netcat
-- ----------------------------
INSERT INTO `netcat` VALUES (1, '信号处理');
INSERT INTO `netcat` VALUES (2, '聚类');
INSERT INTO `netcat` VALUES (3, '分类');
INSERT INTO `netcat` VALUES (4, '回归');
INSERT INTO `netcat` VALUES (5, '优化');
INSERT INTO `netcat` VALUES (6, '异常点');

-- ----------------------------
-- Table structure for network
-- ----------------------------
DROP TABLE IF EXISTS `network`;
CREATE TABLE `network`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `network_params` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `category_id` int NOT NULL,
  `is_deep` int NULL DEFAULT NULL,
  `created_username` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `create_time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `category_id`(`category_id` ASC) USING BTREE,
  CONSTRAINT `network_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `netcat` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 54 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of network
-- ----------------------------
INSERT INTO `network` VALUES (1, 'MLP', 'models/mlp.py', '{\'input_size\': \'输入大小\', \'output_size\': \'输出大小\', \'hidden_size\': \'隐藏层大小\', \'num_layers\': \'隐藏层层数\', \'learning_rate\': \'学习率大小\', \'batch_size\': \'批大小\', \'epochs\': \'多少轮\'}', 1, 1, 'admin', NULL);
INSERT INTO `network` VALUES (2, 'VMDS', 'models/vmds.py', '{\'alpha\': \'数据保真度约束的平衡参数\', \'K\': \'要分解模态的数量\', \'tau\': \'噪声容量\', \'DC\': \'合成的信号\', \'init\': \'初始化值\', \'tol\': \'收敛准则的容忍度\'}', 1, 0, 'admin', NULL);
INSERT INTO `network` VALUES (40, 'LSTM', 'models/lstm.py', '{\'input_size\': \'输入大小\', \'output_size\': \'输出大小\', \'hidden_size\': \'隐藏层大小\', \'num_layers\': \'隐藏层层数\', \'epochs\': \'多少轮\', \'learning_rate\': \'学习率大小\', \'batch_size\': \'批大小\'}', 4, 1, 'admin', '2023-12-06 10:08:20');
INSERT INTO `network` VALUES (41, 'AR', 'models/AR.py', '{\'pred_steps\': \'预测步长\'}', 4, 0, 'admin', '2023-12-07 15:59:29');
INSERT INTO `network` VALUES (42, 'CNN', 'models/cnn.py', '{\'input_size\': \'输入大小\', \'output_size\': \'输出大小\', \'kernel_size\': \'卷积核大小\', \'padding\': \'填充大小\', \'stride\': \'步幅\', \'epochs\': \'多少轮\', \'batch_size\': \'批大小\', \'learning_rate\': \'学习率\'}', 3, 1, 'admin', '2023-12-08 12:27:56');
INSERT INTO `network` VALUES (44, 'Butterworthfilter', 'models/Butterworthfilter.py', '{\'N\': \'滤波器阶数\', \'Wn\': \'截止角频率\'}', 1, 0, 'admin', '2023-12-18 16:38:27');
INSERT INTO `network` VALUES (45, 'Wienerfilter', 'models/Wienerfilter.py', '{\'mysize\': \'维纳滤波的窗口大小\'}', 1, 0, 'admin', '2023-12-18 16:56:32');
INSERT INTO `network` VALUES (47, 'GetHolospectrum', 'models/GetHolospectrum.py', '{\'sample_rate\': \'sample_rate\', \'mask_freq\': \'mask_freq\', \'masks_1\': \'masks_1\', \'masks_loops\': \'masks_loops\'}', 1, 0, 'admin', '2023-12-18 17:16:51');
INSERT INTO `network` VALUES (51, 'QLSTM', 'models/qlstm.py', '{\'1\': \'1\'}', 2, 1, 'admin', '2024-01-03 21:12:03');
INSERT INTO `network` VALUES (53, 'TEST_NEW', 'models/MLP.py', '{\'input_size\': \'输入大小\', \'output_size\': \'输出大小\', \'hidden_size\': \'隐藏层大小\', \'num_layers\': \'隐藏层层数\', \'learning_rate\': \'学习率大小\', \'batch_size\': \'批大小\', \'epochs\': \'多少轮\'}', 1, 1, 'admin', '2024-03-05 16:20:15');

-- ----------------------------
-- Table structure for preprocess
-- ----------------------------
DROP TABLE IF EXISTS `preprocess`;
CREATE TABLE `preprocess`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `category` int NULL DEFAULT NULL,
  `filename` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `create_username` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `create_time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of preprocess
-- ----------------------------

-- ----------------------------
-- Table structure for preprocess_method
-- ----------------------------
DROP TABLE IF EXISTS `preprocess_method`;
CREATE TABLE `preprocess_method`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `path` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `create_date` datetime NULL DEFAULT NULL,
  `created_username` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of preprocess_method
-- ----------------------------
INSERT INTO `preprocess_method` VALUES (1, 'hjjpreprocess', 'test_first', 'C:\\Users\\m1980\\Desktop\\buct-kaggle\\data_model\\601\\preprocess_first', NULL, 'admin');
INSERT INTO `preprocess_method` VALUES (2, 'hjjpreprocess2', 'test_2', 'C:\\Users\\m1980\\Desktop\\buct-kaggle\\data_model\\601\\preprocess_second', NULL, 'admin');

-- ----------------------------
-- Table structure for preprocessed_dataset
-- ----------------------------
DROP TABLE IF EXISTS `preprocessed_dataset`;
CREATE TABLE `preprocessed_dataset`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `data_description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `path` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `testdata_id` int NOT NULL,
  `create_date` datetime NULL DEFAULT NULL,
  `created_username` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `preprocess_id` int NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `preprocess_id`(`preprocess_id` ASC) USING BTREE,
  INDEX `testdata_id`(`testdata_id` ASC) USING BTREE,
  CONSTRAINT `preprocessed_dataset_ibfk_1` FOREIGN KEY (`preprocess_id`) REFERENCES `preprocess_method` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `preprocessed_dataset_ibfk_2` FOREIGN KEY (`testdata_id`) REFERENCES `testdata` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of preprocessed_dataset
-- ----------------------------
INSERT INTO `preprocessed_dataset` VALUES (1, 'hjj_pre_data1', 'hjj_pre_data1', '/', 9, '2015-08-25 10:34:54', 'admin', 1);
INSERT INTO `preprocessed_dataset` VALUES (2, 'hjj_pre_data2', 'hjj_pre_data2', '/csv2', 5, '2015-08-26 10:34:54', 'admin', 2);

-- ----------------------------
-- Table structure for rankings
-- ----------------------------
DROP TABLE IF EXISTS `rankings`;
CREATE TABLE `rankings`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `testdata_id` int NOT NULL,
  `apparams_id` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `apparams_id`(`apparams_id` ASC) USING BTREE,
  INDEX `testdata_id`(`testdata_id` ASC) USING BTREE,
  CONSTRAINT `rankings_ibfk_1` FOREIGN KEY (`apparams_id`) REFERENCES `appparams` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `rankings_ibfk_2` FOREIGN KEY (`testdata_id`) REFERENCES `testdata` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of rankings
-- ----------------------------
INSERT INTO `rankings` VALUES (1, 5, 1);
INSERT INTO `rankings` VALUES (2, 9, 2);
INSERT INTO `rankings` VALUES (3, 5, 2);
INSERT INTO `rankings` VALUES (4, 9, 1);

-- ----------------------------
-- Table structure for syonline
-- ----------------------------
DROP TABLE IF EXISTS `syonline`;
CREATE TABLE `syonline`  (
  `ID` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `CREATEDATETIME` datetime NULL DEFAULT NULL,
  `LOGINNAME` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `IP` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `TYPE` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE,
  INDEX `ix_SYONLINE_CREATEDATETIME`(`CREATEDATETIME` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of syonline
-- ----------------------------
INSERT INTO `syonline` VALUES ('0480f119-fefc-45e2-bfbb-148730c01796', '2024-02-29 16:03:11', '127.0.0.1', 'admin', '1');
INSERT INTO `syonline` VALUES ('0563a8f2-d912-41ed-ae47-f1360e4d6dc0', '2023-11-07 09:11:03', '192.168.3.215', 'zhangsan', '1');
INSERT INTO `syonline` VALUES ('0757b215-63b8-40c9-ba56-b3016f5ce48c', '2024-01-02 14:56:45', '127.0.0.1', 'admin', '0');
INSERT INTO `syonline` VALUES ('095f29f8-0a05-46b7-9425-4612064d91fa', '2023-11-06 13:56:31', '192.168.3.215', 'admin', '1');
INSERT INTO `syonline` VALUES ('0bd7e366-1bb7-4472-bac4-00d3d4fe4e61', '2023-12-25 11:34:55', '127.0.0.1', 'admin', '0');
INSERT INTO `syonline` VALUES ('0c69d762-af59-4f12-bd36-ea7b8af99e78', '2022-05-22 12:00:43', '127.0.0.1', 'admin', '1');
INSERT INTO `syonline` VALUES ('0da06fde-e022-467b-982e-bd309b5ef707', '2024-03-04 10:26:13', '127.0.0.1', 'admin', '1');
INSERT INTO `syonline` VALUES ('1045e70e-ec71-4dc6-bf14-d19f93e1bb6f', '2023-11-03 10:30:16', '127.0.0.1', 'admin', '1');
INSERT INTO `syonline` VALUES ('135c96a6-146a-4357-a7eb-762cb59b0d3b', '2023-11-20 15:26:01', '192.168.3.165', 'admin', '1');
INSERT INTO `syonline` VALUES ('13be07b1-6372-4edc-9f5d-d311ee40dac9', '2023-11-07 20:18:20', '192.168.3.215', 'test', '1');
INSERT INTO `syonline` VALUES ('14a54957-f4da-463f-ab73-0cd933f01fdc', '2024-02-27 12:13:08', '127.0.0.1', 'admin', '1');
INSERT INTO `syonline` VALUES ('14fdc7c1-3bcb-47d5-a55c-b04c1ba6fddf', '2024-01-02 13:56:39', '192.168.3.165', 'admin', '1');
INSERT INTO `syonline` VALUES ('17d22939-4d0d-45a0-85c0-7fb29e416289', '2023-11-20 23:32:32', '192.168.3.165', 'admin', '0');
INSERT INTO `syonline` VALUES ('1895cf4b-8c03-4908-8064-1d065ccb1ed0', '2023-11-14 11:29:00', '127.0.0.1', 'admin', '1');
INSERT INTO `syonline` VALUES ('1b300611-1606-4de7-9ed7-8566220d915c', '2023-11-08 12:03:00', '127.0.0.1', 'admin', '1');
INSERT INTO `syonline` VALUES ('1baa1e2c-887f-4101-9495-2124849d237a', '2024-03-05 16:18:52', '127.0.0.1', 'admin', '1');
INSERT INTO `syonline` VALUES ('206100cc-3ebe-45ed-a951-3cba5094509b', '2023-11-07 21:19:50', '192.168.3.165', 'admin', '1');
INSERT INTO `syonline` VALUES ('20ae3f46-f2d0-4c4a-bedd-bfeab16811bd', '2024-03-04 10:53:32', '192.168.3.215', 'admin', '1');
INSERT INTO `syonline` VALUES ('21e319e2-cbf7-4358-a77b-7fb366feff15', '2023-11-17 22:28:22', '192.168.3.215', 'admin', '1');
INSERT INTO `syonline` VALUES ('24778002-727e-4878-a3ba-c9b82a3524a3', '2023-11-22 17:41:43', '192.168.3.165', 'admin', '1');
INSERT INTO `syonline` VALUES ('2792e467-721d-4123-bcb4-13f00fcc779d', '2024-01-26 15:55:39', '127.0.0.1', 'test', '1');
INSERT INTO `syonline` VALUES ('29302cf4-eb2d-46c3-b1e8-7e7889b9aff1', '2023-11-17 10:20:52', '192.168.3.215', 'admin', '1');
INSERT INTO `syonline` VALUES ('29313876-80d7-4ecc-bcc2-451580cdee6e', '2023-11-18 00:26:58', '192.168.3.215', 'admin', '1');
INSERT INTO `syonline` VALUES ('2c468e8b-b13a-49ab-b3dd-007192f04783', '2023-11-18 09:56:34', '192.168.1.7', 'admin', '0');
INSERT INTO `syonline` VALUES ('2d414009-db4f-4acd-9c17-00cd81e6b676', '2023-11-15 15:13:34', '192.168.3.215', 'admin', '1');
INSERT INTO `syonline` VALUES ('2e134e59-db48-47a5-b2b7-712ae05aa57c', '2023-11-22 20:36:40', '192.168.3.165', 'admin', '1');
INSERT INTO `syonline` VALUES ('2ebb6ffd-0f67-4b02-87fa-de7ef0bf3bc8', '2023-11-17 19:31:20', '10.2.117.149', 'admin', '1');
INSERT INTO `syonline` VALUES ('34a5c3dd-b6c8-4875-a308-44671bf8e5ee', '2023-11-08 17:29:54', '127.0.0.1', 'admin', '1');
INSERT INTO `syonline` VALUES ('352dc5db-66b6-41f1-9236-f9942e0299cd', '2023-11-21 10:30:24', '192.168.3.165', 'admin', '1');
INSERT INTO `syonline` VALUES ('3a0adf02-9f66-46e0-b4d0-48858886e70c', '2023-11-17 23:54:48', '192.168.3.215', 'zhangsan', '0');
INSERT INTO `syonline` VALUES ('3ae7a7a3-834d-416c-8a6c-ceeff274c033', '2023-11-15 16:54:22', '192.168.3.215', 'zhangsan', '1');
INSERT INTO `syonline` VALUES ('3b6a5dfb-e1b9-40b6-bbf0-2d3001993118', '2023-11-18 00:35:04', '192.168.1.7', 'admin', '1');
INSERT INTO `syonline` VALUES ('3c1aced6-fb76-4e91-a1fb-6d157d63f521', '2024-01-26 15:55:58', '127.0.0.1', 'test', '0');
INSERT INTO `syonline` VALUES ('3db90b39-a14e-4de5-bb69-fec8f1ccb358', '2024-01-17 11:41:56', '127.0.0.1', 'admin', '1');
INSERT INTO `syonline` VALUES ('3f8ce7fa-b7e2-473b-aa7b-6a30e176ca6c', '2024-01-02 16:03:26', '127.0.0.1', 'lisi', '0');
INSERT INTO `syonline` VALUES ('42dc8a41-79aa-4518-8b11-7a05c61e68f7', '2023-11-20 20:55:37', '192.168.3.165', 'admin', '1');
INSERT INTO `syonline` VALUES ('447025d2-b1d7-48c1-bcdf-070a91a88f00', '2023-11-17 21:42:44', '192.168.3.215', 'admin', '1');
INSERT INTO `syonline` VALUES ('468713d6-7f08-4346-b075-68ac24dc0cb8', '2023-11-07 20:18:39', '192.168.3.215', 'zhangsan', '1');
INSERT INTO `syonline` VALUES ('487bac63-54ab-4827-84b5-cbffc3b0b8eb', '2023-12-26 14:46:34', '127.0.0.1', 'admin', '0');
INSERT INTO `syonline` VALUES ('48c530fa-0a73-4c1c-b0de-adec5c4a3447', '2023-05-16 19:49:12', '127.0.0.1', 'admin', '1');
INSERT INTO `syonline` VALUES ('4c3f0294-2b5f-41de-a06c-a20072d474dd', '2023-12-26 14:48:11', '127.0.0.1', 'admin', '1');
INSERT INTO `syonline` VALUES ('4ef22581-16da-432b-bbbd-62bd7b6b5a12', '2023-11-08 13:02:19', '127.0.0.1', 'admin', '1');
INSERT INTO `syonline` VALUES ('4f35838a-5da7-457c-935c-9da93115873d', '2024-01-26 15:52:50', '127.0.0.1', 'lisi', '0');
INSERT INTO `syonline` VALUES ('4ff8bdac-1ad0-4ad2-9c1b-68b17426c368', '2023-11-14 17:31:56', '127.0.0.1', 'admin', '1');
INSERT INTO `syonline` VALUES ('5004a0c4-f305-4b6e-8677-a7f3682746fe', '2023-11-06 11:42:55', '192.168.3.215', 'admin', '1');
INSERT INTO `syonline` VALUES ('521b05f3-267f-4430-9f34-28e1f9b1b9b2', '2024-01-02 14:57:09', '127.0.0.1', 'admin', '1');
INSERT INTO `syonline` VALUES ('55e88e2e-91ae-4d86-afa3-9daaa84aee4b', '2023-12-26 14:46:43', '127.0.0.1', 'lisi', '1');
INSERT INTO `syonline` VALUES ('56f783c7-8bfa-46fc-9457-bcc450967aa8', '2023-11-29 11:42:51', '192.168.3.204', 'admin', '1');
INSERT INTO `syonline` VALUES ('5722b01f-4227-451e-9229-267d1c58dc7d', '2023-12-25 11:36:16', '127.0.0.1', 'lisi', '0');
INSERT INTO `syonline` VALUES ('5896a92b-7015-4ca6-9bff-4a9eb79225e0', '2023-12-25 15:20:52', '127.0.0.1', 'admin', '1');
INSERT INTO `syonline` VALUES ('59a24542-3151-496a-b4d9-adb6d2596f18', '2023-12-04 16:20:46', '192.168.3.204', 'admin', '1');
INSERT INTO `syonline` VALUES ('5b1de2cc-e837-4848-b564-6ab73ed172e1', '2023-11-07 21:17:46', '192.168.3.165', 'admin', '1');
INSERT INTO `syonline` VALUES ('5beb1036-f587-40be-b95a-b8676dc57592', '2023-11-17 23:54:51', '192.168.3.215', 'admin', '1');
INSERT INTO `syonline` VALUES ('5c6a765c-0ea5-4329-a0cf-eb264a8c7f0d', '2024-02-26 16:05:56', '127.0.0.1', 'admin', '0');
INSERT INTO `syonline` VALUES ('5ce07faf-9e16-4294-9355-693602948778', '2024-08-30 18:13:27', 'admin', '192.168.3.215', '1');
INSERT INTO `syonline` VALUES ('5dd92f45-a84f-441b-bba1-fbc150d2ae67', '2023-11-03 11:23:54', '127.0.0.1', 'admin', '1');
INSERT INTO `syonline` VALUES ('5eed3910-398b-4f89-ae3d-0457dfb85b8a', '2023-11-17 10:27:20', '192.168.3.215', 'admin', '1');
INSERT INTO `syonline` VALUES ('603dade0-ef15-4bb4-8cc6-91d888353d30', '2023-11-24 10:55:58', '192.168.3.204', 'admin', '1');
INSERT INTO `syonline` VALUES ('6044e177-523d-4242-a774-bdfa0409a5cd', '2023-11-07 16:04:25', '192.168.3.215', 'zhangsan', '1');
INSERT INTO `syonline` VALUES ('60537f90-8fd1-4425-b152-45a9a2a279d8', '2024-01-26 15:51:53', '127.0.0.1', 'lisi', '1');
INSERT INTO `syonline` VALUES ('61ce9d5c-c616-4586-bb65-a460719c1045', '2023-11-07 20:18:03', '192.168.3.215', 'admin', '0');
INSERT INTO `syonline` VALUES ('6326b243-d8cf-40d0-be4b-0ed823e1ce56', '2023-11-06 10:03:58', '192.168.3.215', 'admin', '1');
INSERT INTO `syonline` VALUES ('640ff3cb-7727-4185-a2e7-f6b3aa52672d', '2023-12-25 10:37:45', '127.0.0.1', 'admin', '1');
INSERT INTO `syonline` VALUES ('64366e15-5d36-4277-8d0e-a3952ee0ecb6', '2024-02-29 16:16:41', '127.0.0.1', 'admin', '1');
INSERT INTO `syonline` VALUES ('64ba59ec-9791-462f-9628-6581bf66e89f', '2024-02-23 16:49:24', '127.0.0.1', 'admin', '1');
INSERT INTO `syonline` VALUES ('66533e99-a3bc-47db-9538-61ea6de023be', '2023-11-08 11:57:36', '192.168.3.165', 'admin', '1');
INSERT INTO `syonline` VALUES ('678e0e04-26d5-49a2-aa10-13f9e0641def', '2023-12-26 14:48:08', '127.0.0.1', 'lisi', '0');
INSERT INTO `syonline` VALUES ('67bb73ad-2650-4466-ad79-2feb5666f35d', '2024-01-03 18:12:48', '127.0.0.1', 'admin', '1');
INSERT INTO `syonline` VALUES ('68daa01d-e8dc-4826-b074-4151943a59a3', '2023-11-20 21:19:27', '192.168.3.165', 'admin', '1');
INSERT INTO `syonline` VALUES ('6a25b86d-9a93-4628-99ef-44c9bc56b6b3', '2023-11-20 21:19:06', '192.168.3.165', 'admin', '1');
INSERT INTO `syonline` VALUES ('6c7210f3-9a33-4e71-abc2-8d0e2547c6e6', '2023-12-22 10:18:59', '127.0.0.1', 'admin', '1');
INSERT INTO `syonline` VALUES ('701b2c71-5ff5-468b-9e5a-0869e5b85507', '2023-11-18 09:56:40', '192.168.1.7', 'zhangsan', '1');
INSERT INTO `syonline` VALUES ('728487b2-dbe7-482c-9bce-b3c3198b9e46', '2023-11-07 20:19:07', '192.168.3.215', 'admin', '1');
INSERT INTO `syonline` VALUES ('74a97686-1425-4cf6-8c12-f66b58ecfd24', '2023-12-25 11:35:02', '127.0.0.1', 'lisi', '1');
INSERT INTO `syonline` VALUES ('74d2c979-18fc-4a69-9c40-739bca874c1c', '2023-11-16 16:01:47', '192.168.3.215', 'admin', '1');
INSERT INTO `syonline` VALUES ('76433121-be98-4617-ab86-55c5133543c0', '2023-12-06 10:05:36', '192.168.3.204', 'admin', '1');
INSERT INTO `syonline` VALUES ('76517d85-67e4-4043-af1c-8c47c58d6aef', '2024-02-27 12:17:12', '127.0.0.1', 'admin', '1');
INSERT INTO `syonline` VALUES ('7cc78feb-f728-47b5-ad15-212ee94690f5', '2023-11-17 23:10:47', '192.168.3.215', 'zhangsan', '1');
INSERT INTO `syonline` VALUES ('7f843a29-8463-430b-bde3-40caa390f8d4', '2024-02-26 16:05:58', '127.0.0.1', 'admin', '1');
INSERT INTO `syonline` VALUES ('8552d194-def1-4186-bd2b-6e3be97605b0', '2023-11-22 21:53:46', '192.168.3.165', 'admin', '1');
INSERT INTO `syonline` VALUES ('86e2f1d4-f781-4e84-a104-e6d987602ffd', '2023-11-17 22:09:51', '127.0.0.1', 'zhangsan', '1');
INSERT INTO `syonline` VALUES ('8c7f4b3b-9c4b-4352-ae3c-78b38c0923a3', '2023-11-07 20:18:34', '192.168.3.215', 'test', '0');
INSERT INTO `syonline` VALUES ('8c83f6d2-0f50-48e9-91a3-fd9317d7be72', '2023-12-07 15:34:05', '192.168.3.204', 'admin', '1');
INSERT INTO `syonline` VALUES ('8d60e58b-eccf-49db-a729-3257ce57889f', '2023-11-15 20:04:17', '127.0.0.1', 'admin', '1');
INSERT INTO `syonline` VALUES ('8de7548a-c0bd-4f31-99f1-16d0f26cea8b', '2023-11-16 15:37:40', '192.168.3.165', 'admin', '1');
INSERT INTO `syonline` VALUES ('8f1c94ba-3017-4908-b404-80af9eae900e', '2023-11-08 12:10:12', '222.199.225.75', 'admin', '1');
INSERT INTO `syonline` VALUES ('8f9ed187-579b-45bf-beb5-9dfc8166ba13', '2023-11-07 16:04:05', '192.168.3.215', 'zhangsan', '0');
INSERT INTO `syonline` VALUES ('90319a2f-fe61-40e9-967f-40d8269c5b13', '2023-12-18 16:32:55', '192.168.3.204', 'admin', '1');
INSERT INTO `syonline` VALUES ('93235cde-aaac-4043-a9de-14e00b15b080', '2024-01-26 15:51:47', '127.0.0.1', 'admin', '0');
INSERT INTO `syonline` VALUES ('96cc4dc5-ec59-497b-8ed1-a0670fb50b2a', '2023-12-07 16:40:44', '192.168.3.204', 'admin', '1');
INSERT INTO `syonline` VALUES ('9ac1996e-979d-44e3-b337-806fbef090d4', '2023-12-25 11:36:18', '127.0.0.1', 'admin', '1');
INSERT INTO `syonline` VALUES ('9e693956-e3b3-468d-aa1b-5302529b7a16', '2023-11-24 12:22:31', '192.168.3.165', 'admin', '1');
INSERT INTO `syonline` VALUES ('a07b05c0-f66e-496b-ba06-93c33c558194', '2023-11-16 15:08:24', '127.0.0.1', 'admin', '1');
INSERT INTO `syonline` VALUES ('a238e3a9-ac95-4c90-ac7b-adfc798e8330', '2023-11-17 22:09:46', '127.0.0.1', 'admin', '0');
INSERT INTO `syonline` VALUES ('a3fbaf5f-ae9a-49cc-a5e4-691b5d478a75', '2023-11-22 20:10:14', '192.168.3.165', 'admin', '1');
INSERT INTO `syonline` VALUES ('a8fc0060-5e40-4264-beba-ce3682dc5c4f', '2023-11-06 10:15:54', '192.168.3.215', 'zhangsan', '1');
INSERT INTO `syonline` VALUES ('ab6f49f8-15cd-480e-a9e7-059ae4d29bf6', '2024-01-26 15:55:34', '127.0.0.1', 'admin', '0');
INSERT INTO `syonline` VALUES ('adbc6e7f-e550-4679-8bca-a484648cf1fb', '2024-01-02 15:31:56', '127.0.0.1', 'lisi', '1');
INSERT INTO `syonline` VALUES ('aebb43fd-cad6-4562-b95c-c875b8b97033', '2024-01-02 14:07:04', '127.0.0.1', 'admin', '1');
INSERT INTO `syonline` VALUES ('b218fb28-0d44-443e-97db-b0be722fff22', '2023-11-06 10:11:42', '192.168.3.215', 'admin', '1');
INSERT INTO `syonline` VALUES ('b21e1ea9-a70c-4792-820b-5987f5aeceeb', '2024-03-13 19:28:23', '192.168.3.215', 'admin', '1');
INSERT INTO `syonline` VALUES ('b2ec696d-c53c-4f4d-b3c7-2d82faa6c1db', '2024-01-02 15:31:47', '127.0.0.1', 'admin', '0');
INSERT INTO `syonline` VALUES ('b3d9dc82-ccfd-402f-a3a6-ae5628a4e0e9', '2023-12-15 15:19:28', '192.168.3.204', 'admin', '1');
INSERT INTO `syonline` VALUES ('b58dd83d-d5e5-4189-8e68-97de89038457', '2024-03-11 14:01:18', '192.168.3.215', 'admin', '1');
INSERT INTO `syonline` VALUES ('bb46152b-0199-4ec6-a248-aa57ba530cf6', '2024-09-02 15:39:45', 'admin', '127.0.0.1', '1');
INSERT INTO `syonline` VALUES ('bcc7698c-5a07-4530-8170-e66462fc3f80', '2023-11-18 10:26:20', '192.168.1.7', 'admin', '1');
INSERT INTO `syonline` VALUES ('bdd390ce-6446-4efc-999e-72d3df8a8945', '2023-11-20 23:32:52', '192.168.3.165', 'admin', '1');
INSERT INTO `syonline` VALUES ('bebb6568-6703-41e2-b582-79f9446ab381', '2023-11-06 10:15:40', '192.168.3.215', 'admin', '0');
INSERT INTO `syonline` VALUES ('c0971185-9567-4d68-ad2c-e3a1d72350f3', '2023-11-18 00:26:48', '192.168.3.215', 'admin', '0');
INSERT INTO `syonline` VALUES ('c2bd7d42-d258-42c8-9baa-c72d69ebde8a', '2023-12-04 17:11:39', '192.168.3.204', 'admin', '0');
INSERT INTO `syonline` VALUES ('c4ba6954-222a-4c39-b8d4-a54820592b13', '2023-12-18 16:25:28', '192.168.3.204', 'admin', '1');
INSERT INTO `syonline` VALUES ('c6bad53d-c89d-4db1-8afa-f8ed74a912e7', '2024-01-02 19:16:18', '192.168.3.165', 'admin', '1');
INSERT INTO `syonline` VALUES ('cb376b8d-dd4a-46ee-a330-e173f0fc7a7d', '2023-11-06 11:42:53', '192.168.3.215', 'zhangsan', '0');
INSERT INTO `syonline` VALUES ('cb619708-5e29-4eaa-83f7-bf0e7bdad7f8', '2024-01-02 16:03:28', '127.0.0.1', 'admin', '1');
INSERT INTO `syonline` VALUES ('cce3671d-d0f7-4c6a-a27c-2c8114f3690b', '2024-01-26 15:49:20', '127.0.0.1', 'admin', '1');
INSERT INTO `syonline` VALUES ('ce28d7d8-bb1e-4063-9e3b-1bd9c505df2d', '2024-02-23 15:36:42', '127.0.0.1', 'admin', '1');
INSERT INTO `syonline` VALUES ('cef4f4c4-2139-45ff-83b6-396addfda428', '2023-11-22 20:36:34', '192.168.3.165', 'admin', '0');
INSERT INTO `syonline` VALUES ('d13b313b-681d-47b5-806e-55601aeab206', '2023-12-27 11:43:07', '127.0.0.1', 'admin', '1');
INSERT INTO `syonline` VALUES ('d2ab4bc2-5937-4366-a325-698ae2ad7eb6', '2023-11-17 20:53:04', '127.0.0.1', 'admin', '1');
INSERT INTO `syonline` VALUES ('d57c72f0-c2e6-45d4-824d-24d27d51fdf8', '2023-11-18 10:26:17', '192.168.1.7', 'zhangsan', '0');
INSERT INTO `syonline` VALUES ('dbf56f11-1e57-406c-9ba8-2df384570c7e', '2023-11-17 22:28:20', '192.168.3.215', 'zhangsan', '0');
INSERT INTO `syonline` VALUES ('e8877a98-70bd-4b2f-ae2f-7eb7c6eb394e', '2024-02-26 16:01:53', '127.0.0.1', 'admin', '1');
INSERT INTO `syonline` VALUES ('e90f8c5a-cc33-4fb1-9e15-a5e3c230c855', '2023-11-07 20:18:57', '192.168.3.215', 'zhangsan', '0');
INSERT INTO `syonline` VALUES ('eb45f98d-38aa-4088-9978-19e9927499a3', '2023-11-17 23:10:42', '192.168.3.215', 'admin', '0');
INSERT INTO `syonline` VALUES ('eda23488-496e-41c7-bf53-b583836ccad2', '2023-11-07 09:10:52', '192.168.3.215', 'admin', '0');
INSERT INTO `syonline` VALUES ('ef8071a5-06d1-46b0-933e-07c166464598', '2023-12-07 15:41:22', '192.168.3.204', 'admin', '1');
INSERT INTO `syonline` VALUES ('f17b275b-c7a4-4735-a1fd-85fd0338ac8d', '2024-01-26 15:56:00', '127.0.0.1', 'admin', '1');
INSERT INTO `syonline` VALUES ('fa4bfb9b-8d4f-4f91-8d50-b975dd98cfab', '2023-12-04 17:11:41', '192.168.3.204', 'admin', '1');
INSERT INTO `syonline` VALUES ('fd3907ee-8ab6-4d92-ac0c-3d84eba73e42', '2023-11-08 11:56:51', '192.168.3.165', 'admin', '1');
INSERT INTO `syonline` VALUES ('fe5ad33f-8d0d-4652-89f1-65ed83a36a35', '2023-12-05 09:55:38', '192.168.3.204', 'admin', '1');
INSERT INTO `syonline` VALUES ('fecaa981-81a8-4b4b-bb10-bab055372d5d', '2024-10-10 10:41:37', 'admin', '127.0.0.1', '1');
INSERT INTO `syonline` VALUES ('ff9d5d23-e9df-44c7-bb75-53fff9663a0b', '2024-01-26 15:52:52', '127.0.0.1', 'admin', '1');

-- ----------------------------
-- Table structure for syorganization
-- ----------------------------
DROP TABLE IF EXISTS `syorganization`;
CREATE TABLE `syorganization`  (
  `ID` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `CREATEDATETIME` datetime NULL DEFAULT NULL,
  `UPDATEDATETIME` datetime NULL DEFAULT NULL,
  `NAME` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `ADDRESS` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `CODE` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `ICONCLS` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `SEQ` int NULL DEFAULT NULL,
  `LEADER` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `PHONE` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `EMAIL` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `STATUS` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `SYORGANIZATION_ID` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE,
  INDEX `SYORGANIZATION_ID`(`SYORGANIZATION_ID` ASC) USING BTREE,
  INDEX `ix_SYORGANIZATION_CREATEDATETIME`(`CREATEDATETIME` ASC) USING BTREE,
  INDEX `ix_SYORGANIZATION_UPDATEDATETIME`(`UPDATEDATETIME` ASC) USING BTREE,
  CONSTRAINT `syorganization_ibfk_1` FOREIGN KEY (`SYORGANIZATION_ID`) REFERENCES `syorganization` (`ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of syorganization
-- ----------------------------

-- ----------------------------
-- Table structure for syorganization_syresource
-- ----------------------------
DROP TABLE IF EXISTS `syorganization_syresource`;
CREATE TABLE `syorganization_syresource`  (
  `SYRESOURCE_ID` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `SYORGANIZATION_ID` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  INDEX `SYORGANIZATION_ID`(`SYORGANIZATION_ID` ASC) USING BTREE,
  INDEX `SYRESOURCE_ID`(`SYRESOURCE_ID` ASC) USING BTREE,
  CONSTRAINT `syorganization_syresource_ibfk_1` FOREIGN KEY (`SYORGANIZATION_ID`) REFERENCES `syorganization` (`ID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `syorganization_syresource_ibfk_2` FOREIGN KEY (`SYRESOURCE_ID`) REFERENCES `syresource` (`ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of syorganization_syresource
-- ----------------------------

-- ----------------------------
-- Table structure for syresource
-- ----------------------------
DROP TABLE IF EXISTS `syresource`;
CREATE TABLE `syresource`  (
  `ID` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `CREATEDATETIME` datetime NULL DEFAULT NULL,
  `DESCRIPTION` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `ICONCLS` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `NAME` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `SEQ` int NULL DEFAULT NULL,
  `TARGET` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `UPDATEDATETIME` datetime NULL DEFAULT NULL,
  `PATH` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `URL` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `PERMS` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `SYRESOURCE_ID` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `SYRESOURCETYPE_ID` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `STATUS` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `IS_CACHE` bit(1) NULL DEFAULT b'1',
  PRIMARY KEY (`ID`) USING BTREE,
  INDEX `SYRESOURCETYPE_ID`(`SYRESOURCETYPE_ID` ASC) USING BTREE,
  INDEX `SYRESOURCE_ID`(`SYRESOURCE_ID` ASC) USING BTREE,
  INDEX `ix_SYRESOURCE_CREATEDATETIME`(`CREATEDATETIME` ASC) USING BTREE,
  INDEX `ix_SYRESOURCE_UPDATEDATETIME`(`UPDATEDATETIME` ASC) USING BTREE,
  CONSTRAINT `syresource_ibfk_1` FOREIGN KEY (`SYRESOURCETYPE_ID`) REFERENCES `syresourcetype` (`ID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `syresource_ibfk_2` FOREIGN KEY (`SYRESOURCE_ID`) REFERENCES `syresource` (`ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of syresource
-- ----------------------------
INSERT INTO `syresource` VALUES ('094ad9f6-a253-4782-9b3c-fdd86ed229a0', '2023-11-02 19:13:35', NULL, 'clipboard', '模型存储', 2, NULL, '2023-11-08 15:31:19', 'save', 'model/save/index', NULL, 'mxbc', '0', '0', b'1');
INSERT INTO `syresource` VALUES ('11052667-b53e-40b5-8604-61250da687bf', '2023-11-03 23:45:29', NULL, 'edit', '自定义流程', 7, NULL, '2024-03-13 19:33:50', '/stream', NULL, NULL, NULL, '3', '0', b'1');
INSERT INTO `syresource` VALUES ('1c53bdb2-fd9e-43a3-89ee-81d0787fe2c9', '2023-11-03 09:17:45', NULL, '404', '历史训练', 3, NULL, '2023-11-21 09:00:14', 'history', 'train/history/index', NULL, 'mxxl', '0', '0', b'1');
INSERT INTO `syresource` VALUES ('21898689-1745-4249-b4fb-e40c3b3e253d', '2023-11-03 15:44:02', NULL, 'documentation', '数据管理', 2, NULL, '2023-11-03 17:21:58', '/dataset', '', NULL, NULL, '3', '0', b'1');
INSERT INTO `syresource` VALUES ('27fda67f-61d1-4fe6-8eea-d796a848ab67', '2022-05-28 12:54:39', NULL, 'edit', '参数设置', 6, '', '2022-05-28 12:54:39', 'config', 'system/config/index', 'system:config:list', 'xtgl', '0', '0', b'1');
INSERT INTO `syresource` VALUES ('2b968189-a2b1-4840-a9c4-c77b0410134b', '2023-11-08 13:44:07', NULL, 'upload', '模型上传', 0, NULL, '2023-11-08 15:31:11', 'upload', 'model/upload/index', NULL, 'mxbc', '0', '0', b'1');
INSERT INTO `syresource` VALUES ('2c3b8e07-e038-4ddb-88ad-4ce5e3d69163', '2023-11-03 17:19:50', NULL, 'checkbox', '样本集', 1, NULL, '2023-11-03 20:42:50', 'sample', 'dataset/sample/index', NULL, '21898689-1745-4249-b4fb-e40c3b3e253d', '0', '0', b'1');
INSERT INTO `syresource` VALUES ('37ac3cd3-560b-49b3-ae86-96d1963e9db6', '2022-05-28 12:55:59', NULL, NULL, '参数修改', 3, NULL, '2022-05-28 12:55:59', NULL, NULL, 'system:config:edit', '27fda67f-61d1-4fe6-8eea-d796a848ab67', '1', '0', b'1');
INSERT INTO `syresource` VALUES ('4155d118-f9ef-4c21-acc3-839e6fe6dfd5', '2023-11-02 19:09:38', NULL, 'swagger', '模型配置', 1, NULL, '2023-11-08 15:31:25', 'config', 'model/config/index', NULL, 'mxbc', '0', '0', b'1');
INSERT INTO `syresource` VALUES ('4621e9f8-e7c6-4c2b-8172-3d8c8ea75371', '2022-05-28 12:55:24', NULL, NULL, '参数新增', 2, NULL, '2022-05-28 12:55:24', NULL, NULL, 'system:config:add', '27fda67f-61d1-4fe6-8eea-d796a848ab67', '1', '0', b'1');
INSERT INTO `syresource` VALUES ('6270f1cb-e9fe-4c7f-900e-1a880a0d9772', '2023-11-02 20:18:29', NULL, 'documentation', '项目管理', 1, NULL, '2023-11-07 21:21:23', 'project', 'model/project/index', NULL, 'mxgl', '0', '0', b'1');
INSERT INTO `syresource` VALUES ('726c7c1e-06f8-4c3e-b9e1-95778a430c07', '2022-05-28 12:51:16', NULL, NULL, '字典查询', 1, NULL, '2022-05-28 12:51:16', NULL, NULL, 'system:dict:query', 'ffb8cf26-1049-43ee-9dd5-16e5742ce9d5', '1', '0', b'1');
INSERT INTO `syresource` VALUES ('9d4277a9-b0b4-45ff-b37d-dcc5b636028f', '2023-11-03 23:46:08', NULL, 'color', '低代码开发', 1, NULL, '2024-03-13 19:36:33', 'draggable', 'stream/draggable/index', NULL, '11052667-b53e-40b5-8604-61250da687bf', '0', '0', b'1');
INSERT INTO `syresource` VALUES ('b5f9885f-9c1a-49c9-8c27-ace55fe8d2ed', '2023-11-02 20:19:06', NULL, 'dict', '业务模型', 2, NULL, '2023-11-02 20:19:06', 'business', 'model/business/index', NULL, 'mxgl', '0', '0', b'1');
INSERT INTO `syresource` VALUES ('b95cae69-6389-4ebc-b613-bee7aac5f730', '2022-05-28 12:52:26', NULL, NULL, '字典修改', 3, NULL, '2022-05-28 12:52:26', NULL, NULL, 'system:dict:edit', 'ffb8cf26-1049-43ee-9dd5-16e5742ce9d5', '1', '0', b'1');
INSERT INTO `syresource` VALUES ('c473a2c3-f647-4498-95b2-7f5111e79101', '2023-11-02 15:59:38', NULL, 'job', '岗位管理', 5, NULL, '2023-11-02 20:08:00', 'post', 'system/post/index', 'system:post:list', 'xtgl', '0', '1', b'1');
INSERT INTO `syresource` VALUES ('cc51db1a-88e3-44bb-9e22-5f6fa9b37453', '2023-11-03 17:20:24', NULL, 'clipboard', '自定义数据集', 2, NULL, '2023-11-15 23:23:47', 'userdata', 'dataset/userdata/index', NULL, '21898689-1745-4249-b4fb-e40c3b3e253d', '0', '0', b'1');
INSERT INTO `syresource` VALUES ('cc7ff599-a588-40b3-951d-ce9dd2490482', '2022-05-28 12:53:26', NULL, NULL, '字典导出', 5, NULL, '2022-05-28 12:53:26', NULL, NULL, 'system:dict:export', 'ffb8cf26-1049-43ee-9dd5-16e5742ce9d5', '1', '0', b'1');
INSERT INTO `syresource` VALUES ('cssc', '2022-05-28 12:56:23', NULL, NULL, '参数删除', 4, NULL, '2022-05-28 12:56:23', NULL, NULL, 'system:config:remove', '27fda67f-61d1-4fe6-8eea-d796a848ab67', '1', '0', b'1');
INSERT INTO `syresource` VALUES ('d60df8ae-86ee-4879-b9b9-2fe79f146d31', '2022-05-28 12:55:02', NULL, NULL, '参数查询', 1, NULL, '2022-05-28 12:55:02', NULL, NULL, 'system:config:query', '27fda67f-61d1-4fe6-8eea-d796a848ab67', '1', '0', b'1');
INSERT INTO `syresource` VALUES ('dd41b52b-272c-49ac-b045-b05392890a8d', '2022-05-28 12:56:49', NULL, NULL, '参数导出', 5, NULL, '2022-05-28 12:56:49', NULL, NULL, 'system:config:export', '27fda67f-61d1-4fe6-8eea-d796a848ab67', '1', '0', b'1');
INSERT INTO `syresource` VALUES ('edc3358e-b9c5-462f-8a70-7b1c7d7f2c26', '2022-05-28 12:51:53', NULL, NULL, '字典新增', 2, NULL, '2022-05-28 12:51:53', NULL, NULL, 'system:dict:add', 'ffb8cf26-1049-43ee-9dd5-16e5742ce9d5', '1', '0', b'1');
INSERT INTO `syresource` VALUES ('f1ca0e97-e0d7-4aef-87cd-1199d46d44d3', '2023-11-02 15:56:28', NULL, 'form', '操作日志', 2, NULL, '2023-11-02 20:08:58', 'operlog', 'monitor/operlog/index', 'monitor:operlog:list', 'xtjk', '0', '1', b'1');
INSERT INTO `syresource` VALUES ('ffb8cf26-1049-43ee-9dd5-16e5742ce9d5', '2022-05-28 12:50:37', NULL, 'dict', '字典管理', 5, '', '2022-05-28 12:50:37', 'dict', 'system/dict/index', 'system:dict:list', 'xtgl', '3', '0', b'1');
INSERT INTO `syresource` VALUES ('jgbj', '2015-08-25 10:34:53', '编辑机构', 'ext-icon-bullet_wrench', '编辑机构', 2, '', '2022-05-25 00:39:56', NULL, '/base/syorganization!update', 'system:dept:edit', 'jggl', '1', '0', b'1');
INSERT INTO `syresource` VALUES ('jgck', '2015-08-25 10:34:53', '查看机构', 'ext-icon-bullet_wrench', '查看机构', 4, '', '2015-08-25 10:34:53', NULL, '/base/syorganization!getById', 'system:dept:query', 'jggl', '1', '0', b'1');
INSERT INTO `syresource` VALUES ('jggl', '2015-08-25 10:34:53', '管理系统中用户的机构', 'tree', '机构管理', 4, '', '2022-05-25 00:40:04', 'dept', 'system/dept/index', 'system:dept:list', 'xtgl', '0', '0', b'1');
INSERT INTO `syresource` VALUES ('jglb', '2015-08-25 10:34:53', '查询机构列表', 'ext-icon-bullet_wrench', '机构列表', 0, '', '2016-11-28 14:09:52', NULL, '/base/syorganization!treeGrid', 'system:dept:list', 'jggl', '1', '0', b'1');
INSERT INTO `syresource` VALUES ('jgsc', '2015-08-25 10:34:53', '删除机构', 'ext-icon-bullet_wrench', '删除机构', 3, '', '2015-08-25 10:34:53', NULL, '/base/syorganization!delete', 'system:dept:remove', 'jggl', '1', '0', b'1');
INSERT INTO `syresource` VALUES ('jgsq', '2015-08-25 10:34:53', '机构授权', 'ext-icon-bullet_wrench', '机构授权', 5, '', '2015-08-25 10:34:53', NULL, '/base/syorganization!grant', NULL, 'jggl', '1', '0', b'1');
INSERT INTO `syresource` VALUES ('jgtj', '2015-08-25 10:34:53', '添加机构', 'ext-icon-bullet_wrench', '添加机构', 1, '', '2015-08-25 10:34:53', NULL, '/base/syorganization!save', 'system:dept:add', 'jggl', '1', '0', b'1');
INSERT INTO `syresource` VALUES ('jsbj', '2015-08-25 10:34:53', '编辑角色', 'ext-icon-bullet_wrench', '编辑角色', 2, '', '2015-08-25 10:34:53', NULL, '/base/syrole!update', 'system:role:edit', 'jsgl', '1', '0', b'1');
INSERT INTO `syresource` VALUES ('jsck', '2015-08-25 10:34:53', '查看角色', 'ext-icon-bullet_wrench', '查看角色', 4, '', '2015-08-25 10:34:53', NULL, '/base/syrole!getById', 'system:role:query', 'jsgl', '1', '0', b'1');
INSERT INTO `syresource` VALUES ('jsgl', '2015-08-25 10:34:53', '管理系统中用户的角色', 'peoples', '角色管理', 2, '', '2015-08-25 10:34:53', 'role', 'system/role/index', 'system:role:list', 'xtgl', '0', '0', b'1');
INSERT INTO `syresource` VALUES ('jslb', '2015-08-25 10:34:53', '查询角色列表', 'ext-icon-bullet_wrench', '角色列表', 0, '', '2015-08-25 10:34:53', NULL, '/base/syrole!grid', 'system:role:list', 'jsgl', '1', '0', b'1');
INSERT INTO `syresource` VALUES ('jssc', '2015-08-25 10:34:53', '删除角色', 'ext-icon-bullet_wrench', '删除角色', 3, '', '2015-08-25 10:34:53', NULL, '/base/syrole!delete', 'system:role:remove', 'jsgl', '1', '0', b'1');
INSERT INTO `syresource` VALUES ('jssq', '2015-08-25 10:34:53', '角色授权', 'ext-icon-bullet_wrench', '角色授权', 5, '', '2015-08-25 10:34:53', NULL, '/base/syrole!grant', NULL, 'jsgl', '1', '0', b'1');
INSERT INTO `syresource` VALUES ('jstj', '2015-08-25 10:34:53', '添加角色', 'ext-icon-bullet_wrench', '添加角色', 1, '', '2015-08-25 10:34:53', NULL, '/base/syrole!save', 'system:role:add', 'jsgl', '1', '0', b'1');
INSERT INTO `syresource` VALUES ('mxbc', '2023-11-02 19:07:34', '模型保存', 'post', '模型管理', 3, NULL, '2023-11-08 15:31:05', '/model', NULL, NULL, NULL, '3', '0', b'1');
INSERT INTO `syresource` VALUES ('mxgl', '2023-11-02 20:16:02', '模型管理', 'build', '项目管理', 4, NULL, '2023-11-08 15:51:13', '/model1', NULL, NULL, NULL, '3', '0', b'1');
INSERT INTO `syresource` VALUES ('mxxl', '2023-11-02 20:15:25', '模型训练', 'dashboard', '训练管理', 5, NULL, '2023-11-21 08:56:39', '/train', NULL, NULL, NULL, '3', '0', b'1');
INSERT INTO `syresource` VALUES ('online', '2015-08-25 10:34:53', '监控用户登录、注销', 'date-range', '登录历史', 1, '', '2023-11-02 15:57:00', 'logininfor', 'monitor/logininfor/index', 'monitor:logininfor:list', 'xtjk', '0', '0', b'1');
INSERT INTO `syresource` VALUES ('onlineGrid', '2015-08-25 10:34:53', '用户登录、注销历史记录列表', 'ext-icon-bullet_wrench', '用户登录历史列表', 1, '', '2022-05-28 13:16:37', NULL, '/base/syonline!grid', 'monitor:logininfor:list', 'online', '1', '0', b'1');
INSERT INTO `syresource` VALUES ('xtgl', '2015-08-25 10:34:53', '管理系统的资源、角色、机构、用户等信息', 'system', '系统管理', 1, '', '2023-11-02 20:28:50', '/system', NULL, NULL, NULL, '3', '0', b'1');
INSERT INTO `syresource` VALUES ('xtjk', '2015-08-25 10:34:53', '监控系统运行情况等信息', 'monitor', '日志管理', 6, '', '2023-11-03 16:09:55', '/system/log', '', '', NULL, '0', '0', b'1');
INSERT INTO `syresource` VALUES ('yhbj', '2015-08-25 10:34:53', '编辑用户', 'ext-icon-bullet_wrench', '编辑用户', 2, '', '2015-08-25 10:34:53', NULL, '/base/syuser!update', 'system:user:edit', 'yhgl', '1', '0', b'1');
INSERT INTO `syresource` VALUES ('yhck', '2015-08-25 10:34:53', '查看用户', 'ext-icon-bullet_wrench', '查看用户', 4, '', '2015-08-25 10:34:53', NULL, '/base/syuser!getById', 'system:user:query', 'yhgl', '1', '0', b'1');
INSERT INTO `syresource` VALUES ('yhgl', '2015-08-25 10:34:53', '管理系统中用户的用户', 'user', '用户管理', 1, '', '2023-05-16 20:08:40', 'user', 'system/user/index', 'system:user:list', 'xtgl', '0', '0', b'1');
INSERT INTO `syresource` VALUES ('yhjg', '2015-08-25 10:34:53', '编辑用户机构', 'ext-icon-bullet_wrench', '用户机构', 6, '', '2015-08-25 10:34:53', NULL, '/base/syuser!grantOrganization', 'system:dept:edit', 'yhgl', '1', '0', b'1');
INSERT INTO `syresource` VALUES ('yhjs', '2015-08-25 10:34:53', '编辑用户角色', 'ext-icon-bullet_wrench', '用户角色', 5, '', '2015-08-25 10:34:53', NULL, '/base/syuser!grantRole', 'system:role:edit', 'yhgl', '1', '0', b'1');
INSERT INTO `syresource` VALUES ('yhlb', '2015-08-25 10:34:53', '查询用户列表', 'ext-icon-bullet_wrench', '用户列表', 0, '', '2015-08-25 10:34:53', NULL, '/base/syuser!grid', 'system:user:list', 'yhgl', '1', '0', b'1');
INSERT INTO `syresource` VALUES ('yhsc', '2015-08-25 10:34:53', '删除用户', 'ext-icon-bullet_wrench', '删除用户', 3, '', '2015-08-25 10:34:53', NULL, '/base/syuser!delete', 'system:user:remove', 'yhgl', '1', '0', b'1');
INSERT INTO `syresource` VALUES ('yhtj', '2015-08-25 10:34:53', '添加用户', 'ext-icon-bullet_wrench', '添加用户', 1, '', '2015-08-25 10:34:53', NULL, '/base/syuser!save', 'system:user:add', 'yhgl', '1', '0', b'1');
INSERT INTO `syresource` VALUES ('zdsc', '2022-05-28 12:52:58', NULL, NULL, '字典删除', 4, NULL, '2022-05-28 12:52:58', NULL, NULL, 'system:dict:remove', 'ffb8cf26-1049-43ee-9dd5-16e5742ce9d5', '1', '0', b'1');
INSERT INTO `syresource` VALUES ('zybj', '2015-08-25 10:34:53', '编辑资源', 'ext-icon-bullet_wrench', '编辑资源', 2, '', '2015-08-25 10:34:53', NULL, '/base/syresource!update', 'system:menu:edit', 'zygl', '1', '0', b'1');
INSERT INTO `syresource` VALUES ('zyck', '2015-08-25 10:34:53', '查看资源', 'ext-icon-bullet_wrench', '查看资源', 4, '', '2015-08-25 10:34:53', NULL, '/base/syresource!getById', 'system:menu:query', 'zygl', '1', '0', b'1');
INSERT INTO `syresource` VALUES ('zygl', '2015-08-25 10:34:53', '管理系统的资源', 'tree-table', '菜单管理', 3, '', '2023-11-02 15:57:55', 'menu', 'system/menu/index', 'system:menu:list', 'xtgl', '0', '0', b'1');
INSERT INTO `syresource` VALUES ('zylb', '2015-08-25 10:34:53', '查询资源', 'ext-icon-bullet_wrench', '资源列表', 0, '', '2015-08-25 10:34:53', NULL, '/base/syresource!treeGrid', 'system:menu:query', 'zygl', '1', '0', b'1');
INSERT INTO `syresource` VALUES ('zysc', '2015-08-25 10:34:53', '删除资源', 'ext-icon-bullet_wrench', '删除资源', 3, '', '2015-08-25 10:34:53', NULL, '/base/syresource!delete', 'system:menu:remove', 'zygl', '1', '0', b'1');
INSERT INTO `syresource` VALUES ('zytj', '2015-08-25 10:34:53', '添加资源', 'ext-icon-bullet_wrench', '添加资源', 1, '', '2015-08-25 10:34:53', NULL, '/base/syresource!save', 'system:menu:add', 'zygl', '1', '0', b'1');

-- ----------------------------
-- Table structure for syresourcetype
-- ----------------------------
DROP TABLE IF EXISTS `syresourcetype`;
CREATE TABLE `syresourcetype`  (
  `ID` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `CREATEDATETIME` datetime NULL DEFAULT NULL,
  `UPDATEDATETIME` datetime NULL DEFAULT NULL,
  `NAME` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `DESCRIPTION` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE,
  INDEX `ix_SYRESOURCETYPE_CREATEDATETIME`(`CREATEDATETIME` ASC) USING BTREE,
  INDEX `ix_SYRESOURCETYPE_UPDATEDATETIME`(`UPDATEDATETIME` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of syresourcetype
-- ----------------------------
INSERT INTO `syresourcetype` VALUES ('0', '2015-08-25 10:34:53', '2015-08-25 10:34:53', '菜单', '菜单类型会显示在系统首页左侧菜单中');
INSERT INTO `syresourcetype` VALUES ('1', '2015-08-25 10:34:53', '2015-08-25 10:34:53', '功能', '功能类型不会显示在系统首页左侧菜单中');
INSERT INTO `syresourcetype` VALUES ('3', '2022-05-15 10:27:08', '2022-05-15 10:27:18', '目录', '');

-- ----------------------------
-- Table structure for syrole
-- ----------------------------
DROP TABLE IF EXISTS `syrole`;
CREATE TABLE `syrole`  (
  `ID` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `CREATEDATETIME` datetime NULL DEFAULT NULL,
  `UPDATEDATETIME` datetime NULL DEFAULT NULL,
  `NAME` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `DESCRIPTION` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `ICONCLS` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `SEQ` int NULL DEFAULT NULL,
  `ROLEKEY` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `DATASCOPE` int NULL DEFAULT NULL,
  `STATUS` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE,
  INDEX `ix_SYROLE_CREATEDATETIME`(`CREATEDATETIME` ASC) USING BTREE,
  INDEX `ix_SYROLE_UPDATEDATETIME`(`UPDATEDATETIME` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of syrole
-- ----------------------------

-- ----------------------------
-- Table structure for syrole_syorganization
-- ----------------------------
DROP TABLE IF EXISTS `syrole_syorganization`;
CREATE TABLE `syrole_syorganization`  (
  `SYROLE_ID` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `SYORGANIZATION_ID` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  INDEX `SYORGANIZATION_ID`(`SYORGANIZATION_ID` ASC) USING BTREE,
  INDEX `SYROLE_ID`(`SYROLE_ID` ASC) USING BTREE,
  CONSTRAINT `syrole_syorganization_ibfk_1` FOREIGN KEY (`SYORGANIZATION_ID`) REFERENCES `syorganization` (`ID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `syrole_syorganization_ibfk_2` FOREIGN KEY (`SYROLE_ID`) REFERENCES `syrole` (`ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of syrole_syorganization
-- ----------------------------

-- ----------------------------
-- Table structure for syrole_syresource
-- ----------------------------
DROP TABLE IF EXISTS `syrole_syresource`;
CREATE TABLE `syrole_syresource`  (
  `SYROLE_ID` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `SYRESOURCE_ID` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  INDEX `SYRESOURCE_ID`(`SYRESOURCE_ID` ASC) USING BTREE,
  INDEX `SYROLE_ID`(`SYROLE_ID` ASC) USING BTREE,
  CONSTRAINT `syrole_syresource_ibfk_1` FOREIGN KEY (`SYRESOURCE_ID`) REFERENCES `syresource` (`ID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `syrole_syresource_ibfk_2` FOREIGN KEY (`SYROLE_ID`) REFERENCES `syrole` (`ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of syrole_syresource
-- ----------------------------
INSERT INTO `syrole_syresource` VALUES ('0', 'cssc');
INSERT INTO `syrole_syresource` VALUES ('0', 'jgbj');
INSERT INTO `syrole_syresource` VALUES ('0', 'jgck');
INSERT INTO `syrole_syresource` VALUES ('0', 'jggl');
INSERT INTO `syrole_syresource` VALUES ('0', 'jglb');
INSERT INTO `syrole_syresource` VALUES ('0', 'jgsc');
INSERT INTO `syrole_syresource` VALUES ('0', 'jgsq');
INSERT INTO `syrole_syresource` VALUES ('0', 'jgtj');
INSERT INTO `syrole_syresource` VALUES ('0', 'jsbj');
INSERT INTO `syrole_syresource` VALUES ('0', 'jsck');
INSERT INTO `syrole_syresource` VALUES ('0', 'jsgl');
INSERT INTO `syrole_syresource` VALUES ('0', 'jslb');
INSERT INTO `syrole_syresource` VALUES ('0', 'jssc');
INSERT INTO `syrole_syresource` VALUES ('0', 'jssq');
INSERT INTO `syrole_syresource` VALUES ('0', 'jstj');
INSERT INTO `syrole_syresource` VALUES ('0', 'online');
INSERT INTO `syrole_syresource` VALUES ('0', 'onlineGrid');
INSERT INTO `syrole_syresource` VALUES ('0', 'xtgl');
INSERT INTO `syrole_syresource` VALUES ('0', 'xtjk');
INSERT INTO `syrole_syresource` VALUES ('0', 'yhbj');
INSERT INTO `syrole_syresource` VALUES ('0', 'yhck');
INSERT INTO `syrole_syresource` VALUES ('0', 'yhgl');
INSERT INTO `syrole_syresource` VALUES ('0', 'yhjg');
INSERT INTO `syrole_syresource` VALUES ('0', 'yhjs');
INSERT INTO `syrole_syresource` VALUES ('0', 'yhlb');
INSERT INTO `syrole_syresource` VALUES ('0', 'yhsc');
INSERT INTO `syrole_syresource` VALUES ('0', 'yhtj');
INSERT INTO `syrole_syresource` VALUES ('0', 'zdsc');
INSERT INTO `syrole_syresource` VALUES ('0', 'zybj');
INSERT INTO `syrole_syresource` VALUES ('0', 'zyck');
INSERT INTO `syrole_syresource` VALUES ('0', 'zygl');
INSERT INTO `syrole_syresource` VALUES ('0', 'zylb');
INSERT INTO `syrole_syresource` VALUES ('0', 'zysc');
INSERT INTO `syrole_syresource` VALUES ('0', 'zytj');

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config`  (
  `config_id` int NOT NULL AUTO_INCREMENT,
  `config_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `config_value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `config_type` int NULL DEFAULT NULL,
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `create_time` datetime NULL DEFAULT NULL,
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `update_time` datetime NULL DEFAULT NULL,
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`config_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_config
-- ----------------------------

-- ----------------------------
-- Table structure for sys_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_data`;
CREATE TABLE `sys_dict_data`  (
  `dict_code` int NOT NULL AUTO_INCREMENT,
  `dict_sort` int NULL DEFAULT NULL,
  `dict_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `dict_value` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `css_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `list_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `is_default` int NULL DEFAULT NULL,
  `status` int NULL DEFAULT NULL,
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `create_time` datetime NULL DEFAULT NULL,
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `update_time` datetime NULL DEFAULT NULL,
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`dict_code`) USING BTREE,
  INDEX `dict_type`(`dict_type` ASC) USING BTREE,
  CONSTRAINT `sys_dict_data_ibfk_1` FOREIGN KEY (`dict_type`) REFERENCES `sys_dict_type` (`dict_type`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 107 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dict_data
-- ----------------------------
INSERT INTO `sys_dict_data` VALUES (100, 0, '登录', '1', 'sys_login_type', NULL, 'default', NULL, 0, 'admin', '2022-06-10 00:29:31', 'admin', '2022-06-10 00:29:58', NULL);
INSERT INTO `sys_dict_data` VALUES (101, 1, '注销', '0', 'sys_login_type', NULL, 'default', NULL, 0, 'admin', '2022-06-10 00:29:48', NULL, '2022-06-10 00:29:48', NULL);
INSERT INTO `sys_dict_data` VALUES (102, 1, '已完成', '1', 'train_status', NULL, 'success', NULL, 0, 'admin', '2023-11-04 00:17:41', 'admin', '2023-11-07 14:57:00', NULL);
INSERT INTO `sys_dict_data` VALUES (103, 2, '训练中', '2', 'train_status', NULL, 'primary', NULL, 0, 'admin', '2023-11-06 21:31:49', 'admin', '2023-11-07 14:57:19', NULL);
INSERT INTO `sys_dict_data` VALUES (104, 0, '未开始', '0', 'train_status', NULL, 'info', NULL, 0, 'admin', '2023-11-06 21:32:03', 'admin', '2023-11-07 14:56:51', NULL);
INSERT INTO `sys_dict_data` VALUES (105, 3, '训练出错', '3', 'train_status', NULL, 'danger', NULL, 0, 'admin', '2023-11-06 21:32:34', NULL, '2023-11-06 21:32:34', NULL);
INSERT INTO `sys_dict_data` VALUES (106, 4, '训练中止', '4', 'train_status', NULL, 'warning', NULL, 0, 'admin', '2023-11-07 14:47:57', 'admin', '2023-11-07 14:57:27', NULL);

-- ----------------------------
-- Table structure for sys_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_type`;
CREATE TABLE `sys_dict_type`  (
  `dict_id` int NOT NULL AUTO_INCREMENT,
  `dict_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `status` int NULL DEFAULT NULL,
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `create_time` datetime NULL DEFAULT NULL,
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `update_time` datetime NULL DEFAULT NULL,
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`dict_id`) USING BTREE,
  UNIQUE INDEX `dict_type`(`dict_type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dict_type
-- ----------------------------
INSERT INTO `sys_dict_type` VALUES (1, '用户性别', 'sys_user_sex', 0, 'admin', '2022-05-14 14:04:20', '', NULL, '用户性别列表');
INSERT INTO `sys_dict_type` VALUES (2, '菜单状态', 'sys_show_hide', 0, 'admin', '2022-05-14 14:04:20', '', NULL, '菜单状态列表');
INSERT INTO `sys_dict_type` VALUES (3, '系统开关', 'sys_normal_disable', 0, 'admin', '2022-05-14 14:04:20', '', NULL, '系统开关列表');
INSERT INTO `sys_dict_type` VALUES (4, '任务状态', 'sys_job_status', 0, 'admin', '2022-05-14 14:04:20', '', NULL, '任务状态列表');
INSERT INTO `sys_dict_type` VALUES (5, '任务分组', 'sys_job_group', 0, 'admin', '2022-05-14 14:04:20', '', NULL, '任务分组列表');
INSERT INTO `sys_dict_type` VALUES (6, '系统是否', 'sys_yes_no', 0, 'admin', '2022-05-14 14:04:20', '', NULL, '系统是否列表');
INSERT INTO `sys_dict_type` VALUES (7, '通知类型', 'sys_notice_type', 0, 'admin', '2022-05-14 14:04:20', '', NULL, '通知类型列表');
INSERT INTO `sys_dict_type` VALUES (8, '通知状态', 'sys_notice_status', 0, 'admin', '2022-05-14 14:04:20', '', NULL, '通知状态列表');
INSERT INTO `sys_dict_type` VALUES (9, '操作类型', 'sys_oper_type', 0, 'admin', '2022-05-14 14:04:20', '', NULL, '操作类型列表');
INSERT INTO `sys_dict_type` VALUES (10, '系统状态', 'sys_common_status', 0, 'admin', '2022-05-14 14:04:20', '', NULL, '登录状态列表');
INSERT INTO `sys_dict_type` VALUES (11, '登录日志类型', 'sys_login_type', 0, 'admin', '2022-06-10 00:28:26', 'admin', '2022-06-10 00:28:26', NULL);
INSERT INTO `sys_dict_type` VALUES (12, '训练状态', 'train_status', 0, 'admin', '2023-11-04 00:16:58', 'admin', '2023-11-04 00:17:09', NULL);

-- ----------------------------
-- Table structure for syuser
-- ----------------------------
DROP TABLE IF EXISTS `syuser`;
CREATE TABLE `syuser`  (
  `ID` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `CREATEDATETIME` datetime NULL DEFAULT NULL,
  `UPDATEDATETIME` datetime NULL DEFAULT NULL,
  `LOGINNAME` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `PWD` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `NAME` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `SEX` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `AGE` int NULL DEFAULT NULL,
  `PHOTO` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `EMPLOYDATE` datetime NULL DEFAULT NULL,
  `EMAIL` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `PHONENUMBER` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `STATUS` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE,
  UNIQUE INDEX `ix_SYUSER_LOGINNAME`(`LOGINNAME` ASC) USING BTREE,
  INDEX `ix_SYUSER_CREATEDATETIME`(`CREATEDATETIME` ASC) USING BTREE,
  INDEX `ix_SYUSER_UPDATEDATETIME`(`UPDATEDATETIME` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of syuser
-- ----------------------------
INSERT INTO `syuser` VALUES ('0', '2015-08-25 10:34:54', NULL, 'admin', 'e10adc3949ba59abbe56e057f20f883e', 'admin', '1', 30, NULL, '2022-06-08 11:04:52', 'test@test.com', '18988888888', '0');
INSERT INTO `syuser` VALUES ('0f21b40c-5323-46e5-9200-0364eab3481e', '2022-05-29 09:28:57', '2022-06-10 09:19:56', 'test', 'e10adc3949ba59abbe56e057f20f883e', 'test', '0', NULL, NULL, '2022-05-29 09:28:57', 'test@test.com', '18988888888', '0');

-- ----------------------------
-- Table structure for syuser_syorganization
-- ----------------------------
DROP TABLE IF EXISTS `syuser_syorganization`;
CREATE TABLE `syuser_syorganization`  (
  `SYUSER_ID` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `SYORGANIZATION_ID` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  INDEX `SYORGANIZATION_ID`(`SYORGANIZATION_ID` ASC) USING BTREE,
  INDEX `SYUSER_ID`(`SYUSER_ID` ASC) USING BTREE,
  CONSTRAINT `syuser_syorganization_ibfk_1` FOREIGN KEY (`SYORGANIZATION_ID`) REFERENCES `syorganization` (`ID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `syuser_syorganization_ibfk_2` FOREIGN KEY (`SYUSER_ID`) REFERENCES `syuser` (`ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of syuser_syorganization
-- ----------------------------
INSERT INTO `syuser_syorganization` VALUES ('0', '0');
INSERT INTO `syuser_syorganization` VALUES ('346e8333-b644-4939-8b06-f23654963c6a', '0');
INSERT INTO `syuser_syorganization` VALUES ('3d40cbf0-feff-4a51-9a0a-a163502bb68b', '0');

-- ----------------------------
-- Table structure for syuser_syrole
-- ----------------------------
DROP TABLE IF EXISTS `syuser_syrole`;
CREATE TABLE `syuser_syrole`  (
  `SYUSER_ID` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `SYROLE_ID` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  INDEX `SYROLE_ID`(`SYROLE_ID` ASC) USING BTREE,
  INDEX `SYUSER_ID`(`SYUSER_ID` ASC) USING BTREE,
  CONSTRAINT `syuser_syrole_ibfk_1` FOREIGN KEY (`SYROLE_ID`) REFERENCES `syrole` (`ID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `syuser_syrole_ibfk_2` FOREIGN KEY (`SYUSER_ID`) REFERENCES `syuser` (`ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of syuser_syrole
-- ----------------------------
INSERT INTO `syuser_syrole` VALUES ('0', '0');

-- ----------------------------
-- Table structure for testdata
-- ----------------------------
DROP TABLE IF EXISTS `testdata`;
CREATE TABLE `testdata`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `input` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `output` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `origin_dataset` int NOT NULL,
  `create_date` datetime NULL DEFAULT NULL,
  `created_username` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `created_userrole` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `origin_dataset`(`origin_dataset` ASC) USING BTREE,
  CONSTRAINT `testdata_ibfk_1` FOREIGN KEY (`origin_dataset`) REFERENCES `datasets` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 25 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of testdata
-- ----------------------------
INSERT INTO `testdata` VALUES (5, 'test2', '[\'signal\']', '[]', 2, '2023-11-16 20:49:00', 'zhangsan', 'zhangsan');
INSERT INTO `testdata` VALUES (9, 'test111', '[\'FCC_TIC1303_PV_csv\', \'FCC_PI1301_PV_csv\', \'FCC_FIC1311_PV_csv\', \'FCC_TIC1402_PV_csv\']', '[\'FCC_TI1418_PV_csv\']', 1, '2023-11-17 20:09:31', 'admin', 'admin');
INSERT INTO `testdata` VALUES (14, 'CO2_test', '[\'TIC1008\', \'FIC1020\', \'LIC1005\', \'FIC1021\', \'PIC1001\', \'LZI1005\', \'LZI1001\', \'FIC1008\', \'FIC1009\', \'FIC1025\', \'FIC1028\']', '[\'再生烟气CO2含量\']', 33, '2023-12-04 17:39:10', 'admin', 'admin');
INSERT INTO `testdata` VALUES (16, 'test_4in_1out', '[\'a\', \'b\', \'c\', \'d\']', '[\'e\']', 22, '2023-12-05 10:18:01', 'admin', 'admin');
INSERT INTO `testdata` VALUES (18, 'test1', '[\'value\']', '[]', 35, '2023-12-07 15:53:27', 'admin', 'admin');
INSERT INTO `testdata` VALUES (19, 'test_signal', '[\'signal\']', '[]', 2, '2023-12-07 16:10:23', 'admin', 'admin');
INSERT INTO `testdata` VALUES (21, 'test_自回归_CO2', '[\'再生烟气CO2含量\']', '[]', 33, '2023-12-08 10:40:03', 'admin', 'admin');
INSERT INTO `testdata` VALUES (22, 'test1', '[\'0\']', '[]', 38, '2023-12-18 17:12:03', 'admin', 'admin');
INSERT INTO `testdata` VALUES (23, 'asdf', '[\'a\', \'b\']', '[\'c\', \'d\', \'e\']', 22, '2024-01-02 14:44:09', 'admin', 'admin');
INSERT INTO `testdata` VALUES (24, 'test10-10', '[\'FCC_TIC1303_PV_csv\', \'FCC_PI1301_PV_csv\', \'FCC_FIC1311_PV_csv\']', '[\'FCC_PDI1414_PV_csv\', \'FCC_TI1418_PV_csv.1\']', 1, '2024-10-10 10:41:17', 'admin', 'admin');

SET FOREIGN_KEY_CHECKS = 1;
