import qs from 'qs'
import request from "@/utils/request";


export function getDataset() {
  return request({
    url: "show_dataset",
    method: "get",
  });
}

export function postData(data) {
  return request({
    url: "upload_dataset",
    method: "post",
    data: data,

  });
}

export function delById(id) {
  return request({
    url: 'delete_dataset/' + id,
    method: 'delete'
  })
}

export function getRowCol(id) {
  return request({
    url: "get_csv_dimensions/" + id ,
    method: "get",
  });
}


export function getDetailData(id) {
  return request({
    url: "get_csv_data/" + id ,
    method: "get",
  });
}


export function selectRowCol(id, input, output,name) {
  return request({
    url: "select_dataset/" + id,
    method: "post",
    params: {
      in: input,
      out: output,
      name:name
    },
    paramsSerializer: function (params) {
      return qs.stringify(params, { arrayFormat: 'repeat' })
    }
  });
}


















// export function postData(data) {
//   return request({
//     url: "dataset",
//     method: "post",
//     data: data,
//     // headers: { "Content-Type": "multipart/form-data" },
//   });
// }



// export function getData() {
//   return request({
//     url: "/dataset/all",
//     method: "get",
//     // headers: { "Content-Type": "multipart/form-data" },
//   });
// }










// export function getDataa(id) {
//   return request({
//     url: "/dataset/" + id + "/data",
//     method: "get",
//     // headers: { "Content-Type": "multipart/form-data" },
//   });
// }


// https://blog.csdn.net/weixin_43970434/article/details/121402694