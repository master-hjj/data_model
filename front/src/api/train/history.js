import request from "@/utils/request";


export function getHistory(id) {
  return request({
    url: "/get_train_results/"+id,
    method: "get",
  });
}


export function getConfig() {
  return request({
    url: "/get_all_modelapps",
    method: "get",
  });
}

// export function uploadModel(data) {
//   return request({
//     url: "/upload_modelapp",
//     method: "post",
//     data: data,
//   });
// }

export function deleteHistory(id) {
  return request({
    url: "/delete_train_result/"+id,
    // url: "/delete_appparams/"+id,
    method: "get",
  });
}