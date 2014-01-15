---
layout: default
parent-url: /
parent: owlwood
title: Qt crosscompilation for Windows in Linux
---
Taken from [http://habrahabr.ru/blogs/qt_software/98131/](http://habrahabr.ru/blogs/qt_software/98131/).

Requirements:

* **Qt SDK for Linux** and **Qt SDK for Windows** must be installed.
* **GCC/G++** (usually it comes installed along with a distro).
* Compiler **i586-mingw32msvc-gcc/i586-mingw32msvc-g++** (can be found in repository for your distro).

In order to make crosscompilation possible one must create new spec for it. To make this task a bit easier it is more convinient to copy an existing one, for example, `win32-g++` (here and further `$QT_WIN` points to Qt SDK for Windows installation path and `$QT_LINUX` - to Qt SDK for Linux):

```
$ cd $QT_WIN/qt/mkspecs/
$ cp -R win32-g++/* win32-x-g++/
```

Next, some changes must be done in _win32-x-g++/qmake.conf_:

```
QMAKE_SH = sh
QMAKE_CC = i586-mingw32msvc-gcc
QMAKE_CXX = i586-mingw32msvc-g++
QMAKE_INCDIR_QT = $QT_WIN/qt/include
QMAKE_LIBDIR_QT = $QT_WIN/qt/lib
QMAKE_LINK = i586-mingw32msvc-g++
QMAKE_LINK_C = i586-mingw32msvc-gcc
QMAKE_LFLAGS = -mthreads -Wl,-enable-stdcall-fixup -Wl,-enable-auto-import -Wl,-enable-runtime-pseudo-reloc -mwindows
QMAKE_MOC = $QT_LINUX/qt/bin/moc
QMAKE_UIC = $QT_LINUX/qt/bin/uic
QMAKE_IDC = $QT_LINUX/qt/bin/idc
QMAKE_RC = i586-mingw32msvc-windres
QMAKE_STRIP = i586-mingw32msvc-strip
```

Building project now is easy. All that should be done is setting of _QMAKESPEC_ environment variable. This variable is checked by qmake on the startup. Unsetting it  will return Qt spec target to the Linux one (that is, system's default).

```
$ export QTDIR=/opt/qtsdk-win/Desktop/Qt/4.7.3/mingw
$ export QMAKESPEC=$QTDIR/mkspecs/win32-x-g++
$ make clean distclean # optional; used for cleaning from previous builds
$ qmake # a linux one; all crosscompilation work is by fact done in spec file
$ make
```
