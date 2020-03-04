---
layout: single
title: 'Final Fantasy VII running on Vulkan'
date: '2020-02-19 10:00:00'
aliases: [/final-fantasy-vii-running-on-vulkan/index.html]
cover: /images/posts/FF7-New-Game.png
---

{{< asset_img "/images/posts/FF7-New-Game.png" "FFNx on Vulkan - New Game screen" >}}

> **TL-DR:** This is the story about a new driver for Final Fantasy VII that will allow you to play the game through new rendering backends, like DirectX 11 and Vulkan. If you're eager to try it yourself, feel free to follow installation instructions on the [official repository](https://github.com/julianxhokaxhiu/FFNx).

When Final Fantasy VII Remake [was announced](https://www.gamespot.com/articles/final-fantasy-7-remake-announced-by-sony-at-e3-201/1100-6428174/) unlike most of the fans my first idea was to re-play again the game. The last time I finished the game was long time ago, and I don't honestly remember every bit of the story anymore.

My first attempt was to do it using some Playstation 1 emulators like [Retroarch](https://www.retroarch.com/), although aside the great evolution the emulator is doing, the game has its own limits and it does not look so great today.

So, googling about how to enhance in-game textures, I came across this interesting post: [Remako Mod Version 1.0 Released!](https://captrobau.blogspot.com/2019/05/remako-mod-version-10-released.html) an HD Graphics Mod which would allow me to play the PC version, with upscaled textures. Great!

Attempting to install it, I figured out it was not so immediate and I had to follow some tutorials online. But all my attempted failed, until I came across this very well done forum thread: [Tifa's Final Heaven - 7th Heaven Modding Tutorial](http://forums.qhimm.com/index.php?topic=15520.0). Thank you EQ2Alyza!

This tutorial became the beginning of my journey, which would lead me from just "trying to play the game in HD" to actually developing my own driver (and yet didn't manage to find some time to actually play it...).

  > **WARNING:** This is going to be a VERY long post, with a LOT of technical details so I hope to be as clear as possible.
  >
  > Make sure to have some time to read this + a cup of tea and some bisquits. You will definitely need them down the road :)

Ready? Let's go!

## Introduction

It is no secret that Final Fantasy VII was one of the most known chapter of the whole series. A lot of people did buy and play the game not only on Playstation 1, but also on PC. Although time goes by, and the game unfortunately didn't survive the technology evolution.

Although on Playstation 1 you can use emulators nowadays, which are powered by various rendering engines like OpenGL, DirectX and most recently Vulkan, on PC unfortunately there is no "upgrade" option unless the OS provides some kind of retrocompatibility layer.

What happened in time, in order to allow the game run "just fine" on modern Windows releases, Square Enix did repack the game using an internal upgrade of the rendering engine ( from DirectX 5 to DirectX 9 ), added some support for new video codecs and better audio in-game music ( from MIDI to Ogg ). This version is what is known as Steam release in the community.

One question though stick in my mind: how did Square-Enix manage to actually provide an upgrade [without having the official game source code](https://gamefaqs.gamespot.com/boards/197343-final-fantasy-viii/76999367)<sup>1</sup>?

## ff7_opengl by Aali

Before doing a full analysis of the FF7 Steam Release, you may want to know that actually Final Fantasy VII [was already modded](http://forums.qhimm.com/index.php?topic=8306.0) by one person which we know only via its nickname Aali, **since 2009**. Remember this year as we're going to do some reference later.

This driver made use of an undocumented feature which was discovered inside the `ff7.exe` binary file, once reversed engineer, that allows you to use a special video mode which will allow the game to load a custom driver to renderer on the screen. The path to this driver ( a DLL file ) is given via the Windows Registry, which is then loaded by the game, calling the one and only required exported function: `new_dll_graphics_driver` ( option number 3 ).

{{< asset_img "/images/posts/FF7-Driver-Options.png" "Final Fantasy VII 1.02 - Driver Options parsing" >}}

> Internally the game has three possible options:
>
> 0. Software Rendering
> 1. DirectX ( the only one used on Windows )
> 2. OpenGL ( yes, the game has an OpenGL implementation, which actually works only on Intel today. [Feel free to try it](https://gist.github.com/julianxhokaxhiu/b093daa81871a535efc62563e8abdf16))
> 3. External driver ( load an external DLL with an entry point called `new_dll_graphics_driver` )

After that point though, which parameters were given and how they did look like was unknown, and all you get today was reverse engineered and understood through trial and error, until it was figured out what did the flag do and how it worked. Yet, with some good knowledge and A LOT of time, Aali managed to get most of the driver logic and implemented what the community got to know as `ff7_opengl` driver.

The only existing driver which allowed the game to be rendered even in 4K, using OpenGL: a Graphical API that works ~~just fine~~ even today. Was there any limit in this driver though? Unfortunately yes, it uses OpenGL 2.1 profile, which on new drivers runs through [a compatibility profile](https://www.khronos.org/opengl/wiki/OpenGL_Context#OpenGL_3.1_and_ARB_compatibility) ( no GPU driver as of today supports this layer natively ).

Albeit the fact that OpenGL is a good rendering engine, it is known to be not the best choice on Windows. Performance doesn't always match DirectX, and on [AMD it causes a lot of issues](https://www.reddit.com/r/Amd/comments/ce5uj2/call_to_amd_to_please_fix_their_opengl_windows/). Intel as well is trying to keep up the rendering with its competitors but is not a secret that it has still a lot of room to improve. This means that of all the competitors the only one which is left with good performance is Nvidia.

Another interesting fact, is that unfortunately the driver author did stop developing it, with no further explaination, and as a last gift to the community it decided to release the [driver source code](https://github.com/Aali132/ff7_opengl), but no instructions on how to compile it. No documentation, no build system, no batch file, no Visual Studio solution. If you were interested in continuing it, you would have to figure it out yourself, or enjoy its last release [0.8.1b](http://forums.qhimm.com/index.php?topic=14922.0).

## FF7 Steam release

Meanwhile `ff7_opengl` was getting more and more mature, out of nowhere Square Enix announced a new digital edition of FF7 which had been released on [August 14, 2012](https://web.archive.org/web/20170602072630/http://na.square-enix.com/en/blog/final-fantasy-vii-pc-out-now), which introduces archivements, new "upgraded" movies, new "upgraded" music ( from MIDI to Ogg ), Boosters and...guess what? A new rendering system: DirectX 9. This port is known to be done by [Dotemu SAS](https://en.wikipedia.org/wiki/Dotemu).

Knowing how the very first release of the game works, I was curious to investigate how Dotemu implemented its own driver. What I did discover along the road left me really surprised.

So let's start by actually checking which DLL files does the game imports.

```cmd
# C:\Program Files (x86)\Steam\steamapps\common\FINAL FANTASY VII>dumpbin /imports ff7_en.exe
Microsoft (R) COFF/PE Dumper Version 14.24.28316.0
Copyright (C) Microsoft Corporation.  All rights reserved.

Dump of file ff7_en.exe

File Type: EXECUTABLE IMAGE

  Section contains the following imports:
    [...]

    AF3DN.P
      F6E0E8 Import Address Table
      F6E0E8 Import Name Table
            0 time date stamp
            0 Index of first forwarder reference

          0 dotemuRegCloseKey
          0 dotemuRegDeleteValueA
          0 dotemuRegOpenKeyExA
          0 dotemuRegQueryValueExA
          0 dotemuRegSetValueExA
          0 new_dll_graphics_driver
  Summary

       66000 .bind
      797000 .data
        1000 .dotemu
        4000 .rdata
       1D000 .rsrc
      3B5000 .text
```

I did cut most of the output but I kept the only entry we are interested in. We can clearly see that the game imports from `AF3DN.P` the `new_dll_graphics_driver` exported function. The entrypoint for the driver to be started. Bingo!

But is this actually a DLL file? Let's double check.

```cmd
# C:\Program Files (x86)\Steam\steamapps\common\FINAL FANTASY VII>dumpbin /headers AF3DN.P
Microsoft (R) COFF/PE Dumper Version 14.24.28316.0
Copyright (C) Microsoft Corporation.  All rights reserved.

Dump of file AF3DN.P

PE signature found

File Type: DLL

FILE HEADER VALUES
             14C machine (x86)
               5 number of sections
        51D4549D time date stamp Wed Jul  3 18:43:09 2013
               0 file pointer to symbol table
               0 number of symbols
              E0 size of optional header
            2102 characteristics
                   Executable
                   32 bit word machine
                   DLL

OPTIONAL HEADER VALUES
             10B magic # (PE32)
            9.00 linker version
           21200 size of code
            C600 size of initialized data
               0 size of uninitialized data
           1F675 entry point (1001F675)
            1000 base of code
           23000 base of data
        10000000 image base (10000000 to 10036FFF)
            1000 section alignment
             200 file alignment
            5.00 operating system version
            0.00 image version
            5.00 subsystem version
               0 Win32 version
           37000 size of image
             400 size of headers
           345DC checksum
               2 subsystem (Windows GUI)
             140 DLL characteristics
                   Dynamic base
                   NX compatible
          100000 size of stack reserve
            1000 size of stack commit
          100000 size of heap reserve
            1000 size of heap commit
               0 loader flags
              10 number of directories
           28900 [     198] RVA [size] of Export Directory
           26F94 [     154] RVA [size] of Import Directory
           31000 [     2B0] RVA [size] of Resource Directory
               0 [       0] RVA [size] of Exception Directory
           2DC00 [    20A8] RVA [size] of Certificates Directory
           32000 [    3470] RVA [size] of Base Relocation Directory
           233C0 [      1C] RVA [size] of Debug Directory
               0 [       0] RVA [size] of Architecture Directory
               0 [       0] RVA [size] of Global Pointer Directory
               0 [       0] RVA [size] of Thread Storage Directory
           242E0 [      40] RVA [size] of Load Configuration Directory
               0 [       0] RVA [size] of Bound Import Directory
           23000 [     354] RVA [size] of Import Address Table Directory
               0 [       0] RVA [size] of Delay Import Directory
               0 [       0] RVA [size] of COM Descriptor Directory
               0 [       0] RVA [size] of Reserved Directory

  [...]

  SECTION HEADER #2
  .rdata name
    5A98 virtual size
   23000 virtual address (10023000 to 10028A97)
    5C00 size of raw data
   21600 file pointer to raw data (00021600 to 000271FF)
       0 file pointer to relocation table
       0 file pointer to line numbers
       0 number of relocations
       0 number of line numbers
40000040 flags
         Initialized Data
         Read Only

  Debug Directories

        Time Type        Size      RVA  Pointer
    -------- ------- -------- -------- --------
    51D4549D cv            5E 00024328    22928    Format: RSDS, {78FEF29B-7AE1-4693-9EF7-2383992D14E4}, 1, D:\Desktop\FF7\FF7_Project_svn\Driver\ff7_d3d\Steam Release\AF3DN.pdb
```

So yes, it is a DLL file, but it's not the only detail we can grasp. It seems the driver contains a reference to a PDB file ( debug symbols created by MSVC when building using the Debug profile ) named `AF3DN.pdb`. Looking at the path where it is living we can clearly see `D:\Desktop\FF7\FF7_Project_svn\Driver\ff7_d3d\Steam Release\` which allows also to guess that this may be either just another driver, or THE driver.

> The path also makes me think that they do have actually some source code of the game. I would be happy to know more if you do :)

Either way, let's check what is being used by this driver to actually do what is supposed to do ( render on screen, allow new movies to be renderer and play the new Ogg music files ). In order to check this, I'll use [Cutter](https://cutter.re/).

{{< asset_img "/images/posts/FF7-Cutter-Steam-Driver-Release.png" "Final Fantasy VII Steam Driver - Decompile through Cutter" >}}

Looking on the left column we can see some of the imports they used to actually do some stuff in-game:

- We can clearly see `d3dx9` imported symbols. This confirms they do use DirectX 9 APIs to render.
- They are using `libvgmstream` to reproduce music.
- They are using `avcodec` and `avformat` to reprdouce movies. These are two layers provided by the [FFMpeg](https://www.ffmpeg.org/) project.

Two dependencies on three analyzed, brought though some similarities with Aali released driver `ff7_opengl`. Remember when I said it started in 2009? The Steam release was brought up on 2012. Three years later.

This may be totally a coincidence, but this made me even more curious to double check if there was something unique inside of it, which would either confirm or deny a theory. Aali in his driver introduced a functionality to load external textures, replacing visually the default game ones, allowing you to upgrade texture to something much more appealing.

{{< asset_img "/images/posts/FF7-Chocobo-Farm-Modded.png" "FFNx on OpenGL - Chocobo Farm with HD Textures" >}}

In order to provide this capability, Aali driver did search for specific texture names under one path known as `direct`. If this folder was present next to your `ff7.exe` game file, and it had the texture inside of it, it would have been shown. Otherwise the internal texture would have been shown. So, let's search for this specific string inside of Cutter.

{{< asset_img "/images/posts/FF7-Cutter-Steam-Driver-Release-Strings.png" "Final Fantasy VII Steam Driver - Existing strings within the driver" >}}

So, what did the search return? Two interesting entries:

- `%s/direct/%s/%s%s`
- `%s/direct/%s/%s/%s%s`

Where did I saw these entries before? Ah yes, [right here](https://github.com/Aali132/ff7_opengl/blob/master/ff7/file.c#L211) and [there](https://github.com/Aali132/ff7_opengl/blob/master/ff7/file.c#L216).

Up to this point, I can actually confirm my theory of what happened around this Steam driver: either Aali got hired by Dotemu ( and this explains why the driver stopped in being developed, and is so similar ) or they did use Aali source code to sell you just another repack, using DirectX 9 APIs instead of OpenGL. Smart move :)

Either way, this gave me a good input: if they did manage to re-use that code, or create a new one, it also means I should be able to do it too.

This is how my next seven months would have been used from improving Aali source code, to actually come up with a totally new named FFNx. A next generation driver which allows you to use DirectX 9/11/12, OpenGL and Vulkan!

## FF7_OpenGL Reloaded

To my surprise someone else already did start [a fork of Aali source code](https://github.com/FFT-Hackers/FF7_OpenGL), and attempted to build it via CMake. Those people are [Blake Wilkey](https://github.com/quantumpencil) and [Maxime Bacoux](https://github.com/Nax). Two great guys which I had the honor to work with, and which together are cooking something which will definitely revolutionize Final Fantasy VII modding scene. But until then, you will have to wait. Sorry :)

Until that very moment I used CMake just to build some Arch Linux AUR packages, although developing on top of it was a new adventure. But I like new challanges so I started to read the [official documentation](https://cmake.org/cmake/help/latest/guide/tutorial/index.html) and in little to no time I was already able to hack it and get my very [first](https://github.com/FFT-Hackers/FF7_OpenGL/commit/3d448a9b30cc9dba31dc1f82a54bbac5aa6ecdd0) [build](https://github.com/FFT-Hackers/FF7_OpenGL/commit/12e0ce8f41d0935209d46992cef836b4061ec8da) [results](https://github.com/FFT-Hackers/FF7_OpenGL/commit/166db9e8e71f8b1fd7153fc89c1a7e0aca1bc81b).

As a Solution Architect, and DevOps Engineer, I usually like to have a Continous Integration environment to know how the project quality moves on, commit by commit. My first idea was to use Travis CI, although after some quick tests it came up that Windows build environments were in beta and not really up to the cause. So the choice went to [AppVeyor](https://www.appveyor.com/).

> AppVeyor provides Windows build images, which provides not only the common utilities you may need ( like Bash commands, unzipping tools like 7-Zip and so on ), it provides Visual Studio build environments starting from 2010 until 2019! It's also free to use for Open Source projects. Thank you!

This was great news, as the new FF7_OpenGL fork would exactly make use of MSVC from 2019. And so the [adventure begun](https://github.com/FFT-Hackers/FF7_OpenGL/commit/424f3ad72d303071e893c3d330ab6d6bed803683).

The CMake goals were now able to build the main driver code just fine, but what about the plugins? Aali used to zip its release as its main driver `ff7_opengl.fgd` and a `plugins` directory, which contained the VGMStream plugin to load OGG music files, and the FFMpeg plugin to load movies on new systems. Knowing that, in order to mimic the official Aali release, a new [CMake goal](https://github.com/FFT-Hackers/FF7_OpenGL/commit/ebf5ade4ab80332722cee0fa8553c8a7951d386f) was added to build also those layers.

Another thing that was missing in mimicking the release, was that files were build statically. No external DLLs were provided. In order to do the same thing under MSVC, shipped with Visual Studio 2019, we had to build the code [using Microsoft`s Universal CRT](https://github.com/FFT-Hackers/FF7_OpenGL/commit/132a052c70ed1eb06f85cf01d96d10eae07d0cab).

With this set, we were now able to have at least Aali source code shipped as people were used to. Was this time to settle? No way. The driver had to be improved as various bugs were left. Down the road, the more I was improving it based on awesome people which helped me test it ( thank you [LordUrQuan ](https://forums.qhimm.com/index.php?action=profile;u=28301) and [unab0mb](https://github.com/unab0mb)! ), commit after commit, the more I was gaining knowledge inside of the code.

And the more I was gaining knowledge inside of it, the more in my head one crazy idea was borning. Can we make Final Fantasy VII run on Vulkan?

{{< asset_img "/images/posts/FF15-You-Want-Truth.jpg" >}}

## FFNx

FFNx is the next step evolution of what you were used to know as `ff7_opengl`, which inherits all the good of it ( texture modding, audio using VGMStream and video playback using FFMpeg ), and on top it provides new rendering backends, including Vulkan!

I started by googling around which were the best libraries to use to accomplish this goal. My very first touchpoint happened to be [awesome-vulkan](https://github.com/vinjn/awesome-vulkan), a great repository which provides a LOT of resources around Vulkan. A great start.

Within that list, I discovered that not only Vulkan wrappers were available, but also some multi-API rendering engines were existing, which would allow me to write the code once, and run it on multiple Graphics APIs. Sweet!

Upon looking at the documentation and some examples of those frameworks, I actually figured out one thing: although they were made with C++, I missed a deep knowledge about Computer Graphics. There was no option, than actually learning at least one of them. I decided to go for OpenGL, as I had already worked on `ff7_opengl`, which I could also use as a basis for hacking. A perfect candidate.

So first thing first, I started to read [a getting started with OpenGL](https://learnopengl.com/Getting-started/OpenGL), what [a Vertex shader was](https://learnopengl.com/Getting-started/Shaders), and why did we even need a Fragment shader. Even how to simply draw a triangle passing [Vertex data](https://learnopengl.com/Getting-started/Hello-Triangle), with and without Indices.

> By the way, if you are questioning what is a Shader, it is literally a binary running in your GPU. It is written in C code and compiled by the Graphics API. A shader can pilot your GPU to do some calculations and either return the data to the CPU or "print" something visually based on criterias. This is the basis how OpenCL started.

So, once I figured out that, I discovered it was not enough, yet. I had to learn which data types were supported in shaders (fyi, everything is a vector of 4 numbers usually in the XYZW format), [how the rendering space works](https://learnopengl.com/Getting-started/Coordinate-Systems), what an Ortho matrix was and what a View matrix was.

Even that although was not enough. I had to learn even what does it mean [to blend two textures](https://learnopengl.com/Advanced-OpenGL/Blending), to discard some pixels based on some criteria called [Depth Testing](https://learnopengl.com/Advanced-OpenGL/Depth-testing) and finally the way to optimize some rendering by drawing only what the final user will see, through [Face Culling](https://learnopengl.com/Advanced-OpenGL/Face-culling).

Wow, a lot of knowledge for just "a simple" game like Final Fantasy VII. But it was worth it: after some big code cleanup, code porting from C to C++, and written some shaders from scratch, I was finally able to make use of bgfx to render the game as it was used to run. Great!

Was this enough to complete the task? Not really. I forgot about one of the most used features in game development, especially used by Final Fantasy VII. Before a battle starts a battle swirl effect happens, which is using the "last frame" you see, it spins while it's zooming it, and then the battle starts.

So, how to implement this technically? When working with Graphical APIs this happens to be done by rendering "off screen" all your draw operations, and finally showing the last frame to the user. These operation is also known as [Framebuffer rendering](https://learnopengl.com/Advanced-OpenGL/Framebuffers).

Once that part was also understood, some more code was adapted to make use of it and the game was finally able to show the Swirl. Magic :)

{{< asset_video "/images/posts/FF7-Battle-Swirl.mp4" "FFNx on OpenGL - Battle Swirl" >}}

Once this whole bag of knowledge was figured out, the driver finally look more solid and the game started to render beautifully.

## Render backend evaluation

Before reaching the point in actually being able to draw, by using **bgfx** I carefully evaluated also some other options, which I'll leave here for the sake of shared knowledge. In case you cross this project, be aware of why you'll find bgfx down the road and not something else.

### Diligent Engine

[Diligent Engine](https://github.com/DiligentGraphics/DiligentEngine) is very good Low-Level framework which provides one API across the various Graphics APIs like DirectX 11/12, OpenGL and Vulkan. Its main focus is allowing the developer to stay as close as possible to the Hardware allowing you to manage each behavior.

To speed up implementation on FFNx I even developed [a CI job](https://github.com/julianxhokaxhiu/DiligentEngineCI) to build the latest available code. Feel free to check it out!

Unfortunately for me it didn't work out when I did my first tentative because I didn't had all the Computer Graphics knowledge I do have know. But I will definitely try it again as soon as I will find some time.

I'd like to give a special thank you to the [DiligentEngine team](https://gitter.im/DiligentGraphics) for the support given!

### bsf

[bsf](https://github.com/GameFoundry/bsf) is a full framework which allows you to develop a game. It provides one API to render on top of DirectX, OpenGL and Vulkan, but also an Audio Rendering API, Input management API and so on. Although it offers many pillars, you could also use them separately.

Unfortunately for me it didn't work out either for one main reason: it didn't compile at all under x86 [due to one issue](https://github.com/GameFoundry/bsf/issues/245) which is still unresolved today.

### LLGL

[LLGL](https://github.com/LukasBanana/LLGL) is another very good Low-level early prototype library which allows you to abstract from the common known Graphics APIs like DirectX 11/12, Vulkan and OpenGL, on top of one single API. This looked very promising since its very first releases in December 2019.

Unfortunately also this didn't work out as expected for two reasons:
- the library was missing some OpenGL functionalities required to render YUV movies, [which has now been fixed](https://github.com/LukasBanana/LLGL/commit/89c7400b8f941fd474ca7ce94bc3ae49f9f821e0)
- the library is frozen, which means the author will [not work anymore on it](https://github.com/LukasBanana/LLGL/commit/1bda034b08ccdda284ed9e0d2df425d4118583b7)

Too bad, as I also had developed [a CI job](https://github.com/julianxhokaxhiu/LLGLCI) for this one, to speed up development! Feel free to check it out.

Finally I'd like to give a special thank you to [Lukas Hermanns](https://gitter.im/LukasBanana) for having me helped while I was writing a tenative implementation using LLGL!

### bgfx

[bgfx](https://github.com/bkaradzic/bgfx) is a high level rendering engine which works on top of DirectX 9/11/12, Vulkan and OpenGL. It's not very easy to use at first, although the author is fully supportive, it has [a lot of examples](https://bkaradzic.github.io/bgfx/examples.html), [good reference documentation](https://bkaradzic.github.io/bgfx/bgfx.html) and [there is a good community](https://gitter.im/bkaradzic/bgfx) around it to ask for help.

At this very stage, bgfx helped a lot: as it was abstracting away from me some complex single Grapghics API edge cases, I could focus on just rendering the game. And in order to speed up development, I also developed [a CI job](https://github.com/julianxhokaxhiu/bgfxCI) for this one too! Feel free to check it out.

Also here a special thank you to [pezcode](https://gitter.im/pezcode) and to [Бранимир Караџић](https://github.com/bkaradzic) for having me helped understand some inner internals of bgfx I wasn't aware of. Really appreciated :)

## The final choice

bgfx is the actual rendering backend which empowers FFNx, in allowing you to play Final Fantasy VII on top of Vulkan!

{{< asset_video "/images/posts/FF7-Party-Menu.mp4" "FFNx on Vulkan - Party Menu" >}}

{{< asset_img "/images/posts/FF7-Ropeway-Station.png" "FFNx on Vulkan - Ropeway Station" >}}

**Hold your horses!** Although the game actually works, FPS are not stable. This means there is still room for improvements. I will definitely do my best on improving this, but if you want to help, feel free to do so!

Until then you can have a full play-through either using OpenGL or DirectX 11, which are working fine as expected on a stable framerate.

{{< asset_video "/images/posts/FF7-Battle.mp4" "FFNx on DirectX 11 - Battle mode" >}}

If you also want to explore some other rendeting backends, you can also try DirectX 9 ( which brings some artifacts during rendering, I still have to understand why ) and DirectX 12 ( like Vulkan, it shares the same architecture ).

{{< asset_img "/images/posts/FF7-DirectX9.png" "FFNx on DirectX 9 - Worldmap" >}}

{{< asset_img "/images/posts/FF7-DirectX12.png" "FFNx on DirectX 12 - Worldmap" >}}

Finally, FFNx also inherits all the goods you were used to have with Aali ff7_opengl driver. Which means it works out-of-the-box with 7h **today!**. Feel free to it.

## FFNx is Free and Open Source

[FFNx](https://github.com/julianxhokaxhiu/FFNx) is fully hosted on Github, you can see its source code and you can fork it if you want. Contributions are welcome.

If you want to use it, remember to check [installation instructions](https://github.com/julianxhokaxhiu/FFNx#final-fantasy-vii) on the official repository page.

In case you find an issue, feel free to let me know by creating [one here](https://github.com/julianxhokaxhiu/FFNx/issues).

I hope you will enjoy this, as much as I did while developing it.

## A Special thank you goes to...

Before closing this post, there is a list of people I'd like to thank for their support while I was working on this, which are:

- My family, without them this project would not even exist
- [Blake Wilkey](https://github.com/quantumpencil) and [Maxime Bacoux](https://github.com/Nax) in helping me Reverse Engineer `ff7.exe` and get a better picture on how to hook on program functions in memory
- [DLPB](http://forums.qhimm.com/index.php?action=profile;u=6439) for some code exchange between ff7_opengl/FFnx and The Reunion
- [LordUrQuan ](https://forums.qhimm.com/index.php?action=profile;u=28301) and [unab0mb](https://github.com/unab0mb) for continously testing the driver
- [Robert Russell](https://github.com/Sebanisu) for continously testing the driver and support on FF8 topics
- [Marcin Gomulak](https://github.com/MaKiPL) for FF8 topics support
- [Kaldarasha](http://forums.qhimm.com/index.php?action=profile;u=14276) for the help in testing the driver
- [Qhimm community](http://forums.qhimm.com/index.php) for a fantastic and enthusiastic FF7 Modding Scene and the [official chat room](https://github.com/julianxhokaxhiu/FFNx#join-us-on-discord) creation!

This brings us at the very end of this blog post. A huge adventure which lasted seven months for me, and half an hour to you :)

If you want to get in touch with me, feel free to reach out on [any social channel you prefer](https://julianxhokaxhiu.com/).

Last but not least, if you want to support, feel free to sponsor me on Github at this link: https://github.com/sponsors/julianxhokaxhiu

See you around!

---

<sup>1</sup> <small>Not many people may know about this funny fact: all the Final Fantasy VII releases being done in various platforms like PS4, Switch and even Android, do actually repack the original Final Fantasy VII 1.02 exe + some emulation library that runs on the native platform ( pretty sure they are using [Wine](https://www.winehq.org/) ) + a driver library, like FFNx. If you don't believe me, feel free to unpack the games on those various platforms yourself. You'll be as much surprised as I was :)</small>
