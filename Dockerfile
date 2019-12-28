# Note: You can't install MySql 5.x on alpine 
From alpine:3.11 as builder

# Should put the update in the same line as the "apk add" to avoide using a cached update when you add.

# == install the non-python-package stuff
RUN apk update && apk add --no-cache python3=3.8.0-r0 python3-dev=3.8.0-r0  && \
    apk update && apk add --no-cache build-base openssl-dev libffi-dev
RUN ln /usr/bin/pip3 /usr/bin/pip && \
    ln /usr/bin/python3 /usr/bin/python && \
    pip install --upgrade pip

# == install python packages ==
COPY requirements.txt .
RUN pip install --prefix=/install --no-warn-script-location -r requirements.txt

##########################################################################################

FROM alpine:3.11

WORKDIR /app

# This hack is widely applied to avoid python printing issues in docker containers.
ENV PYTHONUNBUFFERED=1
ENV DEBIAN_FRONTEND="noninteractive"

RUN apk add --no-cache mariadb python3=3.8.0-r0 && rm -rf /usr/mysql-test && \
    ln /usr/bin/python3 /usr/bin/python && \
    rm -rf /mysql-test
COPY --from=builder /install /usr/local

ENV FLASK_APP=shhh

RUN mkdir -p /var/run/mysqld && chown mysql:mysql /var/run/mysqld && mysql_install_db --user=root --datadir=/var/lib/mysql && ls -l /var/lib/mysql && \
    sed -i 's/^skip-networking/#skip-networking/' /etc/my.cnf.d/mariadb-server.cnf && \
    sed -i 's/^#bind-address=0.0.0.0/bind-address=127.0.0.1/' /etc/my.cnf.d/mariadb-server.cnf && \
    mkdir -p /var/log && echo "===" > /var/log/mysqld.error && chown mysql:mysql /var/log/mysqld.error && chown -R mysql:mysql /var/lib/mysql

COPY shhh shhh

EXPOSE 5000
