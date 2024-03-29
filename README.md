# YI Practice Hack 0.4.1
Practice hack for Yoshi's Island designed to be used on a SNES console
Features:
* Savestates
* Room Reset
* Debug Menu
* HUD
* Warp to (almost) any room entrance
* Egg editor
* Slowdown
* Music on/off toggle
* Removal of slow world map animations
* Enabling built-in Debug functions

Bug reports highly appreciated!

Supports J1.0 and U1.0 versions.

Planned features:
* Button configuration

# How to use
### Debug Menu
To enter menu press Start while holding L & R on controller 1 or just press Start on controller 2.
To leave menu press Start on either controller.

Press Up and Down to go between options, B and Y for setting values.

N.B. The flashing upside down key in the egg editor is the boss key.

### HUD
The heads-up display can be toggled on/off from the menu. It may cause some minor graphical glitches when enabled.
It displays:
Column 1 | Column 2 | Column 3 | Column 4 | Column 5
-------- | -------- | -------- | -------- | --------
Yoshi's horizontal velocity | Red coin amount | Stars amount | Level timer | 
Most recent egg-aiming angle | Amount of sprites loaded | Flowers amount | Room timer | Input display
Miscellaneous data | | | Lag frame counter | 

The misc data only appears in certain rooms. Currently, it's just used to show Prince Froggy's damage value.

If Yoshi's egg inventory contains a non-standard sprite (either by null egg manipulation, or via the debug menu editor), then the HUD will display different data:
Column 1 | Column 2 | Column 3 | Column 4 | Column 5
-------- | -------- | -------- | -------- | --------
Yoshi's horizontal velocity | Yoshi x position | Yoshi x subpixel | Level timer | 
Most recent egg-aiming angle | Amount of sprites loaded | BG3 vertical offset | Room timer | Input display
Miscellaneous data | | | Lag frame counter | 

N.B. The HUD data are currently only switched when visiting the world map.

### Egg Editor
Use A/Y to cycle the sprite in the selected, loaded slot.
Current supported sprites:
- Green/yellow/red/flashing eggs
- Green/red giant eggs
- Key
- **NON-STANDARD** - boss key, boss explosion, seesaw log, skull mouser
- Chicken

### Savestates
Press Select on controller 1 inside a level to save your current state

Press X on controller 1 to load your state. Loading can be done from anywhere (but not always guaranteed to work)
Hold L button while pressing X to do a full load (regenerate all terrain). This can be toggled to the opposite in menu.

### Room Reset
Hold R while loading to reset to your last entrance. Your eggs and item memory is saved.

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
Place clean ROM(s) you wish to patch into the ROMs/ dir - they should be called `JP_clean.sfc` for `J1.0` and `NA_clean.sfc` for `U1.0`.
Run `build.sh` or `build.bat` with no args to build both, or `U` or `J`.

Alternatively, run `asar.exe assemble.asm your_rom.sfc`.

Or you can check the **Releases** for `.bps` patches, which you can apply to your clean ROMs with the beat patcher utility.
