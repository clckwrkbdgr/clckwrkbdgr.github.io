---
layout: default
parent-url: /
parent: owlwood
title: Qt project file module snippet
---
For each pair like `main.h` and `main.cpp` they could be replaced with one entry `main` in variable MODULES, for example.

{% endhighlight %}
MODULES = main engine player keyboard etc
{% endhighlight %}

This code snippet expand MODULES variable and goes into the end of the project file:

{% endhighlight %}
for(module, MODULES) {
	HEADERS += $${module}.h
	SOURCES += $${module}.cpp
}
{% endhighlight %}

This does not replace HEADERS/SOURCES pair but extends it.

