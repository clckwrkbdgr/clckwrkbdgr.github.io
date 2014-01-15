---
layout: default
date: 2014-01-14 19:23:05
parent-url: /
parent: owlwood
title: libchthon
---

During development of the Temple of Trials some code had become big, isolated, and grown self-aware. Some utilities I found to be wanted and usable in other my projects. Like Miniban, which is perfect victim for experiments. After all, it depends on Qt for almost nothing: it could be perfectly done using SDL and some utilities (like this). I decided to split repository into two new repos: one for Temple of Trials itself and one for this new library. I called it libchthon. For no reason.

It is divided into two parts: roguelike classes (map, objects, items, game, actions, etc) and utils (unit tests, format, files, etc). The library is built as shared object and has target to install into specified dir (/usr/local/ by default) itself and include headers.

Works perfectly fine, given that this is my first experience with shared objects under Linux.

Lots of work are to do: proper source comments when they're needed, autodocs, probably some code cleaning and performance optimization - the game runs extremely slow even despite the fact it is turn-based.
