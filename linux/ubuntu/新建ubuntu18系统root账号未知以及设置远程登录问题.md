在用虚拟机安装ubuntu18之后, 发现未知root账号密码, 而且已有账号也无法登录

修改root账号密码

```
sudo passwd root

# 输入一次现在登录的账号的密码
# 输入一次root账号的密码
# 再输入一次root账号的密码
```

现在就可以用root账号进行登录

用root账号进行登录

修改ssh远程连接配置

```
vi /etc/ssh/sshd_config

# 替换 #PermitRootLogin prohibit-password 为 PermitRootLogin yes

# 重启ssh服务
/etc/init.d/ssh restart
```



查看网络ip

```
ifconfig
```

在就可以使用该主机的ip和root账号和密码进行远程连接了