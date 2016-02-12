FROM roberthutto/centos-jdk
RUN yum -y install unzip sudo

RUN yum -y install epel-release

RUN yum -y install nodejs npm --enablerepo=epel

RUN npm install -g bower gulp nodemon generator-hottowel

RUN groupadd -r teamcity -g 1000 && useradd -u 1000 -r -g teamcity -m -d /opt/TeamCity -s /sbin/nologin -c "teamcity user" teamcity

ADD setup-agent.sh /setup-agent.sh

EXPOSE  9090
CMD sudo -u teamcity -s -- sh -c "TEAMCITY_SERVER=$TEAMCITY_SERVER bash /setup-agent.sh run"
