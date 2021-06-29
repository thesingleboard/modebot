#!/bin/bash -x

DISKSIZE='4096'

sudo cp mode.txt /etc/motd

#upgrade the PI
sudo apt -y update
sudo apt -y upgrade

#Install packages
sudo apt install -y python3-pip
sudo apt install -y exfat-fuse exfat-utils
sudo pip3 install watchdog

#Set the MODEbot name
hostnamectl set-hostname modebot

#add the dt overlay
sudo echo 'dtoverlay=dwc2' >> /boot/config.txt

#add the overlay to modules
sudo echo 'dwc2' >> /etc/modules

#Create a blank usb disk
sudo dd bs=1M if=/dev/zero of=/piusb.bin count=${DISKSIZE}
sudo mkfs.exfat -n LABEL /piusb.bin

#create a mount point
sudo mkdir -p /mnt/usb_share

#automount the new disk
sudo echo '/piusb.bin /mnt/usb_share exfat users,umask=000 0 2' >> /etc/fstab

sudo mount -a

sudo sed -i 's/exit\ 0/modprobe\ g\_mass\_storage\ file\=\/piusb\.bin\ stall\=0\ ro\=1/g' /etc/rc.local
sudo echo 'exit 0' >> /etc/rc.local

#set up samba so we can mount over the network
sudo echo "samba-common samba-common/workgroup string  WORKGROUP" | sudo debconf-set-selections
sudo echo "samba-common samba-common/dhcp boolean true" | sudo debconf-set-selections
sudo echo "samba-common samba-common/do_debconf boolean true" | sudo debconf-set-selections
sudo apt install -y samba winbind

#add usb samba share
cat << EOF >> /etc/samba/smb.conf
[usb]
browseable = yes
path = /mnt/usb_share
guest ok = yes
read only = no
create mask = 777
EOF

sudo systemctl restart smbd.service

#copy the scaner to /usr/local/share
sudo cp modebotscan.py /usr/local/share/
sudo chmod +x /usr/local/share/modebotscan.py

#copy the systemd file
sudo cp modebot.service /etc/systemd/system/

#Reload the new daemon
sudo systemctl daemon-reload
sudo systemctl enable modebot.service
sudo systemctl start modebot.service

#kill some unneccessary services

