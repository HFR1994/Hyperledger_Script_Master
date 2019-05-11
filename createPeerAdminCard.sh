#!/bin/bash

# Exit on first error
set -e
# Grab the current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Grab the file names of the keystore keys
ORG1KEY="$(ls composer/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/keystore/)"
ORDERER0CA="$(awk 'NF {sub(/\r/, ""); printf "%s\\n",$0;}' composer/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/tls/ca.crt)"
ORDERER1CA="$(awk 'NF {sub(/\r/, ""); printf "%s\\n",$0;}' composer/crypto-config/ordererOrganizations/example.com/orderers/orderer1.example.com/tls/ca.crt)"
ORDERER2CA="$(awk 'NF {sub(/\r/, ""); printf "%s\\n",$0;}' composer/crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/ca.crt)"

ORG1CA="$(awk 'NF {sub(/\r/, ""); printf "%s\\n",$0;}' composer/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt)"

Parse_Arguments() {
	while [ $# -gt 0 ]; do
		case $1 in
			--help)
				HELPINFO=true
				;;
			--host | -h)
                shift
				HOST="$1"
				;;
            --noimport | -n)
				NOIMPORT=true
				;;
		esac
		shift
	done
}

HOST=localhost
Parse_Arguments $@

if [ "${HELPINFO}" == "true" ]; then
    Usage
fi

# Grab the current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ -z "${HL_COMPOSER_CLI}" ]; then
  HL_COMPOSER_CLI=$(which composer)
fi

echo
# check that the composer command exists at a version >v0.16
COMPOSER_VERSION=$("${HL_COMPOSER_CLI}" --version 2>/dev/null)
COMPOSER_RC=$?

if [ $COMPOSER_RC -eq 0 ]; then
    AWKRET=$(echo $COMPOSER_VERSION | awk -F. '{if ($2<19) print "1"; else print "0";}')
    if [ $AWKRET -eq 1 ]; then
        echo Cannot use $COMPOSER_VERSION version of composer with fabric 1.1, v0.19 or higher is required
        exit 1
    else
        echo Using composer-cli at $COMPOSER_VERSION
    fi
else
    echo 'No version of composer-cli has been detected, you need to install composer-cli at v0.19 or higher'
    exit 1
fi

