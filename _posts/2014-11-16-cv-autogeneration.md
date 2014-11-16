---
layout: default
date: 2014-11-16 10:58:52
title: CV autogeneration
---

For some time I've tried to make my CV's in both languages (English and Russian) to be generated as automatically as possible. 

So I've got two CVs: English and Russian version. They should represent pretty much the same information, so every time I update one of them I should mirror the changes into another one. It's not that convenient and could lead to mistakes and differences between them. So I want to update them automatically and as simple as possible. Say, using a Python script to generate CV from some information (for each language) - essentially, a templating. The task is to load template from file, then load CV data and apply template to data in order to produce resulting CV.

Python comes with built-in template engine in `string.Template` module and even more powerful templating engines exits (such as _bottle.py_, _Jinja_ etc.). But for this task they might be to complex as all I need is to just subsitute some values in template. So I went with Python3 `format` function, which supports nested structures, arrays etc:

	{name}
	Tech skills: {skills.cpp}
	Professional experience:
	{job.position} at {job.organization}
	* {job.achievement.feature}

Looks simple and usage is even simplier:

{% highlight python %}
print(TEMPLATE.format(name, skills, job))
{% endhighlight %}

Now I need some way to store data. I considered different text storage format (XML, JSON etc.), but ended up using YAML as it is more easy to read and edit than JSON.

	name: Name
	skills:
		cpp: C++
	job:
		position: Developer
		organization: Organization
		achievement:
			feature: Added new feature to system.

Reading is simple (I use `pyyaml` module):

{% highlight python %}
with open("data.yml", "r") as f:
	data = yaml.loads(f)
{% endhighlight %}

But result is a Python dict, not structure (as needed by `format` function). The most easy way to convert dict to structure is to use Python object's `__dict__` variable:

{% highlight python %}
class Struct:
	pass

struct = new Struct()
struct.__dict__ = data
{% endhighlight %}

But we need to do the same thing for each level of dictionary. And it's already too much code for simple needs. More convenient way is to use `collections.namedtuple` class:

{% highlight python %}
Struct = namedtuple(data.keys())
struct = Struct(*data.values())
{% endhighlight %}

And do it recursively for each level of nesting:

{% highlight python %}
def to_struct(data):
	if isinstance(data, dict):
		return namedtuple('Struct', data.keys())(*[to_struct(x) for x in data.values()])
	elif isinstance(data, list):
		return [to_struct(x) for x in data]
	return data
{% endhighlight %}

It gives Struct object with each complex member being either list of data (Struct or another objects) or Struct object again. Now applying template to resultin data struct looks like:

{% highlight python %}
print(TEMPLATE.format(**(data.__dict__)))
{% endhighlight %}

And produced output is looks like that:

	Name
	Tech skills: C++
	Professional experience:
	Developer at Organization
	* Added new feature to system.

Now data for each language can be stored in separate files. And on loading and applying template errors in data layout will be autodetected, so both data files would represent the same structure essentially.
