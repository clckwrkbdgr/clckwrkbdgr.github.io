---
layout: default
date: 2014-01-29 21:20:24
title: Miniban is version 1.0 now
---

Finally, all the cleaning and converting work is done, and Miniban project is completely free from Qt stuff, only SDL and good old Makefile. Project tree is reorganized. Source moved to src/ dir, test - to test/. Resources (which consists of pixel font and tileset) are moved in their own separate dir called res/. Couple of classes were introduces to replace analogous class from Qt: Settings and XMLReader. The latter one is not a fully-qualified XML reader despite its name but resembles very lopped SAX parser. Minimalistic but working well. Settings class stores settings file in $HOME/.confing/ for now, as I'm not planning to run the game somewhere outside Linux. So, basically, current version is long waited major (heh) release, Miniban 1.0.0. So much for my first finished game ever. Nevertheless, it feels good.
