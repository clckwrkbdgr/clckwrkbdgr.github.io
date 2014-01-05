---
layout: default
date: 2013-12-04 16:28:00
title: "Unit testing framework in C++: init"
---
_My goal was to create simple unit testing framework, possibly one header only. It should support most of usual unit testing features: tests (of course), various assertions, suites, fixtures. Also I wanted it to be as less verbose as possible in test declaration. Probably just to write `TEST(test_name) { ... }` to be sufficient._  
The simplest unit testing could be done using just assert macros, like this:   

```c++
void run_all_tests()  
{  
	assert(to_string(1) == "1");  
	assert(to_string('A') == "A");  
	assert(to_string("Text") == "Text");  
}  
```

At some point, function will grow too big to comprehend. Probably it should be divided into separated tests:   

```c++
void should_convert_int_to_string()  
{  
	assert(to_string(1) == "1");  
}  
  
void should_convert_char_to_string()  
{  
	assert(to_string('A') == "A");  
}  
  
void should_convert_string_to_string()  
{  
	assert(to_string("Text") == "Text");  
}  
  
void run_all_tests()  
{  
	should_convert_int_to_string();  
	should_convert_char_to_string();  
	should_convert_string_to_string();  
}  
```
    
That way all tests invocations stored in one place. Disadvantages remain: function must be explicitly defined which involves lot of includes, extern defines etc. It would be nice if test runner could invoke function without even knowing its name. One way to do it is to use pointer to function. They could be stored in pointer list, which also simplifies invokation.   

```c++
typedef void(*TestFunction)();  
  
std::list & all_tests()  
{  
	static std::list tests;  
	return tests;  
}  
  
void should_convert_int_to_string()  
{  
	assert(to_string(1) == "1");  
}  
  
void should_convert_char_to_string()  
{  
	assert(to_string('A') == "A");  
}  
  
void should_convert_string_to_string()  
{  
	assert(to_string("Text") == "Text");  
}  
  
void run_all_tests()  
{  
	all_tests().push_back(should_convert_int_to_string);  
	all_tests().push_back(should_convert_char_to_string);  
	all_tests().push_back(should_convert_string_to_string);  
  
	std::list::const_iterator test;  
	for(test = all_tests().begin(); test != all_tests().end(); ++test) {  
		*test();  
	}  
}  
```

It would be a lot easier to add new test if appending it to the list were as closer to function declaration as possible. But in global scope, outside of all function such statement couldn't be executed. Only definitions and declarations. So one way to get around it is to add function to the list in some variable declaration:   

```c++
struct AddTest;  
std::list & all_tests();  
struct AddTest {  
	TestFunction impl;  
	AddTest(TestFunction test_function)  
	{  
		all_tests().push_back(*this);  
	}  
};  
  
// We define function's header...  
void should_convert_int_to_string();  
// ...store function...  
AddTest add_test_should_convert_int_to_string(should_convert_int_to_string);  
// ...and declare function body  
void should_convert_int_to_string()  
{  
	assert(to_string(1) == "1");  
}  
  
...  
  
void run_all_tests()  
{  
	std::list::const_iterator test;  
	for(test = all_tests().begin(); test != all_tests().end(); ++test) {  
		test->impl();  
	}  
}  
```
    
Almost what I wanted. Except it would be nice also see some pretty output like test name. And it could be wrapped in macro:   

```c++
struct AddTest {  
	std::string name;  
	TestFunction impl;  
	AddTest(const std::string & test_name, TestFunction test_function);  
};  
  
std::list & all_tests();  
  
#define TEST(test_name) \  
	void test_name(); \  
	AddTest add_test_##test_name(#test_name, test_name); \  
	void test_name()  
  
// That's all what's needed to create a test.  
TEST(should_convert_int_to_string)  
{  
	assert(to_string(1) == "1");  
}  
  
void run_all_tests(int argc, char ** argv)  
{  
	std::list::const_iterator test;  
	for(test = all_tests().begin(); test != all_tests().end(); ++test) {  
		std::cout << test->name << std::endl;  
		test->impl();  
	}  
}  
```

