---
layout: single
title: Expand your Storage on CyanogenMod with Simple2Ext
date: '2012-12-07 22:52:19'
tags:
- modding
---

**UPDATE:** See [this one](http://blog.julianxhokaxhiu.com/2013/05/12/expand-your-storage-on-cyanogenmod-with-mounts2sd/ "Expand your Storage on CyanogenMod with Mounts2SD"), if you're using Android 4.2 (CM10.x) :)

Hi there,

today I would like to share with you this little Know-How i learnt working all day on this.

What I was trying to do was expanding internal storage (limited to 200MB), the same where you install your ROM/Custom ROM. So, what happen as the time goes by? Simple, it will be filled and soon no empty space will be available. So, what are we supposed to do? Buy another phone? No Sir :) Let's enlarge it just by using some simple steps!

## Partition all the things!

First, what we have to do is to partition our SD card, no matter what its size is. BUT we have to make sure that the order of partition are just like this:

1.  The partition where you're going to save your generic data (the same you'll use when you buy an SD and put it inside your phone, for example). MUST be FAT (<=2GB) or FAT32 (>=4GB)
2.  The partition where we're going to put all our apps and Android *heavy* parts like cache and Dalvik-cache. MUST be EXT3 or EXT4.

This way, we're going to have some space available just like it was ROM space. This is where are we going to put some magic :)

## Move all the things!

Yes sir! It's time to move all the things there but...how? Simple, just by installing and using [Simple2Ext](https://play.google.com/store/apps/details?id=ru.krikun.s2e "S2E (simple2ext)"), directly available from the Play Store (it's straightforward compatible with CyanogenMod 7, CyanogenMod 9 and CyanogenMod 10 too).
What we have to do here is just opening the app, ticking all the checkboxes we want (i checked them all as i would like to move all the things from the ROM, letting only the Kernel and some other small tools there) and reboot our phone.
That's it! Yes, no jokes :) We're done.

## That's all?

Yes.  that's all! You've nothing to do now. Just enjoy your "brand new phone". But remember TO NOT remove your SD Card while your phone is turned ON. Your phone may became unstable and your data may be corrupted. So, if you have to pull it out, remember to TURN IT OFF before doing it.

This method have been tested by myself on [Samsung Galaxy Mini](http://it.wikipedia.org/wiki/Samsung_Galaxy_Mini "Samsung Galaxy Mini"), but i think that may work on other Smartphones too.

That's it and as always, thanks for reading :)