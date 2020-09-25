参考文档

https://www.cnblogs.com/kevingrace/p/6261091.html

使用percona工具

在 https://www.percona.com/downloads/percona-toolkit/LATEST/ 界面

挂代理, 下载到本地, 使用crt alt+p上传到服务器

可以在任意一台机器上

```
# 下载percona工具
wget https://www.percona.com/downloads/percona-toolkit/3.1/binary/redhat/7/x86_64/percona-toolkit-3.1-1.el7.x86_64.rpm

# 安装percona
rpm -ivh percona-toolkit-3.1-1.el7.x86_64.rpm
```

实际上docker方式使用percona也是可以的

https://hub.docker.com/u/percona

https://hub.docker.com/r/percona/percona-server



