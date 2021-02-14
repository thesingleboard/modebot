#!/bin/bash -x

DISKSIZE='4096'

sudo cp mode.txt /etc/motd
sudo apt install -y python3-pip
sudo apt install -y exfat-fuse exfat-utils
sudo pip3 install watchdog


#add the dt overlay
sudo echo 'dtoverlay=dwc2' >> /boot/config.txt

#add the overlay to modules
sudo echo 'dwc2' >> /etc/modules

#Create a blank usb disk
sudo dd bs=1M if=/dev/zero of=/piusb.bin count=${DISKSIZE}
sudo mkdosfs /piusb.bin -F 32 -I

#create a mount point
sudo mkdir -p /mnt/usb_share

#automount the new disk
sudo echo '/piusb.bin /mnt/usb_share vfat users,umask=000 0 2' >> /etc/fstab

sudo mount -a

sudo sed -i 's/exit\ 0/modprobe\ g\_mass\_storage\ file\=\/piusb\.bin\ stall\=0\ ro\=1/g' /etc/rc.local
sudo echo 'exit 0' >> /etc/rc.local

#mount the disk
sudo mount -a

#set up samba so we can mount over the network
echo "samba-common samba-common/workgroup string  WORKGROUP" | sudo debconf-set-selections
echo "samba-common samba-common/dhcp boolean true" | sudo debconf-set-selections
echo "samba-common samba-common/do_debconf boolean true" | sudo debconf-set-selections
sudo apt install -y samba winbind

#copy the scaner to /usr/local/share
sudo cp modebotscan.py /usr/local/share/
sudo chmod +x /usr/local/share/modebotscan.py

#copy the systemd file
sudo cp modebot.service /etc/systemd/system/

#Reload the new daemon
sudo systemctl daemon-reload
sudo systemctl enable modebot.service
sudo systemctl start modebot.service