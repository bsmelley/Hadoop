# VERSION   0.1

FROM ubuntu:14.04
MAINTAINER Fernando Zavala <fernando@zavalasystems.com>

# here we get the latest update packages and then we upgrade our system, and install JDK
RUN apt-get update
RUN apt-get upgrade -y \
RUN apt-get dist-upgrade -y \
RUN install openjdk-7-jdk -y

# Add MSSQL Server Driver for Hadoop
ADD curl -L 'http://download.microsoft.com/download/0/2/A/02AAE597-3865-456C-AE7F-613F99F850A8/sqljdbc_4.0.2206.100_enu.tar.gz' | tar xz
RUN cp sqljdbc_4.0/enu/sqljdbc4.jar /var/lib/sqoop/

ADD docker_files/cdh_installer.sh /tmp/cdh_installer.sh
ADD docker_files/install_cloudera_repositories.sh /tmp/install_cloudera_repositories.sh

ADD docker_files/cdh_startup_script.sh /usr/bin/cdh_startup_script.sh
ADD docker_files/cloudera.pref /etc/apt/preferences.d/cloudera.pref
ADD docker_files/hadoop-env.sh /etc/profile.d/hadoop-env.sh
ADD docker_files/spark-env.sh /etc/profile.d/spark-env.sh
ADD docker_files/spark-defaults.conf /etc/spark/conf/spark-defaults.conf





ENV TERM xterm

#The solr config file needs to be added after installation or it fails.
ADD docker_files/solr /etc/default/solr.docker

RUN \
    chmod +x /tmp/cdh_installer.sh && \
    chmod +x /usr/bin/cdh_startup_script.sh && \
    bash /tmp/cdh_installer.sh

# private and public mapping
EXPOSE 8020:8020
EXPOSE 8888:8888
EXPOSE 11000:11000
EXPOSE 11443:11443
EXPOSE 9090:9090
EXPOSE 8088:8088
EXPOSE 19888:19888

# private only
#EXPOSE 80

# Define default command.
#CMD ["/usr/bin/cdh_startup_script.sh && bash"]
#CMD ["bash /usr/bin/cdh_startup_script.sh && bash"]
CMD ["cdh_startup_script.sh"]
