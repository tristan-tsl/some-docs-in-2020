import os
import time

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
password = ""
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


def transfer_remote_file(remote_host, remote_password, local_filepath, remote_filepath):
    command = """sshpass -p %s scp %s root@%s:%s""" % (password, local_filepath, item, remote_filepath)
    os.system("""echo "command is: %s" """ % command)
    os.system(command)


os.system("echo send script file to target server")
for item in target_server_list:
    transfer_remote_file(item, password, "~/mount_nfs.py", "mount_nfs.py")
    exec_remote_shell(item, password, "apt install -y python")
    exec_remote_shell(item, password, "python mount_nfs.py")

os.system(""" echo "all right done, thank you for use this script" """)
