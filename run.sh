#!/bin/bash

# 启动容器
docker-compose -f docker-compose.yml up -d namenode hive-metastore-postgresql
docker-compose -f docker-compose.yml up -d datanode datanode2 datanode3 hive-metastore
docker-compose -f docker-compose.yml up -d resourcemanager
docker-compose -f docker-compose.yml up -d nodemanager
docker-compose -f docker-compose.yml up -d historyserver
sleep 5
docker-compose -f docker-compose.yml up -d hive-server
docker-compose -f docker-compose.yml up -d spark-master spark-worker
docker-compose -f docker-compose.yml up -d mongodb

# 获取ip地址并打印到控制台
my_ip=`ifconfig | grep 'inet.*netmask.*broadcast' |  awk '{print $2;exit}'`
echo "Namenode: http://${my_ip}:50070"
echo "Datanode: http://${my_ip}:50075"
echo "Spark-master: http://${my_ip}:18080"

# 执行脚本，spark yarn支持
docker-compose exec spark-master bash -c "./copy-jar.sh && exit"
