---
layout: single
title: Back/Forward Mouse Button for Logitech LS1 on Ubuntu 12.04
date: '2012-09-22 18:10:51'
---

Have you ever wondered how to make it work? Well, follow these simple steps and you're done :)

1) Install xbindkeys and xautomation

```sh
sudo apt-get install xautomation xbindkeys [ENTER]
```

2) Create a the file .xbindkeysrc in your ~/ folder

```sh
gedit .xbindkeysrc [ENTER]
```

and paste this into it

```
#Back
"xte 'keydown Alt_L' 'key Left' 'keyup Alt_L'"
b:6

#Forward
"xte 'keydown Alt_L' 'key Right' 'keyup Alt_L'"
b:7
```

3) Reboot (or just run "xbindkeys" process from your terminal, DO NOT RUN IT AS SUDO)

```sh
xbindkeys [ENTER]
```

And that's all. Simple and straightforward :)

Enjoy