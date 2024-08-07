# YI Practice Hack 0.4.4
Practice hack for Yoshi's Island designed to be used on a SNES console

Features:
* Savestates
* Re-zone to last room/level
* Debug Menu
* HUD
* Warp to (almost) any room entrance
* Egg editor
* Frame advance/slowdown
* Music on/off toggle
* Removal of slow score screen and world map animations
* Enabling built-in Debug functions
* Button configuration

and more.

Bug reports highly appreciated!

Supports J1.0 and U1.0 versions.


# How to patch
Acquire a Yoshi's Island `J1.0` and/or `U1.0` ROM.

Then, check the latest [**Releases**](https://github.com/Arnethegreat/yoshisisland-practice-hack/releases) for `.bps` patches, which you can apply to your clean ROMs with a patcher such as [**flips**](https://github.com/Alcaro/Flips/releases) or [**beat**](https://www.romhacking.net/utilities/893).


# How to use
### Debug Menu
To enter menu press Start while holding L & R on controller 1 or just press Start on controller 2.
To leave menu press Start on either controller.

Use the d-pad to navigate, B to go back, and Y/A to select options and set values.

### HUD
The heads-up display can be toggled on/off from the menu. It may cause some minor graphical glitches when enabled.
It displays:

Column 1 | Column 2 | Column 3 | Column 4 | Column 5
:------: | :------: | :------: | :------: | :------:
Yoshi's horizontal velocity | Red coin amount | Stars amount | Level timer | 
Most recent egg-aiming angle | Amount of sprites loaded | Flowers amount | Room timer | Input display
Miscellaneous data | RAM watch | | Lag frame counter | 

The misc. data only appear in certain rooms, showing:
* Prince Froggy's damage value during the fight
* A trainer for the rockless key clip in 6-6
  * `[tongue frame | jump frame | move left frame | unused]`

    The values indicate how early or late the input was, with 8 being frame-perfect (e.g. `8880`)
    - starting from the left corner, begin holding right
    - press tongue after 49 frames
    - press jump after 3 frames
    - stop holding right and start holding left after 6 frames

RAM watch reads from an arbitrary little-endian address set from the debug menu. The read value appears in the indicated HUD position when the address is set to a value other than `$000000`.

---

If Yoshi's egg inventory contains a non-standard sprite (either by null egg manipulation, or via the debug menu editor), then the HUD will display different data:

Column 1 | Column 2 | Column 3 | Column 4 | Column 5
:------: | :------: | :------: | :------: | :------:
Yoshi's horizontal velocity | Yoshi x position | Yoshi x subpixel | Level timer | 
Most recent egg-aiming angle | Amount of sprites loaded | BG3 vertical offset | Room timer | Input display
Miscellaneous data | RAM watch | | Lag frame counter | 

> [!NOTE]
> The HUD data are currently only switched when visiting the world map.

### Egg Editor
Use A/Y to cycle the sprite in the selected, loaded slot. The previous/next eggs in the cycle are displayed beside the cursor.
Current supported sprites:
- Green/yellow/red/flashing eggs
- Green/red giant eggs
- Key
- **NON-STANDARD** - boss key (flashing upside-down key), boss explosion, seesaw log, skull mouser
- Chicken

### Savestates
Save your current state while in a level.

Normal (fast) load: works while in the same level as the savestate. Restores changes made to terrain. Certain tiles such as sand may appear visually incorrect, but should still be functional.
Full load: re-loads the room, regenerates all terrain. This can be toggled to the opposite in menu.

Loading can be done from anywhere (but not always guaranteed to work).
An after-load delay can be set from the debug menu. The byte value indicates the number of frames the game will be paused for when a savestate is finished loading.

### Re-zone
Reset to your last room or level entrance depending on the "RE-ZONE LEVEL" menu option. Your eggs are saved.

### Music Toggle
Enable/disable music (sound effects play as normal).

### Free Movement
Enable noclip. Holding A on controller 1 makes you move faster. Yoshi can't collide with terrain in this mode.

### File 3 Complete Save
Hold L or R while entering File 3 to enter a fully unlocked save file. Note that the file 3 save can get strange (copy file over and erase it fixes this)
Warping before selecting a file will automatically load this save file.

### Start-Select to clear a level
Hold L while pressing select in pause menu and you'll leave any level as well as mark it as cleared. This doesn't save until you beat a level legit.

### Frame Skip
Increase or decrease frames to skip per frame (amount of slow down). Game will run at 1/n speed where n is slowdown amount. 
Frame advance mode pauses the game and advances a single frame each time the frame advance input bind is triggered thereafter. It can be disabled via the menu option or by using a bind to change the slow down value. Inputs are buffered in between frames.

### Stage Intro (with the level text)
Stage intro now begins as soon as there's user input (if finished loading).

Hold any button to load level as fast as possible.

### Disable Autoscroll
Frees the camera if used during an autoscroller.

### Force Hasty
Sets the control scheme to hasty while enabled, otherwise, the controls can be changed in-game as usual.

### Soft Reset
Hold `L+R+Start+Select` on controller 1 for 32 frames to reset the game. This can be useful if you have configured the SD2SNES to load when resetting with the console button, for example.

### Button Configuration
Practice functions can be bound to combinations of buttons on both controllers.
- Press X to remove a binding.
- Press A to start recording a binding.
- Once recording begins, press and hold the desired buttons **in sequential order**, then release them to stop recording.
- The last button in the sequence is the final trigger, meaning you must hold the other buttons (in any order) and then press the last one to trigger the function.
- This also means that you should avoid pressing more than one button on a frame when recording.
- Bindings must be unique for a given function and controller, e.g. you can't bind X on controller 1 to both Save and Load.
- Note that bindings for controller 2 are recorded using controller 1.

The default bindings are shown below, and may be restored at any time by selecting "reset default":

Controller 1 | Controller 2 | Function
:------: | :------: | :------
Select | - | Save
X | - | Load
L+X | - | Load full
R+X | - | Re-zone
\- | Select | Toggle music
\- | B | Free movement
\- | L | Slowdown decrease
\- | R | Slowdown increase
\- | A | Frame advance
\- | Y | Disable autoscroll


# How to assemble manually
First, clone this repo.

This project uses the [**asar**](https://github.com/RPGHacker/asar) assembler, so download it if you need to.

Run `asar.exe assemble.asm path/to/your_rom.sfc` from the root directory to apply the patch.
> [!WARNING]
> This will overwrite the clean ROM.

Alternatively, place the clean ROM(s) you wish to patch into the `ROMs/` dir (they should be called `JP_clean.sfc` for `J1.0` and `NA_clean.sfc` for `U1.0`)
then run `build.sh` or `build.bat` with no args to build both, or `U` or `J`. The build scripts preserve the clean ROMs by copying them before patching.
