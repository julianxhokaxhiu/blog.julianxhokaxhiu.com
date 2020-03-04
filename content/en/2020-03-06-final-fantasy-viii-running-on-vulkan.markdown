---
layout: single
title: 'Final Fantasy VIII running on Vulkan, Steam compatibility and much more!'
date: '2020-03-06 10:00:00'
aliases: [/final-fantasy-viii-running-on-vulkan/index.html]
cover: /images/posts/FF8-New-Game.png
---

{{< asset_img "/images/posts/FF8-New-Game.png" "FFNx on Vulkan - New Game screen" >}}

> **TL-DR:** This is the story about a new driver for Final Fantasy VIII that will allow you to play the game through new rendering backends, like DirectX 11 and Vulkan. If you're eager to try it yourself, feel free to follow installation instructions on the [official repository](https://github.com/julianxhokaxhiu/FFNx).

Here we go again with another post, closer to one month later, with another great set of announcements. This time we will talk about [Final Fantasy VIII](https://en.wikipedia.org/wiki/Final_Fantasy_VIII) running on Vulkanm and some other achievements done through this month.

Although the tech stack didn't change, its internals did a lot. Aside of various improvements that happened graphically now we do also have **FULL** support for Final Fantasy VIII. This will finally allow you to play the game upscaled the way it deserves.

For the sake of demonstration I decided to take a few screenshots and videos showing you how the game will look like on its stages using the Vulkan renderer and DirectX 11. But the game is fully playable also on OpenGL and DirectX 12.

Although I personally suggest to keep using OpenGL as a safe default, and the rest as experimental there's nothing that blocks you in trying them all. Just be aware that as like in Final Fantasy VII, also here Vulkan and DirectX 12 are having low FPS. This is because of technical limitations coming straight out of the engine.

In the future I ( or someone else ) may be able to figure out how to unlock this situation, but until then we get what we can :)

## DirectX 9 is now deprecated

You may be wondering, why I forgot to mention the DirectX 9 backend. Well, unfortunately for us this one didn't pass the quality test and the number of issues were growing. As this renderer did not show up to be as mature as the others, I had to pull the trigger and decided to remove it from the available ones.

