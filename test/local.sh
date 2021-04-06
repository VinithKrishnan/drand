#!/bin/bash

set -x

N=5
T=2


curr=$(pwd)
# cd /mnt/c/Users/VinithKrishnan/drand #$GOPATH/src/github.com/dedis/drand

# echo "[+] building drand ..."
# go build

# cp drand $curr/drand
# chmod +x $curr/drand
# cd $curr

tmp=$(mktemp -d)
echo "[+] base tmp folder: $tmp"


a1="127.0.0.1:5000"
a2="127.0.0.1:6000"
a3="127.0.0.1:7000"
a4="127.0.0.1:8000"
a5="127.0.0.1:9000"
p1=8885
p2=8886
p3=8887
p4=8889
p5=8888


# path = "/mnt/c/Users/VinithKrishnan/drand/"
LeaderAddr=$a5

mkdir -p -m740 f1 f2 f3 f4 f5

f1=$curr/f1
f2=$curr/f2
f3=$curr/f3
f4=$curr/f4
f5=$curr/f5

echo "[+] generating keys"
./drand  generate-keypair --tls-disable --folder $f1 $a1 
./drand  generate-keypair --tls-disable --folder $f2 $a2
./drand  generate-keypair --tls-disable --folder $f3 $a3 
./drand  generate-keypair --tls-disable --folder $f4 $a4 
./drand  generate-keypair --tls-disable --folder $f5 $a5 

echo "mysecret901234567890123456789012" > secret-file.log

echo "[+] running drand daemons..."
./drand  --folder $f1 start --folder $f1 --tls-disable --public-listen 127.0.0.1:4444 --control $p1 & # > $tmp/log1 2>&1 &
./drand  --folder $f2 start --folder $f2 --tls-disable --public-listen 127.0.0.1:4445 --control $p2 & # > $tmp/log2 2>&1 &
./drand  --folder $f3 start --folder $f3 --tls-disable --public-listen 127.0.0.1:4446 --control $p3 & # > $tmp/log3 2>&1 &
./drand  --folder $f4 start --folder $f4 --tls-disable --public-listen 127.0.0.1:4447 --control $p4 & # > $tmp/log4 2>&1 &
./drand  --folder $f5 start --folder $f5 --tls-disable --public-listen 127.0.0.1:4448 --control $p5 & # > $tmp/log5 2>&1 &

sleep 2

# echo "[+] creating group.toml file"
# group=$tmp/group.toml
# ./drand group $f1/key/drand_id.public $f2/key/drand_id.public \
#                 $f3/key/drand_id.public $f4/key/drand_id.public \
#                 $f5/key/drand_id.public --out $group

echo "[+] launching dkg ..."
./drand --folder $f5 share --tls-disable --control $p5 --leader --nodes $N --threshold $T --secret-file secret-file.log --period "1s" &
sleep 10
echo "Done sleeping"
./drand --folder $f1 share --tls-disable --control $p1 --connect $LeaderAddr --nodes $N --threshold $T --secret-file secret-file.log --period "1s" &
./drand --folder $f2 share --tls-disable --control $p2 --connect $LeaderAddr --nodes $N --threshold $T --secret-file secret-file.log --period "1s" &
./drand --folder $f3 share --tls-disable --control $p3 --connect $LeaderAddr --nodes $N --threshold $T --secret-file secret-file.log --period "1s" &
./drand --folder $f4 share --tls-disable --control $p4 --connect $LeaderAddr --nodes $N --threshold $T --secret-file secret-file.log --period "1s" &


echo "[+] done"

