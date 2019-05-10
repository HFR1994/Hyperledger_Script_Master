#!/bin/bash
cd "$(dirname "$0")"
HOST1=
HOST2=
HOST3=

sed -i -e "s/$HOST1/{IP-HOST-1}/g" configtx.yaml
sed -i -e "s/$HOST2/{IP-HOST-2}/g" configtx.yaml
sed -i -e "s/$HOST3/{IP-HOST-3}/g" configtx.yaml

sed -i -e "s/$HOST1/{IP-HOST-1}/g" crypto-config.yaml
sed -i -e "s/$HOST2/{IP-HOST-2}/g" crypto-config.yaml
sed -i -e "s/$HOST3/{IP-HOST-3}/g" crypto-config.yaml

sed -i -e "s/$HOST1/{IP-HOST-1}/g" docker-compose.yml
sed -i -e "s/$HOST1/{IP-HOST-1}/g" docker-compose-peer2.yaml
sed -i -e "s/$HOST1/{IP-HOST-1}/g" docker-compose-peer3.yaml

sed -i -e "s/$HOST1/{IP-HOST-1}/g" ../createPeerAdminCard.sh
sed -i -e "s/$HOST2/{IP-HOST-2}/g" ../createPeerAdminCard.sh
sed -i -e "s/$HOST3/{IP-HOST-3}/g" ../createPeerAdminCard.sh


ORG1KEY="$(ls crypto-config/peerOrganizations/org1.example.com/ca/ | grep 'sk$')"

sed -i -e "s/$ORG1KEY/{ORG1-CA-KEY}/g" docker-compose.yml

rm -rf composer* crypto-config
