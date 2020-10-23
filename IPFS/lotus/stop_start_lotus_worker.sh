echo "kill the lotus-worker"
kill $(ps -ef | grep lotus-worker | grep -v grep | awk '{print $2}')
sleep 3;
echo | ps -ef | grep lotus-worker | grep -v grep | awk '{print $2}'
echo "start lotus-worker"
nohup lotus-worker run --listen $1:3456 --attach /mnt/md0 >~/worker.log 2>&1 &
sleep 3;
echo | ps -ef | grep lotus-worker | grep -v grep | awk '{print $2}'