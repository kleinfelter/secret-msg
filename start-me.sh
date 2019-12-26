#/bin/bash
# Start the container as a daemon.  (Part of my standard x-me suite, which assumes your container name matches your folder name.)
container=$(basename $(pwd))
docker-compose up --detach
echo "Started $container with RC $?"
