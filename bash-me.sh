#!/bin/bash
# Open a shell prompt in the container.  (Part of my standard x-me suite, which assumes your container name matches your folder name.)
container=$(basename $(pwd))
docker exec -it $container sh -il
