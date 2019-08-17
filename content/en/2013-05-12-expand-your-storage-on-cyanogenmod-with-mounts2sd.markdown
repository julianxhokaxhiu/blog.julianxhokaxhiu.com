---
layout: single
title: Expand your Storage on CyanogenMod with Mounts2SD
date: '2013-05-12 20:46:11'
tags:
- modding
aliases: [/expand-your-storage-on-cyanogenmod-with-mounts2sd/index.html]
---

Hello again,

based on my last article about [Simple2Ext](https://play.google.com/store/apps/details?id=ru.krikun.s2e "S2E (simple2ext)") I've decided to write another one about [Mounts2SD](https://play.google.com/store/apps/details?id=com.spazedog.mounts2sd&hl=en "Mounts2SD - All-in-one SD-Ext").

## Why

I discovered this one those days because of Android 4.2.x and its partition management, simply finding that Simple2Ext is not working anymore on it. So, I had to found another one good replacement of it.

## How

It's pretty simple and straightforward to install and use. You have to partition and format you SD card just like I've said in [my previous article](/2012-12-07-expand-your-storage-on-cyanogenmod-with-simple2ext/ "Expand your Storage on CyanogenMod with Simple2Ext"). Then you have to download and install Mounts2SD directly from the Play Store. With your MicroSD inserted in your device, open Mounts2SD and configure Busybox and Init.d scripts. After that just simply reboot, and after it finishes to power on (your device will vibrate 3 times) reboot again (just to be sure). **Don't worry:** your device on you first power on will boot a little longer, because it's moving all the Android framework on your EXT4 partition.

## Already done?

Yeah, nothing more to do. If you open up Mounts2SD and the status light is green you're done. If it's yellow, you have to see logs (probably you've not configure it and something else is broken). This app is made to work upon CyanogenMod 7.x, 9.x and 10.x (so Android 2.2 and up).

Enjoy :)