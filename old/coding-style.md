---
layout: default
parent-url: /
parent: owlwood
title: Coding style
---
Identifiers
=========

* Classes and namespaces are named in `CamelCase`.
* Variables, objects, functions, methods are named `using_underscores` and `all_lower_case`.
* Constants are name `ALL_UPPERCASE_AND_UNDERSCORED`.

Tabs are better than spaces
=========

Tabs require fewer keystrokes to add, remove, navigate. Indent size can be set to one's preferences without actually changing code. Tabs take fewer bytes to store; extra spaces take about 10% of HTML page size. Wrong extra tab is more obvious than wrong extra space. And you can never half-indent with tabs. And soft tabs are just redundant workaround which hides horridness of space indentation.

There is absolutely no reason to use spaces for indentation except only one: you have prehistoric 80cols CRT display, where spaces really matters or a prehistoric compiler which supplies error lines with column number and thus displays those numbers incorrectly.

Still, tabs and spaces never should be mixed for indentation and no tab should be used for aligning. And there's no reason _not_ to use spaces for indentation :)

Giving things names
=========

Usage of Hungarian notation or other prefixes/suffixes like buttonRun, urlEdit is redundant due to their unambiguous meaning during actual using (especially when stored in containers like Qt UI or Android layouts):

{% endhighlight %}
ui.url.setText(...);
{% endhighlight %}

And there's no need to know which type `url` is: in current context it is actually URL and it obviously should have some text properties.

But still, to not mix entities from different contexts such context should be explicitly specified (like `ui` in the example above).

