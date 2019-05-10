#!/bin/bash

# Exit on first error, print all commands.
set -ev

#Detect architecture
ARCH=`uname -m`

# Grab the current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo $DIR

#Set IMAGETAG

IMAGETAG="latest"

IMAGETAG=$IMAGETAG ARCH=$ARCH docker-compose -f "${DIR}"/docker-compose-ca2.yml down
IMAGETAG=$IMAGETAG ARCH=$ARCH docker-compose -f "${DIR}"/docker-compose-ca2.yml up -d
