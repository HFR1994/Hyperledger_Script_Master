#!/bin/bash

export VERBOSE=false
ARCH=`uname -m`

# Exit on first error, print all commands.
set -ev

peer channel create -o orderer-svc:7050 -c scd-deviceid -f /opt/gopath/src/github.com/hyperledger/fabric/peer/Peer/Peer1/configtx/channel.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/Peer/Peer1/msp/orderer/msp/tlscacerts/tlsca.scd.org.br-cert.pem
peer channel join -b scd-deviceid.block --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/Peer/Peer1/msp/orderer/msp/tlscacerts/tlsca.scd.org.br-cert.pem