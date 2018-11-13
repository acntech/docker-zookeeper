#!/bin/bash

ZOOKEEPER_CONFIGURED_FLAG="${HOME}/.zookeeper_configured"
ZOOKEEPER_ID_FILE="${ZOO_DATADIR}/myid"
ZOOKEEPER_CONFIG_DIR="${ZOOKEEPER_HOME}/conf"
ZOOKEEPER_CONFIG_FILE="${ZOOKEEPER_CONFIG_DIR}/zoo.cfg"
ZOOKEEPER_LOG_CONFIG_FILE="${ZOOKEEPER_CONFIG_DIR}/log4j.properties"
ZOOKEEPER_ID=${ZOOKEEPER_ID:-1}
ZOOKEEPER_PORT=${ZOOKEEPER_PORT:-2181}
ZOOKEEPER_PEER_PORT=${ZOOKEEPER_PEER_PORT:-2888}
ZOOKEEPER_LEADER_PORT=${ZOOKEEPER_LEADER_PORT:-3888}
ZOOKEEPER_HOSTS=${ZOOKEEPER_HOSTS:-$(hostname):2888:3888}
ZOOKEEPER_SERVER_CMD="${ZOOKEEPER_HOME}/bin/zkServer.sh start-foreground"

if [ ! -f ${ZOOKEEPER_CONFIGURED_FLAG} ]; then

   echo "Configuring ZooKeeper..."

   echo "Checking for presence of config file"
   if [ ! -f ${ZOOKEEPER_CONFIG_FILE} ]; then
      cp ${ZOOKEEPER_CONFIG_DIR}/zoo_sample.cfg ${ZOOKEEPER_CONFIG_FILE}
   fi

   echo "Setting ZooKeeper ID: ${ZOOKEEPER_ID}"
   echo "${ZOOKEEPER_ID}" > ${ZOOKEEPER_ID_FILE}

   echo "Setting ZooKeeper data directory: ${ZOO_DATADIR}"
   sed -i 's@dataDir=.*@dataDir='"${ZOO_DATADIR}"'@g' ${ZOOKEEPER_CONFIG_FILE}

   echo "Setting ZooKeeper port: ${ZOOKEEPER_PORT}"
   sed -i 's@clientPort=.*@clientPort='"${ZOOKEEPER_PORT}"'@g' ${ZOOKEEPER_CONFIG_FILE}

   echo "Setting ZooKeeper hosts: ${ZOOKEEPER_HOSTS}"
   sed -i 's/server\.[0-9]=.*//g' ${ZOOKEEPER_CONFIG_FILE}
   IFS=',' read -ra HOSTS <<< "${ZOOKEEPER_HOSTS}"
   for i in "${!HOSTS[@]}"; do
      HOST="server.$((i+1))=${HOSTS[$i]}"
      echo "${HOST}" >> ${ZOOKEEPER_CONFIG_FILE}
   done

   echo "Setting ZooKeeper log dirs"
   sed -i 's@zookeeper.log.dir=.*@zookeeper.log.dir='"${ZOO_LOG_DIR}"'@g' ${ZOOKEEPER_LOG_CONFIG_FILE}
   sed -i 's@zookeeper.tracelog.dir=.*@zookeeper.tracelog.dir='"${ZOO_LOG_DIR}"'@g' ${ZOOKEEPER_LOG_CONFIG_FILE}

   date > ${ZOOKEEPER_CONFIGURED_FLAG}

else
   echo "ZooKeeper has already been configured, continuing..."
fi

echo "Starting ZooKeeper..."
echo "Command: ${ZOOKEEPER_SERVER_CMD}"

${ZOOKEEPER_SERVER_CMD}
