FROM acntech/jre:1.8.0_101-alpine
MAINTAINER Thomas Johansen "thomas.johansen@accenture.com"


ARG ZOOKEEPER_VERSION=3.4.9
ARG ZOOKEEPER_MIRROR=https://dist.apache.org/repos/dist/release/zookeeper


ENV ZOOKEEPER_BASE /opt/zookeeper
ENV ZOOKEEPER_HOME ${ZOOKEEPER_BASE}/default
ENV ZOOKEEPER_DATA /var/zookeeper
ENV PATH ${PATH}:${ZOOKEEPER_HOME}/bin


RUN apk update && apk upgrade
RUN apk add bash gnupg

RUN wget --no-cookies --no-check-certificate "${ZOOKEEPER_MIRROR}/zookeeper-${ZOOKEEPER_VERSION}/zookeeper-${ZOOKEEPER_VERSION}.tar.gz" -O /tmp/zookeeper.tar.gz
RUN wget --no-cookies --no-check-certificate "${ZOOKEEPER_MIRROR}/zookeeper-${ZOOKEEPER_VERSION}/zookeeper-${ZOOKEEPER_VERSION}.tar.gz.asc" -O /tmp/zookeeper.tar.gz.asc
RUN wget --no-cookies --no-check-certificate "${ZOOKEEPER_MIRROR}/KEYS" -O /tmp/zookeeper.KEYS

RUN gpg --import /tmp/zookeeper.KEYS && gpg --batch --verify /tmp/zookeeper.tar.gz.asc /tmp/zookeeper.tar.gz
RUN mkdir -p ${ZOOKEEPER_BASE} && tar -xzvf /tmp/zookeeper.tar.gz -C ${ZOOKEEPER_BASE}/ && ln -s ${ZOOKEEPER_BASE}/zookeeper-${ZOOKEEPER_VERSION}/ ${ZOOKEEPER_HOME}
RUN rm -f /tmp/zookeeper.*

RUN mkdir ${ZOOKEEPER_DATA}


COPY resources/zoo.cfg ${ZOOKEEPER_HOME}/conf/
COPY resources/zkServer.sh ${ZOOKEEPER_HOME}/bin/


EXPOSE 2181 2888 3888


WORKDIR ${ZOOKEEPER_HOME}


VOLUME "${ZOOKEEPER_HOME}/conf"
VOLUME "${ZOOKEEPER_DATA}"


CMD ["/opt/zookeeper/default/bin/zkServer.sh", "start-foreground"]