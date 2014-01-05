---
layout: default
date: 2013-12-05 16:25:00
title: "Unit testing framework in C++: asserts"
---
Simple C-style asserts aren't usable for unit testing, as they exit immediately on first error. Desired functionality for unit test's asserts is to stop execution only of current test, and then go to the next one. C++ exceptions are the best for that. Just detect error and throw exception, then catch it, show "FAIL" message, and continue. As for test asserts, most basic ones (I choose to stick with them) are: conditional assert (ASSERT), equality test (EQUAL), and FAIL assert which always fails - suitable for not implemented yet tests or when catching exceptions. 
    
```c++
struct TestException {  
	std::string filename;  
	int line;  
	std::string what;  
	TestException(const std::string & ex_filename, int ex_linenumber,  
			const std::string & message);  
};  
  
#define ASSERT(expression) \  
	do { if(!(expression)) { \  
		throw TestException(__FILE__, __LINE__, "failed assertion: " #expression ); \  
	} } while(0)  
  
#define EQUAL(a, b) \  
	do { if(a != b) { \  
		throw TestException(__FILE__, __LINE__,\  
				#a + " (" + to_string(a) + ") != " \  
				+ #b + " (" + to_string(b) + ")"); \  
	} } while(0)  
  
#define FAIL(message) \  
	throw TestException(__FILE__, __LINE__, message)  
```
    
Works fine until **a** and **b** expressions in EQUAL macro are not producing side-effects. They're computed two times: in comparison operator and for each to_string() call, which can result in undefined behaviour or at least print wrong information. Simple macro isn't enough for that, templated function could do better: 
    
```c++
template  
void test_equal(const A & a, const B & b,  
		const std::string & a_string, const std::string & b_string,  
		const std::string & file, int line)  
{  
	if(a != b) {  
		throw TestException(file, line, a_string + " (" + to_string(a) + ") != "   
				+ b_string + " (" + to_string(b) + ")");  
	}  
}  
#define EQUAL(a, b) \  
	test_equal(a, b, #a, #b, __FILE__, __LINE__)  
```

Now instead simple call of test's impl() function cathing exception is need to be done. Also all exception (including std::exception-based and not std::exception based) should be catched in order not to break test flow. 
    
```c++
bool ok = true;  
try {  
	test->impl();  
} catch(const TestException & e) {  
	ok = false;  
	std::cout << "[FAIL] " << test->name << std::endl;  
	std::cerr << e.filename << ":" << e.line << ": " << e.what << std::endl;  
} catch(const std::exception & e) {  
	ok = false;  
	std::cout << "[FAIL] " << test->name << std::endl;  
	std::cerr << e.what() << std::endl;  
} catch(...) {  
	ok = false;  
	std::cout << "[FAIL] " << test->name << std::endl;  
	std::cerr << "Unknown exception caught." << std::endl;  
}  
if(ok) {  
	std::cout << "[ OK ] " << test->name << std::endl;  
}  
```    

