---
layout: single
title: How to install SuperSu on Hamlet Zelig Pad 210/210G
date: '2013-12-07 14:53:14'
tags:
- modding
aliases: [/how-to-install-supersu-on-hamlet-zelig-pad-210g/index.html]
---

Hi there,

today I would like to share with you this simple package that will help you getting SuperSu (so, Apps that require root access) on your [Hamlet Zelig Pad 210/210G](http://english.hamletcom.com/products/xzpad210g.aspx) (probably this method would work also on other Hamlet tablets but I'm not sure, you have to try it yourself).

So, back to business, those are the simple steps you have to folllow.

## Prerequisites

1.  You need to have enabled Debug USB option under "Development Settings" into Settings.
2.  Install the proper drivers when asked (you can download them from {{< asset_link "/misc/hamlet-210g/ADB-drivers.zip" "here" >}}).
    <span class="text-muted">If you're having signature errors while installing, disable the signature check for your current windows setup (64-bit only).</span>
3.  A working ADB on your PC (Windows/Mac/Linux). To get it working just place this {{< asset_link "/misc/hamlet-210g/adb_usb.ini" "adb_usb.ini" >}} file into `~/.android` folder.

## Installing SuperSu

Just download {{< asset_link "/misc/hamlet-210g/supersu.zip" "this" >}} file, extract it to your internal memory (**NOT** SD!) and make sure that you're having the supersu folder into the root of your internal memory.

Then just run this simple lines:

```
adb shell
cd /sdcard/supersu
sh install.sh
```

**And you're done!** After this, if you open your App menu list and you see SuperSu app, you can be sure that the install was done correctly. Open it up and be sure that you're not getting any error.

From now on. you're free to update the SuperSu app from the Play Store and/or install another Su App Manager (like Superuser). I suggest you also to update your busybox using one of the many apps available into the Play Store.

Enjoy