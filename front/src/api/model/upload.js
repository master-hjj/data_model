// import { http2 as request } from "@/utils/request1";
import request from '@/utils/request'

export function uploadNetwork(data) {
  return request({
    url: "/upload_network",
    method: "post",
    data: data,
  });
}

export function getNetworkFunction() {
  return request({
    url: "/upload_network",
    method: "get",
  });
}

export function showNetworks() {
  return request({
    url: "/show_networks",
    method: "get",
  });
}//

export function getListByCat(id) {
  return request({
    url: "/get_category_networks/" + id,
    method: "get",
  });
}

export function getNetwork(id) {
  return request({
    url: "/get_network/" + id,
    method: "get",
  });
}


export function getDataset() {
  return request({
    url: "/get_datasets",
    method: "get",
  });
}

export function getChildDataset(id) {
  return request({
    url: "/get_TestData_ById/" + id,
    method: "get"
  });
}


export function delNetwork(id) {
  return request({
    url: '/delete_network/' + id,
    method: 'get'
  })
}

export function getOwnNetwork() {
  return request({
    url: '/get_ownnetworks',
    method: 'get'
  })
}


// export function getTags() {
//   return request({
//     url: "/get_netcats",
//     method: "get",
//   });
// }