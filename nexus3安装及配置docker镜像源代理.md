# 背景分析

在某些情况下, 服务器不能访问外网, 无法正常自由拉取网络上的docker镜像

我们需要找到一台能访问外网的电脑搭建代理服务器去访问网络下载资源

甚至于我们都找不到一台能访问外网的linux服务器， 这个时候需要在windows电脑上下载、配置、安装代理工具

网络上的要求为: 1、代理服务器能访问外网   2、代理服务器能被服务器访问

# 搭建Nexus3

## 下载nexus安装包for windows

https://segmentfault.com/a/1190000015629878

目前我用的是nexus3

## 准备nexus依赖的环境

java 8

maven 3

## 解压、配置nexus

C:\Users\dev\Desktop\nexus-3.23.0-03-win64\nexus-3.23.0-03\bin\nexus.vmoptions

```
-Xms2703m
-Xmx2703m
-XX:MaxDirectMemorySize=2703m
```

### 配置docker镜像仓库域名

```
vi /etc/hosts

10.192.56.204 docker.tristan.zteict.com

ping docker.tristan.zteict.com
```



### https问题(暂时不管)

使用keytool工具

参考: https://blog.csdn.net/shida_csdn/article/details/80006645



如果配置https, 则docker客户端在使用docker代理时则需要单独配置insecure

centos7 情况下: 

```
vi /usr/lib/systemd/system/docker.service

使用 /ExecStart 进行搜索
修改:
ExecStart=/usr/bin/dockerd --insecure-registry 0.0.0.0/0

sudo systemctl daemon-reload
sudo systemctl restart docker
```



## 启动nexus

管理员身份打开cmd

```
C:\Users\dev\Desktop\nexus-3.23.0-03-win64\nexus-3.23.0-03\bin\nexus.exe /run
```

服务常驻:

```
启动nexus服务
C:\Users\dev\Desktop\nexus-3.23.0-03-win64\nexus-3.23.0-03\bin\nexus.exe /start

停止nexus服务
C:\Users\dev\Desktop\nexus-3.23.0-03-win64\nexus-3.23.0-03\bin\nexus.exe /stop
```

## 可能会出现的问题

###  Encoding GBK is not supported yet

不用管, 影响不大, 不影响使用

出现`Started Sonatype Nexus OSS XXX` 即代表成功

## 访问

http://10.192.56.204:8081  

账号: admin

密码: 

密码不再是默认的 admin123

<查看C:\Users\dev\Desktop\nexus-3.23.0-03-win64\sonatype-work\nexus3\admin.password文件>

登录之后重设密码

# 创建Nexus3-Docker

思路

```
1、创建文件存储块
2、创建本地docker镜像存储库(类似Harbor)
3.1、创建代理dockerhub镜像存储库(类似nginx)
3.1、创建代理阿里云docker镜像存储库(类似nginx)
4、创建组合docker镜像存储库, 统一入口和使用
```

### 创建文件存储块

进入Repository页面

![image-20200604153206647](C:\Users\Administrator\Desktop\监控体系\nexus3安装及配置docker镜像源代理.assets\image-20200604153206647.png)

进入Blob Stores

![image-20200604153231031](C:\Users\Administrator\Desktop\监控体系\nexus3安装及配置docker镜像源代理.assets\image-20200604153231031.png)

创建Blob Stores

![image-20200604153247607](C:\Users\Administrator\Desktop\监控体系\nexus3安装及配置docker镜像源代理.assets\image-20200604153247607.png)



![image-20200604153332373](C:\Users\Administrator\Desktop\监控体系\nexus3安装及配置docker镜像源代理.assets\image-20200604153332373.png)



### 创建本地docker镜像存储库

创建一个Repository

![image-20200604153359008](C:\Users\Administrator\Desktop\监控体系\nexus3安装及配置docker镜像源代理.assets\image-20200604153359008.png)

![image-20200604153425181](C:\Users\Administrator\Desktop\监控体系\nexus3安装及配置docker镜像源代理.assets\image-20200604153425181.png)

创建本机仓库

![image-20200604153447072](C:\Users\Administrator\Desktop\监控体系\nexus3安装及配置docker镜像源代理.assets\image-20200604153447072.png)

![image-20200604153527135](C:\Users\Administrator\Desktop\监控体系\nexus3安装及配置docker镜像源代理.assets\image-20200604153527135.png)

![image-20200604153541347](C:\Users\Administrator\Desktop\监控体系\nexus3安装及配置docker镜像源代理.assets\image-20200604153541347.png)

### 创建代理镜像存储库(dockerhub/aliyun)

创建一个代理仓库

![image-20200604153624048](C:\Users\Administrator\Desktop\监控体系\nexus3安装及配置docker镜像源代理.assets\image-20200604153624048.png)

dockerhub:

Remote storage: https://registry-1.docker.io

aliyun:

Remote storage: https://registry.cn-shenzhen.aliyuncs.com

![image-20200604153707486](C:\Users\Administrator\Desktop\监控体系\nexus3安装及配置docker镜像源代理.assets\image-20200604153707486.png)

![image-20200604153849763](C:\Users\Administrator\Desktop\监控体系\nexus3安装及配置docker镜像源代理.assets\image-20200604153849763.png)

![image-20200604153912751](C:\Users\Administrator\Desktop\监控体系\nexus3安装及配置docker镜像源代理.assets\image-20200604153912751.png)



### 创建组合docker镜像存储库

创建一个组合仓库

![image-20200604153940742](C:\Users\Administrator\Desktop\监控体系\nexus3安装及配置docker镜像源代理.assets\image-20200604153940742.png)

![image-20200604154020477](C:\Users\Administrator\Desktop\监控体系\nexus3安装及配置docker镜像源代理.assets\image-20200604154020477.png)

![image-20200604154110442](C:\Users\Administrator\Desktop\监控体系\nexus3安装及配置docker镜像源代理.assets\image-20200604154110442.png)

最终结果如下

![image-20200604154433287](C:\Users\Administrator\Desktop\监控体系\nexus3安装及配置docker镜像源代理.assets\image-20200604154433287.png)

访问: http://10.192.56.204/v2/_catalog

### 启用Docker realms

![image-20200604180944548](C:\Users\Administrator\Desktop\监控体系\nexus3安装及配置docker镜像源代理.assets\image-20200604180944548.png)

## 使用Nexus3-Docker

还原

```
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["http://docker.in.zteict.com"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker

docker search docker.in.zwxict.com/official/java:8u111-jdk
docker rmi 	  docker.in.zwxict.com/official/java:8u111-jdk
docker pull   docker.in.zwxict.com/official/java:8u111-jdk
```

配置使用docker镜像仓库

```
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["http://docker.tristan.zteict.com"]
}
EOF
sudo systemctl daemon-reload
```

测试使用

```
docker pull docker.tristan.zteict.com/hello-world
```





