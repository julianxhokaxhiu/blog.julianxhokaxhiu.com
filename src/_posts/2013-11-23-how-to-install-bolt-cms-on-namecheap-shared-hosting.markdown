---
layout: single
title: How to install Bolt CMS on Namecheap Shared Hosting
date: '2013-11-23 17:07:02'
tags:
- php
- twig
- template
---

Hi guys,

you probably have already noticed it, but the blog had changed. Yeah, a completly new look, new functions (such as search one) and completely responsive too (try resizing your window).

But what is most important is the platform I've chosen to built it upon. Probably you don't know it already, but I've decided to use [Bolt CMS](http://bolt.cm/). Why? Well, it's simply to understand and probably, if you're a developer too you could probably understand by yourself that using a Structure-based CMS vs Content-Based CMS is better to develop within it, manage it and design it. Honestly, with Wordpress I never found APIs that could return Objects but only HTML snippets. Probably, that would be good for lazy people, but not for me :)

So, going back to the topic, which difficulties I've got using this piece of software? Well, honestly no one. Apart a little tweak I had to do on my PHP.ini to make it work on my [NameCheap Shared Hosting](https://www.namecheap.com/hosting/web-hosting.aspx). So, I've decided it to share them with you.

```
[PHP]
magic_quotes_gpc = off
extension=pdo.so
extension=pdo_mysql.so
```

And that's it! Pretty easy, isn't it? :)

Placing a `php.ini` file inside of your root folder where you decided to install Bolt, will make it magically work! Also, if you probably need to use PDO extension, this would be useful to you too.

Thanks for reading as always.