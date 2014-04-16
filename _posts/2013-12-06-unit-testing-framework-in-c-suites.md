---
layout: default
date: 2013-12-06 10:29:00
parent-url: /
parent: owlwood
title: "Unit testing framework in C++: suites"
---
Some tests belong to one collection called 'test suite'. They are still usual tests, so nothing should be changed in a workflow. Practically, suite behaves a lot like namespace, so latter one is the best way to implement suite. 
    
{% highlight c++ %}
#define SUITE(suite_name) \  
	namespace Suite_##suite_name  
  
SUITE(strings) {  
  
TEST(should_convert_int_to_string)  
{  
	EQUAL(to_string(1), "1");  
}  
  
}  
{% endhighlight %}
    
Test runner did not changed at all in the case.   
  
This brings another problem though. Sometimes I have need in only couple of tests (or one suite, for example). It could bothersome to hunt them in hundreds of tests in the output. And in that case I don't need other tests to run at all. So I want to specify test names, say, as command line arguments, so only specified tests (or test suites) would run. As tests have names, there is no complication to implement such filter. But in case of suites they don't have names and I couldn't filter them. So I need some unified way to know the name of suite. Test function will also change a little. 
    
{% highlight c++ %}
// Global suite name (that is, no suite at all).  
const char * current_suite_name() { return ""; }  
#define SUITE(suite_name) \  
	namespace Suite_##suite_name { \  
		const char * current_suite_name() { return #suite_name; } \  
	} \  
	namespace Suite_##suite_name  
  
#define TEST(test_name) \  
	void test_name(); \  
	AddTest add_test_##test_name(current_suite_name(), #test_name, test_name); \  
	void test_name()  
{% endhighlight %}

Sadly, nested namespaces don't support previous scope function calling, so nested suites are not possible. 

