---
layout: default
date: 2014-02-21 11:45:47
title: Code coverage with cppcheck.
---

A neat trick to get code coverage in library projects: run `cppcheck` and look for `unusedFunction` warning. As all tested function likely will be "used" (in this case meaning "tested"), all untested functions won't be used anywhere in code and thus will be not covered by unit testing. Of course, it is very rough assumption but still can do some good help in code coverage measurement.
