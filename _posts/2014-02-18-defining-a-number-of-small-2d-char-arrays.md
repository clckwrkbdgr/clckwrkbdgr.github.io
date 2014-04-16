---
layout: default
date: 2014-02-18 18:35:53
title: Defining a number of small 2D char arrays
---

In libchthon, class `Map<T>` is able to store 2D arrays of any type. Usually when it comes to testing maps (like FOV, rays, pathfinding) the simplest way to define such map is using strings:

{% highlight c++ %}
const std::string data = 
	"         "
	"         "
	"  #####  "
	"  #      "
	"  # @ #  "
	"  #   #  "
	"  #####  "
	"         "
	"         "
	;
Map<char> map(9, 9, data.begin(), data.end());
{% endhighlight %}

But when there are a few maps like that, they're consuming code lines. In the meantime, there are plenty of room just to the right of the map. Why not to use this space like that:


{% highlight c++ %}
const std::string data[] = {
   "         ","         ","         ",
   "         ","         ","         ",
   "         ","         ","  #####  ",
   "         ","    #    ","  #      ",
   "    @    ","    @    ","  # @ #  ",
   "         ","         ","  #   #  ",
   "         ","         ","  #####  ",
   "         ","         ","         ",
   "         ","         ","         ",
};
{% endhighlight %}

Folded up the strings are arranged alternately: `1, 2, 3, 1, 2, 3, 1, 2, 3, ...` That is, strings that defines specified map are located at each `COUNT` position stared from some index.

As I need the result as a string (or, rather, as an iterator pair, to save memory and time), I've found following algorithm:

* Create and iterator and point it at the start of the first line in the specified map (for second map it would be string with index 1).
* Forward it till the end of the current string.
* Find out next string (it would be in the `COUNT` of positions).
* If current position is on the last row (i.e. there is no _next_ string), then point iterator at the end of the current (i.e. last) string. It'll be an exact position of the iterator which should be returned from the `end()` function.

Incrementing operator of iterator, designed for such walkthrough:

{% highlight c++ %}
InterleavedCharMap::const_iterator & InterleavedCharMap::const_iterator::operator++()
{
	++it;
	if(it == current_string->end()) {
		size_t count = map.count;
		std::vector<std::string>::const_iterator new_string = current_string;
		while(count --> 0 && new_string != std::end(map.data)) {
			++new_string;
		}
		if(new_string != std::end(map.data)) {
			current_string = new_string;
			it = current_string->begin();
		}
	}
	return *this;
}
{% endhighlight %}

