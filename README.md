# 甲骨文本机自检 自动更换IP
# 执行前确保服务器有 IPv6 不然服务器会失联 


## Docker 版
``` bash
docker run --name ip-changer -itd --restart=always --net=host 你的镜像名 bash -c "curl -s https://raw.githubusercontent.com/xiaoxiaobujidao/oracle-ip-changer/refs/heads/master/main.sh | bash"
```

## 或者直接使用脚本
``` bash
curl -s https://raw.githubusercontent.com/xiaoxiaobujidao/oracle-ip-changer/refs/heads/master/main.sh | bash
```