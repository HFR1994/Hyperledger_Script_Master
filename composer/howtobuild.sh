#!/bin/bash
cd "$(dirname "$0")"
HOST1=192.168.1.2
HOST2=192.168.1.3
HOST3=192.168.1.4
CHANNEL_NAME=default

sed -i -e "s/{IP-HOST-1}/$HOST1/g" configtx.yaml
sed -i -e "s/{IP-HOST-2}/$HOST2/g" configtx.yaml
sed -i -e "s/{IP-HOST-3}/$HOST3/g" configtx.yaml

sed -i -e "s/{IP-HOST-1}/$HOST1/g" crypto-config.yaml
sed -i -e "s/{IP-HOST-2}/$HOST2/g" crypto-config.yaml
sed -i -e "s/{IP-HOST-3}/$HOST3/g" crypto-config.yaml

sed -i -e "s/{IP-HOST-1}/$HOST1/g" docker-compose.yml
sed -i -e "s/{IP-HOST-1}/$HOST1/g" docker-compose-peer2.yml
sed -i -e "s/{IP-HOST-2}/$HOST2/g" docker-compose-peer2.yml
sed -i -e "s/{IP-HOST-1}/$HOST1/g" docker-compose-peer3.yml
sed -i -e "s/{IP-HOST-3}/$HOST3/g" docker-compose-peer3.yml

sed -i -e "s/{IP-HOST-1}/$HOST1/g" ../createPeerAdminCard.sh
sed -i -e "s/{IP-HOST-2}/$HOST2/g" ../createPeerAdminCard.sh
sed -i -e "s/{IP-HOST-3}/$HOST3/g" ../createPeerAdminCard.sh


cryptogen generate --config=./crypto-config.yaml
export FABRIC_CFG_PATH=$PWD

configtxgen -profile ModeKafkaOrderer -channelID $CHANNEL_NAME -outputBlock ./channel-artifacts/genesis.block
configtxgen -profile ModeKafkaChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID $CHANNEL_NAME
configtxgen -profile ModeKafkaChannel -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org1MSP
ORG1KEY="$(ls crypto-config/peerOrganizations/org1.bc.cip/ca/ | grep 'sk$')"

sed -i -e "s/{ORG1-CA-KEY}/$ORG1KEY/g" ./CA-Replication/CA1/docker-compose-ca1.yml
sed -i -e "s/{ORG1-CA-KEY}/$ORG1KEY/g" ./CA-Replication/CA2/docker-compose-ca2.yml
