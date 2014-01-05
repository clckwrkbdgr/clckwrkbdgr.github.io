---
layout: default
date: 2013-11-21 12:35:00
title: Temple of Trials
---
_So. A roguelike-wannabe I'm doing now, Temple of Trials. When it'll be done, it will be a roguelike after Arroyo's Temple of Trials. Have no idea is this idea would look good as a game, but still, I liked that temple a lot. Decided to write it using ["How to Write a Roguelike in 15 Steps"][15-steps] article. Right now it has implemented no time system, no combat, just map of tiles and some monsters moving and bumping (up till step 7)._  

![temple-of-trials](/images/temple-of-trials.png)

Moved to the step 9 (items), skipping step 8 - I don't need data files for now and I don't think I'll need it later. Finally done hitting killing monsters (and player), fixed some console bugs, added builder classes for objects, which made generation a lot easier and more readable. Probably should take care of whole messaging system: some messages are supposed to be one-turn messages, like errors or prompts, so there is no need to store them in the game - they should go as for the next turn. Added items (just money) laying on the floor. Cannot pick them up for now, let them just lay.

[15-steps]: http://roguebasin.roguelikedevelopment.org/index.php?title=How_to_Write_a_Roguelike_in_15_Steps#Step_8_-_Data_files
