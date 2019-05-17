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
configtxgen -profile ModeKafkaChannel -outputAnchorPeersUpdate ./channel-artifacts/04391007anchors.tx -channelID $CHANNEL_NAME -asOrg ISPB04391007

## Remove CA files
rm -rf ./CA/*_sk ./CA/*.pem
cp -r ./crypto-config/peerOrganizations/hext.scd.org.br/ca/* ./CA/

## Remove Orderer files
rm -rf ./Orderer/*/configtx/* ./Orderer/*/msp/orderer/* ./Orderer/*/tls/orderer/*

cp ./channel-artifacts/* ./Orderer/Orderer1/configtx/
cp -r ./crypto-config/ordererOrganizations/hext.scd.org.br/orderers/orderer1.hext.scd.org.br/msp ./Orderer/Orderer1/msp/orderer/
cp -r ./crypto-config/ordererOrganizations/hext.scd.org.br/orderers/orderer1.hext.scd.org.br/tls ./Orderer/Orderer1/tls/orderer/

cp ./channel-artifacts/* ./Orderer/Orderer2/configtx/
cp -r ./crypto-config/ordererOrganizations/hext.scd.org.br/orderers/orderer2.hext.scd.org.br/msp ./Orderer/Orderer2/msp/orderer/
cp -r ./crypto-config/ordererOrganizations/hext.scd.org.br/orderers/orderer2.hext.scd.org.br/tls ./Orderer/Orderer2/tls/orderer/

cp ./channel-artifacts/* ./Orderer/Orderer3/configtx/
cp -r ./crypto-config/ordererOrganizations/hext.scd.org.br/orderers/orderer3.hext.scd.org.br/msp ./Orderer/Orderer3/msp/orderer/
cp -r ./crypto-config/ordererOrganizations/hext.scd.org.br/orderers/orderer3.hext.scd.org.br/tls ./Orderer/Orderer3/tls/orderer/

## Remove Peer files
rm -rf ./Peer/*/configtx/* ./Peer/*/msp/orderer/* ./Peer/*/peer/*

cp ./channel-artifacts/* ./Peer/Peer1/configtx/
cp -r ./crypto-config/peerOrganizations/hext.scd.org.br/peers/peer1.hext.scd.org.br/msp ./Peer/Peer1/peer/
cp -r ./crypto-config/peerOrganizations/hext.scd.org.br/peers/peer1.hext.scd.org.br/tls ./Peer/Peer1/peer/
cp -r ./crypto-config/peerOrganizations/hext.scd.org.br/users ./Peer/Peer1/msp/
cp -r ./crypto-config/ordererOrganizations/hext.scd.org.br/orderers/orderer1.hext.scd.org.br/msp ./Peer/Peer1/msp/orderer

cp ./channel-artifacts/* ./Peer/Peer2/configtx/
cp -r ./crypto-config/peerOrganizations/hext.scd.org.br/peers/peer2.hext.scd.org.br/msp ./Peer/Peer2/peer/
cp -r ./crypto-config/peerOrganizations/hext.scd.org.br/peers/peer2.hext.scd.org.br/tls ./Peer/Peer2/peer/
cp -r ./crypto-config/peerOrganizations/hext.scd.org.br/users ./Peer/Peer2/msp/
cp -r ./crypto-config/ordererOrganizations/hext.scd.org.br/orderers/orderer2.hext.scd.org.br/msp ./Peer/Peer2/msp/orderer