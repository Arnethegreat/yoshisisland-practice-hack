; hijack at level load where it actually has the current save_current_area
; saving value because game never saves it while in level

org save_current_area            
    autoclean JSL set_level

freecode $FF

set_level:
; saves stuff for room reset function
    ; if loading from state with full load, don't store anything cos it'll break room reset
    LDY !loaded_state
    CPY #$0001
    BNE +
    AND #$00FF
    ASL A
    BRA .ret
+
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
    AND #$00FF
    STA !current_level
    ASL A
.ret
    RTL
