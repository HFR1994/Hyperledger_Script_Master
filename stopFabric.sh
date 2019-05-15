#!/bin/bash

# Exit on first error, print all commands.
set -ev

#Detect architecture
ARCH=`uname -m`

# Grab the current directorydirectory.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

git reset --hard HEAD
git pull origin master
chmod +x *.sh material/*.sh
docker container stop $(docker container ls -aq)
docker rm $(docker ps -a -q)
docker system prune -f