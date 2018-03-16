FROM centos:7

COPY ./mongodb-org-3.6.repo /etc/yum.repos.d/mongodb-org-3.6.repo
COPY ./run.sh /run.sh

RUN yum install -y mongodb-org-tools-3.6.3
RUN yum install -y cronie

ENV MONGODB_HOST="127.0.0.1"
ENV MONGODB_PORT="27017"
ENV MONGODB_DB="test"
ENV CRON_TIME="0 0 * * *"
ENV INIT_BACKUP="true"
ENV MAX_BACKUPS=5

VOLUME /backup
CMD /run.sh