load_state:
.before_load
; This part will be run just before entering gamemode 0C
    PHX
    PHY
    PHP
    REP #$30

    ; Clear APU I/O to fix audio queue choking up
    STZ $2140
    STZ $2141
    STZ $2142
    STZ $2143

    LDA !save_x_pos
    STA !yoshi_x_pos
    LDA !save_y_pos
    STA !yoshi_y_pos

    ; Hack gamemode to 0E to skip fade-out
    PLP
    PLY
    PLX

    LDA #$0E
    STA $0118
    JMP game_mode_return

.after_load
; First frame after load

    PHX
    PHY
    PHP
    REP #$30

    LDA !save_x_pos
    STA !yoshi_x_pos 
    LDA !save_y_pos
    STA !yoshi_y_pos 

    JSR load_yoshi_states
    JSR load_all_sram
    JSR load_some_ram

    PLP
    PLY
    PLX
    JMP game_mode_return

prepare_load:
    PHX
    PHY
    PHP
    REP #$30

; Do some checks for already loading game modes
    LDA !gamemode
    CMP #$000B
    BEQ .ret
    CMP #$000C
    BEQ .ret

    JSR load_inventory
    JSR load_item_memory

; Flag for us to use later
    LDA #$0002
    STA !loaded_state

; Screen zero
    STZ !current_screen

.handle_load_type
    LDA !current_level
    CMP !save_level
    BNE .different_level
; override fast load if user is pressing L
    LDA !controller_data1
    AND #$0020
    BNE .different_level

.same_level
    LDA #$0002
    STA !level_load_type

    BRA .ret
.different_level
    LDA #$0001
    STA !level_load_type

    LDA !save_level
    STA !screen_exit_level 


    LDA !save_x_pos
    CLC
    ADC #$0008
    LSR A
    LSR A
    LSR A
    LSR A
    STA !screen_exit_xpos
    LDA !save_y_pos
    CLC
    ADC #$0008
    LSR A
    LSR A
    LSR A
    LSR A
    STA !screen_exit_ypos

.ret
    LDA #$000C
    STA !gamemode

    PLP
    PLY
    PLX
    JMP game_mode_return