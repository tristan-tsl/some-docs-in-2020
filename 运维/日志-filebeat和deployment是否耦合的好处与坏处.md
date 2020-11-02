# **filebeat和deployment耦合：**

每一个deployment都要跑一个伴生容器, 挂载共享存储卷

## **好处:**

每个pod都是独立的日志采集程序, 任意一个日志采集卡顿都不会影响整体

日志文件目录跟宿主机没有关系, 更加云化

日志文件生命周期跟着pod的生命周期保持一致, 不需要额外管理, 因为如果是挂载日志目录到宿主机的话, 随着deployment的随机调度, 几乎每一台node中都会有几乎所有的deployment的目录以及pod_name的日志目录, 随着时间的推进, 宿主机的磁盘很难能存储的下, 这个时候就需要定时去清理, 这就是额外管理成本



## **坏处:**

每一个deployment都要配置一个伴生filebeat



# **filebeat不和deployment耦合**

deployment挂载日志目录到宿主机上, 使用deamonset让每一台服务器上都跑一个filebeat

每个deployment都要在挂载宿主的目录上再加两层: /<deployment_name>/<pod_name>

## **好处:**

每个deployment都是独立的, 专注度更高

因为每个主机只有一个filebeat, 所以整体管理数量更少 

## **坏处:**

日志采集程序不独立, 当某个deployment日志产生过快时, 可能会导致整体日志采集失败

需要单独编码定时查询k8s deployment pod情况, 以及宿主机的磁盘空间度, 清理每台宿主机的日志目录, 清理频率跟磁盘大小和日志生成频率有关联关系

不够云化, deployment的部署需要考虑宿主机的磁盘目录情况, 如果宿主机情况有很多差异, 还需要更加多的考虑