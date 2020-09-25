mysql主从思路
搭建一主一从

搭建mysql

网络

```
yum install -y net-tools
ifconfig
ping baidu.com
```

yum方式安装mysql8.0

```shell
# 安装mysql
yum localinstall https://repo.mysql.com//mysql80-community-release-el7-1.noarch.rpm -y
# 安装mysql服务
yum install mysql-community-server -y
# 启动mysql
systemctl enable mysqld
systemctl daemon-reload
systemctl start  mysqld
systemctl status mysqld
# 查看mysql密码
grep 'temporary password' /var/log/mysqld.log
# 修改mysql密码
mysql -uroot -p
ALTER USER 'root'@'localhost' IDENTIFIED BY 'Tristan0615-';
FLUSH PRIVILEGES;
# 设置外部可以访问
use mysql
update user set host='%' where user ='root';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%'WITH GRANT OPTION;
FLUSH PRIVILEGES;
exit
```

记得关闭防火墙

```
# 防火墙状态
firewall-cmd --state
# 关闭防火墙
systemctl stop firewalld.service
systemctl disable firewalld.service 
```

配置主从(都要执行一遍)

vi /etc/my.cnf

```
[mysqld]
server-id=100
log-bin=mysql-bin
```

从

```
[mysqld]
server-id=101
log-bin=mysql-slave-bin
relay_log=mysql-slave-relay-bin
```



然后

```
# 重启mysql
systemctl restart mysqld
systemctl status  mysqld

# 在主节点上创建slave用户以及授权
mysql -uroot -pTristan0615-
CREATE USER 'slave'@'%' IDENTIFIED BY 'Tristan0615-';
ALTER USER 'slave'@'%' IDENTIFIED WITH mysql_native_password BY 'Tristan0615-';
GRANT REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'slave'@'%';
# 查看主节点状态
show master status;

# 在从节点上配置主从同步
mysql -uroot -pTristan0615-
change master to master_host='192.168.121.128', master_user='slave', master_password='Tristan0615-', master_port=3306, master_log_file='mysql-bin.000001', master_log_pos=2139, master_connect_retry=5;

## 启动主从同步
reset slave;
start slave;
show slave status \G;
## SlaveIORunning 和 SlaveSQLRunning 都是Yes说明主从复制已经开启

## 停止主从同步
stop slave;
set GLOBAL SQL_SLAVE_SKIP_COUNTER=1; 
```

操作记录
指令编写
ansible-playbook编写
搭建多主多从
提出疑问





一主一从搭建:

https://juejin.im/post/6844903921677238285#heading-3



多主多从搭建:

https://www.cnblogs.com/ygqygq2/p/6045279.html