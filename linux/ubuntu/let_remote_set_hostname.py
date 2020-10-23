import os
import time

"""
improve point:
    parallel invoke(schedule)
    status
    log
    data declaration
"""

# read target server config
target_server_list = []
target_server_file_name = "target_server"
password_file_name = "password"
with open(target_server_file_name) as f:
    target_server_list_temp = f.readlines()
    for item in target_server_list_temp:
        item = item.strip().replace("\n", "").replace("\t", "")
        if "" != item:
            target_server_list.append(item)

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
    hostname = "storage" + item[item.find(".", 3):].replace(".", "_")
    exec_remote_shell(item, password, "hostnamectl set-hostname " + hostname)

os.system(""" echo "all right done, thank you for use this script" """)
