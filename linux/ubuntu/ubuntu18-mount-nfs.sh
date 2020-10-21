sudo apt-get install nfs-common -y
echo "update exports"
# declare ip array for after use
ip_array=("10.11.1.2" "10.11.1.4" "10.11.1.6" "10.11.1.8" "10.11.1.10" "10.11.1.12" "10.11.1.16" "10.11.1.18" "10.11.1.20" "10.11.1.22" "10.11.4.52" "10.11.4.54" "10.11.4.58" "10.11.4.60" "10.11.4.62" "10.11.4.64" "10.11.4.66" "10.11.4.68")
for(( i=1;i<=${#ip_array[@]};i++)) do
item=$ip_array[@];
item=`awk '{split("$item",a,'\.');a[3]a[4]}'`
echo $item
done;




mkdir -p /data/fil001

sudo cat >> /etc/fstab<<EOF
10.11.1.2:/mnt/md0 /data/fil_1_2  nfs4      defaults    0       0
10.11.1.4:/mnt/md0 /data/fil002  nfs4      defaults    0       0
10.11.1.6:/mnt/md0 /data/fil003  nfs4      defaults    0       0
10.11.1.8:/mnt/md0 /data/fil004  nfs4      defaults    0       0
10.11.1.10:/mnt/md0 /data/fil005  nfs4      defaults    0       0
10.11.1.12:/mnt/md0 /data/fil006  nfs4      defaults    0       0
10.11.1.16:/mnt/md0 /data/fil007  nfs4      defaults    0       0
10.11.1.18:/mnt/md0 /data/fil008  nfs4      defaults    0       0
10.11.1.20:/mnt/md0 /data/fil009  nfs4      defaults    0       0
10.11.1.22:/mnt/md0 /data/fil010  nfs4      defaults    0       0
10.11.4.52:/mnt/md0 /data/fil011  nfs4      defaults    0       0
10.11.4.54:/mnt/md0 /data/fil012  nfs4      defaults    0       0
10.11.4.58:/mnt/md0 /data/fil013  nfs4      defaults    0       0
10.11.4.60:/mnt/md0 /data/fil014  nfs4      defaults    0       0
10.11.4.62:/mnt/md0 /data/fil015  nfs4      defaults    0       0
10.11.4.64:/mnt/md0 /data/fil016  nfs4      defaults    0       0
10.11.4.66:/mnt/md0 /data/fil017  nfs4      defaults    0       0
10.11.4.68:/mnt/md0 /data/fil018  nfs4      defaults    0       0

EOF

echo "mount all config"
mount -a
df -h  /data/fil001 
df -h  /data/fil002 
df -h  /data/fil003 
df -h  /data/fil004 
df -h   /data/fil005
df -h   /data/fil006
df -h   /data/fil007
df -h   /data/fil008
df -h   /data/fil009
df -h   /data/fil010
df -h   /data/fil011
df -h   /data/fil012
df -h   /data/fil013
df -h   /data/fil014
df -h   /data/fil015
df -h   /data/fil016
df -h   /data/fil017
df -h   /data/fil018

# umount /data/fil001





