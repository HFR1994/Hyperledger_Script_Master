#!/bin/bash

export VERBOSE=false
ARCH=`uname -m`

# Exit on first error, print all commands.
set -ev

peer channel fetch config -o orderer-svc:7050 -c scd-deviceid --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/Peer/Peer1/msp/orderer/msp/tlscacerts/tlsca.bc.cip-cert.pem
peer channel join -b scd-deviceid_config.block --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/Peer/Peer1/msp/orderer/msp/tlscacerts/tlsca.bc.cip-cert.pem
peer channel fetch update -o orderer-svc:7050 -c scd-deviceid -f /opt/gopath/src/github.com/hyperledger/fabric/peer/Peer/Peer1/configtx/Org1MSPanchors.tx  --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/Peer/Peer1/msp/orderer/msp/tlscacerts/tlsca.bc.cip-cert.pem