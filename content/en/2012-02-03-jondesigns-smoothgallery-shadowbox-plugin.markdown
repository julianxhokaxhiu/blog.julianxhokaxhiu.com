---
layout: single
title: "[UPDATED] JonDesign's SmoothGallery Shadowbox plugin"
date: '2012-02-03 16:39:12'
tags:
- javascript
aliases: [/jondesigns-smoothgallery-shadowbox-plugin/index.html]
---

Hi there,

very little and fast post about this plugin. Today i had to make [SmoothGallery](http://smoothgallery.jondesign.net/ "JonDesign's SmoothGallery") to work with [Shadowbox](http://www.shadowbox-js.com/ "Shadowbox.js") plugin (rather than [Lightbox](http://lokeshdhakar.com/projects/lightbox2/ "Lightbox")) and within an extreme surprise i didn't found nothing on the web. So i had to do it myself. I thought it would be much difficult, but in fact it was really easy to fix it. So here, i'm sharing this with you, if you had also my problem.

To make it work just replace at line 116

```javascript
this.currentLink.rel = 'lightbox';
```

with

```javascript
this.currentLink.addEvent('click',function(e){
 Shadowbox.open({
  content:e.target.href,
  player:'img',
  title:e.target.title
 });
 e.preventDefault()
});
```

and that's it!

This method works with JonDesign's SmoothGallery v2.0 + Shadowbox 3.1.3\. Maybe it will work also with next versions of each other, but i don't know, we will see it.

Hope you'll enjoy this post :)

UPDATE!
Found the method to make it work also on v2.1! (useful if you use jQuery and MooTools, all together).

Replace lines 133-136

```javascript
this.currentLink = new Element('a').addClass('open').setProperties({
 href: '#',
 title: ''
}).injectInside(element);
```

with

```javascript
this.currentLink = new Element('a').addClass('open').setProperties({
 href: '#',
 title: ''
}).injectInside(element).addEvent('click',function(e){
 Shadowbox.open({
  content:e.target.href,
  player:'img',
  title:e.target.title
 });
 e.preventDefault()
});
```

That's it! Enjoy :)