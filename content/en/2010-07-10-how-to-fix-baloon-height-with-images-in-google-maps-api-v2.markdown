---
layout: single
title: How to fix baloon height with images in Google Maps API v2
date: '2010-07-10 11:24:41'
tags:
- javascript
aliases: [/how-to-fix-baloon-height-with-images-in-google-maps-api-v2/index.html]
---

Hi,

today i'm going to talk about how to fix the (annoying?) baloon height when it has images in itself, on Google Maps API v2\. Of course, i've had so much headache with this problem, i've searched all around the web to find how to fix it and of course i found two ways that tell's how to fix it.

The first method implies that you have to set a fixed height for the baloon, but personaly, i was searching for a more flexible way to get it to work (let's say that i need to have multiple heights on the baloon because my image would be sometimes in 16:9 and sometimes in 4:3). The second method itself tells about an async load of the image in the baloon about Google Maps API itself, so if you see that the text is going outside the baloon in fact it's not a text fault but Google cannot found the size of the image because it wasn't loaded at the moment it was calculating.

So, after reading this i thought "why not mixing them both?" and fact i did it. What i did to fix the height in the baloon, was two simple steps: cache the image before the baloon opens and (ta-da) set an height and a width in the image tag (the height and the width of the image of course). And bingo! the baloon opens quite well and without any sort of problems in any browser (that goes from IE6-8, Firefox 2.x-3.x, Safari, Chrome and Opera).

So, see my snippet, as an example, to understand much more the code and how it does work. If you're asking yourself why did i use jQuery to do things is because of the more fast coding that it let you to do and because it's much better to load javascript only after the page has fully loaded (so it's much more compatible and fluid). Again, the document.ready is not always fired that way if you use that event (eg Internet Explorer do that in other way) so i prefer to use much more safe way that covers all the browsers that we know.

I hope you will find this useful, because i didn't found any article that talk about this in the internet so i hope that people will have less headache than me next time we will have to do so :)

We'll catch the next time with maybe some other cool things i'm preparing like a more functional jQueryUI [Autocomplete](http://jqueryui.com/demos/autocomplete/) (with multiple input texts and so on) that i'll explain when the time will come.

Thanks again for the visit.

```javascript
var imageCache;
(function($){
    var cGIcon =  new GIcon(G_DEFAULT_ICON) ;
    marker = new GMarker(new GLatLng(dLat,dLng),{icon:cGIcon});
    GEvent.addListener(marker, "click", function(){
        // Cache the image before loading the baloon - This way is preferred because of the Garbage Collector of Firefox. If you put this on a var, firefox will think that is not usefull so will throw it away, without loading the image
        if(imageCache) imageCache = $('body').append('<div id="img-cache" style="display:none/>').children('#img-cache'); //So we will create a DIV to put image cache inside it at the end of the body
        $('<img/>').attr('src', 'http://path/to/the/image.jpg').appendTo(imageCache); // Finally, append the image itself
        marker.openInfoWindowHtml('<div class="content"><h1>Title</h1><img src="http://path/to/the/image.jpg" height="100" width="100"><p>This is the text of the baloon</p></div>');
    }
    map.addOverlay(marker);
})(jQuery);
```