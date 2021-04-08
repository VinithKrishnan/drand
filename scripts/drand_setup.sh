#!/bin/bash 

# sudo apt-get -y install build-essential;
# sudo add-apt-repository ppa:longsleep/golang-backports;
# # sudo apt update;

# sudo apt install golang-go;

# # killall drand

if [ ! -d drand ] ; then
git clone https://github.com/VinithKrishnan/drand.git;
    cd drand;
    make build;

else
    cd drand;
fi
# cd drand

# git clone https://github.com/drand/drand;
# cd drand;
# # # # git checkout v1.2.5
# make build;

# IP=`ip address show | \
#     grep "inet .* brd" | \
#     sed 's/ brd.*//g' | \
#     sed 's/inet //' | \
#     sed 's;/.*;;g' | \
#     sed 's/.* //g'`

# echo "Got IP: $IP"

IP=$1
# echo $IP

if [ ! -d datadir ] ; then
    mkdir -p datadir
else
    rm -rf datadir
    mkdir -p datadir
fi

./drand --folder datadir generate-keypair --tls-disable --folder datadir $IP:8080