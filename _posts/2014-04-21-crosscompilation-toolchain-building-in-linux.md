---
layout: default
date: 2014-04-21 09:45:27
title: Crosscompilation toolchain in Linux (for building SDL2 applications)
---

Best crosscompilation choice is MXE project. It is fully automatized Makefile that downloads and builds all needed cross-tools and libraries.

{% highlight bash %}
~$ cd /opt/
opt$ git clone -b master https://github.com/mxe/mxe.git
opt$ cd mxe
mxe$ make gcc sdl2 # or just make sdl2, as gcc is listed in its dependencies.
{% endhighlight %}

At the time of writing this article, SDL2 was not yet ready to be built. If sdl2 is not installed, download SDL2-devel-mingw from official site and put `include/` dir content into `./usr/include/SDL2`, `lib/` to `lib/` etc.

Now that all tools and libraries is installed simple Bash script that wraps normal `make` invokation would do all the work:

{% highlight bash %}
# Define our new tools and libs and stuff for cross-compilation.
export CXX=/opt/mxe/usr/bin/i686-pc-mingw32.static-g++
export CXXFLAGS='-I/opt/mxe/usr/include -L/opt/mxe/usr/lib'
export LIBS='-lmingw32 -lSDL2main -mwindows'
exec make $* # Invoke make with new defines.
{% endhighlight %}

All user libs and includes should go to `./usr/{lib,include}` dirs resp. Normally any `.dll` file can be used by linker, so there is no need to make `.a` files.

## Troubleshooting

Some old MinGW C++ STL versions do not suppport `to_string` and other standard string conversion routines. Fix for that problem is described [here](http://tehsausage.com/mingw-to-string)

If `Undefined reference to 'SDL_main'` errors pop up, make sure that `main` routine is declared as following:

{% highlight c++ %}
int main(int argc, char *argv[]) 
{% endhighlight %}

If linker is cursing with messages like 'undefined reference to SDL_Init' and such, check order of arguments in gcc invokation:

{% highlight make %}
target:
	# Wrong.
	gcc `sdl-config --libs` -o main main.o
	# Right.
	gcc main.o  `sdl-config --libs` -o main
{% endhighlight %}

