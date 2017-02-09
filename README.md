# YI Practice Hack 0.2
Practice hack for Yoshi's Island designed to be used on a SNES console
Features:
* Savestates
* Music on/off toggle
* Enabling built-in Debug functions

Bug reports highly appreciated!

Supports J 1.0 and U 1.0 versions. I'll add more versions upon request.

Planned features:
* Button configuration, 
* Simple menu for setting options, 

# How to use
### Savestates
Press Select on controller 1 inside a level to save your current state

Press X on controller 1 to load your state. Loading can be done from anywhere (but not guaranteed to work)
Hold L button while pressing X to do a full load (regenerate all terrain)

Some levels like 6-4 beginning has issues. Try using Full Load for these.

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

### Frame Advance
Press Start on controller 2 to enable/disable frame advance. Press L or R on controller 2 to advance frames. Note however that on-press input is hard to achieve (working on) 

# How to patch
Open ASAR.exe
Enter "assemble.asm" for patch
Enter your ROM name with file ending

alternatively do "asar.exe assemble.asm your_rom.sfc" through commandline

Or you can be lazy and check the **Releases** for already patched files.
