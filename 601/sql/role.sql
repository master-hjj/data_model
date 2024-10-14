INSERT INTO `SYROLE` (`ID`, `CREATEDATETIME`, `UPDATEDATETIME`, `NAME`, `DESCRIPTION`, `ICONCLS`, `SEQ`, `ROLEKEY`, `DATASCOPE`, `STATUS`) VALUES
	('0', '2015-08-25 10:34:53', '2022-06-10 00:27:23', '超管', '拥有系统所有权限', NULL, 0, 'superadmin', '1', '0'),
	('1', '2016-11-28 14:24:00', '2022-06-10 00:27:41', '管理员', '管理员可以看到数据上传和任务创建页面', NULL, 100, 'admin', '1', '0'),
	('2', '2022-05-29 13:29:38', '2022-06-10 00:13:55', '用户', '普通用户只能看到数据预处理和网络上传页面', NULL, 1, 'user', '2', '0');
