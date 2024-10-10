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

