echo "update apt-get"
sudo apt-get update -y
echo "install nfs-server"
sudo apt install -y nfs-kernel-server
echo "close the ufw"
sudo ufw disable
echo "enable nfs-server in systemctl"
sudo systemctl enable/disable nfs-server.service
echo "status nfs-server in systemctl"
sudo systemctl status nfs-server.service
echo "start nfs-server in systemctl"
sudo systemctl start nfs-server.service