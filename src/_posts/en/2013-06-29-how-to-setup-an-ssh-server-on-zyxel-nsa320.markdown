---
layout: single
title: How to setup an SSH server on ZyXEL NSA320
date: '2013-06-29 16:45:03'
tags:
- modding
---

Hi there,

some days ago I bought a very kind NAS for myself after the (terrible) adventure with WD My Book World Edition II. Not that it was so bad but...after three years it was very old (Kernel 2.6.24) and not so much apps were supported nowadays. So, I thought to get a new one which is [community supported](http://archlinuxarm.org/platforms/armv5/zyxel-nsa320 "Arch Linux ARM for ZyXEL NSA320") (at last) but some kind hardware with a very low budget, and then I found this one: [ZyXEL NSA320](http://www.zyxel.com/products_services/nsa320.shtml?t=p "ZyXEL NSA320").

This is a VERY GOOD NAS, best choice out there (imho) and has a lot of things built-in and already configured for the low-end users. But, as you may know already, I'm not satisfied until I'm the root of anything I own so, I asked myself: how to get SSH on this box? (unfortunatelly it isn't already built-in).

After some search on Google [I found that there's something called FFP](http://zyxel.nas-central.org/wiki/FFP-stick "FFP-stick for ZyXEL NSA320"), a custom USB with a very-small OS made up already to boot a [Telnet](http://en.wikipedia.org/wiki/Telnet "Telnet Interface") interface, and after that an SSH one. So I used this guide to accomplish this but...I didn't work. I have to admit I'm on the latest firmware (until today, 4.60) so probably It wasn't tested already there but I didn't lose the hope to have the SSHd.

So, searching again in the deep, [I found this topic which talked about FFP that could be installed as a Package](http://forum.nas-central.org/viewtopic.php?f=249&t=6315#p27531 "FFP as a Package into ZyXEL NSA320") with the built-it package manager inside of NSA320\. So, to keep it simple, to get your SSH running within a minute you have to do this:

1.  With any PC (Windows/Mac/Linux) point to this directory (I'll write it down in Windows notation): `\\YOUR_NAS_IP\\admin\zy-pkgs`
2.  Create a file called `web_prefix`
3.  Write inside of that file `ftp://ftp.zyxel-tech.de/2.new_mirror/` and save it
4.  Login into the Web Admin interface (through a Web Browser), go into the Package Manager and choose `ffp`, click over it and after the big green plus called `Install/Update`
5.  Wait for it to install and enjoy!

Now you can login with `root` and your `admin` account password you're actually using. That's it.

I hope you'll find this useful. See you next time!