import os

target_server_list = []
target_server_file_name = "target_server"
password_file_name = "password"
with open(target_server_file_name) as f:
    target_server_list = f.readlines()
password = ""
with open(password_file_name) as f:
    password = f.read()
os.system("echo target_server: %s \n password:%s" % (str(target_server_list), password))

# install sshpass
os.system("apt-get install sshpass")

os.system("echo send script file to target server")
for item in target_server_list:
    os.system("sshpass -p %s scp mount_nfs.py root@%s:mount_nfs.py" % (password, item))
