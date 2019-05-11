#!/bin/bash

if [ -z ${FABRIC_START_TIMEOUT+x} ]; then
 echo "FABRIC_START_TIMEOUT is unset, assuming 15 (seconds)"
 export FABRIC_START_TIMEOUT=15
else

   re='^[0-9]+$'
   if ! [[ $FABRIC_START_TIMEOUT =~ $re ]] ; then
      echo "FABRIC_START_TIMEOUT: Not a number" >&2; exit 1
   fi

 echo "FABRIC_START_TIMEOUT is set to '$FABRIC_START_TIMEOUT'"
fi

# Exit on first error, print all commands.
set -ev

#Detect architecture
ARCH=`uname -m`

# Grab the current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

IMAGETAG="latest"

IMAGETAG=$IMAGETAG ARCH=$ARCH docker-compose -f "${DIR}"/composer/docker-compose.yml down
IMAGETAG=$IMAGETAG ARCH=$ARCH docker-compose -f "${DIR}"/composer/docker-compose.yml up -d

# wait for Hyperledger Fabric to start
# incase of errors when running later commands, issue export FABRIC_START_TIMEOUT=<larger number>
echo ${FABRIC_START_TIMEOUT}
sleep ${FABRIC_START_TIMEOUT}

# Create the channel
docker exec peer0.org1.bc.cip peer channel create -o orderer0.bc.cip:7050 -c default -f /etc/hyperledger/configtx/channel.tx --tls --cafile /etc/hyperledger/msp/orderer/msp/tlscacerts/tlsca.bc.cip-cert.pem

echo ${FABRIC_START_TIMEOUT}
sleep ${FABRIC_START_TIMEOUT}
sleep ${FABRIC_START_TIMEOUT}

# Join peer0.org1.bc.cip to the channel.
docker exec -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org1.bc.cip/msp" peer0.org1.bc.cip peer channel join -b genesis.block --tls --cafile /etc/hyperledger/msp/orderer/msp/tlscacerts/tlsca.bc.cip-cert.pem

# # Create the channel
docker exec -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org1.bc.cip/msp" peer1.org1.bc.cip peer channel fetch config -o orderer0.bc.cip:7050 -c default --tls --cafile /etc/hyperledger/msp/orderer/msp/tlscacerts/tlsca.bc.cip-cert.pem
# docker exec peer1.org1.bc.cip peer channel create -o orderer.bc.cip:7050 -c default -f /etc/hyperledger/configtx/composer-channel.tx

# # Join peer1.org1.bc.cip to the channel.
docker exec -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org1.bc.cip/msp" peer1.org1.bc.cip peer channel join -b default_config.block --tls --cafile /etc/hyperledger/msp/orderer/msp/tlscacerts/tlsca.bc.cip-cert.pem
