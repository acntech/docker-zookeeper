FROM eclipse-temurin:17-jre
MAINTAINER Thomas Johansen "thomas.johansen@accenture.com"


ARG ZOOKEEPER_VERSION=3.8.0
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
    apt-get -y install gpg && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p ${ZOOKEEPER_BASE} && \
    mkdir -p ${ZOO_DATADIR} && \
    mkdir -p ${ZOO_LOG_DIR} && \
    cd /var/log && \
    ln -s ${ZOO_LOG_DIR}/ zookeeper

RUN curl --silent --show-error --output zookeeper.tar.gz \
         "${ZOOKEEPER_MIRROR}/zookeeper-${ZOOKEEPER_VERSION}/apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz" && \
    curl --silent --show-error --output zookeeper.tar.gz.asc \
         "${ZOOKEEPER_MIRROR}/zookeeper-${ZOOKEEPER_VERSION}/apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz.asc" && \
    curl --silent --show-error --output zookeeper.KEYS \
         "${ZOOKEEPER_MIRROR}/KEYS"

RUN gpg --quiet --import --no-tty zookeeper.KEYS && \
    gpg --quiet --batch --verify --no-tty zookeeper.tar.gz.asc zookeeper.tar.gz

RUN tar -xzvf zookeeper.tar.gz -C ${ZOOKEEPER_BASE}/ && \
    cd ${ZOOKEEPER_BASE} && \
    ln -s ${ZOOKEEPER_DIR}/ default && \
    rm -f zookeeper.*


COPY ./resources/entrypoint.sh /entrypoint.sh


RUN chown -R root:root ${ZOOKEEPER_BASE}
RUN chmod +x /entrypoint.sh


EXPOSE 2181 2888 3888


WORKDIR ${ZOOKEEPER_HOME}


VOLUME "${ZOOKEEPER_DATA_ROOT}"


ENTRYPOINT ["/entrypoint.sh"]
