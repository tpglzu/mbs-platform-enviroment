#!/bin/bash

# 启动容器
docker-compose -f docker-compose.yml up -d --remove-orphans namenode hive-metastore-postgresql
docker-compose -f docker-compose.yml up -d --remove-orphans datanode datanode2 datanode3 hive-metastore
docker-compose -f docker-compose.yml up -d --remove-orphans resourcemanager
docker-compose -f docker-compose.yml up -d --remove-orphans nodemanager
docker-compose -f docker-compose.yml up -d --remove-orphans historyserver
sleep 5
docker-compose -f docker-compose.yml up -d --remove-orphans hive-server
docker-compose -f docker-compose.yml up -d --remove-orphans spark-master spark-worker
docker-compose -f docker-compose.yml up -d --remove-orphans mongodb
docker-compose -f docker-compose.yml up -d --remove-orphans zookeeper
docker-compose -f docker-compose.yml up -d --remove-orphans kafka
docker-compose -f docker-compose.yml up -d --remove-orphans nimbus
docker-compose -f docker-compose.yml up -d --remove-orphans supervisor
docker-compose -f docker-compose.yml up -d --remove-orphans storm-ui

# 获取ip地址并打印到控制台
my_ip=`ifconfig | grep 'inet.*netmask.*broadcast' |  awk '{print $2;exit}'`
echo "Namenode: http://${my_ip}:50070"
echo "Datanode: http://${my_ip}:50075"
echo "Spark-master: http://${my_ip}:18080"

# 执行脚本，spark yarn支持
docker-compose exec spark-master bash -c "./copy-jar.sh && exit"

