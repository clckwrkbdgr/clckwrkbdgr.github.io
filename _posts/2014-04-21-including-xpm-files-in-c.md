---
layout: default
date: 2014-04-21 21:28:45
title: Including XPM files in C++
---

XPM standard describes image data as `static char * xpm_data[] = { ...`. It works fine in C, but C++ (and C99), but C++ forbid declaring static string constants without `const` modifier. It would _very_ bad decision to edit XPM files, as it break backward compatibility with old editors/viewers. Also XPM images could be rewritten by image editors.

Easiest solution is to redefine `char` to `const char` while including XPM. It is not very good though as it uses macros with all of their drawbacks

{% highlight c++ %}
#define char const char
#include "icon.xpm"
#undef char
{% endhighlight %}

More right (but less portable) solution is to switch off GCC warnings. Obviously, on other platforms there would be another pragmas (if they would be in the first place).

{% highlight c++ %}
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wwrite-strings"
#include "icon.xpm"
#pragma GCC diagnistic pop
{% endhighlight %}

But the best solution I've found is following:

{% highlight c++ %}
const
#include "icon.xpm"
{% endhighlight %}

It is still should be used with caution. Found [here](http://www.linux.org.ru/forum/development/10400992?cid=10406949).
