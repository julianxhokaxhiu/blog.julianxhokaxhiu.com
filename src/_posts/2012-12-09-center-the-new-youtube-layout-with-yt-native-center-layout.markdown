---
layout: single
title: Center the new Youtube layout with YT Native Center Layout
date: '2012-12-09 23:17:43'
tags:
- extensions
---

Hi guys,

today i would like to share with you this little extension for Google Chrome, that is called YT Native Center Layout.

## What is it?

This extension will simply center the Youtube layout, as I personally didn't liked it Left-Aligned, it look old-style and little professional IMHO ;) So, after looking at the Youtube DOM, i found a little trick to center it: in fact seems that Youtube staff did already implement a centered layout so it was as simple as changing in the `<body>` tag, the class "site-left-aligned" to "site-center-aligned". In fact, this wasn't all.
When you open a video, a little menu on the left appears (called Guide). This one, when website is centered, falled behind the flash player so i had to trick that also with CSS by manipulating the "left" property.
Last but not least, personally i never liked the "white-space" on the right of the video, when you look at it as Wide. So i tricked the CSS again to remove the fixed size and make it "100%".
That's all, and that's what the extension do :)

## Can i watch the source code?

Sure! You can see it [here](https://github.com/julianxhokaxhiu/chrome-yt-native-center-layout "YT Native Center Layout GitHub Repo"), as always in my GitHub Repo. And yeah, it's Open Source covered by GPLv3 License.

## Is is available anywhere, for example in the Chrome Web Store?

Yes, you can download it from [here](https://chrome.google.com/webstore/detail/yt-native-center-layout/becgdfhcipoaiiaigklmfjpcmdeclobd "YT Native Center Layout") :)

## That's it!

Thanks for reading. If you liked this, please share wherever you want :)