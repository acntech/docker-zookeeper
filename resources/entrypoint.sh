#!/bin/bash

# Set ZooKeeper ID
if [ -n "${ZOOKEEPER_ID}" ]; then
   echo "ZooKeeper ID set: ${ZOOKEEPER_ID}"
   echo "${ZOOKEEPER_ID}" > ${ZOO_DATADIR}/myid
else
   echo "No ZooKeeper ID set"
fi

# Set ZooKeeper quorum hosts
if [ -n "${ZOOKEEPER_HOSTS}" ]; then
   if ! grep -q -e "^server\.[0-9]=.*" "${ZOOKEEPER_HOME}/conf/zoo.cfg"; then
      echo "Setting ZooKeeper hosts: ${ZOOKEEPER_HOSTS}"
      IFS=',' read -ra HOSTS <<< "${ZOOKEEPER_HOSTS}"
      echo -e "\n\n" >> ${ZOOKEEPER_HOME}/conf/zoo.cfg
      for i in "${!HOSTS[@]}"; do
         echo "server.$((i+1))=${HOSTS[$i]}:2888:3888" >> ${ZOOKEEPER_HOME}/conf/zoo.cfg
      done
   else
      echo "ZooKeeper hosts already set"
   fi
else
   echo "No ZooKeeper hosts set"
fi

${ZOOKEEPER_HOME}/bin/zkServer.sh start-foreground