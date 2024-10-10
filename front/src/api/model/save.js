import request from "@/utils/request";


export function get() {
    return request({
        url: "/show_userinfo",
        method: "get",
    });
}