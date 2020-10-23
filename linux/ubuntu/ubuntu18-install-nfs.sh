echo "update apt-get"
sudo apt-get update -y

sleep 1
echo "install nfs-server"
sudo apt install -y nfs-kernel-server

sleep 1
echo "close the ufw"
sudo ufw disable

sleep 1
echo "enable nfs-server in systemctl"
sudo systemctl enable nfs-server.service

sleep 1
echo "update exports"
sudo cat >> /etc/exports<<EOF
/mnt/md0  *(rw,async,no_subtree_check,no_root_squash)
EOF

sleep 1
echo "enable nfs-server in systemctl"
sudo systemctl enable nfs-server.service

sleep 1
echo "start nfs-server in systemctl"
sudo systemctl start nfs-server.service

sleep 1
echo "status nfs-server in systemctl"
sudo systemctl status nfs-server.service

