#!/bin/bash

if [ -n "${ZOOKEEPER_ID}" ]; then
   echo "ZooKeeper ID set: ${ZOOKEEPER_ID}"
   echo "${ZOOKEEPER_ID}" > ${ZOO_DATADIR}/myid
else
   echo "No ZooKeeper ID set"
fi

if [ -n "${ZOOKEEPER_HOSTS}" ]; then
   echo "ZooKeeper hosts set: ${ZOOKEEPER_HOSTS}"
   IFS=',' read -ra HOSTS <<< "${ZOOKEEPER_HOSTS}"
   echo -e "\n\n" >> ${ZOOKEEPER_HOME}/conf/zoo.cfg
   for i in "${!HOSTS[@]}"; do
      echo "server.$((i+1))=${HOSTS[$i]}:2888:3888" >> ${ZOOKEEPER_HOME}/conf/zoo.cfg
   done
else
   echo "No ZooKeeper hosts set"
fi

#${ZOOKEEPER_HOME}/bin/zkServer.sh start
${ZOOKEEPER_HOME}/bin/zkServer.sh start-foreground