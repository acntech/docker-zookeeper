FROM openjdk:11-jre
MAINTAINER Thomas Johansen "thomas.johansen@accenture.com"


ARG ZOOKEEPER_VERSION=3.7.0
ARG ZOOKEEPER_MIRROR=https://dist.apache.org/repos/dist/release/zookeeper
ARG ZOOKEEPER_DIR=apache-zookeeper-${ZOOKEEPER_VERSION}-bin


ENV ZOOKEEPER_BASE /opt/zookeeper
ENV ZOOKEEPER_HOME ${ZOOKEEPER_BASE}/default
ENV ZOOKEEPER_DATA_ROOT /var/lib/zookeeper
ENV ZOO_DATADIR ${ZOOKEEPER_DATA}/data
ENV ZOO_LOG_DIR ${ZOOKEEPER_DATA}/logs
ENV PATH ${PATH}:${ZOOKEEPER_HOME}/bin


WORKDIR /tmp


RUN apt-get update && \
    apt-get -y upgrade && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p ${ZOOKEEPER_BASE} && \
    mkdir -p ${ZOO_DATADIR} && \
    mkdir -p ${ZOO_LOG_DIR} && \
    cd /var/log && \
    ln -s ${ZOO_LOG_DIR}/ zookeeper

RUN wget --no-cookies \
         --no-check-certificate \
         "${ZOOKEEPER_MIRROR}/zookeeper-${ZOOKEEPER_VERSION}/apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz" \
         -O zookeeper.tar.gz

RUN wget --no-cookies \
         --no-check-certificate \
         "${ZOOKEEPER_MIRROR}/zookeeper-${ZOOKEEPER_VERSION}/apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz.asc" \
         -O zookeeper.tar.gz.asc

RUN wget --no-cookies \
         --no-check-certificate \
         "${ZOOKEEPER_MIRROR}/KEYS" \
         -O zookeeper.KEYS

RUN gpg --import --no-tty zookeeper.KEYS && \
    gpg --batch --verify --no-tty zookeeper.tar.gz.asc zookeeper.tar.gz

RUN tar -xzvf zookeeper.tar.gz -C ${ZOOKEEPER_BASE}/ && \
    cd ${ZOOKEEPER_BASE} && \
    ln -s ${ZOOKEEPER_DIR}/ default && \
    rm -f zookeeper.*


COPY resources/entrypoint.sh /entrypoint.sh


RUN chown -R root:root ${ZOOKEEPER_BASE}
RUN chmod +x /entrypoint.sh


EXPOSE 2181 2888 3888


WORKDIR ${ZOOKEEPER_HOME}


VOLUME "${ZOOKEEPER_DATA_ROOT}"


ENTRYPOINT ["/entrypoint.sh"]
