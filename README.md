# YI Practice Hack 0.3.0
Practice hack for Yoshi's Island designed to be used on a SNES console
Features:
* Savestates
* Global Menu
* Slowdown
* Music on/off toggle
* Enabling built-in Debug functions

Bug reports highly appreciated!

Supports J 1.0 and U 1.0 versions. I'll add more versions upon request.

Planned features:
* Button configuration
* Room reset

# How to use
### Menu
To enter menu press Start while holding L & R on controller 1 or just press Start on controller 2.
To leave menu press Start on either controller.

Press Up and Down to go between options, B and Y for setting values.

Note, egg editor really only affects your eggs when entering a new level from map screen. Flashing upside down key is the boss key.

### Savestates
Press Select on controller 1 inside a level to save your current state

Press X on controller 1 to load your state. Loading can be done from anywhere (but not always guaranteed to work)
Hold L button while pressing X to do a full load (regenerate all terrain)

*Experimental loading:* if you hold R while loading, it will ignore reloading the level itself. Loading outside of area you saved in will result in issues.
Hookbill and Big Bowser uses this by default, loading outside of the fight itself will cause graphical glitches.

### Warp to Boss Room
Press A+X on controller 2 to warp to that levels Boss Room.

### Music Toggle
Press Select on controller 2 to enable/disable. Note that enabling it makes it play the default track for that level which might not be correct (reload fixes this)

### Free Movement
Press B on controller 2 to enable/disable. Holding A on controller 1 makes you move faster. Yoshi can't collide with terrain in this mode.

### File 3 Complete Save
Hold L or R while entering File 3 to enter a fully unlocked save file. Note that the file 3 save can get strange (copy file over and erase it fixes this)

### Start-Select to clear a level
Hold L while pressing select in pause menu and you'll leave any level as well as mark it as cleared. This doesn't save until you beat a level legit.

### Frame Skip (slow down)
Press R to increase frames to skip per frame (amount of slow down). Press L to decreas. Game will run at 1/n speed where n is frame skip amount. 

### Stage Intro (with the level text)
Stage intro now begins as soon as there's user input (if finished loading).

Hold a button to load level as fast as possible.

### Disable Autoscroll
Press Y on controller 2 to disable an autoscroll.


# How to patch
Open ASAR.exe
Enter "assemble.asm" for patch
Enter your ROM name with file ending

alternatively do "asar.exe assemble.asm your_rom.sfc" through commandline

Or you can be lazy and check the **Releases** for already patched files.
