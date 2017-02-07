# YI Practice Hack
Practice hack for Yoshi's Island designed to be used on a SNES console
Includes savestates so far

Bug reports highly appreciated!

Supports J 1.0 and U 1.0 versions. I'll add more versions upon request.

Planned features:
Button configuration, 
Simple menu for setting options, 
Frame Advance, 
Full Save Clear on go, 
Free Movement debug mode, 

# How to use
Press Select on controller 1 inside a level to save your current state

Press X on controller 1 to load your state. Loading can be done from anywhere (but not guaranteed to work)
Hold L button while pressing X to do a full load (regenerate all terrain)

# How to patch
Open ASAR.exe
Enter "assemble.asm" for patch
Enter your ROM name with file ending

alternative do "asar.exe assemble.asm your_rom.sfc" through commandline
