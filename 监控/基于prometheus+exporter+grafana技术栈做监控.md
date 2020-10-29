# 思路

一般思路为: 部署prometheus作为数据存储源, 部署exporter作为数据采集点, 配置exporter到prometheus中进行定时采集数据, 使用grafana图表编写promql表达式进行查询数据展示

但是仍然有一些问题

exporter的初始化及运行状态检测

prometheus是否需要部署在k8s中? 如果存在多个k8s? 

​	监控系统应该独立运维系统, 不产生耦合

多环境数据的集合? 

​	使用PushGateway进行数据汇聚

安装方式:

​	prometheus、grafana、alertmanager等应该尽可能使用docker方式部署

​	数据采集exporter, 根据实际环境进行选择安装, node_exporter应该使用二进制方式安装(而非docker), 使用批量脚本进行安装

# 部署

## prometheus

```
# 清理prometheus
docker stop promethues && docker rm prometheus

# 创建数据存储目录
rm -rf /tristan/prometheus
mkdir -p /tristan/prometheus/data /tristan/prometheus/config
chmod -R 777 /tristan/prometheus/data /tristan/prometheus/config

# 拷贝配置文件目录出来
docker run -d --name prometheus prom/prometheus:v2.18.1
docker cp prometheus:/etc/prometheus/ /tristan/prometheus/config/
docker stop prometheus && docker rm prometheus

# 启动prometheus
docker run -d \
  --name=prometheus \
  --restart=always \
  -p 9090:9090 \
  -v /tristan/prometheus/config:/etc/prometheus \
  -v /tristan/prometheus/data:/prometheus \
  prom/prometheus:v2.18.1

# 查看日志
docker logs -f prometheus

# 访问
http://192.168.90.223:9090

# 修改配置文件/tristan/prometheus/config/prometheus.yml
# 重启容器
docker restart prometheus
```





## node_exporter

下载node_exporter到本地

```
yum install -y wget
wget https://github.com/prometheus/node_exporter/releases/download/v1.0.1/node_exporter-1.0.1.linux-amd64.tar.gz
tar -zvxf node_exporter-1.0.1.linux-amd64.tar.gz
cp node_exporter-1.0.1.linux-amd64/node_exporter node_exporter
```

修改target_server文件, 添加需要采集主机信息的ip列表

```

```

修改password, 修改主机的密码

```

```

let_remote_install_node_exporter.py

```
import os
import time

# read target server config
target_server_list = []
target_server_file_name = "target_server"
password_file_name = "password"
with open(target_server_file_name) as f:
    original_target_server_list = f.readlines()
    for item in original_target_server_list:
        if not item or "" == item:
            continue
        item = item.strip().replace("\n", "").replace("\t", "")
        target_server_list.append(item)

with open(password_file_name) as f:
    password = f.read().strip().replace("\n", "").replace("\t", "")
os.system("echo target_server: %s \n password:%s" % (str(target_server_list), password))

# install sshpass
os.system("yum install -y sshpass")
time.sleep(1)


def exec_remote_shell(remote_host, remote_password, shell):
    command = """ sshpass -p %s ssh root@%s -o StrictHostKeyChecking=no "%s" """ % (remote_password, remote_host, shell)
    os.system("""echo "command is: %s" """ % command)
    os.system(command)
    time.sleep(1)


def transfer_remote_file(remote_host, remote_password, local_filepath, remote_filepath):
    command = """sshpass -p %s scp %s root@%s:%s""" % (remote_password, local_filepath, remote_host, remote_filepath)
    os.system("""echo "command is: %s" """ % command)
    os.system(command)
    time.sleep(2)


os.system("echo send script file to target server")
for item in target_server_list:
    transfer_remote_file(item, password, "node_exporter", "node_exporter")
    exec_remote_shell(item, password, "chmod +x node_exporter")
    exec_remote_shell(item, password, "kill $(ps aux|grep ~/node_exporter |  awk '{print $2}')")
    exec_remote_shell(item, password, "nohup  ~/node_exporter --web.listen-address=':9101' > node_exporter.log 2>&1 &")
    exec_remote_shell(item, password, "curl http://localhost:9101/metrics")
    time.sleep(3)
os.system(""" echo "all right done, thank you for use this script" """)
```

运行分发指令执行

```
python let_remote_install_node_exporter.py
```

gen_prometheus_scrape_config.py

```
target_server_list = []
with open('target_server') as f:
    original_target_server_list = f.readlines()
    for item in original_target_server_list:
        if not item or "" == item:
            continue
        item = item.strip().replace("\n", "").replace("\t", "")
        target_server_list.append(item)

result = ""
for item in target_server_list:
    result += """  - job_name: 'node_exporter_%s'
    metrics_path: '/metrics'
    static_configs:
    - targets: ['%s:9100']\n""" % (item, item)
with open('prometheus.yml', 'w') as f:
    f.write(result)
print(result)
```

运行生成prometheus scrape采集点, 查看prometheus.yml文件

```
python gen_prometheus_scrape_config.py
```

## grafana

```
# official doc address: https://grafana.com/grafana/download/7.2.2?platform=docker
# official docker image address: https://hub.docker.com/r/grafana/grafana
rm -rf /tristan/grafana/configs /tristan/grafana/data
mkdir -p /tristan/grafana/configs /tristan/grafana/data
chmod -R 777 /tristan/grafana/configs /tristan/grafana/data
# start grafana
# warning: mount just for /root directory
docker run -d \
  --name=grafana \
  --restart=always \
  -p 80:3000 \
  -v /tristan/grafana/data:/var/lib/grafana \
  grafana/grafana:7.2.2
# also can update cofing by:   -v /tristan/grafana/configs/grafana.ini:/etc/grafana/grafana.ini \
# also can update icon by:   -v /tristan/grafana/configs/grafana_icon.svg:/usr/share/grafana/public/img/grafana_icon.svg \
# stop grafana
docker sotp grafana
# delete grafana
docker rm grafana
# monitor grafana running status
docker ps | grep grafana
# visit now the log of grafana
docker logs -f --tail=100 grafana
```

访问: http://IP

