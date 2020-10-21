# 如果miner和worker不在一台机器，需要将miner机器LOTUS_STORAGE_PATH下的api和token两个文件拷贝到worker机器的LOTUS_STORAGE_PATH下

# 可选的环境变量
# 以下设置会让PreCommit1使用更多的内存并且计算更快，在推荐的硬件配置上建议使用
# 需要给miner和worker都设置
export FIL_PROOFS_SDR_PARENTS_CACHE_SIZE=1073741824
# 以下设置会让worker使用GPU计算PreCommit2。
export FIL_PROOFS_USE_GPU_COLUMN_BUILDER=1
export FIL_PROOFS_USE_GPU_TREE_BUILDER=1
# 以下设置将会让worker显示更详细的日志
export RUST_BACKTRACE=full
export RUST_LOG=debug

# 启动worker，需要加入局域网IP
lotus-worker run --listen xxx.xxx.xxx.xxx:3456 > ~/worker.log 2>&1 &
# 查看日志
tail -f ~/miner.log