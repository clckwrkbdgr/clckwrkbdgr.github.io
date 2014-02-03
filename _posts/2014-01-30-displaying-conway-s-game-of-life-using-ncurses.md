---
layout: default
date: 2014-01-30 21:59:31
title: Displaying Conway's Game of Life using ncurses
---

Having simple working Game of Life simulator (almost anyone have written it at some point) simplest way to present it is to draw using graphic display, e.g. SDL. Say, white pixel for alive cell and black for dead. With large resolutions game field will be too small, so possibly one can use some scaling, like drawing coloured rectangles. Personally, I prefer to work in console, so I would want to output game field on the terminal.

## Using stream

The simplest way to do that is just to output game array into stdout and flush it. It will work fine when height of the array is equal to the height of the console window. When array is smaller than the window, one can fill the gap using empty lines.

Alive cell should be printed as visible as it possible: symbols like `O`, `#`, `@`, `0` etc. I prefer symbol `0` - it gives cleaner look overall.

![life-ncurses-plain](/images/life-ncurses-plain.png)

```c++
for(int y = 0; y < height; ++y) {
	for(int x = 0; x < width; ++x) {
		std::cout << (cell(x, y) ? '0' : ' ');
	}
	std::cout << std::endl;
}
for(int y = height; y < window_height; ++y) {
	std::cout << std::endl;
}
```

Thus at each iteration screen will be reprinted and scrolled so it will contain the game field only. Notice that outer loop is for `y` coordinate as we must print whole line (which is `x`-loop) and only than proceed to the next `y`-row). 

Major withdraw of this way is that it takes time, a lot of time to scroll the screen. Putting only changed cells, for example, will be much more efficiently. And colours for the win. So **ncurses** is the choice.

## Using ncurses

```c++
for(int x = 0; x < width; ++x) {
	for(int y = 0; y < height; ++y) {
		mvaddch(cell(x, y) ? '0' : ' ');
	}
}
```

Nothing sophisticated and looks pretty much the same. It's just that it's looks not so good. Rectangles (or squares) should fit perfectly.

## Coloured ncurses

One way to output rectangle in place of character is to use coloured background and print space character (`' '`, 0x20).

![life-ncurses-colour](/images/life-ncurses-colour.png)

```c++
start_color();
init_pair(1, COLOR_BLACK, COLOR_BLUE);
for(int x = 0; x < width; ++x) {
	for(int y = 0; y < height; ++y) {
		mvaddch(cell(x, y) ? ' ' | COLOR_PAIR(1) : ' ');
	}
}
```

It is rectangles all right, but squares still would be best fit.

## Unicode ncurses

Luckily, such possility exists and uses Unicode symbols. Specifically, UPPER HALF BLOCK (`▀`, 0x2580) and LOWER HALF BLOCK (`▄`, 0x2584. Not the perfect squares, but the best ones I've found so far. So, we use `<ncursesw/ncurses.h>` header from **ncursesw** instead of ASCII-only-aware **ncurses** and links executable against `-lncursesw`. Now, for the output of unicode characters.

Ncurses' character type, `char_t` is just a typedef for plain integer. It's first byte stores the character itself (8-bit encoding is used, depending on your terminal settings), other bytes is taken by various attributes like colour, blinking, bold, underline etc. Unicode symbols can have more than one character to display, so ncursesw presents a structure for that, `cchar_t`. Fields that we are interested of are `cchar_t::attr` for attributes (of `attr_t` type) and `cchar_t::chars` array of `char_t`, which stores all characters to display.

```c++
cchar_t t;
t.attr = COLOR_PAIR(1);
t.chars[0] = 0x2584; // LOWER HALF BLOCK
t.chars[1] = 0; // Null-terminating.
```

And the loops are drastically changed. Prior to this we print one row using one iteration, but now we have two cells printed in one screen character, so we need to get two subsequent row at a time.

![life-ncurses-blocks](/images/life-ncurses-blocks.png)

```c++
for(int x = 0; x < life.width; x++) {
	for(int y = 0; y < life.height; y += 2) {
		int up = cell(x, y);
		int down = cell(x, y + 1);

		cchar_t t;
		t.attr = COLOR_PAIR(1);
		if(up && down) {
			t.chars[0] = 0x2588; // FULL BLOCK
		} else if(up) {
			t.chars[0] = 0x2580; // UPPER HALF BLOCK
		} else if(down) {
			t.chars[0] = 0x2584; // LOWER HALF BLOCK
		} else {
			t.chars[0] = ' '; // Space.
		}
		t.chars[1] = 0;

		mvadd_wch(y / 2, x, &t); // This is also changed.
	}
}
```

It looks almost excellent. Almost, because some fonts treats block as an ordinary symbol, which is not the full character place height, so it results in ugly breaks.

## Final solution

As upper half block if not really the upper half block, why not to replace it with reverse-coloured lower half block? I.e. lets say we print white lower block when lower cell is alive, so to fully paint upper half block we fill background with white and print black lower half block again. Thus upper half of the charater is filled completely without any breaks. And for full block we need to pull the same trick: lets fill the whole character with 'alive' colour.

![life-ncurses-final](/images/life-ncurses-final.png)


```c++
init_pair(1, COLOR_BLUE, COLOR_BLACK); // This is an ordinary colours.
init_pair(2, COLOR_BLACK, COLOR_BLUE); // This is reversed ones.
for(int x = 0; x < life.width; x++) {
	for(int y = 0; y < life.height; y += 2) {
		int up = cell(x, y);
		int down = cell(x, y + 1);

		cchar_t t;
		// For cells that has upper block (either full blocks or the upper one only) the reverse-colour trick is used.
		t.attr = up ? COLOR_PAIR(2) : COLOR_PAIR(1);
		// For both upper and lower blocks either present or absent altogether we print space (i.e. full block).
		// Otherwise, lower half block is printed.
		t.chars[0] = (up == down) ? ' ' : 0x2584; // LOWER HALF BLOCK
		t.chars[1] = 0;

		mvadd_wch(y / 2, x, &t);
	}
}
```
