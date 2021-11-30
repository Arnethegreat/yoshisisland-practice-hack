@includeonce

; $7E WRAM freespace
; range       bytes
; $0000-$0030 48    (scratch)
; $00CC-$0101 53    (wiped every loading screen)
; $026A-$02B8 78
; $1409-$19D9 1488
; $1E00-$2140 832   (only first 512 bytes are mirrored - up to $1FFF)
; $2340-$4000 7360  (first 3KB used for savestate data)
; $B8E2-$C000 1822  (debug menu tilemap buffer)

; almost the first half of bank $7F is used for savestate data

; $70 SRAM freespace
; range       bytes
; $7800-$7C00 1024  (cleared on boot/file select)
; $7E7E-$8000 386


macro def_var(id, size, region)
	!<id> := !freeram_<region>+!freeram_<region>_used
	!freeram_<region>_used #= !freeram_<region>_used+<size>
endmacro


!freeram_026A = $026A
!freeram_026A_used = 0
!freeram_026A_max = $02B8
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
!freeram_1E00_max = $2000 ; stop at the end of the mirror
macro var_1E00(id, size)
	%def_var(<id>, <size>, 1E00)
endmacro

!freeram_707E7E = $707E7E
!freeram_707E7E_used = 0
!freeram_707E7E_max = $708000
macro var_707E7E(id, size)
	%def_var(<id>, <size>, 707E7E)
endmacro


incsrc variables/game_vars.asm
incsrc variables/sprite_table_vars.asm
incsrc variables/reg_vars.asm
incsrc variables/debug_vars.asm
incsrc variables/savestate_vars.asm
incsrc variables/hud_vars.asm


assert !freeram_026A+!freeram_026A_used < !freeram_026A_max, "exceeded WRAM freespace region $7E:026A"
assert !freeram_1409+!freeram_1409_used < !freeram_1409_max, "exceeded WRAM freespace region $7E:1409"
assert !freeram_1E00+!freeram_1E00_used < !freeram_1E00_max, "exceeded WRAM freespace region $7E:1E00"
assert !freeram_707E7E+!freeram_707E7E_used < !freeram_707E7E_max, "exceeded SRAM freespace region $70:7E7E"

if 0
    print "freespace $026A used: "
    print dec(!freeram_026A_used)
    print "freespace $1409 used: "
    print dec(!freeram_1409_used)
    print "freespace $1E00 used: "
    print dec(!freeram_1E00_used)
    print "freespace $707E7E used: "
    print dec(!freeram_707E7E_used)
endif
