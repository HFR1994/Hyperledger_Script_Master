# Hyperledger Fabric 1.4 Multinode, MultiOrderer across three nodes

## VM can be found here

```
https://ibm.box.com/s/obelaje9482pcqdwh4olm7js4afvi587
```

##Initializiation
```
git clone https://github.com/InflatibleYoshi/fabric-1.1-kafka-multi-orderer
cd Hyper_Script_Maker
cd composer
./howtobuild.sh
```

###Worker 1

```
cd CA-Replication
cd CA1
./startCA1.sh
```

###Worker 2

```
cd CA-Replication
cd CA2
./startCA2.sh
```

## Install Everything else

###Worker 1

```
./startFabric.sh
```

###Worker 2

```
./startFabric-Peers2.sh
```

###Worker 3

```
./startFabric-Peers3.sh
```