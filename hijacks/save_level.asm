; hijack at level load where it actually has the current save_current_area
; saving value because game never saves it while in level

!current_level = $1410

org save_current_area            
    autoclean JSL set_level

freecode $FF

set_level:
    STA !current_level
    AND #$00FF
    ASL A
    RTL