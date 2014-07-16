---
layout: default
date: 2014-07-16 14:24:37
title: Some new features in html2mark script
---

Script is working and doing it pretty well. I've been using it with `ranger` manager as a viewer for html files. Usual markdown formatting is nice and readable, but why not display colours if terminal (and ranger) supports it? So I've added standard color escape sequences to the output. It did help to strip out the `**` and `_` symbols etc, so now plain output is even more plain text and looks a lot nicer.

This feature brought a new bug: internal `ranger` word-wrapping utility breaks colours upon line breaking. So once again I've needed embedded word-wrapping code. It should also take into consideration colours (apparently they're not taking terminal space) and handle UTF-8 (correctly calculating text length).

Also cleaned up a bit, fixed some empty lines and extra spaces bugs, lots of colour bugs, lots of wrapping bugs.

In the end a bug in the `ranger` itself was revealed: ranger also got no clue about multibyte encoding, so I've needed to hack the code and add encoding/decoding part for slicing the text.
