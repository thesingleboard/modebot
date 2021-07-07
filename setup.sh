#!/bin/bash -x

DISKSIZE='4096'
PASS='password'

#admin password(pi user)
ADMINPASS='modebot1!*'

sudo cp mode.txt /etc/motd

#chnage pi user pass
sudo echo -e "${ADMINPASS}\n${ADMINPASS}\n" | sudo passwd modebot

#upgrade the PI
sudo apt -y update
sudo apt -y upgrade

#modebot user
sudo mkdir /home/modebot
sudo useradd -U -d /home/modebot -s /bin/bash modebot
sudo chown modebot:modebot /home/modebot
sudo echo -e "${PASS}\n${PASS}\n" | sudo passwd modebot

#add the groups
sudo usermod -aG pi modebot;usermod -aG adm modebot

#set the bashrc
sudo cp .bashrc /home/modebot
sudo chown modebot:modebot /home/modebot/.bashrc;sudo chmod 644 /home/modebot/.bashrc
sudo cp .profile /home/modebot
sudo chown modebot:modebot /home/modebot/.profile;sudo chmod 644 /home/modebot/.profile

#Install packages
sudo apt install -y python3-pip
sudo apt install -y exfat-fuse exfat-utils
sudo pip3 install watchdog

#Set the MODEbot name
hostnamectl set-hostname modebot

#add the dt overlay
#sudo echo 'dtoverlay=dwc2' >> /boot/config.txt
#sudo echo 'disable_splash=1' >> /boot/config.txt
#sudo echo 'boot_delay=0' >> /boot/config.txt
#sudo echo 'force_turbo=1' >> /boot/config.txt
#sudo echo 'dtoverlay=sdtweak,overclock_50=100' >> /boot/config.txt
cat << EOF >> /boot/config.txt
dtoverlay=dwc2
disable_splash=1
boot_delay=0
force_turbo=1
dtoverlay=sdtweak,overclock_50=100
EOF

#add the overlay to modules
sudo echo 'dwc2' >> /etc/modules

#fix the boot cmd
sudo sed -i 's/rootwait/quiet\ rootwait/g' /boot/cmdline.txt

#Create a blank usb disk
sudo dd bs=1M if=/dev/zero of=/piusb.bin count=${DISKSIZE}
sudo mkfs.exfat -n LABEL /piusb.bin

#create a mount point
sudo mkdir -p /mnt/usb_share

#automount the new disk
sudo echo '/piusb.bin /mnt/usb_share exfat users,umask=000 0 2' >> /etc/fstab

sudo mount -a

sudo sed -i 's/exit\ 0/modprobe\ g\_mass\_storage\ file\=\/piusb\.bin\ stall\=0\ ro\=0/g' /etc/rc.local
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
sudo systemctl disable avahi-daemon.service
sudo systemctl disable systemd-udev-trigger.service
sudo systemctl disable rpi-eeprom-update.service
sudo systemctl disable rsyslog.service
sudo systemctl disable systemd-journald.service
sudo systemctl disable systemd-fsck-root.service
sudo systemctl disable bluetooth.service
sudo systemctl disable hciuart.service
