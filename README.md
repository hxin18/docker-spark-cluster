# docker-spark-cluster
To deploy hadoop and spark and config cluster in dockers in ubuntu 16.04

## Build
```bash
docker build .
docker tag IMAGE_ID yuchen/spark
```

## Deploy a cluster with 3 nodes
- Run three containers: cloud1, cloud2 and cloud3
```bash
sudo docker run --name cloud1 -h cloud1 --add-host cloud1:172.17.0.2 --add-host cloud2:172.17.0.3 --add-host cloud3:172.17.0.4 -it yuchen/spark
sudo docker run --name cloud2 -h cloud2 --add-host cloud1:172.17.0.2 --add-host cloud2:172.17.0.3 --add-host cloud3:172.17.0.4 -it yuchen/spark
sudo docker run --name cloud3 -h cloud3 --add-host cloud1:172.17.0.2 --add-host cloud2:172.17.0.3 --add-host cloud3:172.17.0.4 -it yuchen/spark
```
- Run in cloud2:
```bash
echo 2 > ~/zookeeper/tmp/myid
```
- Run in cloud3:
```bash
echo 3 > ~/zookeeper/tmp/myid
```
- Run in all containers:
```bash
zkServer.sh start
hadoop-daemon.sh start journalnode
```
- Run in master container, we chose cloud1 here: 
```bash
hdfs zkfc -formatZK
hdfs namenode -format

start-dfs.sh
start-yarn.sh
start-all.sh
```
