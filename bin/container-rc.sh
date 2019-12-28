#!/bin/sh
# >> alpine needs sh, not bash

echo "Starting container-rc.sh"

#mkdir -p /var/log
#echo "===" > /var/log/mysqld.error
#chown mysql:mysql /var/log/mysqld.error
#chown -R mysql:mysql /var/lib/mysql

mysqld_safe --log-error=/var/log/mysqld.error --skip-syslog &
sleep 2
echo "Checking to see if mysqld is running"
while ! ps -ef | grep -v grep | grep mysqld ; do
    echo "waiting for mysqld to go active"
    sleep 2
done

echo "Found active mysqld.  See if it stays up."
sleep 5
echo "Checking"

if ps -ef | grep -v grep | grep mysqld ; then
    echo "Yep, it stayed up."
else
    echo "No, mysqld did not stay up. Login with sh and see what happened..."
    sleep 5000
fi

# Difficult to  move this to Dockerfile because you need MySQL *running* to run this.
echo "Checking to see about initializing DB"
if ! [ -r /var/lib/mysql/initialized ] ; then
    date > /var/lib/mysql/initialized
    mysql -u root < /docker-entrypoint-initdb.d/initialize.sql
fi

export PYTHONPATH="$PYTHONPATH:/usr/local/lib/python3.8/site-packages"
echo "Starting flask"
python -m flask run --host=0.0.0.0 --port=5000

while true ; do
    sleep 5000
done

