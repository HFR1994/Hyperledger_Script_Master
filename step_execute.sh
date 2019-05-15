#!/usr/bin/env bash

export VERBOSE=false
ARCH=`uname -m`

function printHelp() {
  echo "Usage: "
  echo "  step_execute.sh <mode> [-w <worker_node>] [-v]"
  echo "    <mode> - one of 'up', 'down'"
  echo "      - 'up' - bring up the network with docker-compose up"
  echo "      - 'down' - clear the network with docker-compose down"
  echo "    -w <worker_node> - Integer denotates Worker 1,2 or 3 (defaults to 1)"
  echo "    -s <step> - Integer denotates step execution (defaults to 1)"
  echo "    -v - verbose mode"
  echo "  step_execute.sh -h (print this message)"
  echo
  echo "Typically, one would first generate the required certificates and "
  echo "genesis block, then bring up the network."
  echo
}

# Obtain the OS and Architecture string that will be used to select the correct
# native binaries for your platform, e.g., darwin-amd64 or linux-amd64
OS_ARCH=$(echo "$(uname -s | tr '[:upper:]' '[:lower:]' | sed 's/mingw64_nt.*/windows/')-$(uname -m | sed 's/x86_64/amd64/g')" | awk '{print tolower($0)}')
# timeout duration - the duration the CLI should wait for a response from
# another container before giving up
WORKER_NODE=1
STEP=1

function networkUp() {

    echo "${EXPMODE} step1 docker containers"

    if [ -d "./material/crypto-config" ]; then
        # Grab the current directory
        DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
        #Replace Certificate Key
        ORG1CAKEY="$(ls ./material/crypto-config/peerOrganizations/org1.bc.cip/ca/ | grep 'sk$')"
        #Set IMAGETAG
        IMAGETAG="1.4.0"
        EXTERNALTAG="0.4.10"
        ORG1CAKEY=$ORG1CAKEY EXTERNALTAG=$EXTERNALTAG IMAGETAG=$IMAGETAG ARCH=$ARCH docker-compose -f "${DIR}"/worker"${WORKER_NODE}"/docker-compose-step"${STEP}".yml up -d
    else
        echo "No crypto material has been generated"
    fi
}


function networkDown() {

    echo "${EXPMODE} step1 docker containers"

    if [ -d "./material/crypto-config" ]; then
        # Grab the current directory
        DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

        #Replace Certificate Key
        ORG1CAKEY="$(ls ./material/crypto-config/peerOrganizations/org1.bc.cip/ca/ | grep 'sk$')"
        #Set IMAGETAG
        IMAGETAG="1.4.0"
        EXTERNALTAG="0.4.10"
        ORG1CAKEY=$ORG1CAKEY EXTERNALTAG=$EXTERNALTAG IMAGETAG=$IMAGETAG ARCH=$ARCH docker-compose -f "${DIR}"/worker"${WORKER_NODE}"/docker-compose-step"${STEP}".yml down --rmi all -v
    else
        echo "No crypto material has been generated"
    fi
}

# Parse commandline args
if [ "$1" = "-m" ]; then # supports old usage, muscle memory is powerful!
  shift
fi
MODE=$1
shift
# Determine whether starting, stopping, restarting, generating or upgrading
if [ "$MODE" == "up" ]; then
  EXPMODE="Starting"
elif [ "$MODE" == "down" ]; then
  EXPMODE="Stopping"
else
  printHelp
  exit 1
fi

while getopts "h?w:s:v" opt; do
  case "$opt" in
  h | \?)
    printHelp
    exit 0
    ;;
  w)
    WORKER_NODE=$OPTARG
    ;;
  s)
    STEP=$OPTARG
    ;;
  v)
    VERBOSE=true
    ;;
  esac
done

if [ "${MODE}" == "up" ]; then
  networkUp
elif [ "${MODE}" == "down" ]; then ## Clear the network
  networkDown
else
  printHelp
  exit 1
fi