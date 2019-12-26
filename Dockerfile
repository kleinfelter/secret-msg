# Note: You can't install MySql 5.x on alpine 
#FROM python:3.8-buster
FROM alpine:3.11

WORKDIR /app

# This hack is widely applied to avoid python printing issues in docker containers.
ENV PYTHONUNBUFFERED=1
ENV DEBIAN_FRONTEND="noninteractive"

RUN apk update 
RUN apk add mariadb
RUN apk add python3=3.8.0-r0
RUN apk add python3-dev=3.8.0-r0
RUN apk add build-base openssl-dev libffi-dev
RUN apk add openrc

RUN which pip3
RUN ln /usr/bin/pip3 /usr/bin/pip
RUN ln /usr/bin/python3 /usr/bin/python
RUN pip install --upgrade pip
COPY requirements.txt .
RUN pip install -r requirements.txt

ENV FLASK_APP=shhh
COPY shhh shhh

RUN mkdir -p /var/run/mysqld && chown mysql:mysql /var/run/mysqld && mysql_install_db --user=root --datadir=/var/lib/mysql && ls -l /var/lib/mysql
RUN sed -i 's/^skip-networking/#skip-networking/' /etc/my.cnf.d/mariadb-server.cnf
RUN sed -i 's/^#bind-address=0.0.0.0/bind-address=127.0.0.1/' /etc/my.cnf.d/mariadb-server.cnf



EXPOSE 5000
