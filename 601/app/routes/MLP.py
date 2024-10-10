from io import BytesIO

import numpy as np

import torch.optim as optim
import torch
import torch.nn as nn
from sklearn import metrics
from torch.utils.data import Dataset, DataLoader
import matplotlib.pyplot as plt
# from config import minio_config

# 数据集划分等
class MyDatasetReader(Dataset):
    """
    定义数据集合处理类
    根据数据集特点进行不同的初始化
    由于data.csv数据集第一列为时间，所以特殊处理
    根据数据集不同，另外加处理方式
    （若要根据网络构造不同处理方法，需要另写）
    """
    def __init__(self, data, input, output):
        # 公共初始化代码
        # self.data = pd.read_csv(csv_path, encoding='utf-8')
        self.data = data
        self.features = self.data[input]
        self.labels = self.data[output]

    def __len__(self):
        return len(self.data)

    def __getitem__(self, index):
        feature = torch.tensor(self.features.iloc[index].values, dtype=torch.float32)
        label = torch.tensor(self.labels.iloc[index], dtype=torch.float32)
        return feature, label

def mae(y_true, y_pred):
    return metrics.mean_absolute_error(y_true, y_pred)
def mse(y_true, y_pred):
    return metrics.mean_squared_error(y_true, y_pred)
def mape(y_true, y_pred):
    l = len(y_true)
    sum = 0.0
    for i in range(l):
        if y_true[i] == 0.:
            l-=1
            continue
        else:
            sum += np.abs((y_pred[i] - y_true[i]) / y_true[i])
    return sum[0]/l
    # return np.mean(np.abs((y_pred - y_true) / y_true))

def r2(y_true, y_pred):
    return metrics.r2_score(y_true, y_pred)
def rmse(y_true, y_pred):
    return np.sqrt(mse(y_true, y_pred))
# 评价指标
def Eva_Min(y_true, y_pred):
    metrics = {}
    metrics['mae'] = mae(y_true, y_pred)
    metrics['rmse'] = rmse(y_true, y_pred)
    metrics['mape'] = mape(y_true, y_pred)
    metrics['r2'] = r2(y_true, y_pred)
    metrics['mse'] = mse(y_true, y_pred)
    return metrics
import torch.nn.functional as F

import torch.nn as nn

# 网络
class MLP(nn.Module):
    def __init__(self, input_size, hidden_size, output_size, num_layers):
        super(MLP, self).__init__()
        self.input_size = int(input_size)
        self.hidden_size = int(hidden_size)
        self.output_size = int(output_size)
        self.num_layers = int(num_layers)
        self.layer_lst = nn.ModuleList()
        self.is_tuple = False
        self.input_layer = nn.Linear(self.input_size, self.hidden_size)
        for _ in range(self.num_layers):
            self.layer_lst.append(nn.Linear(self.hidden_size, self.hidden_size))

        self.out_layer = nn.Linear(self.hidden_size, self.output_size)

    def otherfucntion(self):
        ##神经网络中需要的其他逻辑

        pass

    def forward(self, input_data):
        if self.is_tuple:
            x = F.relu(self.input_layer(self.flatten(input_data)))
        else:
            x = F.relu(self.input_layer(input_data))
        for layer_ele in self.layer_lst:
            x = F.relu(layer_ele(x))

        return self.out_layer(x)



class Train_DML:
    def __init__(self, dataset, input, output, model_params):
        self.dataset = dataset
        self.dataset_input = input
        self.dataset_output = output
        # self.network_path = fr'/{network_path}'
        # self.network = network_name
        self.params = model_params
        # self.image_path = fr'{image_path}'  # 图像保存路径
        # self.model_path = fr'{model_path}'  # 模型保存路径
        # self.test_image = fr'{test_image}'
        # 默认网络都含有这几个参数
        self.epochs = int(model_params['epochs'])
        self.learning_rate = float(model_params['learning_rate'])
        self.batch_size = int(model_params['batch_size'])
        # self.class_obj = class_obj
        self.params = model_params

    def train(self):
        res = {}
        # 读取数据集文件，对文件做划分

        data = MyDatasetReader(self.dataset, self.dataset_input, self.dataset_output)
        # 训练集测试集划分0.8,0.2
        train_dataset, test_dataset = torch.utils.data.random_split(data, [0.8, 0.2])

        train_dataloader = DataLoader(train_dataset, batch_size=self.batch_size, shuffle=False)
        test_dataloader = DataLoader(test_dataset, batch_size=self.batch_size, shuffle=False)

        # 读取对应网络的py文件，并实例化类
        # class_obj = minio_config.load_class_from_file(self.network_path, self.network)

        # 将不需要的参数删除
        keys_to_delete = ['epochs', 'learning_rate', 'batch_size']
        for key in keys_to_delete:
            if key in self.params:
                del self.params[key]
        # 实例化类
        model_ = MLP(**self.params)
        criterion = nn.MSELoss()
        optimizer = optim.Adam(model_.parameters(), lr=self.learning_rate)


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

        plt.plot(loss_l)
        plt.xlabel('Epoch')
        plt.ylabel('Loss')
        plt.title('Training Loss')
        # 将loss图像存起来
        buffer = BytesIO()
        plt.savefig(buffer, format='png')
        plt.close()
        buffer.seek(0)
        res['loss'] = buffer
        # res = minio_config.upload_file2(self.image_path, buffer)
        # print(res)

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
            res['comparison'] = buffer
            # res = minio_config.upload_file2(self.test_image, buffer)
            # print(res)
            eva = Eva_Min(test_labels.numpy(), outputs.numpy())
            res['eva'] = eva
            print(eva)
            # plt.show()
        model_bytes = BytesIO()
        torch.save(model_.state_dict(), model_bytes)
        model_bytes.seek(0)  # 将文件指针移到开头
        res['model_file'] = model_bytes
        # minio_config.upload_file2(self.model_path, model_bytes)

        return res


if __name__ == '__main__':
    import pandas as pd
    # import importlib
    dataset = pd.read_csv(fr'D:\Users\deeptrain_back\app\model_and_data\datasets\data.csv')
    # module_spec = importlib.util.spec_from_file_location('MLP', fr'D:\Users\deeptrain_back\app\model_and_data\models\mlp.py')
    #
    # # 步骤2：加载模块
    # module = importlib.util.module_from_spec(module_spec)
    # module_spec.loader.exec_module(module)
    #
    # # 步骤3：获取类对象
    # class_obj = getattr(module, 'MLP')
    params = {
        'dataset': dataset,
        'model_params': {'input_size': '12', 'output_size': '1', 'hidden_size': '5', 'num_layers': '3', 'learning_rate': '0.01', 'batch_size': '32', 'epochs': '10'},
        'input': ['FCC_TIC1303_PV_csv', 'FCC_PI1301_PV_csv', 'FCC_FIC1311_PV_csv', 'FCC_TIC1402_PV_csv', 'FCC_TIC1402-1_PV_csv', 'FCC_FI1400_PV_csv', 'FCC_FIC1402-1_PV_csv', 'FCC_FVC1402_PV_csv', 'FCC_TI1419_PV_csv', 'FCC_LIC1404_PV_csv', 'FCC_TI1418_PV_csv', 'FCC_PDI1414_PV_csv'],
        'output': ['FCC_TI1418_PV_csv'],
    }

    model_train = Train_DML(**params)
    model_train.train()
    print("训练结束")