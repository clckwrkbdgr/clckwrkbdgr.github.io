---
layout: default
date: 2014-01-22 10:43:56
title: Docs for libchthon
---

At first I decided to make autodocs for libchthon using Doxygen. I set up neat Doxyfile with lots of preferences (graphs, pages, modules) and started to fill docs. But then I got tired of cleaning errors and typing senseless and redundant words for each and every one entity. And it was just the first file. So I had given up on 'fully documented code' idea and decided to just document all not-so-obvious parts. And it still made me tired and wandering. Why do I need to make docs for everything if I aint gonna need it? what I really gonna need is list of all classes/methods/fields and its signatures and types. And I already have these. So I just wrap every file in doxygen's `@defgroup` and now am completely satisfied. If some documentation will be needed, it will be filled then, but no more than that. So no documentation is compeleted yet, but at least project is prepared for it and ready.
