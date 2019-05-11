#!/bin/bash

# Exit on first error, print all commands.
set -ev

#Detect architecture
ARCH=`uname -m`

# Grab the current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


ORG1CAKEY="$(ls ../../crypto-config/peerOrganizations/org1.bc.cip/ca/ | grep 'sk$')"

#Set IMAGETAG

IMAGETAG="latest"

ORG1CAKEY=$ORG1CAKEY IMAGETAG=$IMAGETAG ARCH=$ARCH docker-compose -f "${DIR}"/docker-compose-ca1.yml down
ORG1CAKEY=$ORG1CAKEY IMAGETAG=$IMAGETAG ARCH=$ARCH docker-compose -f "${DIR}"/docker-compose-ca1.yml up -d
