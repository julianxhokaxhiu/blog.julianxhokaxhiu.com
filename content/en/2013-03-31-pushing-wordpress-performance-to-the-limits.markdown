---
layout: single
title: Pushing Wordpress performance to the limits!
date: '2013-03-31 00:21:37'
tags:
- php
aliases: [/pushing-wordpress-performance-to-the-limits/index.html]
---

Hi guys,

first I would like to say sorry for the long time of silence i kept here, but as you may know I'm always a little busy :) This month I tried to archive so many goals which couldn't be mentioned here, but If you [follow me on Twitter](https://twitter.com/JulianXhokaxhiu "Julian Xhokaxhiu (JulianXhokaxhiu) on Twitter") you'll be updated with all the projects I'm working on.

By the way, today I would like to share with you some important, small and cool things regarding Wordpress itself, since I'm studying hardly those days and I'm trying to find the ways to push it over its limits to keep good performance and speed on my Blog too (yeah, this website). So what did I found that needs a Blog post over here? Obviously I would like to share to you a very good plugin of Caching system called [W3 Total Cache](http://wordpress.org/extend/plugins/w3-total-cache/ "Easy Web Performance Optimization (WPO) using caching for Wordpress").

That plugin will do so much things that you'll never image it. Probably you may already know [WP Super Cache](http://wordpress.org/extend/plugins/wp-super-cache/ "A very fast caching engine for WordPress that produces static html files.") and it's beautiful way to cache pages over HTML files on your disk webspace. But in fact this is not sufficient. As you may know Wordpress is made of many more complex things like DB, Po files, plugins, themes and so on, and as long as you add them, the more your HTML will be filled by scripts or css in the HEAD part of you page, or also as inline scripts. So, how can we optimize all of this things? Of course with another plugin that will compact all the other ones!

W3 Total Cache will minify and compress all the HTML, CSS and JS files or inline piece of code that will be embedded on all your website. But it doesn't stop there, it will cache DB queries, output-ed results, static pages and so on. Bringing this to a full blaze of speed to the user that will surf your website. And in fact this is pretty cool because you never have to worry about plugins that will embed scripts here and there. You can forget forever and ever about them, W3 Total Cache will do all the dirty work for you.

But as you may already know, we can optimize as much as we want our website, but our Server bandwidth isn't always free and dedicated to us. That's why I may suggest to you using a [Cloudflare CDN](https://www.cloudflare.com/ "Cloudflare CDN") free account linked to your Wordpress website. How? Simply, with W3 Total Cache! You can find the option to that in the "General Settings" tab of this plugin.

So, you may now think "how much could this speed up things?" well, you're watching it with your eyes already. This website is powered by W3 Total Cache and Cloudflare mixed together :)

Hoping you'll find this article useful, I thank you, and don't forget to share your own experience here after the break :)