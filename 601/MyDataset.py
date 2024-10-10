import pandas as pd
import numpy as np
import torch
import torch.nn as nn
from torch.utils.data import Dataset, DataLoader

from config import minio_config


class MyDatasetReader(Dataset):
    """
    定义数据集合处理类
    根据数据集特点进行不同的初始化
    由于data.csv数据集第一列为时间，所以特殊处理
    根据数据集不同，另外加处理方式
    （若要根据网络构造不同处理方法，需要另写）
    """
    def __init__(self, csv_path, input, output):
        # 公共初始化代码
        # self.data = pd.read_csv(csv_path, encoding='utf-8')
        self.data = minio_config.read_file(csv_path)
        self.features = self.data[input]
        self.labels = self.data[output]

    def __len__(self):
        return len(self.data)

    def __getitem__(self, index):
        feature = torch.tensor(self.features.iloc[index].values, dtype=torch.float32)
        label = torch.tensor(self.labels.iloc[index], dtype=torch.float32)
        return feature, label



if __name__ == '__main__':
    dataset = MyDatasetReader('datasets/digits.csv')
    # train_dataset, test_dataset = torch.utils.data.random_split(dataset, [0.8, 0.2])
    #
    # batch_size = 32
    # train_dataloader = DataLoader(train_dataset, batch_size=batch_size, shuffle=False)
    # test_dataloader = DataLoader(test_dataset, batch_size=batch_size, shuffle=False)
    # for features, labels in train_dataloader:
    #     print(features)
    #     print(labels)