load_state:
.before_load
; This part will be run just before entering gamemode 0C
    PHP
    %a8()

    ; force blank on
    LDA #%10000000 : TSB !r_reg_inidisp_mirror

    ; Clear APU I/O to fix audio queue choking up
    STZ !reg_apu_port0
    STZ !reg_apu_port1
    STZ !reg_apu_port2
    STZ !reg_apu_port3

    %ai16()

    LDA !save_x_pos
    STA !yoshi_x_pos
    LDA !save_y_pos
    STA !yoshi_y_pos

; blocks needed before load
    JSR load_item_memory

    PLP
    JMP game_loop_continue

.after_load
; First frame after load
    PHP
    REP #$30

..entry
    LDA !save_x_pos
    STA !yoshi_x_pos 
    LDA !save_y_pos
    STA !yoshi_y_pos

    STZ !level_load_type

    ; prevent the slowdown setting from being overwritten
    LDA !slowdown_mag : PHA

    JSR load_ram ; note that this loads the saved !gamemode, which will be $0F
    JSR load_dyntile_buffer
; check if in cross section and empty BG3 if so
    JSR fix_cross_section
    JSR load_dma_channel_settings
    JSR preserve_hud

    PLA : STA !slowdown_mag

    LDA !save_lag_counter : STA !lag_counter

    SEP #$20

    LDA !save_level_frames : STA !level_frames
    LDA !save_level_seconds : STA !level_seconds
    LDA !save_level_minutes : STA !level_minutes
    LDA !save_room_frames : STA !room_frames
    LDA !save_room_seconds : STA !room_seconds
    LDA !save_room_minutes : STA !room_minutes

    LDA !load_delay_timer_init : STA !load_delay_timer

; Re-enable screen when finished loading
    LDA #%10000000 : TRB !r_reg_inidisp_mirror

    PLP
    JMP game_loop_continue

preserve_hud: ; HUD settings shouldn't be affected by loading a state
    PHP
    SEP #$20

    LDA !hud_hdma_channels : TRB !r_reg_hdmaen_mirror
    LDA !hud_enabled
    BEQ .ret
    JSR level_room_init_common
.ret
    PLP
    RTS

;=================================

prepare_load:
    PHP
    REP #$30

; Do some checks for already loading game modes
    LDA !gamemode
    CMP.w #!gm_levelloading
    BEQ .in_loading_mode
    CMP.w #!gm_overworldloading
    BEQ .in_loading_mode
    BRA .test_reset_room
.in_loading_mode
    BRA .fail_load

.test_reset_room
    LDA !load_mode
    AND #$0002
    BEQ .check_savestate
    JSR load_last_exit
    JMP .no_load

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
    BCC .continue

.experimental_load
    LDA !gamemode
; Only allow experimental load for certain gamemodes
; mainly in-level, death and retry screen
    CMP.w #!gm_level
    BEQ +
    CMP.w #!gm_death
    BEQ +
    CMP.w #!gm_midringrestart
    BEQ +
    CMP.w #!gm_starlessdeath
    BEQ +
    CMP.w #!gm_retry
    BEQ +
    BRA .fail_load
+
    JSR load_sram_map16
    LDA #$0001 : STA !loaded_state
    BRA .no_load

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

    ; mode 1 = full load binding triggered, but if fullloaddefault then we want to do the opposite, effectively mode 0
    LDA !load_mode
    EOR !full_load_default
    AND #$0001
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
    LDA.w #!gm_levelloading
    STA !gamemode
    STZ $35
    STZ $37
    STZ $093C
    STZ $093E
    PLP
    RTS
.no_load
    PLP
    RTS

;=================================
; restore data from last exit and load
;

item_memory_page_pointers:
  dw $03C0, $0440, $04C0, $0540

load_last_exit:
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

    JSR calc_level_timer

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
    LDY #$007E
    .restore_item_memory
        LDA !last_exit_item_mem_backup,y
        STA ($00),y
        DEY
        DEY
        BPL .restore_item_memory

    LDA #$0001
    STA !last_exit_loading_flag

    LDA.w #!gm_levelfadeout
    STA !gamemode
.ret
    RTS

calc_level_timer: ; reset the HUD level timer to whatever it was when entering the room by subtracting the room timer
    PHP
    SEP #$20

    ; first, subtract RF from LF
    LDA !level_frames
    SEC
    SBC !room_frames
    ; if carry bit set, no underflow occurred, proceed
    BCS +
    ; else, add 60, decrement LS
    CLC
    ADC #60
    DEC !level_seconds
+
    STA !level_frames

    ; second, subtract RS from LS
    LDA !level_seconds
    SEC
    SBC !room_seconds
    ; if carry bit set, no underflow occurred, proceed
    BCS +
    ; else, add 60, decrement LM
    CLC
    ADC #60
    DEC !level_minutes
+
    STA !level_seconds

    ; finally, subtract RM from LM
    LDA !level_minutes
    SEC
    SBC !room_minutes
    STA !level_minutes

.ret
    PLP
    RTS
