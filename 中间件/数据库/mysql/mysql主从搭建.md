mysql主从思路
搭建一主一从

yum方式安装mysql8.0

```shell
# 安装mysql
yum localinstall https://repo.mysql.com//mysql80-community-release-el7-1.noarch.rpm
# 安装mysql服务
yum install mysql-community-server
# 启动mysql
systemctl enable mysqld
systemctl daemon-reload
systemctl start  mysqld
systemctl status mysqld
# 查看mysql密码
grep 'temporary password' /var/log/mysqld.log
# 修改mysql密码
mysql -uroot -p
ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'Tristan0615-';
FLUSH PRIVILEGES;
# 设置外部可以访问
use mysql
update user set host='%' where user ='root';
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%'WITH GRANT OPTION;
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



操作记录
指令编写
ansible-playbook编写
搭建多主多从
提出疑问





一主一从搭建:

https://juejin.im/post/6844903921677238285#heading-3



多主多从搭建:

https://www.cnblogs.com/ygqygq2/p/6045279.html