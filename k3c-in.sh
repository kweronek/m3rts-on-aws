#
git clone https://github.com/rancher/k3c
cd k3c
make build
./bin/k3c daemon --group=$(id -g) &
cd ..


#docker pull rancher/k3s

# docker exec -it k3s K3C_ADDRESS=/run/k3s/containerd/containerd.sock bash
# docker exec -it K3C_ADDRESS=/run/k3s/containerd/containerd.sock k3s bash
#docker exec -it -e K3C_ADDRESS=/run/k3s/containerd/containerd.sock k3s --s

#./bin/k3c daemon --cni/bin=/bin --bootstrap-image=docker.io/rancher/k3c:dev


	
	
