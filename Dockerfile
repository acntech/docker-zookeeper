FROM acntech/jre:1.8.0_101
MAINTAINER Thomas Johansen "thomas.johansen@accenture.com"


ENV ZOOKEEPER_VERSION 3.4.9
ENV ZOOKEEPER_BASE /opt/zookeeper
ENV ZOOKEEPER_HOME $ZOOKEEPER_BASE/default
ENV ZOOKEEPER_TEMP /tmp/zookeeper
ENV PATH $PATH:$ZOOKEEPER_HOME/bin


RUN apt-get update && apt-get -y upgrade

RUN wget --no-cookies --no-check-certificate "https://dist.apache.org/repos/dist/release/zookeeper/zookeeper-$ZOOKEEPER_VERSION/zookeeper-$ZOOKEEPER_VERSION.tar.gz" -O /tmp/zookeeper.tar.gz
RUN wget --no-cookies --no-check-certificate "https://dist.apache.org/repos/dist/release/zookeeper/zookeeper-$ZOOKEEPER_VERSION/zookeeper-$ZOOKEEPER_VERSION.tar.gz.asc" -O /tmp/zookeeper.tar.gz.asc
RUN wget --no-cookies --no-check-certificate "https://dist.apache.org/repos/dist/release/zookeeper/KEYS" -O /tmp/zookeeper.KEYS

RUN gpg --import /tmp/zookeeper.KEYS
RUN gpg --batch --verify /tmp/zookeeper.tar.gz.asc /tmp/zookeeper.tar.gz
RUN mkdir $ZOOKEEPER_BASE && tar -xzvf /tmp/zookeeper.tar.gz -C $ZOOKEEPER_BASE/ && ln -s $ZOOKEEPER_BASE/zookeeper-$KAFKA_VERSION/ $ZOOKEEPER_HOME
RUN rm -f /tmp/zookeeper.tar.gz /tmp/zookeeper.tar.gz.asc /tmp/zookeeper.KEYS

RUN mkdir /tmp/zookeeper


EXPOSE 2181 2888 3888


WORKDIR $ZOOKEEPER_HOME

VOLUME "$ZOOKEEPER_HOME/conf"
VOLUME "$ZOOKEEPER_TEMP"

ENTRYPOINT "$ZOOKEEPER_HOME/bin/zkServer.sh"
CMD "start-foreground"