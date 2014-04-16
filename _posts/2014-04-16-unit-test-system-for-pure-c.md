---
layout: default
date: 2014-04-16 14:43:07
title: Unit test system for Pure C
---

At some point I decided to have unit tests for Cybercrawl in order to do some refactoring and possibly introduce graphics into the game later. As my C++ unit test framework turned up to work pretty well, I'd chosen to use something like that. But Chthon unit tests are using C++ features like exceptions, function overloading et cetera, so I've needed to come up with some replacement for them. I'd given up on some features, though, like exception testing (obviously), containers (though I probably shall bring them back) tests and suites (no namespaces in C).

# Test cases

First, we need a test case.

{% highlight c++ %}
TEST(name) {
	assert(true); // Lets use embedded asserts for now.
}
{% endhighlight %}

Now we need to define `TEST()` macro. This macro should add new test case to the test case list. In C++, we could execute function in global variable declaration, like this:

{% highlight c++ %}
void new_test_case();
int a = add_test_case(new_test_case);
void new_test_case()
{% endhighlight %}

But in ANSI C there is no possibility to execute code _before_ `main()`. The best solution I've found is to rely on GCC tricks like `constructor` attribute. This attribute marks functions to execute them _before_ main routine in order of definition.

{% highlight c++ %}
#define TEST(name) \
	void name(); \
	__attribute__((constructor)) \
	static void add_test_##name() \
	{ \
			add_test(name, #name); \
	} \
	void name()
{% endhighlight %}

# Asserts

The very basic test assert, which evaluates boolean exception and stops execution, is embedded `assert()`. However, it will break the whole program flow, which would seem rather harsh for testing. It would be more convienient to be able to stop only current test case. In C++, we have exception to do that. In Pure C we can only interrupt function execution using `return`. Unfortunately, we cannot use something like `return false` as at the end of test case it would be strictly needed to put `return true`. So if we want to use as less instructions as possible, we define global variable `last_test_result` and set it to false on such notice.

{% highlight c++ %}
#define ASSERT(x) \
	do { if(!(x)) { \
		printf("%s:%d: failed assertion: %s\n", __FILE__, __LINE__, #x); \
		current_test_result = false; \
		return; \
	} } while(0)
{% endhighlight %}

# Internal test mechanics

Inside of the unit test system there is a linked list of nodes that store test case pointer and test case name, and a loop that iterates through the list. All the other details is taken from Chthon unit test system, so there is no much need to describe it.
