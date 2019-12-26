#/bin/bash
# Restart the container.  (Part of my standard x-me suite, which assumes your container name matches your folder name.)
container=$(basename $(pwd))

tmp=`docker ps | grep $container| wc -l`
if [ $tmp -ne 0 ] ; then
    echo " "
    echo "    Stopping old $container"
    ./stop-me.sh
fi


./build-me.sh

docker-compose up --detach
echo "Started $container with RC $?"
