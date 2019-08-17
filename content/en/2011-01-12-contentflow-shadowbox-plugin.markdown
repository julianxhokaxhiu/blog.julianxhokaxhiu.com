---
layout: single
title: ContentFlow Shadowbox plugin
date: '2011-01-12 22:30:30'
tags:
- javascript
---

Hi there,

for all you guys who knows already what [ContentFlow](http://www.jacksasylum.eu/ContentFlow/) is and what [ShadowBox](http://www.shadowbox-js.com/) is, this is for you! (but this is also for you, if you don't know what they are,  just visit their respective websites). What does it do? Simply, inspired by the LightBox plugin, this does just the same, but with Shadowbox, so when you click on an active item and on it's image link, it just open it on Shadowbox without leaving your page. And what about the title? Yeah it does get it also.

Remember to include this script AFTER ContentFlow, which it have to be AFTER Shadowbox (otherwise it won't work).

Enjoy!

```javascript
/*  ContentFlowAddOn_shadowbox, version 0.1
 *  (c) 2011 Julian Xhokaxhiu
 *
 */
new ContentFlowAddOn('shadowbox',{
    ContentFlowConf:{
        onclickActiveItem: function (item){
            if (item.content.getAttribute('src'))
        Shadowbox.open({
            player:'img',
            title:(item.caption)?item.caption.firstChild.nodeValue.replace(/]*>/,': '):'',
            content:item.content.getAttribute('src')
        });
        }
    }
});
```