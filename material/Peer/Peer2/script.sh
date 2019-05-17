#!/bin/bash

export VERBOSE=false
ARCH=`uname -m`

# Exit on first error, print all commands.
set -ev

peer channel fetch config -o orderer-svc:7050 -c scd-deviceid --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/Peer/Peer2/msp/orderer/msp/tlscacerts/tlsca.scd.org.br-cert.pem
peer channel join -b scd-deviceid_config.block --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/Peer/Peer2/msp/orderer/msp/tlscacerts/tlsca.scd.org.br-cert.pem
peer channel update -o orderer-svc:7050 -c scd-deviceid -f /opt/gopath/src/github.com/hyperledger/fabric/peer/Peer/Peer2/configtx/04391007anchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/Peer/Peer2/msp/orderer/msp/tlscacerts/tlsca.scd.org.br-cert.pem