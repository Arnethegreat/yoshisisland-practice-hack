; hijack at level load where it actually has the current save_current_area
; saving value because game never saves it while in level

org save_current_area            
    autoclean JSL set_level

freespacebyte $FF
freecode

set_level:
; saves stuff for room reset function
    ; this is called when entering a sublevel normally, and also when loading a savestate with full load
    ; in the latter case, we need to update the current sublevel ID, as we might be loading from another sublevel
    ; don't store any other data, because loading a room via savestate is not the same as loading it traditionally
    ; room reset should only respect normal gameplay and ignore savestate tomfoolery
    LDY !loaded_state
    CPY #$0001
    BEQ .skip
    STA !last_exit_1
    PHA
    LDA $7F7E02,x
    STA !last_exit_2

    LDA !level_load_type
    STA !last_exit_load_type

    LDA !red_coin_count
    STA !last_exit_red_coins
    LDA !star_count
    STA !last_exit_stars
    LDA !flower_count
    STA !last_exit_flowers

    LDA !item_mem_current_page
    STA !last_exit_item_page

    PHX
    LDX #$000C
    .save_eggs
        LDA !egg_inv_size,x
        STA !last_exit_eggs,x
        DEX
        DEX
        BPL .save_eggs

    PLX

    PLA
.skip
    AND #$00FF
    STA !current_level
    ASL A
.ret
    RTL
