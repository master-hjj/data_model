import asyncio
import websockets
import json
def get_cpu_usage():
    return json.dumps({"num":"1"})
async def cpu_usage(websocket, path):
    while True:
        # 获取 CPU 占用率数据的逻辑，假设使用一个函数 get_cpu_usage() 获取 CPU 占用率
        cpu_usage = get_cpu_usage()

        # 发送 CPU 占用率数据给前端
        await websocket.send(cpu_usage)

        # 等待一定时间（10秒）后再次发送更新后的 CPU 占用率数据
        await asyncio.sleep(5)


start_server = websockets.serve(cpu_usage, 'localhost', 8765)

asyncio.get_event_loop().run_until_complete(start_server)
asyncio.get_event_loop().run_forever()