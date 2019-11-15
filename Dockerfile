FROM openjdk:8-jre
MAINTAINER Thomas Johansen "thomas.johansen@accenture.com"


ARG ZOOKEEPER_VERSION=3.5.6
ARG ZOOKEEPER_MIRROR=https://dist.apache.org/repos/dist/release/zookeeper
ARG ZOOKEEPER_DIR=apache-zookeeper-${ZOOKEEPER_VERSION}-bin


ENV ZOOKEEPER_BASE /opt/zookeeper
ENV ZOOKEEPER_HOME ${ZOOKEEPER_BASE}/default
ENV ZOO_DATADIR /var/lib/zookeeper
ENV ZOO_LOG_DIR /var/log/zookeeper
ENV PATH ${PATH}:${ZOOKEEPER_HOME}/bin


WORKDIR /tmp


RUN apt-get update && \
    apt-get -y upgrade && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p ${ZOOKEEPER_BASE} && \
    mkdir ${ZOO_DATADIR} && \
    mkdir ${ZOO_LOG_DIR}

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


VOLUME "${ZOOKEEPER_HOME}/conf"
VOLUME "${ZOO_DATADIR}"
VOLUME "${ZOO_LOG_DIR}"


ENTRYPOINT ["/entrypoint.sh"]
