#!/bin/bash

export VERBOSE=false
ARCH=`uname -m`

# Exit on first error, print all commands.
set -ev

export CORE_PEER_MSPCONFIGPATH="/opt/gopath/src/github.com/hyperledger/fabric/peer/Peer/Peer2/msp/users/Admin@04391007.hext.scd.org.br/msp"

peer channel create -o orderer-svc:7050 -c scd-deviceid -f /opt/gopath/src/github.com/hyperledger/fabric/peer/Peer/Peer1/configtx/channel.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/Peer/Peer1/msp/orderer/msp/tlscacerts/tlsca.orderer.hext.scd.org.br-cert.pem

peer channel fetch config -o orderer-svc:7050 -c scd-deviceid --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/Peer/Peer1/msp/orderer/msp/tlscacerts/tlsca.orderer.hext.scd.org.br-cert.pem
peer channel join -b scd-deviceid_config.block --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/Peer/Peer1/msp/orderer/msp/tlscacerts/tlsca.orderer.hext.scd.org.br-cert.pem

peer chaincode install -n deviceid -v 1.0 -l node -p /opt/gopath/src/github.com/hyperledger/fabric/peer/Peer/Chaincode
