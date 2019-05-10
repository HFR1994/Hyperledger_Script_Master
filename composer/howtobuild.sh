#!/bin/bash
cd "$(dirname "$0")"
HOST1=192.168.1.2
HOST2=192.168.1.3
HOST3=192.168.1.4

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


##cryptogen generate --config=./crypto-config.yaml
##export FABRIC_CFG_PATH=$PWD

configtxgen -profile SampleDevModeKafka -channelID byfn-sys-channel -outputBlock ./channel-artifacts/genesis.block
configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID $CHANNEL_NAME
configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org1MSP


##configtxgen -profile ComposerOrdererGenesis -outputBlock ./composer-genesis.block
##configtxgen -profile ComposerChannel -outputCreateChannelTx ./composer-channel.tx -channelID composerchannel

##ORG1KEY="$(ls crypto-config/peerOrganizations/org1.example.com/ca/ | grep 'sk$')"

##sed -i -e "s/{ORG1-CA-KEY}/$ORG1KEY/g" docker-compose.yml
