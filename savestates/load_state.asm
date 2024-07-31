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

; blocks needed before load
    JSR load_item_memory
    LDA !level_load_type : CMP #$0002 : BNE + ; quick load only
    JSR load_wram_map16_delta ; mode 0C will update S/VRAM for us
    +

    PLP
    JMP game_loop_continue

.after_load
; First frame after load
    PHP
    REP #$30

..entry
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
    LDA !save_inidisp_mirror : STA !r_reg_inidisp_mirror
    STZ !map16delta_index

    SEP #$20

    LDA !save_level_frames : STA !level_frames
    LDA !save_level_seconds : STA !level_seconds
    LDA !save_level_minutes : STA !level_minutes
    LDA !save_room_frames : STA !room_frames
    LDA !save_room_seconds : STA !room_seconds
    LDA !save_room_minutes : STA !room_minutes

    LDA !load_delay_timer_init : STA !load_delay_timer
    BEQ +
    ; don't run the frame if load delay is active
    PLP
    JMP game_loop_skip
    +

    PLP
    JMP game_loop_continue

preserve_hud: ; HUD settings shouldn't be affected by loading a state
    PHP
    SEP #$20

    LDA !hud_hdma_channels : TRB !r_reg_hdmaen_mirror
    LDA !hud_enabled : BEQ .ret
    JSR init_hud
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
    BEQ .fail_load
    CMP.w #!gm_overworldloading
    BEQ .fail_load

; Check if a savestate exists 
    LDA !savestate_exists
    BNE .test_experimental_state
.fail_load
    LDA.w #!sfx_incorrect : STA !sound_immediate
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
