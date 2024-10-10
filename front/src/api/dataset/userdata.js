import request from "@/utils/request";

export function getUserData() {
    return request({
        url: "show_userdata",
        method: "get",
    });
}

export function showUserData(id) {
    return request({
        url: "get_userdata_info/"+id,
        method: "get",
    });
}


export function delById(id) {
    return request({
        url: 'delete_userdata/' + id,
        method: 'delete'
    })
}