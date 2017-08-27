---
layout: single
title: Fix NTFS-3G boot message warning on OS X Lion/Mountain Lion
date: '2012-11-28 18:27:18'
tags:
- ntfs-3g
- osx
---

Hi,

today i'm sharing with you a little know-how i got by myself regarding an annoying error that maybe you faced yourself when you tryed to install [NTFS-3G over Mac OS X](http://macntfs-3g.blogspot.it/ "NTFS-3G for Mac OS X") Lion 10.7 or Mac OS X Mountain Lion 10.8\. An example of this annoying message is like this one.  

![](/uploads/ntfs-3g-osx.png)

If you're facing the same problem, you can fix it within a click of your mouse (or something like...) by just installing [this](https://github.com/downloads/bfleischer/fuse_wait/fuse_wait-1.1.pkg "fuse_wait Installer for OS X 10.7 and later versions of Mac OS X") package. Simple as is!

But, what's happing here, why are you having that error? In fact it's nothing dangerous, it's only a WARNING message like "Hey, i didn't get any sign of response from your NTFS HDD so i didn't mount it on my first 15 seconds of life. So, i'll try later".  
This is showing because of an INCOMPATIBILITY of NTFS-3G with newest OSX releases (which unfortunatelly aren't compiled for those versions), but maybe one day will be fixed :) Until then you can fix it by installing that package.

So, i hope you'll enjoy this as much as i did. Thanks for reading!