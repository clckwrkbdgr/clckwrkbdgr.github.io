Civilisation3 under Linux
=========================

So far I managed to run a Civilization 3: Conquests (v122) version under wine-1.0.1. Debian Squeeze, NVidia driver.

I've encountered and fixed following problems:

1.  Game tries to change resolution on start, and crashes or displays incorrectly. A way to fix this is to add a line to the game's INI-file: `KeepRes=1`. It will allow game to run using current resolution; of course, it will produce playable interface only when desktop resolution &gt;= Civ3's standard one (which, IIRC, is 1024x768).
2.  Opening movie also can corrupt display. And again, a line is to be added: `PlayIntro=0`
3.  Game's internal error 13 means that it couldn't find font file LSANS.FOT, which serves as load helper for LSANS.TTF. The following workaround seems to be fine:

    cp LSANS.TTF LSANS.FOT
    sudo chattr +i LSANS.FOT # So it can't be rewritten or deleted.

Otherwise, installs and runs perfectly, maybe a bit slow though.

**UPD**: There are some sound problems in game: at random time some ambient sounds would just go looping without end. The only solution I've found is to switch sound off and on again.
