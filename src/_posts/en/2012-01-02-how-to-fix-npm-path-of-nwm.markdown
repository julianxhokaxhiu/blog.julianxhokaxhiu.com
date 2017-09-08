---
layout: single
title: "[UPDATED] How to fix npm PATH of NWM"
date: '2012-01-02 22:36:10'
tags:
- javascript
- mongodb
- nodejs
---

Hello everyone again,

just in a hurry, i'm here to tell how to fix npm PATH of NWM 0.1b, i knew that something was missing (didn't notice why that final b? that means BETA) and finally someone [reported](http://twitter.com/#!/Autarc/status/152702609780772865 "Autarc") it to me (thanks [Autarc](http://twitter.com/#!/Autarc)). I've found a faster bugfix for this:

1) Add "global=true" to your "npmrc" file (located at "nodejs\node_modules\npm" of your NWM installation folder)  
2) Add "%USERPROFILE%\AppData\Roaming\npm" to your PATH variabile

"global=true" is necessary because it make the installation of packages always global (with a fixed path) also if you do not use the "-g" parameter. That's why the PATH can be easily set fixed and always work.

That's it. Restart your machine and you're done. This will be fixed with the new NWM 0.2b release, with a little add-in inside (didn't you ever heard of [Mongoose](https://github.com/LearnBoost/mongoose)?).

Happy new year and see you with the next release of NWM! :)

UPDATE: as promised, enjoy the new release [0.2b](http://nwm.julianxhokaxhiu.com/ "NWM") of NWM! (Mongoose is not included in this release, will come in next one)