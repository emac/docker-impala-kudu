FROM parrotstream/centos-openjdk:8

MAINTAINER Emac Shen <emac@xingren.com>

USER root

ADD cloudera-impala-kudu.repo /etc/yum.repos.d/
ADD cloudera-cdh5.repo /etc/yum.repos.d/
RUN rpm --import http://archive.cloudera.com/beta/impala-kudu/redhat/7/x86_64/impala-kudu/RPM-GPG-KEY-cloudera   
RUN yum install -y hadoop-libhdfs
RUN yum install -y impala impala-server impala-shell impala-catalog impala-state-store
RUN yum install -y gcc python-devel cyrus-sasl*
RUN yum clean all

ADD etc/supervisord.conf /etc/
ADD etc/default/impala /etc/default/
ADD etc/hadoop/conf/core-site.xml /etc/hadoop/conf/
ADD etc/hadoop/conf/hdfs-site.xml /etc/hadoop/conf/
ADD etc/hadoop/conf/mapred-site.xml /etc/hadoop/conf/
ADD etc/impala/conf/hive-site.xml /etc/impala/conf/

WORKDIR /

# Various helper scripts
ADD bin/start-impala.sh /
ADD bin/supervisord-bootstrap.sh /
ADD bin/wait-for-it.sh /
RUN chmod +x ./*.sh

# Impala Ports
EXPOSE 21000 21050 22000 23000 24000 25010 26000 28000

##########################
# Kudu Ports
##########################
EXPOSE 8050 7050 8051 7051

ENTRYPOINT ["supervisord", "-c", "/etc/supervisord.conf", "-n"]
