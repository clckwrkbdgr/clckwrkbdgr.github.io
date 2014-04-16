---
layout: default
parent-url: /
parent: owlwood
title: Civilization3 under Linux
---
So far I managed to run a Civilization 3: Conquests (v122) version under wine-1.0.1. Debian Squeeze, NVidia driver.

Following problems has been encountered:

* Game tries to change resolution on start, and crashes or displays incorrectly. A way to fix this is to add a line to the game's INI-file: `KeepRes=1`.
It will allow game to run using current resolution; resolution should be >= Civ3's standard one (1024x768).
* Opening movie also can corrupt display. Line in the INI-file: `PlayIntro=0`
* Game's internal error 13 means that it couldn't find font file LSANS.FOT, which serves as load helper for LSANS.TTF. Following commands fix that:
{% highlight bash %}
$ cp LSANS.TTF LSANS.FOT
$ sudo chattr +i LSANS.FOT # So it can't be rewritten or deleted.
{% endhighlight %}

Otherwise, installs and runs perfectly, maybe a bit slow though.

**UPD**: There are some sound problems in game: at random time some ambient sounds would just go looping without end. The only solution I've found is to switch sound off and on again.
