FROM dockerfile/java

MAINTAINER Stefan Glase <stefan.glase@googlemail.com>

ENV TOMCAT_VERSION 7.0.55
ENV KUNAGI_VERSION 0.26

# make sure the package repository is up to date
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update

# download apache tomcat
RUN wget -nv --no-cookies http://archive.apache.org/dist/tomcat/tomcat-7/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz -O /tmp/apache-tomcat-${TOMCAT_VERSION}.tar.gz

# extract apache tomcat
RUN tar xzf /tmp/apache-tomcat-${TOMCAT_VERSION}.tar.gz -C /opt

# create short cut link
RUN ln -s /opt/apache-tomcat-${TOMCAT_VERSION} /opt/apache-tomcat

# delete downloaded file
RUN rm /tmp/apache-tomcat-${TOMCAT_VERSION}.tar.gz

# ignore the following volumes containing runtime data as part of the image 
VOLUME ["/opt/apache-tomcat/logs", "/opt/apache-tomcat/work", "/opt/apache-tomcat/temp", "/tmp/hsperfdata_root"]

# set environment variables and add to path
ENV CATALINA_HOME /opt/apache-tomcat
ENV PATH $PATH:$CATALINA_HOME/bin

# download kunagi
RUN wget -nv --no-cookies http://kunagi.org/releases/${KUNAGI_VERSION}/kunagi.war -O /tmp/kunagi.war

# move kunagi into tomcat webapps 
RUN mv /tmp/kunagi.war /opt/apache-tomcat/webapps/kunagi.war

# expose the apache tomcat default port
EXPOSE 8080

# start apache tomcat in the foreground (run) to make sure docker does not immediately shutdown the container
CMD ["/opt/apache-tomcat/bin/catalina.sh", "run"]
