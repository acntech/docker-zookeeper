FROM openjdk:8-jre
MAINTAINER Thomas Johansen "thomas.johansen@accenture.com"


ARG ZOOKEEPER_VERSION=3.4.13
ARG ZOOKEEPER_MIRROR=https://dist.apache.org/repos/dist/release/zookeeper
ARG ZOOKEEPER_DIR=zookeeper-${ZOOKEEPER_VERSION}


ENV ZOOKEEPER_BASE /opt/zookeeper
ENV ZOOKEEPER_HOME ${ZOOKEEPER_BASE}/default
ENV ZOO_DATADIR /var/lib/zookeeper
ENV ZOO_LOG_DIR /var/log/zookeeper
ENV PATH ${PATH}:${ZOOKEEPER_HOME}/bin


RUN apt-get update && \
    apt-get -y upgrade && \
    rm -rf /var/lib/apt/lists/*


RUN mkdir -p ${ZOOKEEPER_BASE} && \
    mkdir ${ZOO_DATADIR} && \
    mkdir ${ZOO_LOG_DIR}


WORKDIR /tmp


RUN wget --no-cookies \
         --no-check-certificate \
         "${ZOOKEEPER_MIRROR}/zookeeper-${ZOOKEEPER_VERSION}/zookeeper-${ZOOKEEPER_VERSION}.tar.gz" \
         -O zookeeper-${ZOOKEEPER_VERSION}.tar.gz

RUN wget --no-cookies \
         --no-check-certificate \
         "${ZOOKEEPER_MIRROR}/zookeeper-${ZOOKEEPER_VERSION}/zookeeper-${ZOOKEEPER_VERSION}.tar.gz.sha1" \
         -O zookeeper-${ZOOKEEPER_VERSION}.tar.gz.sha1

RUN sha1sum --check zookeeper-${ZOOKEEPER_VERSION}.tar.gz.sha1

RUN tar -xzvf zookeeper-${ZOOKEEPER_VERSION}.tar.gz -C ${ZOOKEEPER_BASE}/ && \
    cd ${ZOOKEEPER_BASE} && \
    ln -s ${ZOOKEEPER_DIR}/ default && \
    rm -f /tmp/zookeeper.*


COPY resources/entrypoint.sh /entrypoint.sh


RUN chown -R root:root ${ZOOKEEPER_BASE}
RUN chmod +x /entrypoint.sh


EXPOSE 2181 2888 3888


WORKDIR ${ZOOKEEPER_HOME}


VOLUME "${ZOOKEEPER_HOME}/conf"
VOLUME "${ZOO_DATADIR}"
VOLUME "${ZOO_LOG_DIR}"


ENTRYPOINT ["/entrypoint.sh"]
