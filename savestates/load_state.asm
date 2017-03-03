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

; blocks needed before load
    JSR load_item_memory

    PLP
    PLY
    PLX
    ; Hack gamemode to 0E to skip fade-out for next frame
    LDA #$0E
    STA $0118
    ; really hacky fix to avoid gamemode being written over from previous frame
    ; sets this frame mode to 0C
    LDX #$24
    JMP game_mode_return

.after_load
; First frame after load

    PHX
    PHY
    PHP
    REP #$30

..entry
    LDA !save_x_pos
    STA !yoshi_x_pos 
    LDA !save_y_pos
    STA !yoshi_y_pos


; Turn off screen while loading
    LDA $0200
    ORA #$0080
    STA $0200

    STZ !level_load_type

    JSR load_sram_block_00
    JSR load_sram_block_01
    JSR load_sram_block_02
    JSR load_sram_block_03
    JSR load_sram_block_04

    JSR load_wram_block_00
    JSR load_wram_block_01
    JSR load_wram_block_02
    JSR load_wram_block_03

    JSR load_dyntile_buffer
; check if in cross section and empty BG3 if so
    JSR fix_cross_section

    JSR load_dma_channel_settings

; Re-enable screen when finished loading
    LDA $0200
    AND #$FF7F
    STA $0200

    PLP
    PLY
    PLX
    JMP game_mode_return

;=================================

prepare_load:
    PHX
    PHY
    PHP
    REP #$30

; Do some checks for already loading game modes
    LDA !gamemode
    CMP #$000C
    BEQ .in_loading_mode
    CMP #$0020
    BEQ .in_loading_mode
    BRA .check_savestate
.in_loading_mode
    BRA .fail_load

.check_savestate
; Check if a savestate exists 
    LDA !savestate_exists
    BNE .test_experimental_state
.fail_load
    LDA #$0090
    STA $0053
    JMP .no_load

.test_experimental_state
; experimental states
    JSR fix_special_bosses
; if we're in hookbill/bowser, do experimental load
    BCS .experimental_load

; if user is holding R, do room reset of last room
.test_reset_room
    LDA !controller_data1
    AND #$0010
    BEQ .continue
    JSR load_last_exit
    JMP .no_load

.experimental_load
    LDA !gamemode
; Only allow experimental load for certain gamemodes
; mainly in-level, death and retry screen
    CMP #$000F
    BEQ +
    CMP #$0011
    BEQ +
    CMP #$0035
    BEQ +
    CMP #$0012
    BEQ +
    CMP #$003D
    BEQ +
    BRA .fail_load
+
    JSR load_sram_map16
    JMP load_state_after_load_entry

.continue
; Flag for us to use later
    LDA #$0002
    STA !loaded_state

; zero load type
    STZ !level_load_type

; Screen zero
    STZ !current_screen

.handle_load_type
    LDA !current_level
    CMP !save_level
    BNE .different_level

; override fast load if user is pressing L
    LDA !controller_data1
    EOR !full_load_default
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
    STZ $35
    STZ $37
    STZ $093C
    STZ $093E
.no_load
    PLP
    PLY
    PLX
    JMP game_mode_return

;=================================
; restore data from last exit and load
;

item_memory_page_pointers:
  dw $03C0, $0440, $04C0, $0540

load_last_exit:
    PHB

    PHK
    PLB

    ; word sized
    LDA !last_exit_1
    STA !screen_exit_level
    LDA !last_exit_2
    STA !screen_exit_ypos

    LDA !last_exit_load_type
    STA !level_load_type

    LDA !last_exit_red_coins
    STA !red_coin_count
    LDA !last_exit_stars
    STA !star_count
    LDA !last_exit_flowers
    STA !flower_count

    STZ !current_screen
    LDX #$000C
    .restore_eggs
        LDA !last_exit_eggs,x
        STA !egg_inv_size,x
        DEX
        DEX
        BPL .restore_eggs

    LDA !item_mem_current_page
    ASL A
    TAX
    LDA item_memory_page_pointers,x
    STA $00
; TODO: save and restore item memory? 
    LDY #$0080
    .nuke_item_memory
        LDA #$0000
        STA ($00),y
        DEY
        DEY
        BPL .nuke_item_memory

    LDA #$000B
    STA !gamemode
.ret
    PLB
    RTS