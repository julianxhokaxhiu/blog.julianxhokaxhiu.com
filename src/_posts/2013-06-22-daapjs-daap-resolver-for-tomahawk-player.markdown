---
layout: single
title: DAAPjs - DAAP Resolver for Tomahawk Player
date: '2013-06-22 23:12:26'
tags:
- tomahawk
---

Hi guys,

it has passed a lot until the last time I wrote here huh? In fact as you may already think I was not drinking some Cocktail somewhere at the Caraibi Beach or something similar :P I was busy learning cool new things as always but today I wouldn't want to talk about this but about my latest project I was busy in particulary these last days which is called [DAAPjs](https://github.com/julianxhokaxhiu/tomahawk-daapjs "A DAAP resolver for Tomahawk made in Javascript").

What is it? Simple, it's a DAAP resolver for [Tomahawk Player](http://www.tomahawk-player.org/ "Tomahawk Player") 0.7.0 (don't you know it already? Go visit their website now!) which will let you listen to your music, in your LAN or your WAN wherever you want. Now you may ask, what is DAAP? Shortly, it's the same protocol which is currently using iTunes from Apple, but made open source and you may choose between: [mt-daapd](http://en.wikipedia.org/wiki/Firefly_Media_Server "mt-daapd aka Firefly Media Server") (aka Firefly Media Server), [forked-daapd](https://github.com/jasonmc/forked-daapd "forked-daapd") and [DAAP.js](https://github.com/hellomatty/daap.js "DAAP Server made up in NodeJS") (made in NodeJS).

But why this resolver? Primary because I need it personally. When I bought my NAS (where I installed Debian into it) it came with mt-daapd pre-installed, and into Debian, because of its limited resources I'm forced again to use it. After all it just works so it's not as bad as you may think. But after years it was deprecated and no player in the market is supporting it (Winamp was the last one, thanks to a guy who tryed to make one but it was bugged as hell) so I finally made up with a decision: it's time to make one more easier to developer, more userfriendly and using a player which could be the feature. So I found Tomahawk and I sad, this is the one!

I hope you'll enjoy this project as much as I, and if you found any bug feel free to comment down here :)

Thanks as always, see you soon with the next project!