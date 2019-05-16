#!/bin/bash
cd "$(dirname "$0")"
CHANNEL_NAME="cip-channel"

rm -rf crypto-config
rm -rf channel-artifacts
mkdir channel-artifacts
cryptogen generate --config=./crypto-config.yaml
export FABRIC_CFG_PATH=$PWD

configtxgen -profile ModeKafkaOrderer -channelID $CHANNEL_NAME -outputBlock ./channel-artifacts/genesis.block
configtxgen -profile ModeKafkaChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID $CHANNEL_NAME
configtxgen -profile ModeKafkaChannel -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org1MSP

