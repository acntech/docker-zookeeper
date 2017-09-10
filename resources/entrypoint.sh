#!/bin/bash

ZOOKEEPER_CONFIGURED_FLAG="${HOME}/.zookeeper_configured"
ZOOKEEPER_ID_FILE="${ZOO_DATADIR}/myid"
ZOOKEEPER_CONFIG_FILE="${ZOOKEEPER_HOME}/conf/zoo.cfg"
ZOOKEEPER_ID=${ZOOKEEPER_ID:-1}
ZOOKEEPER_PORT=${ZOOKEEPER_PORT:-2181}
ZOOKEEPER_PEER_PORT=${ZOOKEEPER_PEER_PORT:-2888}
ZOOKEEPER_LEADER_PORT=${ZOOKEEPER_LEADER_PORT:-3888}
ZOOKEEPER_HOSTS=${ZOOKEEPER_HOSTS:-$(hostname):2888:3888}
ZOOKEEPER_SERVER_CMD="${ZOOKEEPER_HOME}/bin/zkServer.sh start-foreground"

if [ ! -f ${ZOOKEEPER_CONFIGURED_FLAG} ]; then

   echo "Configuring ZooKeeper..."

   echo "Sanitizing old ZooKeeper configuration..."
   rm -f ${ZOOKEEPER_ID_FILE}
   sed -i 's/clientPort=.*//g' ${ZOOKEEPER_CONFIG_FILE}
   sed -i 's/server\.[0-9]=.*//g' ${ZOOKEEPER_CONFIG_FILE}

   echo "Setting ZooKeeper ID: ${ZOOKEEPER_ID}"
   echo -e "\n\n" >> ${ZOOKEEPER_CONFIG_FILE}
   echo "${ZOOKEEPER_ID}" > ${ZOOKEEPER_ID_FILE}

   echo "Setting ZooKeeper port: ${ZOOKEEPER_PORT}"
   echo -e "\n\n" >> ${ZOOKEEPER_CONFIG_FILE}
   echo "clientPort=${ZOOKEEPER_PORT}" >> ${ZOOKEEPER_CONFIG_FILE}

   echo "Setting ZooKeeper hosts: ${ZOOKEEPER_HOSTS}"
   echo -e "\n\n" >> ${ZOOKEEPER_CONFIG_FILE}
   IFS=',' read -ra HOSTS <<< "${ZOOKEEPER_HOSTS}"
   for i in "${!HOSTS[@]}"; do
      HOST="server.$((i+1))=${HOSTS[$i]}"
      echo "${HOST}" >> ${ZOOKEEPER_CONFIG_FILE}
   done

   date > ${ZOOKEEPER_CONFIGURED_FLAG}

else
   echo "ZooKeeper has already been configured, continuing..."
fi

echo "Starting ZooKeeper..."
echo "Command: ${ZOOKEEPER_SERVER_CMD}"

${ZOOKEEPER_SERVER_CMD}
