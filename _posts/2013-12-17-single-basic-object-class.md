---
layout: default
date: 2013-12-17 21:28:00
parent-url: /
parent: owlwood
title: Single basic Object class
---
It took me longer, than I expected, but I finally managed to turn all object classes (doors, traps, stairs etc) into one basic class Object. Behaviour is controlled by amount of flags like 'passable' or 'triggerable', which is some disadvantage, but on the other hand all that classes had too similar behaviour to remain splitted up. Also, now complex objects can be constructed, like wells, that can be drinkable but also allow to travel down, or traps that contain items, or (possibly in future) statues that contains item or whatever. Also have planned some major refactoring to do, like extracting all messaging stuff to a Message (or even Event) class, which will take care of proper grammar and thing like that, or extracting Inventory class with simplified slot using interface and belts/wielding/wearing etc.

