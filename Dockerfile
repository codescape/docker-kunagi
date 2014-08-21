FROM dockerfile/java

MAINTAINER Stefan Glase <stefan.glase@googlemail.com>

# make sure the package repository is up to date
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update

# download apache tomcat
RUN wget -nv --no-cookies http://mirror.gopotato.co.uk/apache/tomcat/tomcat-7/v7.0.55/bin/apache-tomcat-7.0.55.tar.gz -O /tmp/apache-tomcat-7.0.55.tar.gz

# verify checksum
RUN echo "3c46fc0f608c1280dcd65100a983f285  /tmp/apache-tomcat-7.0.55.tar.gz" | md5sum -c > /dev/null 2>&1 || echo "ERROR: MD5SUM MISMATCH"

# extract apache tomcat
RUN tar xzf /tmp/apache-tomcat-7.0.55.tar.gz -C /opt

# delete downloaded file
RUN rm /tmp/apache-tomcat-7.0.55.tar.gz

# The following volumes should not be considered part of the image, but contain runtime data
VOLUME ["/opt/apache-tomcat-7.0.55/logs", "/opt/apache-tomcat-7.0.55/work", "/opt/apache-tomcat-7.0.55/temp", "/tmp/hsperfdata_root"]

# set environment variables and add to path
ENV CATALINA_HOME /opt/apache-tomcat-7.0.55
ENV PATH $PATH:$CATALINA_HOME/bin

# download kunagi
RUN wget -nv --no-cookies http://kunagi.org/releases/0.26/kunagi.war -O /tmp/kunagi.war

# move kunagi into tomcat webapps 
RUN cp /tmp/kunagi.war /opt/apache-tomcat-7.0.55/webapps/kunagi.war

# Start Tomcat in the foreground (run) to make sure docker does not immediately shutdown the container
CMD ["/opt/apache-tomcat-7.0.55/bin/catalina.sh", "run"]

EXPOSE 8080
