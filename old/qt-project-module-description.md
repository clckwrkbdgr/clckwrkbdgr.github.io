---
layout: default
title: Qt project file module snippet
---
For each pair like `main.h` and `main.cpp` they could be replaced with one entry `main` in variable MODULES, for example.

```
MODULES = main engine player keyboard etc
```

This code snippet expand MODULES variable and goes into the end of the project file:

```
for(module, MODULES) {
	HEADERS += $${module}.h
	SOURCES += $${module}.cpp
}
```

This does not replace HEADERS/SOURCES pair but extends it.

