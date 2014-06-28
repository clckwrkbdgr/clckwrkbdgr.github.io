---
layout: default
date: 2014-06-28 11:44:54
title: HTML to Markdown converter
---

The `html2text` converter that `ranger` uses by default produces pretty ugly text, so I'd need a new one. So I've tried to look up a good HTML-to-Markdown, since it would look better than just a plain text with some unusual formatting. And I've found nothing that could be used as a standalone and is relatively small. All I've found were JavaScript code and some combines that could convert anything-to-anything. So I've decided to write a new one. Took some tests from projects that I've found (hope they would mind even if they'll find out). At first I tried to use regexp, but than I've remembered my own kinda-SAX parser, so I decided to use it in order to include it to `libchthon` later. Also I thought I could use a little more experience with state machines, to polish the skill. So the code came up an ugly mess, but at least it produces well looking, tolerable markdown. There are some glitches and bugs such as some extra empty lines, but it isn't affecting output too much.

