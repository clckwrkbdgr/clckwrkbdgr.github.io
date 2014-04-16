---
layout: default
date: 2014-01-16 20:34:32
title: C++ warning list for Makefile
---

This is almost full list of C++ related compiler warning flags I found for GCC 4.8.

* **-pedantic** - Turns on pedantic syntax check.
* **-Werror** - Turns every warning found to error.
* **-Wall** - Basic warnings that should be turned on in almost every project.
* **-Wextra** - Extra warnings
* **-Wformat=2** - Checks for format routines and their args misusing.
* **-Wmissing-include-dirs** - Complains when directory specified with `-I` flag doesn't exist.
* **-Wswitch-default** - Checks for `default` section in `switch` operator.
* **-Wswitch-enum** - If `switch` operator index is of `enum`, all of enum values should be present as selectors.
* **-Wuninitialized** - For auto variables. Enough said.
* **-Wunused** - All of "unused object" cases.
* **-Wfloat-equal** - Floating-points shouldn't be compared using basic strict equality operator.
* **-Wundef** - Some ID, that's being used in preprocessor directivers, is undefined.
* **-Wno-endif-labels** - For every #if there should be an #endif.
* **-Wshadow** - Shadowing variables in outer scopes.
* **-Wcast-qual** - Pointer type qualifier casting misusing.
* **-Wcast-align** - Pointer memory-alignment casting errors.
* **-Wconversion** - For implicit conversions that may change value (like unsigned to signed).
* **-Wsign-conversion** - Particular case of signed implicit conversion.
* **-Wlogical-op** - Usage of logical operators where bit-wise operator should be used.
* **-Wmissing-declarations** - Global function defined without previous declarations (like one in header file).
* **-Wno-multichar** - No multichar constants (`FOOF`).
* **-Wredundant-decls** - Enough said.
* **-Wunreachable-code** - Enough said.
* **-Winline** - When `inline` function cannot be inlined.
* **-Winvalid-pch** - Enough said.
* **-Wvla** - No variable-length arrays.
* **-Wdouble-promotion** - Downcasting `double` to `float`
* **-Wzero-as-null-pointer-constant** - Facilitates `nullptr` usage instead of zeroes.
* **-Wuseless-cast** - Enough said.
* **-Wvarargs** - Misusing varargs.
* **-Wsuggest-attribute=pure** - Suggests when function (probably) should be declared as `pure`.
* **-Wsuggest-attribute=const** - Suggests when function (probably) should be declared as `const`.
* **-Wsuggest-attribute=noreturn** - Suggests when function (probably) should be declared as `noreturn`.
* **-Wsuggest-attribute=format** - Warn about function pointers that might be candidates for format attributes.

Complete warning list code for Makefile:

{% highlight c++ %}
WARNINGS = -pedantic -Werror -Wall -Wextra -Wformat=2 -Wmissing-include-dirs
	-Wswitch-default -Wswitch-enum -Wuninitialized -Wunused -Wfloat-equal
	-Wundef -Wno-endif-labels -Wshadow -Wcast-qual -Wcast-align -Wconversion
	-Wsign-conversion -Wlogical-op -Wmissing-declarations -Wno-multichar
	-Wredundant-decls -Wunreachable-code -Winline -Winvalid-pch -Wvla
	-Wdouble-promotion -Wzero-as-null-pointer-constant -Wuseless-cast
	-Wvarargs -Wsuggest-attribute=pure -Wsuggest-attribute=const
	-Wsuggest-attribute=noreturn -Wsuggest-attribute=format
{% endhighlight %}
