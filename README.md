# docker-zookeeper
Docker image with Apache ZooKeeper, based on the eclipse-temurin:17-jre image

## Configuration
The ZooKeeper instance can be configures using the following environment variables:
* ```ZOOKEEPER_ID```: A unique ID for the instance.
* ```ZOOKEEPER_HOSTS```: A comma separated string of ZooKeeper nodes that will make up a ZooKeeper cluster.
* ```ZOOKEEPER_PORT```: The ZooKeeper client port, used by clients to communicate with the instance.
* ```ZOOKEEPER_PEER_PORT```: The ZooKeeper peer port, used for communication between the peers in the ZooKeeper quorum.
* ```ZOOKEEPER_LEADER_PORT```: The ZooKeeper leader port, used for leader selection within a cluster.

#### Default values
* ```ZOOKEEPER_ID```: ```1```
* ```ZOOKEEPER_HOSTS```: ```$(hostname):2888:3888```
* ```ZOOKEEPER_PORT```: ```2181```
* ```ZOOKEEPER_PEER_PORT```: ```2888```
* ```ZOOKEEPER_LEADER_PORT```: ```3888```

## Running single instrance
To run a stand-alone ZooKeeper node you need minimal configuration.

#### Docker Run
Run the following command to create and start a container in daemon mode:
```
docker run -d -name lonely_zookeeper -p 2181:2181 acntechie/zookeeper
```

#### Docker Compose
Define a ```docker-compose.yml``` file along the lines of:
```
version: "2"

services:
  lonely_zookeeper:
    image: acntechie/zookeeper
    container_name: lonely_zookeeper
    ports:
      - "2181:2181"
```

Then run ```docker-compose up -d``` to create and start a container in daemon mode.

See example file ```docker-compose.standalone.yml```.

## Running cluster
To run a cluser of multiple ZooKeeper nodes you need a bit more configuration.
The ZooKeeper nodes need to be able to discover each other, so you need to set up the environment with the address to all nodes in the quorum.

#### Docker Run
First create a network for use with all the nodes:
```
docker network create zookeeper
```

Now start three ZooKeeper instances:
```
docker run -d -name friendly_zookeeper_1 -p 2181:2181 --net zookeeper --env ZOOKEEPER_ID=1 --env ZOOKEEPER_HOSTS=friendly_zookeeper_1:2888:3888,friendly_zookeeper_2:2888:3888,friendly_zookeeper_3:2888:3888 acntechie/zookeeper
```

```
docker run -d -name friendly_zookeeper_2 -p 2182:2181 --net zookeeper --env ZOOKEEPER_ID=2 --env ZOOKEEPER_HOSTS=friendly_zookeeper_1:2888:3888,friendly_zookeeper_2:2888:3888,friendly_zookeeper_3:2888:3888 acntechie/zookeeper
```

```
docker run -d -name friendly_zookeeper_3 -p 2183:2181 --net zookeeper --env ZOOKEEPER_ID=3 --env ZOOKEEPER_HOSTS=friendly_zookeeper_1:2888:3888,friendly_zookeeper_2:2888:3888,friendly_zookeeper_3:2888:3888 acntechie/zookeeper
```

#### Docker Compose
Define a ```docker-compose.yml``` file along the lines of:
```
version: "2"

services:
  friendly_zookeeper_1:
    image: acntechie/zookeeper
    container_name: friendly_zookeeper_1
    ports:
      - "2181:2181"
    environment:
      - ZOOKEEPER_ID=1
      - ZOOKEEPER_HOSTS=friendly_zookeeper_1:2888:3888,friendly_zookeeper_2:2888:3888,friendly_zookeeper_3:2888:3888
    networks:
    - zookeeper

  friendly_zookeeper_2:
    image: acntechie/zookeeper
    container_name: friendly_zookeeper_2
    ports:
      - "2182:2181"
    environment:
      - ZOOKEEPER_ID=2
      - ZOOKEEPER_HOSTS=friendly_zookeeper_1:2888:3888,friendly_zookeeper_2:2888:3888,friendly_zookeeper_3:2888:3888
    networks:
    - zookeeper

  friendly_zookeeper_3:
    image: acntechie/zookeeper
    container_name: friendly_zookeeper_3
    ports:
      - "2183:2181"
    environment:
      - ZOOKEEPER_ID=3
      - ZOOKEEPER_HOSTS=friendly_zookeeper_1:2888:3888,friendly_zookeeper_2:2888:3888,friendly_zookeeper_3:2888:3888
    networks:
    - zookeeper

networks:
  zookeeper:

```

Then run ```docker-compose up -d``` to create and start all containers in daemon mode.

See example file ```docker-compose.cluster.yml```.
