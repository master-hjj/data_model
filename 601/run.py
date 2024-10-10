# # import psutil
# # import time
# # import pycuda.driver as cuda
# # import pycuda.autoinit
# # import numpy as np
# # def get_cpu_usage():
# #     cpu_usage = psutil.cpu_percent(interval=1)
# #     return cpu_usage
# #
# # def get_memory_usage():
# #     memory = psutil.virtual_memory()
# #     memory_usage = memory.percent
# #     return memory_usage
# #
# # if __name__ == "__main__":
# #     # while True:
# #         cpu_usage = get_cpu_usage()
# #         memory_usage = get_memory_usage()
# #         print(f"当前CPU占用率：{cpu_usage}%")
# #         print(f"当前内存占用率：{memory_usage}%")
# #         print("-" * 30)
# #         time.sleep(1)
#

# memory = psutil.virtual_memory()
#     memory_usage = memory.percent
#
#     cpu_usage = psutil.cpu_percent(interval=1)


import pandas as pd
import GPUtil
import time
import psutil

stopped_num = 10000000  # （设置一个最大获取次数，防止记录文本爆炸）
delay = 10  # 采样信息时间间隔
Gpus = GPUtil.getGPUs()


def get_gpu_info():
    """
    :return:
    """
    gpulist = []
    GPUtil.showUtilization()
    for gpu in Gpus:
        print('gpu.id:', gpu.id)
        print('GPU总量：', gpu.memoryTotal)
        print('GPU使用量：', gpu.memoryUsed)
        print('gpu使用占比:', gpu.memoryUtil * 100)
        # 按GPU逐个添加信息
        gpulist.append([gpu.id, gpu.memoryTotal, gpu.memoryUsed, gpu.memoryUtil * 100])

    return gpulist


def get_cpu_info():
    """ :return:
    memtotal: 总内存
    memfree: 空闲内存
    memused: Linux: total - free,已使用内存
    mempercent: 已使用内存占比
    cpu: 各个CPU使用占比
    """
    mem = psutil.virtual_memory()
    memtotal = mem.total/1024
    memfree = mem.free/1024
    mempercent = mem.percent
    memused = mem.used/1024
    cpu = psutil.cpu_percent(percpu=False)
    # print(cpu)

    print(memtotal, memfree, memused, mempercent, cpu)


# 主函数
def main():
    times = 0
    while True:
        # 最大循环次数
        if times < stopped_num:
            # 打印当前时间
            time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(time.time()))
            # 获取CPU信息
            cpu_info = get_cpu_info()
            # 获取GPU信息
            gpu_info = get_gpu_info()
            # 添加时间间隙
            print(cpu_info)
            print(gpu_info, '\n')
            time.sleep(delay)
            times += 1
        else:
            break


if __name__ == '__main__':
    main()

    # get_cpu_info()