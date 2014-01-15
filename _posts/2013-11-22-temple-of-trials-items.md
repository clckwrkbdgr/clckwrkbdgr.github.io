---
layout: default
date: 2013-11-22 17:25:00
title: "Temple of Trials: items"
---
[![tot-items][tot-items-thumb]] [tot-items]

Implemented items, inventories, picking/dropping items, dropping loot by monsters after death. Also containers (your standard pot), added scorpion with tail for tests. Monsters has hit strength, items has damage value. Now anyone can wield items, and item's damage will counts as one's damage. I.e. if player hit strength was 3 and he picks up spear [dmg=5] then it's current damage in combat equals 5, not 8. Not sure if this works well, but in original game unarmed hit damage differs from melee damage a lot. Wearing and throwing are left to implement in current step 9.  
  
Also refactored savefile routines, finally made it not to look like shit. Templates and C++ type system is one, though, so had need to use macros, unfortunately. Still, looks pretty good and solid.  
  
[tot-items]: /images/tot-items.png
[tot-items-thumb]: /thumbs/tot-items.png
