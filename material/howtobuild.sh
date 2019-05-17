#!/bin/bash
cd "$(dirname "$0")"
CHANNEL_NAME="scd-deviceid"

rm -rf crypto-config
rm -rf channel-artifacts
mkdir channel-artifacts
cryptogen generate --config=./crypto-config.yaml
export FABRIC_CFG_PATH=$PWD

configtxgen -profile ModeKafkaOrderer -channelID scd-system-channel -outputBlock ./channel-artifacts/genesis.block
configtxgen -profile ModeKafkaChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID $CHANNEL_NAME
configtxgen -profile ModeKafkaChannel -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org1MSP

## Remove CA files
rm -rf ./CA/*_sk ./CA/ca.org1.bc.cip-cert.pem
cp -r ./crypto-config/peerOrganizations/org1.bc.cip/ca/* ./CA/

## Remove Orderer files
rm -rf ./Orderer/*/configtx/* ./Orderer/*/msp/orderer/* ./Orderer/*/tls/orderer/*

cp ./channel-artifacts/* ./Orderer/Orderer1/configtx/
cp -r ./crypto-config/ordererOrganizations/bc.cip/orderers/orderer1.bc.cip/msp ./Orderer/Orderer1/msp/orderer/
cp -r ./crypto-config/ordererOrganizations/bc.cip/orderers/orderer1.bc.cip/tls ./Orderer/Orderer1/tls/orderer/

cp ./channel-artifacts/* ./Orderer/Orderer2/configtx/
cp -r ./crypto-config/ordererOrganizations/bc.cip/orderers/orderer2.bc.cip/msp ./Orderer/Orderer2/msp/orderer/
cp -r ./crypto-config/ordererOrganizations/bc.cip/orderers/orderer2.bc.cip/tls ./Orderer/Orderer2/tls/orderer/

cp ./channel-artifacts/* ./Orderer/Orderer3/configtx/
cp -r ./crypto-config/ordererOrganizations/bc.cip/orderers/orderer3.bc.cip/msp ./Orderer/Orderer3/msp/orderer/
cp -r ./crypto-config/ordererOrganizations/bc.cip/orderers/orderer3.bc.cip/tls ./Orderer/Orderer3/tls/orderer/

## Remove Peer files
rm -rf ./Peer/*/configtx/* ./Peer/*/msp/orderer/* ./Peer/*/peer/*

cp ./channel-artifacts/* ./Peer/Peer1/configtx/
cp -r ./crypto-config/peerOrganizations/org1.bc.cip/peers/peer1.org1.bc.cip/msp ./Peer/Peer1/peer/
cp -r ./crypto-config/peerOrganizations/org1.bc.cip/peers/peer1.org1.bc.cip/tls ./Peer/Peer1/peer/
cp -r ./crypto-config/peerOrganizations/org1.bc.cip/users ./Peer/Peer1/msp/
cp -r ./crypto-config/ordererOrganizations/bc.cip/orderers/orderer1.bc.cip/msp ./Peer/Peer1/msp/orderer

cp ./channel-artifacts/* ./Peer/Peer2/configtx/
cp -r ./crypto-config/peerOrganizations/org1.bc.cip/peers/peer2.org1.bc.cip/msp ./Peer/Peer2/peer/
cp -r ./crypto-config/peerOrganizations/org1.bc.cip/peers/peer2.org1.bc.cip/tls ./Peer/Peer2/peer/
cp -r ./crypto-config/peerOrganizations/org1.bc.cip/users ./Peer/Peer2/msp/
cp -r ./crypto-config/ordererOrganizations/bc.cip/orderers/orderer2.bc.cip/msp ./Peer/Peer2/msp/orderer