# MODEbot

Load images to a Terraonion MODE over the network.

Attribution: Russell Barnes - Magpi - https://magpi.raspberrypi.org/articles/pi-zero-w-smart-usb-flash-drive

## Materials needed

**Raspberry Pi Zero W**

The Modebot uses a Raspberry PI Zero W since it is small, low power, and does not need any sort of fans or cooling. They are also widley available and relativly inexpensive.

[!PI Zero](https://www.raspberrypi.org/products/raspberry-pi-zero-w/)

**SD Card**

If you have never used a PI before, you will need a MicroSD card to run the OS from and to store your games on. A larger card with the fastest transfer rate is suggested, however any card should work.

[!Card Types](https://kb.sandisk.com/app/answers/detail/a_id/2520/~/sd/sdhc/sdxc-specifications-and-compatibility)

Here are a couple of examples.

[!256GB](https://www.amazon.com/Samsung-Electronics-microSDXC-Adapter-MB-ME256HA/dp/B0887P21Z2/ref=sr_1_3?dchild=1&keywords=microSD&qid=1625587489&refinements=p_n_feature_two_browse-bin%3A13203835011&rnid=6518301011&s=pc&sr=1-3)

[!128GB](https://www.amazon.com/SanDisk-128GB-Extreme-microSD-Adapter/dp/B07FCMKK5X/ref=sr_1_4?dchild=1&keywords=microSD&qid=1625587590&sr=8-4)

**Flash Utility**

There are several SD card flashing utilities you can use. The two popular flash utilites are Etcher, and 

[!Etcher](https://etcher.download/download-etcher/)

[!PI Imager](https://www.raspberrypi.org/software/)

**USB Dongle Module**

The Terraonion MODE accepts a USB stick as one of the supported storage types. However, you can not use the USB storage with an SSD installed on the MODE.

To make the install more natural, and allow you to fit the MODEbot in the console case, a USB dongle adaper is suggested. The dongle also adds a finished touch to the project.

Here is a link to the iUniker USB Dongle adapter.

[!USB Dongle](https://www.amazon.com/iUniker-Expansion-Breakout-Raspberry-Inserted/dp/B07NKNBZYG)

**USB Cable**

In the absence of a USB adapter a USB cable can be used. However you will need to make sure that you plug the cable into the second MicroUSB port, since the first port is for *power only*. 

**MODE Installed**

The most obvious part is to have the MODE properly installed in your console, tested and functional. The MODE install is outside of the scope of this project, however the Terraonion team has put together a comprehnsive
set of instructions that make the install very straight forward.

[!MODE](https://terraonion.com/en/producto/terraonion-mode/)

## Setup

### OS

MODEbot has been built and tested on a Raspberry PI Zero W, running Raspberry PI os Buster(Raspbian10).

To install the OS use the Raspberry PI os loader, or a similar utility to write flash the OS to the MicroSD card.

### Install Git

```
# apt install git
```