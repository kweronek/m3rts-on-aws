#!/usr/bin/env sh

#VNCPASSWD=
apt update
apt upgrade -y
apt install -y make
apt install -y build-essential
sudo snap install tree
sudo snap install htop
# to use kate/vnc instead of vi/ssh
sudo snap install kate

# Set timezone
timedatectl set-timezone Europe/Berlin

# Install KDE desktop via metapackage
apt install -y kubuntu-desktop

# Install RDP server (xrdp)
apt install -y xrdp

# Install VNC server software (tigervnc)
apt install -y tigervnc-standalone-server

# Set password by install
install --owner=ubuntu --group=ubuntu --mode=700 --directory /home/ubuntu/.vnc
if [ -n "${VNCPASSWD:-}" ];
then
	echo -n ${VNCPASSWD:-""} | vncpasswd -f > /home/ubuntu/.vnc/passwd
	chown ubuntu:ubuntu /home/ubuntu/.vnc/passwd
	chmod 600 /home/ubuntu/.vnc/passwd
else
	if [ -f ./vncpasswd]
	then
		install --owner=ubuntu --group=ubuntu --mode=600 ./vncpasswd /home/ubuntu/.vnc/passwd
	else
		echo "Could not set VNC password automatically"
		echo "Please enter one now"
		sudo -u ubuntu vncpasswd
	fi
fi

# Install systemd unit for vnc server daemon
install --owner=root --group=root --mode=644 ./vncserver.service /etc/systemd/system/vncserver.service

# Reload unit files
systemctl daemon-reload
# Start vnc server on future system startups
systemctl enable vncserver.service
# Start vnc server now
systemctl start vncserver.service

# install Libre-Office 7
sudo snap install libreoffice 

# Zoom-Client
cd ~/Downloads
wget https://zoom.us/client/latest/zoom_amd64.deb
sudo apt install -y ./zoom_amd64.deb
cd ~

# install Chrome
cd ~/Downloads
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
cd ~

# ensure that arrows work in vi
echo "set nocompatible" > $HOME/.vimrc
# add . to PATH
echo "export PATH=$PATH:." >> $HOME/.profile
source $HOME/.profile
