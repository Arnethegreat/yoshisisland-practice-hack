save_state:
    PHX
    PHY
    PHP
    REP #$30

; Only save if we're in gamemode 0F
    LDA !gamemode
    CMP #$000F
    BNE .ret
; Check pause flag too (don't wanna save at start-select)
    LDA $0B0F
    BNE .ret

; play 1-up sound for cue that you saved
    LDA #$0008
    STA $0053

    JSR save_inventory
    JSR save_item_memory

    JSR save_yoshi_states
    JSR save_all_sram
    JSR save_some_ram

.save_position
    LDA !current_level
    STA !save_level
    LDA $608C
    STA !save_x_pos
    LDA $6090
    STA !save_y_pos

.ret
    PLP
    PLY
    PLX
    JMP game_mode_return