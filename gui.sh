#!/usr/bin/env sh

#VNCPASSWD=


apt update
apt upgrade -y

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
