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
    password = f.read()
os.system("echo target_server: %s \n password:%s" % (str(target_server_list), password))

# install sshpass
os.system("apt-get install sshpass")
time.sleep(1)


def exec_remote_shell(remote_host_ip, remote_host_password, shell):
    command = """ sshpass -p %s ssh root@%s "%s" """ % (remote_host_password, remote_host_ip, shell)
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
    transfer_remote_file(item, password, "/root/106/pro/lotus-miner-pro.f7-0.10.0.tar.gz",
                         "lotus-miner-pro.f7-0.10.0.tar.gz")
    transfer_remote_file(item, password, "install.sh", "install.sh")
    exec_remote_shell(item, password, "chmod +x install.sh && sh install.sh")

os.system(""" echo "all right done, thank you for use this script" """)
