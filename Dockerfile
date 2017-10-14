FROM ubuntu:16.04

MAINTAINER YuchenWang <lucassjtu@gmail.com>

WORKDIR /

COPY config/sources.list /etc/apt/sources.list

# install ssh, vim 
RUN apt-get update && apt-get install -y ssh vim && \
    echo '/usr/sbin/sshd' >> ~/.bashrc && mkdir /var/run/sshd && /usr/sbin/sshd

# ssh without key
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

# install java, scala, zookeeper, hadoop, spark
ADD tar/* /usr/

# set environment variables
ENV JAVA_HOME /usr/jdk1.8.0_144
ENV SCALA_HOME /usr/scala-2.12.3
ENV ZOOKEEPER_HOME /usr/zookeeper-3.4.9
ENV HADOOP_HOME /usr/hadoop-2.7.4
ENV HADOOP_CLASSPATH ${JAVA_HOME}/lib/tools.jar
ENV SPARK_HOME /usr/spark-2.2.0-bin-hadoop2.7
ENV PATH $PATH:$JAVA_HOME/bin:$SCALA_HOME/bin:$ZOOKEEPER_HOME/bin:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$SPARK_HOME/bin:$SPARK_HOME/sbin

#configuration
COPY config/* /tmp/

RUN mkdir -p ~/zookeeper/tmp/ && \echo 1 > ~/zookeeper/tmp/myid && \
    mv /tmp/zoo.cfg $ZOOKEEPER_HOME/conf/zoo.cfg && \
    mv /tmp/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml && \ 
    mv /tmp/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml && \
    mv /tmp/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml && \
    mv /tmp/hadoop-env.sh $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
    cp /tmp/slaves $HADOOP_HOME/etc/hadoop/slaves && \
    mv /tmp/slaves $SPARK_HOME/conf/slaves && \
    mv /tmp/spark-env.sh $SPARK_HOME/conf/spark-env.sh
    
    
