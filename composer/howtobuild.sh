#!/bin/bash
cd "$(dirname "$0")"
CHANNEL_NAME=default

rm -rf crypto-config
rm -rf channel-artifacts
mkdir channel-artifacts
cryptogen generate --config=./crypto-config.yaml
export FABRIC_CFG_PATH=$PWD

configtxgen -profile ModeKafkaOrderer -channelID $CHANNEL_NAME -outputBlock ./channel-artifacts/genesis.block
configtxgen -profile ModeKafkaChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID $CHANNEL_NAME
configtxgen -profile ModeKafkaChannel -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org1MSP
ORG1KEY="$(ls crypto-config/peerOrganizations/org1.bc.cip/ca/ | grep 'sk$')"

sed -i -e "s/{ORG1-CA-KEY}/$ORG1KEY/g" ./CA-Replication/CA1/docker-compose-ca1.yml
sed -i -e "s/{ORG1-CA-KEY}/$ORG1KEY/g" ./CA-Replication/CA2/docker-compose-ca2.yml
