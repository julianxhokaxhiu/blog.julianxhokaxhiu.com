---
layout: single
title: How to install Debian Wheezy over ZyXEL NSA320
date: '2013-10-05 23:18:00'
tags:
- modding
---

Hi guys,

sorry for the silence of all these days but I was busy with my real life, work stuff and something else. But hey, I didn't lost my passion to write about things I do and things that I think may be useful to you.

So, I'm here today to write a little guide on how to install Debian Wheezy 7.x on your [ZyXEL NSA320](http://www.zyxel.com/products_services/nsa320.shtml?t=p "ZyXEL NSA320") and boot it up from an external device from USB (I like it this way, so my 2 disks inside will only be my storage and can sleep when needed, so I'll span their life longer). So, where to start?

## 0) BACKUP, BACKUP, BACKUP!

Yeah, no matter what, it's better to make a backup of everything you've stored on your NAS. Just to be sure.

## 1) Wire up your ZyXEL with your PC

To make this you'll need a [USB TTL 3.3V Cable](http://www.adafruit.com/products/954 "USB to TTL Serial Cable - Debug / Console Cable for Raspberry Pi") so you can connect to the device once it boots. Just think about it as a BIOS. You have to access a low-level state of you device before the OS boots so, here it is. We're going to to tweak the U-Boot! Once you're done, open your RS-232 console (if you're on Windows I suggest you to use [PuTTY](https://puttytray.goeswhere.com/ "PuTTYTray") with the **Serial** option select). Choose the COM port assigned by your OS and click Open, normaly it will just not do anything, but once you'll boot your ZyXEL it will start to write down all the U-Boot messages. To stop the boot process, just press any key until it will stay idle to a simple prompt.
Here remember to type "**printenv**" to write down ALL your U-Boot configuration. **BACKUP it! You'll need it later.**

**REMEMBER:** turn off your NAS before you wire it up with your PC!
{: .notice--danger}

## 2) Update your U-Boot

Yeah, this is the first step. Why? Because the stock U-Boot that is flashed inside the ZyXEL do not support booting from USB so, someone on the net called davygray compiled a special u-boot for us so we can directly flash it. So let's start by [downloading it](http://forum.doozan.com/read.php?2,7806 "Zyxel NSA320 : basic support for Debian installation") (click on link 2), once finished uncompress it somewhere in your PC and then, follow up instructions on how to flash U-Boot. Be sure to have a T-FTP server installed as it will be required.

**WARNING:** this is a very delicate process. Be careful that if something goes wrong you cannot bootup your NAS.
{: .notice--warning}

## 3) Configure your U-Boot environment

Once you're logged in, you have to configure some field like ethernet MAC address and so on. Just be sure to write down YOUR MAC address which your ZyXEL unit came with. Otherwise it will not work (or maybe you'll spoof you MAC address which will NOT be unique anymore).

## 4) Prepare you external USB

This is less risky and easier to do. Just simply download the latest version of this [prepacked Debian installation](http://forum.doozan.com/read.php?2,12096 "Linux Kernel 3.11.1 Kirkwood package and rootfs (Non Flattened Device Tree)") (called **rootfs**) packed with the latest Stable Linux kernel (actually 3.11). Once you finished downloading it, follow the instructions on the topic to extract it. Be sure to format your device with EXT3 file system before extracting your rootfs inside of it. Make it bootable and remember to label it as "**USBROOT**". It's really important to do this, otherwise it will NOT boot.

## 5) Insert your USB Drive/Stick and Boot!

If all the things will go right you're done! Once your system will boot up, you're ready to login with SSH on your NAS with username root and password root.

**BE CAREFUL:** change it as soon as possible!
{: .notice--danger}

That's it. Pretty easy huh? In fact the only thing which will be difficult is to get that cable to wire up your PC with your NAS but, when you'll be done, and you'll configure the netconsole field in you're U-Boot you can easily administrate it with ncat!

## 6) Bonus! Here is an example of U-Boot configuration with netboot working

Here you can find an example working. Just a little explain of some fields:

**ethaddr**: the MAC address of your NAS (the same you got before starting all the process)
**ncip**: the IP of your network card that you'll use from your computer, where you'll use ncat.
**usb_custom_params**: the "**yy:yy:yy:yy:yy:yy**" is the MAC address of your network card that you'll use from your computer, where you'll use ncat.

Basically in this configuration it is intended to assign the IP 192.168.1.2 to your NAS, so 192.168.1.3 is the PC where you're going to use your ncat. Enjoy!

```
arcNumber=3956
baudrate=115200
boot_sata1=mw 0x800000 0 1; setenv bootargs console=ttyS0,115200 root=/dev/sda1 rootdelay=10 $mtdparts; ide reset; ext2load ide 0:1 0x800000 /boot/uImage; ext2load ide 0:1 0x01100000 /boot/uInitrd; bootm 0x00800000 0x01100000
boot_sata2=mw 0x800000 0 1; setenv bootargs console=ttyS0,115200 root=/dev/sdb1 rootdelay=10 $mtdparts; ide reset; ext2load ide 1:1 0x800000 /boot/uImage; ext2load ide 1:1 0x01100000 /boot/uInitrd; bootm 0x00800000 0x01100000
bootcmd=run bootcmd_usb; usb stop; run boot_sata1; run boot_sata2; run bootcmd_rescue; reset
bootcmd_usb=run usb_init; run usb_load_uimage; run set_bootargs_usb; run usb_boot;
bootdelay=10
console=ttyS0,115200
ethact=egiga0
ethaddr=xx:xx:xx:xx:xx:xx
gatewayip=192.168.1.1
if_netconsole=ping $serverip
ipaddr=192.168.1.2
mainlineLinux=yes
mtdids=nand0=orion_nand
mtdparts=mtdparts=orion_nand:1M(u-boot),512K(uboot_env),512K(key_store),512K(info),10M(etc),10M(kernel_1),48896K(rootfs1),10M(kernel_2),-(rootfs2)
ncip=192.168.1.3
netmask=255.255.255.0
partition=nand0,2
preboot=run if_netconsole start_netconsole
serverip=192.168.1.3
set_bootargs_usb=setenv bootargs console=$console root=$usb_root rootdelay=$usb_rootdelay rootfstype=$usb_rootfstype $mtdparts $usb_custom_params
start_netconsole=setenv ncip $serverip; setenv bootdelay 10; setenv stdin nc; setenv stdout nc; setenv stderr nc; version;
stderr=nc
stdin=nc
stdout=nc
usb_boot=if ext2load usb $usb_device 0x1100000 /boot/uInitrd; then bootm 0x800000 0x1100000;else bootm 0x800000;fi;
usb_custom_params=loglevel=7 netconsole=6666@192.168.1.2/eth0,6666@192.168.1.3/yy:yy:yy:yy:yy:yy
usb_device=0:1
usb_init=usb start; sleep 5; usb start; sleep 5
usb_load_uimage=mw 0x800000 0 1; ext2load usb $usb_device 0x800000 /boot/uImage
usb_root=LABEL=USBROOT
usb_rootdelay=10
usb_rootfstype=ext3
```

Thanks for reading as always and I hope you'll like this too. See you again with the next topic, on how to install Arch on your ZyXEL NSA320!