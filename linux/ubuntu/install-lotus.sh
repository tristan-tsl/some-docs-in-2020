echo "requirements: 8-core CPU and 32 GiB RAM"
echo "Models with support for Intel SHA Extensions (AMD since Zen microarchitecture, or Intel since Ice Lake) will significantly speed things up"
echo "install necessary dependencies"
sudo apt install mesa-opencl-icd ocl-icd-opencl-dev gcc git bzr jq pkg-config curl clang build-essential -y && sudo apt upgrade -y

echo "time adjust"
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
ntpdate ntp.aliyun.com

echo "ulimit adjust"
ulimit -n 1048576
sed -i "/nofile/d" /etc/security/limits.conf
echo "* hard nofile 1048576" >> /etc/security/limits.conf
echo "* soft nofile 1048576" >> /etc/security/limits.conf
echo "root hard nofile 1048576" >> /etc/security/limits.conf
echo "root soft nofile 1048576" >> /etc/security/limits.conf



echo "install rustup"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
echo "install go"
wget -c https://dl.google.com/go/go1.14.7.linux-amd64.tar.gz -O - | sudo tar -xz -C /usr/local
echo "export PATH=$PATH:/usr/local/go/bin" > /etc/profile
export PATH=$PATH:/usr/local/go/bin
go version


echo "install lotus"
git clone https://github.com/filecoin-project/lotus.git
cd lotus/
git checkout 0.10.0
echo "special for chian"
echo "Speed up proof parameter download for first boot"
export IPFS_GATEWAY=https://proof-parameters.s3.cn-south-1.jdcloud-oss.com/ipfs/
echo "Speed up Go module download during builds"
export GOPROXY=https://goproxy.cn

export RUSTFLAGS="-C target-cpu=native -g"
export FFI_BUILD_FROM_SOURCE=1

export CGO_CFLAGS_ALLOW="-D__BLST_PORTABLE__"
export CGO_CFLAGS="-D__BLST_PORTABLE__"

echo "build and install Lotus"
make clean all
sudo make install

echo "start the Lotus daemon"
lotus daemon --import-snapshot https://fil-chain-snapshots-fallback.s3.amazonaws.com/mainnet/minimal_finality_stateroots_latest.car
lotus daemon

echo "support SHA extensions"
export RUSTFLAGS="-C target-cpu=native -g"
export FFI_BUILD_FROM_SOURCE=1

echo "wait for sync"
lotus sync wait

echo "check the number of other peers that it is connected to in the Filecoin network"
lotus net peers


echo "see the default wallet"
lotus wallet default