echo "update apt-get"
sudo apt-get update -y
echo "install nfs-client"
sudo apt-get install nfs-common
echo "mount dir"
mount -t nfs  192.168:/data /data/fil001