cat << EOF > connection.json
{
    "name": "hlfv1",
    "x-type": "hlfv1",
    "x-commitTimeout": 300,
    "version": "1.0.0",
    "client": {
        "organization": "Org1",
        "connection": {
            "timeout": {
                "peer": {
                    "endorser": "300",
                    "eventHub": "300",
                    "eventReg": "300"
                },
                "orderer": "300"
            }
        }
    },
    "channels": {
        "default": {
            "orderers": [
                "orderer0.example.com",
                "orderer1.example.com",
                "orderer2.example.com"
            ],
            "peers": {
                "peer0.org1.example.com": {
                    "endorsingPeer": true,
                    "chaincodeQuery": true,
                    "eventSource": true
                },
                "peer1.org1.example.com": {
                    "endorsingPeer": true,
                    "chaincodeQuery": true,
                    "eventSource": true
                },
                "peer2.org1.example.com": {
                    "endorsingPeer": true,
                    "chaincodeQuery": true,
                    "eventSource": true
                },
                "peer3.org1.example.com": {
                    "endorsingPeer": true,
                    "chaincodeQuery": true,
                    "eventSource": true
                },
                "peer4.org1.example.com": {
                    "endorsingPeer": true,
                    "chaincodeQuery": true,
                    "eventSource": true
                },
                "peer5.org1.example.com": {
                    "endorsingPeer": true,
                    "chaincodeQuery": true,
                    "eventSource": true
                }
            }
        }
    },
    "organizations": {
        "Org1": {
            "mspid": "Org1MSP",
            "peers": [
                "peer0.org1.example.com",
                "peer1.org1.example.com",
                "peer2.org1.example.com",
                "peer3.org1.example.com",
                "peer4.org1.example.com",
                "peer5.org1.example.com"
            ],
            "certificateAuthorities": [
                "ca.org1.example.com"
            ]
        }
    },
    "orderers": {
        "orderer0.example.com": {
            "url": "grpcs://192.168.1.2:7050",
            "grpcOptions": {
                "ssl-target-name-override": "orderer0.example.com"
            },
            "tlsCACerts": {
                "pem": "${ORDERER0CA}"
            }
        },
        "orderer1.example.com":{ 
            "url": "grpcs://192.168.1.3:7050",
            "grpcOptions": {
                "ssl-target-name-override": "orderer1.example.com"
            },
            "tlsCACerts": {
                "pem": "${ORDERER1CA}"
            }
        },
        "orderer2.example.com":{ 
            "url": "grpcs://192.168.1.4:7050",
            "grpcOptions": {
                "ssl-target-name-override": "orderer2.example.com"
            },
            "tlsCACerts": {
                "pem": "${ORDERER2CA}"
            }
        }
    },
    "peers": {
        "peer0.org1.example.com": {
            "url": "grpcs://192.168.1.2:7051",
            "eventUrl": "grpcs://192.168.1.2:7053",
            "grpcOptions": {
                "ssl-target-name-override": "peer0.org1.example.com"
            },
            "tlsCACerts": {
                "pem": "${ORG1CA}"
            }
        },
        "peer1.org1.example.com": {
            "url": "grpcs://192.168.1.2:8051",
            "eventUrl": "grpcs://192.168.1.2:8053",
            "grpcOptions": {
                "ssl-target-name-override": "peer1.org1.example.com"
            },
            "tlsCACerts": {
                "pem": "${ORG1CA}"
            }
        },
        "peer2.org1.example.com":{ 
            "url": "grpcs://192.168.1.3:9051",
            "eventUrl": "grpcs://192.168.1.3:9053",
            "grpcOptions": {
                "ssl-target-name-override": "peer2.org1.example.com"
            },
            "tlsCACerts": {
                "pem": "${ORG1CA}"
            }
        },
        "peer3.org1.example.com":{ 
            "url": "grpcs://192.168.1.3:10051",
            "eventUrl": "grpcs://192.168.1.3:10053",
            "grpcOptions": {
                "ssl-target-name-override": "peer3.org1.example.com"
            },
            "tlsCACerts": {
                "pem": "${ORG1CA}"
            }
        },
        "peer4.org1.example.com":{ 
            "url": "grpcs://192.168.1.4:9051",
            "eventUrl": "grpcs://192.168.1.4:9053",
            "grpcOptions": {
                "ssl-target-name-override": "peer4.org1.example.com"
            },
            "tlsCACerts": {
                "pem": "${ORG1CA}"
            }
        },
        "peer5.org1.example.com":{ 
            "url": "grpcs://192.168.1.4:10051",
            "eventUrl": "grpcs://192.168.1.4:10053",
            "grpcOptions": {
                "ssl-target-name-override": "peer5.org1.example.com"
            },
            "tlsCACerts": {
                "pem": "${ORG1CA}"
            }
        }
    },
    "certificateAuthorities": {
        "ca.org1.example.com": {
            "url": "https://192.168.1.2:7054",
            "caName": "ca.org1.example.com",
            "httpOptions": {
                "verify": false
            }
        }
    }
}
EOF

PRIVATE_KEY="${DIR}"/composer/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/keystore/"${ORG1KEY}"
CERT="${DIR}"/composer/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/signcerts/Admin@org1.example.com-cert.pem

if [ "${NOIMPORT}" != "true" ]; then
    CARDOUTPUT=/tmp/PeerAdmin@hlfv1.card
else
    CARDOUTPUT=PeerAdmin@hlfv1.card
fi

"${HL_COMPOSER_CLI}"  card create -p connection.json -u PeerAdmin -c "${CERT}" -k "${PRIVATE_KEY}" -r PeerAdmin -r ChannelAdmin --file $CARDOUTPUT

if [ "${NOIMPORT}" != "true" ]; then
    if "${HL_COMPOSER_CLI}"  card list -c PeerAdmin@hlfv1 > /dev/null; then
        "${HL_COMPOSER_CLI}"  card delete -c PeerAdmin@hlfv1
    fi

    "${HL_COMPOSER_CLI}"  card import --file /tmp/PeerAdmin@hlfv1.card 
    "${HL_COMPOSER_CLI}"  card list
    echo "Hyperledger Composer PeerAdmin card has been imported, host of fabric specified as '${HOST}'"
    rm /tmp/PeerAdmin@hlfv1.card
else
    echo "Hyperledger Composer PeerAdmin card has been created, host of fabric specified as '${HOST}'"
fi
echo "Hyperledger Composer PeerAdmin card has been imported"
composer card list
