服务器上目录: ~/tristan/ansible

```
mkdir -p ~/tristan/ansible
```

填充服务器ip列表到hosts文件, 例如

```
cat >> ~/tristan/ansible/nfs/hosts << EOF
1.2.3.4
EOF
```

运行指令: 

```
ansible-playbook -i ~/tristan/ansible/nfs/hosts ~/tristan/ansible/nfs/install_nfs_server.yml

ansible-playbook -i hosts install_nfs_server.yml
```

