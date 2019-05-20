#!/bin/sh

export VERBOSE=false
ARCH=`uname -m`

# Exit on first error, print all commands.
set -ev

export CORE_PEER_MSPCONFIGPATH="/etc/hyperledger/config/msp/users/Admin@04391007.hext.scd.org.br/msp"

peer channel fetch config -o orderer-svc:7050 -c scd-deviceid --tls --cafile /etc/hyperledger/config/msp/orderer/msp/tlscacerts/tlsca.orderer.hext.scd.org.br-cert.pem
peer channel join -b scd-deviceid_config.block --tls --cafile /etc/hyperledger/config/msp/orderer/msp/tlscacerts/tlsca.orderer.hext.scd.org.br-cert.pem
peer channel update -o orderer-svc:7050 -c scd-deviceid -f /etc/hyperledger/config/configtx/04391007anchors.tx --tls --cafile /etc/hyperledger/config/msp/orderer/msp/tlscacerts/tlsca.orderer.hext.scd.org.br-cert.pem

peer chaincode install -n deviceid -v 1.0 -l node -p /opt/gopath/src/github.com/hyperledger/fabric/peer/Peer/Chaincode
peer chaincode instantiate --connTimeout 10 -o orderer-svc:7050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/Peer/Peer1/msp/orderer/msp/tlscacerts/tlsca.orderer.hext.scd.org.br-cert.pem -C scd-deviceid -n deviceid -v 1.0 -c '{"Args":["initLedger"]}' -P "OR('ISBP04391007.peer')"