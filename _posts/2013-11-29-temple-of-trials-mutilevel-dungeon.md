---
layout: default
date: 2013-11-29 09:41:00
title: "Temple of Trials: mutilevel dungeon"
---
![](/images/tot-multilevel.png)

Added some levels in dungeon, so player can walk up and down. Dungeon is permanent, so each visited level is saved when being leaved and restored when being entered. Right now I didn't decided yet, how entering position is determined, so the game just restore player where he was when he left it, at the same position. In case of only one upstairs and only one downstairs it will works fine, so be it for now.  
  
I detached all level data from the Game class, so each Level struct can safely represent whole level and could be as safely stored and restored. The Game class now only does game processing and stuff, and all static functionality like cell or object properties are handled by Level. It also ease saving levels (and visited levels).  
