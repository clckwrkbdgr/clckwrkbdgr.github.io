---
layout: default
date: 2014-04-29 10:24:49
title: Quicksort explained
---

Horrible sort algorithm, have been bugging me for days. While the list version is simple as heck, in-place version is tough for me because of all of those indexes to remember.


Here's simple version of the algorithm:

{% highlight python %}
def sort(v):
	# List of one item is sorted by definition,
	# so this is a base-case for recursion.
	if len(v) <= 1:
		return v
	# Get pivot value. For simplicity lets take the first value.
	pivot = v[0]
	# Prepare lists for all result parts.
	left, right, pivots = [], [], []
	# For each value (well, err, including pivot).
	for i in v:
		if i < pivot:
			# Here go all 'lesser' values.
			left.append(i)
		elif i > pivot:
			# Here go all 'greater' values.
			right.append(i)
		else:
			# Here go all the pivots (at least one).
			pivots.append(i)
	# Visualization.
	print(left, pivots, right)
	# Resulting list consists of:
	# - all the lesser values (sorted),
	# - then pivots,
	# - then all the greater values (sorted).
	return sort(left) + pivots + sort(right)
{% endhighlight %}

In-place version operates on a continuous array, but still uses lesser-pivot-greater separation model, so we need to emulate those lists in array.

For input lets take start position inside the array and the count of values to emulate sub-array to sort:

{% highlight python %}
def sort(v, start, count):
{% endhighlight %}

As in simple version, if subarray contains only one item (or less), it is sorted and we done with it:

{% highlight python %}
	if count <= 1:
		return
{% endhighlight %}

Now for pivot we take `v[0]` value, which in our sub-array emulation will actually be `v[start]`:

{% highlight python %}
	pivot = v[start]
{% endhighlight %}

The idea is to move all lesser value to the left part of the array and all greater values to the right part. We start from both ends of the array and go to the center (or wherever these two 'pointers' meet). When the left pointer encounters value greater than pivot (and in the left part there should be only lesser values), we have our candidate to move to the right part. The right pointer in the mean time searches for lesser value in the right side (which should be on the left side). Now we have two values which are out of place, so we swap them. Right after that, all values that are left to the 'left' pointer and values right to the 'right' pointer are _exactly_ where we need them. They're separated. So we proceed further to the meeting point. We proceed until these two pointers meet each other in some position.

So, first we create pointers:

{% highlight python %}
	#  0  1  2  3  4  5  6
	# [x, x, x, x, x, x, x]
	#     ^           ^
	# start           end (five values)
	# Start value is at the index 1. Which is pivot position.
	# So we skip it to the next, which is at the index 2 (start + 1).
	# This is our 'left' pointer.
	# Right pointer is exactly in 4 (five minus one) values from start.
	left = start + 1
	right = start + count - 1
{% endhighlight %}

Now we proceed until they meet each other.

{% highlight python %}
	while left <= right:
{% endhighlight %}


Find the out-of-place value on the left.

{% highlight python %}
		while left <= right and v[left] < pivot:
			left += 1
{% endhighlight %}

Find the out-of-place value on the right.

{% highlight python %}
		while left <= right and v[right] > pivot:
			right -= 1
{% endhighlight %}

If it is still not the same value, we swap them:

{% highlight python %}
		if left < right:
			v[left], v[right] = v[right], v[left]
{% endhighlight %}

...and proceed. The comparisons is not strict because of cases when all the values are less than pivot, so we travel to the very end of the array, which is the `right` pointer, and we should have possibility to 'step' to this position with `left` pointer.

When we done, `right` and `left` will point at the same position, and the pivot is at the start of the subarray. Lets move pivot to the meet point by swapping the very left lesser value with it:

{% highlight python %}
	left -= 1
	v[start], v[left] = v[left], v[start]
{% endhighlight %}

Now the pivot value is between left and right parts. It is in its place, and will not be moved anyway, so we create two new subarrays without it. The left one starts from the `start` and up to the new `left` position. The right one starts from the pivot position to the end of original subarray (`count`). These two lists should be sorted now:

{% highlight python %}
	#  0  1  2  3  4  5  6
	# [x, x, x, x, x, x, x]
	#    [x, x][x][x, x]
	#     ^     ^     ^
	# start   pivot   end
	#         (left)
	sort(v, start, left - start)
	# (count + start - 1) is absolute position of the original end.
	sort(v, left + 1, count + start - 1 - left)
{% endhighlight %}

The full code:

{% highlight python %}
def sort(v, start, count):
	if count <= 1:
		return
	pivot = v[start]
	left = start + 1
	right = start + count - 1
	while left <= right:
		while left <= right and v[left] < pivot:
			left += 1
		while left <= right and v[right] > pivot:
			right -= 1
		if left < right:
			v[left], v[right] = v[right], v[left]
	left -= 1
	v[start], v[left] = v[left], v[start]
	sort(v, start, left - start)
	sort(v, left + 1, count + start - 1 - left)
{% endhighlight %}
