FROM acntech/jre:1.8.0_101-alpine
MAINTAINER Thomas Johansen "thomas.johansen@accenture.com"


ARG ZOOKEEPER_VERSION=3.4.9
ARG ZOOKEEPER_MIRROR=https://dist.apache.org/repos/dist/release/zookeeper
ARG ZOOKEEPER_DIR=zookeeper-${ZOOKEEPER_VERSION}


ENV ZOOKEEPER_BASE /opt/zookeeper
ENV ZOOKEEPER_HOME ${ZOOKEEPER_BASE}/default
ENV ZOO_DATADIR /var/lib/zookeeper
ENV ZOO_LOG_DIR /var/log/zookeeper
ENV PATH ${PATH}:${ZOOKEEPER_HOME}/bin
ENV TERM xterm


RUN apk update && \
    apk upgrade && \
    apk add bash gnupg


RUN mkdir -p ${ZOOKEEPER_BASE} && \
    mkdir ${ZOO_DATADIR} && \
    mkdir ${ZOO_LOG_DIR}


RUN wget --no-cookies \
         --no-check-certificate \
         "${ZOOKEEPER_MIRROR}/zookeeper-${ZOOKEEPER_VERSION}/zookeeper-${ZOOKEEPER_VERSION}.tar.gz" \
         -O /tmp/zookeeper.tar.gz

RUN wget --no-cookies \
         --no-check-certificate \
         "${ZOOKEEPER_MIRROR}/zookeeper-${ZOOKEEPER_VERSION}/zookeeper-${ZOOKEEPER_VERSION}.tar.gz.asc" \
         -O /tmp/zookeeper.tar.gz.asc

RUN wget --no-cookies \
         --no-check-certificate \
         "${ZOOKEEPER_MIRROR}/KEYS" \
         -O /tmp/zookeeper.KEYS

RUN gpg --import /tmp/zookeeper.KEYS && \
    gpg --batch --verify /tmp/zookeeper.tar.gz.asc /tmp/zookeeper.tar.gz

RUN tar -xzvf /tmp/zookeeper.tar.gz -C ${ZOOKEEPER_BASE}/ && \
    cd ${ZOOKEEPER_BASE} && \
    ln -s ${ZOOKEEPER_DIR}/ default && \
    rm -f /tmp/zookeeper.*


COPY resources/zoo.cfg ${ZOOKEEPER_HOME}/conf/
COPY resources/log4j.properties ${ZOOKEEPER_HOME}/conf/
COPY resources/zkServer.sh ${ZOOKEEPER_HOME}/bin/
COPY resources/entrypoint.sh /entrypoint.sh


EXPOSE 2181 2888 3888


WORKDIR ${ZOOKEEPER_HOME}


VOLUME "${ZOOKEEPER_HOME}/conf"
VOLUME "${ZOO_DATADIR}"


ENTRYPOINT ["/entrypoint.sh"]