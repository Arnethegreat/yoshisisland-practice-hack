includeonce

; $7E WRAM freespace
; range(inc)   bytes  notes
; $0000-$002F  48     scratch
; $00CC-$0100  53     wiped every loading screen
; $026A-$02B7  78
; $1409-$19D9  1488
; $19DA-$1DFF  1063   !undocumented mystery bytes not on the disassembly wiki!
; $1E00-$213F  832    only first 512 bytes are mirrored - up to $1FFF
; $2140-$233F  512    !undocumented mystery bytes not on the disassembly wiki!
; $2340-$3FFF  7360   first 3KB used for savestate data
; $40BA-$47FF  1862   VRAM tilemap DMA queue region @ $4002 uses max 182 bytes in vanilla; rest is effectively free
; $499C-$503F  1700   general-purpose DMA queue region @ $4802 uses max 406 bytes in vanilla; rest is effectively free
; $B8E2-$BFFF  1822   debug menu tilemap buffer

; almost the first half of bank $7F is used for savestate data

; $70 SRAM freespace
; range        bytes
; $7800-$7BFF  1024   cleared on boot/file select - not useful for persistent data
; $7E7E-$7FFF  386

!DEBUG_VARS = 0 ; set to 1 when defining variables to print debug info

macro def_var(id, size, region)
	!<id> := !freeram_<region>+!freeram_<region>_used
	!freeram_<region>_used #= !freeram_<region>_used+<size>
	if !DEBUG_VARS
		print "ID: <id>, region: <region>, size: $", hex(<size>)
		print "!", "<id> = $", hex(!<id>)
	endif
endmacro


!freeram_026A = $026A
!freeram_026A_used = 0
!freeram_026A_max = $02B7
macro var_026A(id, size)
	%def_var(<id>, <size>, 026A)
endmacro

!freeram_1409 = $1409
!freeram_1409_used = 0
!freeram_1409_max = $19D9
macro var_1409(id, size)
	%def_var(<id>, <size>, 1409)
endmacro

!freeram_1E00 = $1E00
!freeram_1E00_used = 0
!freeram_1E00_max = $1FFF ; stop at the end of the mirror
macro var_1E00(id, size)
	%def_var(<id>, <size>, 1E00)
endmacro

!freeram_7E40BA = $7E40BA
!freeram_7E40BA_used = 0
!freeram_7E40BA_max = $7E47FF
macro var_7E40BA(id, size)
	%def_var(<id>, <size>, 7E40BA)
endmacro

!freeram_7E499C = $7E499C
!freeram_7E499C_used = 0
!freeram_7E499C_max = $7E503F
macro var_7E499C(id, size)
	%def_var(<id>, <size>, 7E499C)
endmacro

!freeram_707E7E = $707E7E
!freeram_707E7E_used = 0
!freeram_707E7E_max = $707FFF
macro var_707E7E(id, size)
	%def_var(<id>, <size>, 707E7E)
endmacro


incsrc variables/game_vars.asm
incsrc variables/sprite_table_vars.asm
incsrc variables/reg_vars.asm
incsrc variables/debug_vars.asm
incsrc variables/savestate_vars.asm
incsrc variables/hud_vars.asm


assert !freeram_026A+!freeram_026A_used <= !freeram_026A_max+1, "exceeded WRAM freespace region $7E:026A"
assert !freeram_1409+!freeram_1409_used <= !freeram_1409_max+1, "exceeded WRAM freespace region $7E:1409"
assert !freeram_1E00+!freeram_1E00_used <= !freeram_1E00_max+1, "exceeded WRAM freespace region $7E:1E00"
assert !freeram_7E40BA+!freeram_7E40BA_used <= !freeram_7E40BA_max+1, "exceeded WRAM freespace region $7E:40BA"
assert !freeram_7E499C+!freeram_7E499C_used <= !freeram_7E499C_max+1, "exceeded WRAM freespace region $7E:499C"
assert !freeram_707E7E+!freeram_707E7E_used <= !freeram_707E7E_max+1, "exceeded SRAM freespace region $70:7E7E"

if 0
    print "freespace $7E026A used: ", dec(!freeram_026A_used), ", remaining: ", dec(!freeram_026A_max-!freeram_026A_used-!freeram_026A+1)
    print "freespace $7E1409 used: ", dec(!freeram_1409_used), ", remaining: ", dec(!freeram_1409_max-!freeram_1409_used-!freeram_1409+1)
    print "freespace $7E1E00 used: ", dec(!freeram_1E00_used), ", remaining: ", dec(!freeram_1E00_max-!freeram_1E00_used-!freeram_1E00+1)
    print "freespace $7E40BA used: ", dec(!freeram_7E40BA_used), ", remaining: ", dec(!freeram_7E40BA_max-!freeram_7E40BA_used-!freeram_7E40BA+1)
    print "freespace $7E499C used: ", dec(!freeram_7E499C_used), ", remaining: ", dec(!freeram_7E499C_max-!freeram_7E499C_used-!freeram_7E499C+1)
    print "freespace $707E7E used: ", dec(!freeram_707E7E_used), ", remaining: ", dec(!freeram_707E7E_max-!freeram_707E7E_used-!freeram_707E7E+1)
endif
