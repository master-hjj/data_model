import request from '@/utils/request'


export function getDeviceInfo() {
    return request({
        url: '/index/deviceinfo',
        method: 'get'
    })
}