// import { http2 as request } from "@/utils/request1";
import request from '@/utils/request'

export function uploadpreprocess(data) {
  return request({
    url: "/upload_preprocess",
    method: "post",
    data: data,
  });
}
//

export function delpreprocess(id) {
  return request({
    url: '/delete_preprocess/' + id,
    method: 'get'
  })
}

export function showpreprocess() {
  return request({
    url: "/show_preprocess",
    method: "get",
  });
}

export function classifiedpreprocess() {
  return request({
    url: "/classified_preprocess",
    method: "get",
  });
}
// export function getpreprocessFunction() {
//   return request({
//     url: "/upload_preprocess",
//     method: "get",
//   });
// }

// export function getListByCat(id) {
//   return request({
//     url: "/get_category_preprocesss/" + id,
//     method: "get",
//   });
// }

// export function getpreprocess(id) {
//   return request({
//     url: "/get_preprocess/" + id,
//     method: "get",
//   });
// }

// export function getDataset() {
//   return request({
//     url: "/get_datasets",
//     method: "get",
//   });
// }

// export function getChildDataset(id) {
//   return request({
//     url: "/get_TestData_ById/" + id,
//     method: "get"
//   });
// }

// export function getOwnpreprocess() {
//   return request({
//     url: '/get_ownpreprocesss',
//     method: 'get'
//   })}

// export function getTags() {
//   return request({
//     url: "/get_netcats",
//     method: "get",
//   });
// }