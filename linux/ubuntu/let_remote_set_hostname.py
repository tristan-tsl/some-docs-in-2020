import os
import time

"""
完善方向:
    并行调执行(调度)
    状态
    日志
    数据声明式
"""

# read target server config
target_server_list = []
target_server_file_name = "target_server"
password_file_name = "password"
with open(target_server_file_name) as f:
    target_server_list = f.readlines()
    for index in range(len(target_server_list)):
        item = target_server_list[index]
        if not item or "" == item:
            target_server_list.pop(index)
with open(password_file_name) as f:
    password = f.read()
os.system("echo target_server: %s \n password:%s" % (str(target_server_list), password))

# install sshpass
os.system("apt-get install sshpass")
time.sleep(1)


def exec_remote_shell(remote_host_ip, remote_host_password, shell):
    command = """ sshpass -p %s ssh root@%s "%s" """ % (remote_host_password, remote_host_ip, shell)
    os.system("""echo "command is: %s" """ % command)
    os.system(command)


for item in target_server_list:
    hostname = "storage_" + item[item.find(".", 3):].replace(".", "_")
    exec_remote_shell(item, password, "hostnamectl set-hostname ")

os.system(""" echo "all right done, thank you for use this script" """)
