---
layout: default
date: 2014-01-28 22:12:34
title: SDL Miniban
---

Miniban was heavily rewritten using SDL. Took me three days to do it. Almost all old code that was using Qt4 GUI painting system was gone. I chose SDL2 instead of plain old SDL, simply because it supports neat DESKTOP_FULLSCREEN mode, which allows to use Alt-Tab and other window manager combinations under Linux. Code is still messy and stinks like a pony, and Qt4 classes are still used, but I plan to remove them as quickly as possible and completely move game to SDL and libchthon.

Fadings (in and out) and intermission screen still here, without any outer difference.

[![miniban-intermission][miniban-intermission-thumb]] [miniban-intermission]

Also I found TTF text output is too complicated and redundant to just print text, so I decided to use pixel font instead. Simple ASCII char map, loaded as XPM resource, like sprites tileset. It was taken from Dwarf Fortress repo (it's just the first one to be found). Looks pretty good.

[miniban-intermission]: /images/miniban-intermission.png
[miniban-intermission-thumb]: /thumbs/miniban-intermission.png
