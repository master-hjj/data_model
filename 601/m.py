import numpy as np
import pandas as pd
import torch.nn.functional as F
import torch
import torch.nn as nn
import torch.optim as optim
import matplotlib.pyplot as plt


class CNN(nn.Module):
    def __init__(self, input_size, output_size, kernel_size, stride, padding):
        super(CNN, self).__init__()
        self.input_size = int(input_size)
        self.output_size = int(output_size)
        self.kernel_size = int(kernel_size)
        self.stride = int(stride)
        self.padding = int(padding)
        self.conv1 = nn.Conv2d(in_channels=1, out_channels=16, kernel_size=(self.kernel_size, self.kernel_size),
                               stride=(self.stride, self.stride), padding=self.padding)
        self.relu1 = nn.ReLU()
        self.pool1 = nn.MaxPool2d(kernel_size=2, stride=2)
        self.conv2 = nn.Conv2d(in_channels=16, out_channels=32, kernel_size=(self.kernel_size, self.kernel_size),
                               stride=(self.stride, self.stride), padding=self.padding)
        self.relu2 = nn.ReLU()
        self.pool2 = nn.MaxPool2d(kernel_size=2, stride=2)
        # self.fc = nn.Linear(32 * 2 * 2, 3)  # 输出维度为3个类别
        self.fc = nn.LazyLinear(self.output_size)  # 省去计算输入的过程

    def forward(self, x):
        x = x.view(x.shape[0], 1, self.input_size, self.input_size)
        '''
        将输入张量x的形状进行调整。具体来说，x的形状是(batch_size, input_size, input_size)，其中batch_size表示批量大小，
        input_size表示输入图像的大小。
        而经过x.view(x.shape[0], 1, self.input_size, self.input_size)操作后，
        x的形状变为(batch_size, 1, input_size, input_size)。
        '''
        out = self.conv1(x)
        out = self.relu1(out)
        out = self.pool1(out)
        out = self.conv2(out)
        out = self.relu2(out)
        out = self.pool2(out)
        out = out.view(out.size(0), -1)
        out = self.fc(out)
        return out


if __name__ == '__main__':
    network = CNN(14, 3, 2, 1, 0)
    print(network)
    random_input = torch.rand(1, 196)
    print(random_input)
    print(network(random_input))