import os

os.system("echo install dependencies")
os.system("sudo apt-get install nfs-common -y")
os.system("echo declare the nfs server list")
nfs_server_list = [
    "10.11.1.2"
    , "10.11.1.4"
    , "10.11.1.6"
    , "10.11.1.8"
    , "10.11.1.10"
    , "10.11.1.12"
    , "10.11.1.16"
    , "10.11.1.18"
    , "10.11.1.20"
    , "10.11.1.22"
    , "10.11.4.52"
    , "10.11.4.54"
    , "10.11.4.58"
    , "10.11.4.60"
    , "10.11.4.62"
    , "10.11.4.64"
    , "10.11.4.66"
    , "10.11.4.68"
]
os.system("echo create dir")
base_dir = "/data/fil"
nfs_server_suffix_list = []
for item in nfs_server_list:
    suffix = base_dir + item[item.find(".", 3):].replace(".", "_")
    nfs_server_suffix_list.append(suffix)
for item in nfs_server_suffix_list:
    command = "mkdir -p " + item
    os.system(command)
os.system("echo adjust config")
command = ""
for index in range(len(nfs_server_suffix_list)):
    suffix = nfs_server_suffix_list[index]
    ip_addr = nfs_server_list[index]
    command += "%s:/mnt/md0 %s  nfs4      defaults    0       0" % (ip_addr, suffix)
os.system("""
sudo cat >> /etc/fstab<<EOF
%s
EOF
""" % command)
os.system("echo mount all config")
os.system("mount -a")
command = ""
for item in nfs_server_suffix_list:
    command += "df -h  %s" % item
os.system(command)
