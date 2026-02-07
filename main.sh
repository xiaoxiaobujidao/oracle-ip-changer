#!/bin/bash
# 循环
while true
do
# 检查当前IP联通性 （鉴于现在基本只墙IP，直接检查大陆互联
# 联通则什么都不做，不联通则更换IP）
# 三次检查 通过则退出
curl -4 baidu.com > /dev/null 2>&1 || curl -4 baidu.com > /dev/null 2>&1 || curl -4 baidu.com > /dev/null 2>&1 && exit 0

# 如果没有安装jq （只考虑 oracle linux
if ! command -v jq &> /dev/null
then
    echo "jq is not installed, installing..."
    sudo dnf install -y jq
fi

# 获取当前IP
public_ip=$(curl -4 ifconfig.me)

# 打印时间
date

# 打印当前IP
echo "current ip: $public_ip"
echo "被墙正在更换IP..."

# 配置文件
CONFIG_FILE='/root/.oci/config' 

# 获取compartmentId
compartmentId=$(oci iam user list --config-file $CONFIG_FILE | jq -r '.[][0]."compartment-id"')

# 获取实例列表
instance_json=$(oci compute instance list -c $compartmentId --config-file $CONFIG_FILE)
echo $instance_json	

json=$(oci network public-ip get --public-ip-address $public_ip --config-file $CONFIG_FILE)
# 获取公共ip ID
publicipId=$(echo $json | jq -r '.data.id')
#获取私有ip ID
privateipId=$(echo $json | jq -r '.data."private-ip-id"')			
#删除原公共ip
oci network public-ip delete --public-ip-id $publicipId --force --config-file $CONFIG_FILE
#新建公共ip
oci network public-ip create -c $compartmentId --private-ip-id $privateipId --lifetime EPHEMERAL --config-file $CONFIG_FILE

date
echo "IP更换完成"

sleep 300
done