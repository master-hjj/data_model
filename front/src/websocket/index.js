const socketService = {
    socket: null,
    init(username) {
        if (typeof WebSocket === "undefined") {
            alert("您的浏览器不支持socket");
        } else {
            // ws://10.244.11.117:8089/dashboard/websocket/
            let path = "ws://localhost:8765"; // 请求路径
            this.socket = new WebSocket(path);
            this.socket.onopen = this.open.bind(this);
            this.socket.onerror = this.error.bind(this);
            this.socket.onmessage = this.getMessage.bind(this);
        }
    },
    open() {
        console.log("socket连接成功");
    },
    error() {
        console.log("连接错误");
    },
    getMessage(msg) {
        return new Promise((resolve, reject) => {
            this.socket.onmessage = (msg) => {
                console.log(msg.data);
                // 利用promise 返回出去结果
                if (msg.data != '连接成功' && JSON.parse(msg.data)) {
                    const data = JSON.parse(msg.data);
                    resolve(data); // 将数据传递给调用者
                }
                // this.scrollInstance.refresh(); // 手动刷新滚动效果
            };
        });
        // this.scrollInstance.refresh(); // 手动刷新滚动效果
    },
    send(params) {
        if (this.socket) {
            this.socket.send(params);
        }
    },
    close() {
        this.socket.close()
        console.log("socket已经关闭");
    }
};
//最后导出
export default socketService;