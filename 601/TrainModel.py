from io import BytesIO

import numpy as np
import torch
import torch.nn as nn
from torch.utils.data import Dataset, DataLoader
import pandas as pd
import importlib.util
import torch.optim as optim
import matplotlib.pyplot as plt
import os
from MyDataset import MyDatasetReader
from config import minio_config
from evaluate import Eva_Min


class Train_ML:
    def __init__(self, dataset, input, output, network_name, network_path, model_params, image_path):
        # print(os.environ['app_home'])
        self.dataset = fr'{dataset}'
        self.network_path = fr'{network_path}'
        self.network = network_name
        self.dataset_input = input
        self.dataset_output = output
        self.params = model_params
        self.path = fr'{image_path}'  # 图像保存路径
        '''
        随机生成的图像文件名
        注意传进来的是数据文件的名字，需要拼接以便找到文件的地址
        '''
    def train(self):
        # data = np.genfromtxt(self.dataset, delimiter=',')   # 读取数据
        data = minio_config.read_file(self.dataset)
        data = data[self.dataset_input]
        # print(data)
        # 映射网络模型
        # 假设网络模型名为小写（vmd）,类名为大写（VMD）
        class_obj = minio_config.load_class_from_file(self.network_path, self.network)
        print(class_obj)
        model_ = class_obj(**self.params)
        print(model_)
        print(444)
        # 要结果数据，还是要画图？
        # 如何保存训练好的保存数据

        res = model_.forward(data)  # 训练数据
        print(res)
        minio_config.upload_file2(self.path, res)
        # model_.plot(data, self.image_name)  # 画图
        return res


class Train_DML:
    def __init__(self, dataset, input, output, network_name, network_path, model_params, image_path,test_image, model_path):
        self.dataset = fr'/{dataset}'
        self.dataset_input = input
        self.dataset_output = output
        self.network_path = fr'/{network_path}'
        self.network = network_name
        # self.params = model_params
        self.image_path = fr'{image_path}'  # 图像保存路径
        self.model_path = fr'{model_path}'  # 模型保存路径
        self.test_image = fr'{test_image}'
        # 默认网络都含有这几个参数
        self.epochs = int(model_params['epochs'])
        self.learning_rate = float(model_params['learning_rate'])
        self.batch_size = int(model_params['batch_size'])
        self.train_size = 0.3
        self.params = model_params

    def train(self):
        # 读取数据集文件，对文件做划分
        data = MyDatasetReader(fr'{self.dataset}', self.dataset_input, self.dataset_output)
        train_dataset, test_dataset = torch.utils.data.random_split(data, [0.8, 0.2])

        train_dataloader = DataLoader(train_dataset, batch_size=self.batch_size, shuffle=False)
        test_dataloader = DataLoader(test_dataset, batch_size=self.batch_size, shuffle=False)

        # 读取对应网络的py文件，并实例化类
        class_obj = minio_config.load_class_from_file(self.network_path, self.network)

        # 将不需要的参数删除
        keys_to_delete = ['epochs', 'learning_rate', 'batch_size']
        for key in keys_to_delete:
            if key in self.params:
                del self.params[key]
        # 实例化类
        model_ = class_obj(**self.params)
        criterion = nn.MSELoss()
        optimizer = optim.Adam(model_.parameters(), lr=self.learning_rate)


        # data = DataLoader(data, batch_size=self.batch_size, shuffle=False)
        loss_l = []
        for epoch in range(self.epochs):
            losses = 0
            for features, labels in train_dataloader:
                output = model_.forward(features)
                loss = criterion(output, labels)
                optimizer.zero_grad()
                loss.backward()
                optimizer.step()
                losses += loss.item()
            loss_l.append(losses/len(train_dataloader))
            if (epoch + 1) % 10 == 0:
                print(f'Epoch [{epoch + 1}/{self.epochs}], Loss: {losses/len(data):.4f}')
        print(loss_l)
        plt.plot(loss_l)
        plt.xlabel('Epoch')
        plt.ylabel('Loss')
        plt.title('Training Loss')
        plt.show()       # 将loss图像存起来
        buffer = BytesIO()
        plt.savefig(buffer, format='png')
        plt.close()
        buffer.seek(0)
        res = minio_config.upload_file2(self.image_path, buffer)
        print(res)

        # 画出对比图
        model_.eval()
        with torch.no_grad():
            test_inputs, test_labels = next(iter(test_dataloader))
            outputs = model_(test_inputs)
            print(test_labels, outputs)
            plt.plot(outputs)
            plt.plot(test_labels)
            plt.legend(['pred', 'real'])
            # 将图像存起来
            buffer = BytesIO()
            plt.savefig(buffer, format='png')
            plt.close()
            buffer.seek(0)
            res = minio_config.upload_file2(self.test_image, buffer)
            print(res)
            eva = Eva_Min(test_labels.numpy(), outputs.numpy())
            print(eva)
            # plt.show()
        model_bytes = BytesIO()
        torch.save(model_.state_dict(), model_bytes)
        model_bytes.seek(0)  # 将文件指针移到开头
        minio_config.upload_file2(self.model_path, model_bytes)

        return eva



if __name__ == '__main__':
    model = {
        'dataset': 'signal.csv',
        'model_params': {
            'alpha': '2000',
            'tau': '0',
            'K': '3',
            'DC': '0',
            'init': '1',
            'tol': '0.0000001'
                   },
        'network_name': 'vmds',
        'image_name': '11gaea'
    }
    modelTrain = Train_ML(**model)
    u, u_hat, omega = modelTrain.train()
    print(u, u_hat, omega)

    # params = {
    #     'dataset': 'data.csv',
    #     'model_params': {
    #         'input_size': 12,
    #         'hidden_size': 10,
    #         'output_size': 1,
    #         'num_layers': 3,
    #         'epochs': 1000,
    #         'learning_rate': 0.01,
    #         'batch_size': 32
    #     },
    #     'network_name': 'mlp',
    #     'image_name': 'faaesf'
    # }
    #
    # model_train = Train_DML(**params)
    # model_train.train()
    # print("训练结束")
