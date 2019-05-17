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

CHANNEL_NAME="cip_channel"

# Grab the current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

ORG1CAKEY="$(ls ./material/crypto-config/peerOrganizations/org1.hext.scd.org.br/ca/ | grep 'sk$')"

IMAGETAG="latest"

ORG1CAKEY=$ORG1CAKEY IMAGETAG=$IMAGETAG ARCH=$ARCH docker-compose -f "${DIR}"/composer/docker-compose.yml down
ORG1CAKEY=$ORG1CAKEY IMAGETAG=$IMAGETAG ARCH=$ARCH docker-compose -f "${DIR}"/composer/docker-compose.yml up -d

# wait for Hyperledger Fabric to start
# incase of errors when running later commands, issue export FABRIC_START_TIMEOUT=<larger number>
echo ${FABRIC_START_TIMEOUT}
sleep ${FABRIC_START_TIMEOUT}

# Create the channel
docker exec peer0.org1.hext.scd.org.br peer channel create -o orderer0.hext.scd.org.br:7050 -c $CHANNEL_NAME -f /etc/hyperledger/configtx/channel.tx --tls --cafile /etc/hyperledger/msp/orderer/msp/tlscacerts/tlsca.hext.scd.org.br-cert.pem

echo ${FABRIC_START_TIMEOUT}
sleep ${FABRIC_START_TIMEOUT}
sleep ${FABRIC_START_TIMEOUT}

# Join peer0.org1.hext.scd.org.br to the channel.
docker exec -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org1.hext.scd.org.br/msp" peer0.org1.hext.scd.org.br peer channel join -b genesis.block --tls --cafile /etc/hyperledger/msp/orderer/msp/tlscacerts/tlsca.hext.scd.org.br-cert.pem

# # Create the channel
docker exec -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org1.hext.scd.org.br/msp" peer1.org1.hext.scd.org.br peer channel fetch config -o orderer0.hext.scd.org.br:7050 -c $CHANNEL_NAME --tls --cafile /etc/hyperledger/msp/orderer/msp/tlscacerts/tlsca.hext.scd.org.br-cert.pem
# docker exec peer1.org1.hext.scd.org.br peer channel create -o orderer.hext.scd.org.br:7050 -c default -f /etc/hyperledger/configtx/material-channel.tx

# # Join peer1.org1.hext.scd.org.br to the channel.
docker exec -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org1.hext.scd.org.br/msp" peer1.org1.hext.scd.org.br peer channel join -b default_config.block --tls --cafile /etc/hyperledger/msp/orderer/msp/tlscacerts/tlsca.hext.scd.org.br-cert.pem
