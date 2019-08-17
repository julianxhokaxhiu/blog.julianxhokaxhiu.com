---
layout: single
title: Install Ajenti over WD MyBook World Edition II with Debian Squeeze
date: '2012-11-15 17:18:37'
aliases: [/install-ajenti-over-wd-mybook-world-edition-ii-with-debian/index.html]
---

Hi guys,

sorry if i'm not writing very much frequently here but I was busy hacking my own NAS. Yes, bored of how these corporations treat us (customers) with their update logic, i decided to overwrite my existing firmware with an open one that you will surely know: Debian Squeeze.

After i decided to change my firmware, using [this](http://mybookworld.wikidot.com/forum/t-304045/how-to:debian-on-mybook-white-light "Debian on MyBook White Light") method (thanks WikiDot community) i found myself asking "How the hell i'm going to configure it with a comfortable web admin panel?". In fact searching these days in Google i found Ajenti, which seems a very cool and promising Web Admin interface. So, i SSH-ed my NAS, added the repo to my **sources.list** and tried to install it as always by typing **apt-get install ajenti**.

But things didn't seems promising. It wasn't in fact installing at all as it was complaining about some [missing dependencies](https://bugs.launchpad.net/ajenti/+bug/876403 "Can't install Ajenti on Debian Squeeze"). Searching better on Google, i understood that a library was missing, **libevent**, which in fact is NOT compiled for armel arch (remember that our WD is powered by an ARM cpu). So after this, i went to [packages.debian.org](http://packages.debian.org "Debian Packages Repo") and searching for that lib, I found that in fact [IT WAS AVAILABLE](http://packages.debian.org/squeeze-backports/libevent-dev "libevent squeeze backport") but ONLY for Debian Squeeze BACKPORTS. So, after this, i'm going to share with you my definitive **sources.list** to install anything without pain on your WD.

```
# Debian
deb http://ftp.debian.org/debian/ squeeze main contrib non-free
# Debian Backports
deb http://ftp.at.debian.org/debian-backports/ squeeze-backports main contrib non-free
# Debian Security
deb http://security.debian.org/ squeeze/updates main contrib non-free
# Ajenti
deb http://repo.ajenti.org/debian main main
```

And there it is! After this you can freely do **apt-get update** and **apt-get install ajenti**.

I hope you'll find useful this post, share and comment as you feel it.
Thanks for reading, and see you with another (I hope) Tip'n'Trick next time :)