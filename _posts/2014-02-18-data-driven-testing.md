---
layout: default
date: 2014-02-18 14:35:03
title: Data-driven testing
---

During extracting FOV and raycasting routines in libchthon I ran into a need of testing a number of data using same test flow. Each case consisted of some original map and a map with expected calculated FOV. Basically, I needed some way to describe repeatable tests with different names but the same value types and testing code and ONLY ONE instance of actual testing code.

The solution was to declare a test function separately from the test itself and define it when the actual code is started:

```c++
void run();
void run();
void run()
{
}
```

Thanks to that, each test case working with data can be easily declared with define looking like this:

```c++
#define TEST_DATA(value, test_name) \
	void run(decltype(value) &); \
	TEST(test_name) \
	{ \
		void run(value); \
	} \
	void run(decltype(value) &)

TEST_DATA(1, should_be_one); // <- just a declaration.
TEST_DATA(2, should_be_two); // <- just a declaration.
TEST_DATA(3, should_be_three) // <- and here is a definition.
{
}
```

Data sets could be differentiated using corresponding names of `run()` function. One more possible impovement is to declare two values: one for input and one for expected output. Final version of macro looks like this:

```c++
#define TEST_DATA(dataset_name, data_value, expected_value, test_name) \
	void run_##dataset_name( \
			decltype(data_value) & dataset_name##_data, \
			decltype(expected_value) & dataset_name##_expected); \
	TEST(test_name) \
	{ \
		run_##dataset_name(data_value, expected_value); \
	} \
	void run_##dataset_name( \
			decltype(data_value) & dataset_name##_data, \
			decltype(expected_value) & dataset_name##_expected)
```

Actual example of usage (taken from documentation):

```c++
TEST_DATA(upper, "hello", "HELLO", should_convert_all_lower_to_upper);
TEST_DATA(upper, "World", "WORLD", should_convert_mixed_to_upper);
TEST_DATA(upper, "foo 123", "FOO 123", should_not_convert_digits)
{
    EQUAL(toupper(upper_data), upper_expected);
}
```
