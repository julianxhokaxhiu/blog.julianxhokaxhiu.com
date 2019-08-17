---
layout: single
title: When Wordpress meets Twig
date: '2013-04-21 18:02:50'
tags:
- php
- template
aliases: [/when-wordpress-meets-twig/index.html]
---

Good evening guys,

what I've done those days? Well, today I would like to share with you something cool I've found.

What happens when you love Wordpress but you don't like its templating system? There's where the magic happens. You introduce a templating language, more powerful and easy to maintain. And the one I've chosen is called [Twig from SensioLabs](http://twig.sensiolabs.org/ "Twig: The flexible, fast, and secure template engine for PHP"). I've already managed to use it at work where I do my full job. That's why using it I asked myself "why Wordpress team never implemented this?" so I began searching in the net if someone has already started this project.

In fact, with so much surprise, someone has begun this project and is called [Timber](http://jarednova.github.io/timber/ "Because WordPress is awesome, but the_loop isn't."). Its main goal is to port Twig templating engine to Wordpress by using a main theme as "a Twig parser" and a child theme as your main theme for you Wordpress based website. In fact it's pretty much cool as a project but no one seems to have maintained it since is from one month to four months old. So, looking at it's code I've seen that it could be optimized and probably rewritten in a much cleaner way. That's why I've decided to <del>fork it</del> [make a new one](/2013-04-27-twigpress-a-boilerplate-twig-engine-theme-for-wordpress/ "TwigPress: a boilerplate Twig engine theme for WordPress").

Why I'm saying it here? Because any project couldn't be maintained alone, the community has so much power in it, and I would like to have all you contributes into this. I'm currently accepting Pull Requests (if they make sense). Meanwhile which are my current targets?

*   <span style="line-height: 13px;">Rewrite all the code base to make it much cleaner</span>
*   Reorganize the project so we wouldn't need two themes in one folder, but one, probably divided by /app and /design folders but I'll look how much free  I could be
*   Port as much WP api natively in Twig (the best option would be to mirror them without having to map them 1-by-1)

So, hoping you would like this, I wish myself I can do this as much faster as I can.

Finally I would like to thank you for all the visits I'm having in this blog. It wouldn't have been what it is without you.