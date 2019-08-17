---
layout: single
title: "[UPDATED] How the LineageOS OTA server works and how to implement and use
  ours"
date: '2014-02-01 18:51:23'
tags:
- modding
- rest
---

**EDIT:** I took the time to develop the first release of the REST API server, you can find it [on my Github](https://github.com/julianxhokaxhiu/LineageOTA) as always as an OpenSource project.

* * *

Hello everybody,

first of all Happy New Year since it's the first post of 2014 :) Next, you probably may be curious to know what I was doing all these days. Well, since I'm using a custom ROM on my own Galaxy S2 ([CM11 compiled by iNFECTED](http://forum.xda-developers.com/showthread.php?t=2535369)) I was asking myself "why cannot custom roms use the already built-in OTA by CM with our custom server?

Well, today I'm here to explain how to it, since I'm really astonished why a bigger community like [LineageOS](http://lineageos.org/) which loves Open Source does not document or release their public server interface that talks with their ROMs. But hey, we love to hack, right? Let's get back to business!

First of all [clone the Unit Test example](https://github.com/julianxhokaxhiu/LineageOTAUnitTest) on how to call [the ACTUAL server of LineageOS](http://download.cyanogenmod.org). You can run this script using [NodeJS](http://nodejs.org/). These are the simple steps you have to do to run it and debug it by yourself

```
cd /path/to/LineageOtaTest
npm install
node index.js
```

If all went well, you will see a  `console.log` of the server answer, which will be like this one (I'm using a piece of that from the i9300 channel):

```javascript
{
    "id": null,
    "result": [
        {
            "incremental": "7f96568932",
            "api_level": 19,
            "url": "http: //get.cm/get/jenkins/57124/cm-11-20140130-NIGHTLY-i9300.zip",
            "timestamp": "1391086037",
            "md5sum": "4e0a335b378035d12cb6626b6623072b",
            "changes": "http: //get.cm/get/jenkins/57124/CHANGES.txt",
            "channel": "nightly",
            "filename": "cm-11-20140130-NIGHTLY-i9300.zip"
        }
    ],
    "error": null
}
```

As we may see, the answer is pretty much a simple JSON object with some metadata inside. To replicate by yourself you just have to implement a simple REST API that works on POST requests.

For generic lists the ROM is using  `http://download.cyanogenmod.org/api` while for DELTA updates is using `http://download.cyanogenmod.org/api/v1/build/get_delta` .

If you would like to point to your own server you have two ways doing so:

*   Declare [`cm.updater.uri`](https://github.com/LineageOS/android_packages_apps_CMUpdater/blob/cm-14.1/src/com/cyanogenmod/updater/service/UpdateCheckService.java#L203) on your own `build.prop` file with the value of you own server URL where you have deployed it
*   Replace the string `conf_update_server_url_def` value inside `values.xml` of the [OTA source code](https://github.com/lineageos/android_packages_apps_CMUpdater/blob/cm-14.1/res/values/config.xml)

And that's it! Possible good points on using your own server would be to provide an OTA update also to all the custom builds based on CM without having to hassle users on going everyday into the topic and reading if it was released something. Also, you can use it to centralize updates on your own Corp if people are using massively LineageOS as their ROMs on their phones.

As always, thanks for reading and I hope to provide a simple REST server for this on my GitHub so stay tuned :)