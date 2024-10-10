from datetime import datetime
import psutil
import sys
import GPUtil
import torch
import asyncio
import websockets
import json
import platform

version = sys.version_info
Gpus = GPUtil.getGPUs()
mem = psutil.virtual_memory()
# flag = True

def get_cpu_model():
    if platform.system() == "Windows":
        return platform.processor()
    elif platform.system() == "Darwin":
        return platform.machine()
    elif platform.system() == "Linux":
        with open('/proc/cpuinfo', 'r') as f:
            for line in f:
                if line.startswith('model name'):
                    return line.split(':')[1].strip()
    return "Unknown"

def get_os():
    os_name = platform.system()
    return os_name

# os = get_os()
# if os == "Windows":
#     print("当前系统是Windows")
# elif os == "Linux":
#     print("当前系统是Linux")
# else:
#     print("当前系统是其他")
# async def cpu_usage_loop(websocket):
#     while flag:
#         # 获取 CPU 占用率数据的逻辑，假设使用一个函数 get_cpu_usage() 获取 CPU 占用率
#         cpu_usage = get_cpu_usage()
#         print("still  running")
#         # 发送 CPU 占用率数据给前端
#         await websocket.send(cpu_usage)
#
#         # 等待一定时间（10秒）后再次发送更新后的 CPU 占用率数据
#         await asyncio.sleep(5)


class DeviceInfo:
    __tablename__ = 'DEVICE'
    python_version = "%d.%d.%d" % (version.major, version.minor, version.micro)
    cuda_version = torch.version.cuda
    device_count = len(Gpus)
    cpu_usage = psutil.cpu_percent(interval=1)
    gpu_name = Gpus[0].name
    cpu_usage=psutil.cpu_percent()
    ram_usage= mem.percent
    cpu_name = get_cpu_model()
    platform=get_os()
    memtotal = round(mem.total/1073741824,2)
    memused = round(mem.used/1073741824,2)
    # def start_loop(self):
    #     start_server = websockets.serve(cpu_usage_loop, 'localhost', 8765)
    #     asyncio.get_event_loop().run_until_complete(start_server)
    #     asyncio.get_event_loop().run_forever()

    def to_json(self):
        return {
            'python_version': self.python_version,
            'cuda_version': self.cuda_version,
            'device_count': self.device_count,
            'gpu_name':self.gpu_name,
            'cpu_usage':self.cpu_usage,
            'ram_usage':self.ram_usage,
            'cpu_name':self.cpu_name,
            'platform':self.platform,
            'memtotal':self.memtotal,
            'memused':self.memused
        }


