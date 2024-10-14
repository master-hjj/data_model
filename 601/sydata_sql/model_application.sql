INSERT INTO `model_application` (`id`, `model_name`, `model_description`, `data_id`, `params`, `network_id`, `status`, `created_username`, `create_time`) VALUES (1, 'nb', '11111111', 5, '{\'input_size\': \'12\', \'output_size\': \'1\', \'hidden_size\': \'5\', \'num_layers\': \'3\', \'learning_rate\': \'0.01\', \'batch_size\': \'32\', \'epochs\': \'10\'}', 1, 1, 'admin', NULL);
INSERT INTO `model_application` (`id`, `model_name`, `model_description`, `data_id`, `params`, `network_id`, `status`, `created_username`, `create_time`) VALUES (2, '信号分解', '用vmd对信号分解', 5, '{\'alpha\': \'2000\', \'tau\': \'0\', \'K\': \'3\', \'DC\': \'0\', \'init\': \'1\', \'tol\': 1e-07}', 2, 1, 'admin', NULL);
INSERT INTO `model_application` (`id`, `model_name`, `model_description`, `data_id`, `params`, `network_id`, `status`, `created_username`, `create_time`) VALUES (3, 'mlp测试', '用mlp对data.csv操作', 5, '{\'input_size\': \'12\', \'output_size\': \'1\', \'hidden_size\': \'20\', \'num_layers\': \'3\', \'learning_rate\': \'0.01\', \'batch_size\': \'32\', \'epochs\': \'10\'}', 1, 0, 'admin', '2023-11-17 11:38:22');
INSERT INTO `model_application` (`id`, `model_name`, `model_description`, `data_id`, `params`, `network_id`, `status`, `created_username`, `create_time`) VALUES (71, 'mlp_test', '用mlp对随机导入的4输入1输出数据测试', 16, '{\'input_size\': \'4\', \'output_size\': \'1\', \'hidden_size\': \'4\', \'num_layers\': \'2\', \'learning_rate\': \'0.01\', \'batch_size\': \'10\', \'epochs\': \'1000\'}', 1, 1, 'admin', '2023-12-05 10:19:48');
INSERT INTO `model_application` (`id`, `model_name`, `model_description`, `data_id`, `params`, `network_id`, `status`, `created_username`, `create_time`) VALUES (72, 'lstm_预测', '用lstm实现预测', 5, '{\'input_size\': \'12\', \'output_size\': \'1\', \'hidden_size\': \'20\', \'num_layers\': \'1\', \'epochs\': \'10\', \'learning_rate\': \'0.001\', \'batch_size\': \'32\'}', 40, 1, 'admin', '2023-12-06 10:11:15');
INSERT INTO `model_application` (`id`, `model_name`, `model_description`, `data_id`, `params`, `network_id`, `status`, `created_username`, `create_time`) VALUES (73, 'AR_test', '自回归测试_师姐项目', 18, '{\'pred_steps\': \'30\'}', 41, 1, 'admin', '2023-12-07 16:00:59');
INSERT INTO `model_application` (`id`, `model_name`, `model_description`, `data_id`, `params`, `network_id`, `status`, `created_username`, `create_time`) VALUES (74, 'AR_co2', 'sys', 21, '{\'pred_steps\': \'10\'}', 41, 1, 'admin', '2023-12-08 10:40:36');
INSERT INTO `model_application` (`id`, `model_name`, `model_description`, `data_id`, `params`, `network_id`, `status`, `created_username`, `create_time`) VALUES (75, '测试', 'chenhai', 19, '{\'N\': \'1\', \'Wn\': \'0.01\'}', 44, 1, 'admin', '2023-12-18 16:40:58');
INSERT INTO `model_application` (`id`, `model_name`, `model_description`, `data_id`, `params`, `network_id`, `status`, `created_username`, `create_time`) VALUES (76, 'Filter_test', 'Filter_test', 19, '{\'N\': \'2\', \'Wn\': \'0.01\'}', 44, 1, 'admin', '2023-12-18 16:51:03');
INSERT INTO `model_application` (`id`, `model_name`, `model_description`, `data_id`, `params`, `network_id`, `status`, `created_username`, `create_time`) VALUES (77, 'Wienerfilter', 'Wienerfilter', 19, '{\'mysize\': \'127\'}', 45, 1, 'admin', '2023-12-18 16:57:05');
INSERT INTO `model_application` (`id`, `model_name`, `model_description`, `data_id`, `params`, `network_id`, `status`, `created_username`, `create_time`) VALUES (78, 'GetHolospectrum', 'GetHolospectrum', 22, '{\'sample_rate\': \'200\', \'mask_freq\': \'0.25\', \'masks_1\': \'25\', \'masks_loops\': \'12\'}', 47, 1, 'admin', '2023-12-18 17:17:32');
INSERT INTO `model_application` (`id`, `model_name`, `model_description`, `data_id`, `params`, `network_id`, `status`, `created_username`, `create_time`) VALUES (81, 'TEST_new', 'chenhai', 5, '{\'input_size\': \'12\', \'output_size\': \'1\', \'hidden_size\': \'5\', \'num_layers\': \'3\', \'learning_rate\': \'0.01\', \'batch_size\': \'32\', \'epochs\': \'100\'}', 53, 1, 'admin', '2024-03-05 16:20:15');