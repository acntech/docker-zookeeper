#!/bin/bash

ZOOKEEPER_CONFIGURED_FLAG="${HOME}/.zookeeper_configured"
ZOOKEEPER_ID_FILE="${ZOO_DATADIR}/myid"
ZOOKEEPER_CONFIG_FILE="${ZOOKEEPER_HOME}/conf/zoo.cfg"
ZOOKEEPER_PEER_PORT=${ZOOKEEPER_PEER_PORT:-2888}
ZOOKEEPER_LEADER_PORT=${ZOOKEEPER_LEADER_PORT:-3888}
ZOOKEEPER_SERVER_CMD="${ZOOKEEPER_HOME}/bin/zkServer.sh start-foreground"

if [ ! -f ${ZOOKEEPER_CONFIGURED_FLAG} ]; then

   echo "Configuring ZooKeeper..."

   ZOOKEEPER_ID=${ZOOKEEPER_ID:-0}
   ZOOKEEPER_HOSTS=${ZOOKEEPER_HOSTS:-localhost}

   echo "Sanitizing old ZooKeeper configuration..."
   rm -f ${ZOOKEEPER_ID_FILE}
   sed -i 's/server\.[0-9]=.*//g' ${ZOOKEEPER_CONFIG_FILE}

   echo "Setting ZooKeeper ID: ${ZOOKEEPER_ID}"
   echo "${ZOOKEEPER_ID}" > ${ZOOKEEPER_ID_FILE}

   echo "Setting ZooKeeper hosts: ${ZOOKEEPER_HOSTS}"
   IFS=',' read -ra HOSTS <<< "${ZOOKEEPER_HOSTS}"
   echo -e "\n\n" >> ${ZOOKEEPER_CONFIG_FILE}
   for i in "${!HOSTS[@]}"; do
      HOST="server.$((i+1))=${HOSTS[$i]}:${ZOOKEEPER_PEER_PORT}:${ZOOKEEPER_LEADER_PORT}"
      echo "${HOST}" >> ${ZOOKEEPER_CONFIG_FILE}
   done

   date > ${ZOOKEEPER_CONFIGURED_FLAG}

else
   echo "ZooKeeper is already configured..."
fi

echo "Starting ZooKeeper..."
echo "Command: ${ZOOKEEPER_SERVER_CMD}"

${ZOOKEEPER_SERVER_CMD}
