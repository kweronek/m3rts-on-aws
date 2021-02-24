# 
apt update

## install make
apt install -y make
make -v

## install
apt install -y build-essential
gcc -v

snap install go --classic
go version

## install go 1.13
#wget https://dl.google.com/go/go1.13.linux-amd64.tar.gz
#sha256sum go1.13.linux-amd64.tar.gz
#tar -C /usr/local -xzf go1.13.linux-amd64.tar.gz
#export PATH=$PATH:/usr/local/go/bin
#mkdir go
#mkdir go/{src,bin,pkg}
#export $GOPATH=$HOME/go

apt-get update -y
apt-get install -y libseccomp-dev
apt-get install -y pkg-config
