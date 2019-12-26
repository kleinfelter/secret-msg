#/bin/bash
# Stop the container (assuming it is running as a daemon).  (Part of my standard x-me suite, which assumes your container name matches your folder name.)
container=$(basename $(pwd))
docker kill $container