It may come back later if the backend will become more mature on [bgfx](https://github.com/bkaradzic/bgfx). Until then, this has to be considered deprecated.

## Final Fantasy VIII 2000 edition

As FFNx is based upon the great work that [Aali started](http://forums.qhimm.com/index.php?topic=8306.0), we did inherit also some engine logics that were required to allow FF8 render as well. Although it may not be perfect, it's great enough to allow you to play the full game.

{{< asset_img "/images/posts/FF8-In-Game.png" "FFNx on Vulkan - Field screen" >}}

Aside of minor glitches you may find ( for example at end of the battle swirl animation ) the driver handles very well Battle scenes too.

{{< asset_video "/images/posts/FF8-Battle.mp4" "FFNx on DirectX 11 - Battle mode" >}}

What about Party menus? Nailed that :)

> Please do note that the slowdown effect happens **only** on DirectX 12 and Vulkan! The Party menu will work fine at FULL FPS on OpenGL/DirectX 11.
>
> The following video is just a pure demonstration that Vulkan works inside of the game engine too.

{{< asset_video "/images/posts/FF8-Party-Menu.mp4" "FFNx on Vulkan - Party Menu" >}}

This is just a taste of what this driver will allow you to enjoy. So please feel free to download the [latest version](https://github.com/julianxhokaxhiu/FFNx/releases/latest) available and let me know how it goes!

## A new era for Final Fantasy VIII - Welcome modding!

Like Final Fantasy VII, it's time to make the 8th chapter a first class citizen too! Thanks to FFNx this will be more true than ever.

Below you can already see some examples of how HD Textures will allow you to upgrade in-game content. Expect therefore some new tools like [7h](http://forums.qhimm.com/index.php?topic=19533.0) to be available for Final Fantasy VIII as time goes by, which will allow full Hext patching, model replacement, texture replacement and much more!

{{< asset_img "/images/posts/FF8-New-Game-Modded.png" "FFNx on DirectX 11 - New Game screen with HD Textures" >}}

{{< asset_img "/images/posts/FF8-Load-Savegame-Modded.png" "FFNx on DirectX 11 - Load Savegame screen with HD Textures" >}}

{{< asset_img "/images/posts/FF8-Party-Menu-Modded.png" "FFNx on DirectX 11 - Party Menu with HD Textures" >}}

You may notice some minor glitches being present in the last screenshot. Do not be afraid: the community and myself are already at full work on fixing those last minor bugs :)

Remember to check for new releases from time to time.

## Full Steam edition compatibility

Aside of the previous achievements, another great one is **FULL Steam compatibility** out of the box on both [Final Fantasy VII](https://github.com/julianxhokaxhiu/FFNx#steam-official-release) and [Final Fantasy VIII](https://github.com/julianxhokaxhiu/FFNx#steam-official-release-1).

This support means that you can just swap one file and you will be able to enjoy another session of your favorite game ( including save game support, and keyboard/gamepad controls like you're used to ) without the need to take any further action ( like move files around and such ) in your game directory.

The only downside unfortunately, is that Game Archivements are not supported. This may, or may not come into FFNx as it will require massive reverse engineering in order to find how and when those archivements are triggered, based on which condition.

{{< asset_video "/images/posts/FF7-Steam.mp4" "FFNx on Vulkan - Final Fantasy VII Steam Edition" >}}

{{< asset_video "/images/posts/FF8-Steam.mp4" "FFNx on Vulkan - Final Fantasy VIII Steam Edition" >}}

If you're curious to try, feel free to check the [installation instructions](https://github.com/julianxhokaxhiu/FFNx#how-to-install).

## Multilanguage support!

Not being enough already of cool new announcements here you can find another one!

Before only English editions were supported, but now also various other languages for [Final Fantasy VII](https://github.com/julianxhokaxhiu/FFNx#final-fantasy-vii) and [Final Fantasy VIII](https://github.com/julianxhokaxhiu/FFNx#final-fantasy-viii) are now supported.

Feel free to try and let me know how it goes.

## Final Fantasy VII Battle swirls, like they should

In the [previous post](https://blog.julianxhokaxhiu.com/2020-02-19-final-fantasy-vii-running-on-vulkan/) I talked about Battle swirls and Framebuffer implementation, thinking that I managed to nail them.

Well, I was not 100% correct during that phase of the implementation. I actually forgot to set the right properties ( flags ) during texture binding. Once that was fixed, the Battle swirls started to swirl like they should. Uiiiiiiiiiii!

{{< asset_video "/images/posts/FF7-Battle-Swirl-Fixed.mp4" "FFNx on DirectX 11 - Final Fantasy VII Battle Swirl fixed" >}}

## User configuration reorganized

As the driver will now officially support two games, it's time for the user to know which option may impact both, and which one are available only for one specific chapter of the game.

In order to enable that scenario, the new version will come with a brand new polished configuration file. Feel free [to check it out](https://github.com/julianxhokaxhiu/FFNx/blob/master/misc/FFNx.cfg)!

## FFNx is Free and Open Source

[FFNx](https://github.com/julianxhokaxhiu/FFNx) is fully hosted on Github, you can see its source code and you can fork it if you want. Contributions are welcome.

If you want to use it, remember to check [installation instructions](https://github.com/julianxhokaxhiu/FFNx#final-fantasy-vii) on the official repository page.

In case you find an issue, feel free to let me know by creating [one here](https://github.com/julianxhokaxhiu/FFNx/issues).

I hope you will enjoy this, as much as I did while developing it.

## A Special thank you goes to...

Before closing this post, there is a list of people I'd like to thank for their support while I was working on this, which are:

- My family, without them this project would not even exist
- [Robert Russell](https://github.com/Sebanisu) for continously testing the driver and support on inner details on FF8
- [Marcin Gomulak](https://github.com/MaKiPL) for continously testing the driver and support on inner details on FF8
- [Kaldarasha](http://forums.qhimm.com/index.php?action=profile;u=14276) for the help in testing the driver, especially Steam compatibility
- [Qhimm community](http://forums.qhimm.com/index.php) for a fantastic and enthusiastic FF7 Modding Scene and the [official chat room](https://github.com/julianxhokaxhiu/FFNx#join-us-on-discord) creation!

If you want to get in touch with me, feel free to reach out on [any social channel you prefer](https://julianxhokaxhiu.com/).

Last but not least, if you want to support, feel free to sponsor me on Github at this link: https://github.com/sponsors/julianxhokaxhiu

Enjoy!
