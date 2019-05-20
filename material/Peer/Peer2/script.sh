#!/bin/bash

export VERBOSE=false
ARCH=`uname -m`

# Exit on first error, print all commands.
set -ev

peer channel fetch config -o orderer-svc:7050 -c scd-deviceid --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/Peer/Peer2/msp/orderer/msp/tlscacerts/tlsca.hext.scd.org.br-cert.pem
peer channel join -b scd-deviceid_config.block --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/Peer/Peer2/msp/orderer/msp/tlscacerts/tlsca.hext.scd.org.br-cert.pem

peer chaincode install -n deviceid -v 1.0 -l node -p /opt/gopath/src/github.com/hyperledger/fabric/peer/Peer/Chaincode
peer chaincode instantiate -o orderer-svc:7050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/Peer/Peer1/msp/orderer/msp/tlscacerts/tlsca.hext.scd.org.br-cert.pem -C scd-deviceid -n deviceid -v 1.0 -c '{"Args":["initLedger"]}' -P "OR('ISBP04391007.peer')"