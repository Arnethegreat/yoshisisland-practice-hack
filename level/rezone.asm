rezone:
    PHP
    %a8()

    ; check if level or room reset
    LDA !zone_reset_flag : BEQ +
    JSR reload_current_level
    BRA ++
    +
    JSR load_last_exit
    ++
    JSR set_yoshi_colour
    STZ !hud_displayed ; temporarily hide HUD in order to prevent lag on level intro
    STZ !r_level_music_playing ; so that music gets loaded
.ret
    PLP
    RTS

item_memory_page_pointers:
  dw $03C0, $0440, $04C0, $0540

load_last_exit:
    PHP
    %a16()
    %i8()

    ; set up the warp to the last exit
    LDA !last_exit_1 : STA !screen_exit_level
    LDA !last_exit_2 : STA !screen_exit_ypos
    STZ !current_screen
    LDA !last_exit_load_type : STA !level_load_type ; room entrance or level intro

    ; restore collectible counts
    LDA !last_exit_red_coins : STA !red_coin_count
    LDA !last_exit_stars : STA !star_count
    LDA !last_exit_flowers : STA !flower_count

    JSR calc_level_timer

    ; restore eggs
    LDX #$0C
    -
        LDA !last_exit_eggs,x : STA !egg_inv_size,x
        DEX #2
        BPL -

    ; restore in-level collectible items (stars, red coins, etc.)
    LDA !item_mem_current_page : ASL : TAX
    LDA item_memory_page_pointers,x : STA $00
    LDY #$7E
    -
        LDA !last_exit_item_mem_backup,y : STA ($00),y
        DEY #2
        BPL -

    LDA.w #!gm_levelfadeout : STA !gamemode
.ret
    PLP
    RTS

reload_current_level:
    PHP
    %a16()
    %i8()

    ; set up the warp to the beginning of the current stage
    LDA !current_level : STA !screen_exit_level
    STZ !current_screen
    STZ !level_load_type ; start of level flag

    ; reset collectible counts
    STZ !red_coin_count
    STZ !star_count
    STZ !flower_count

    ; restore eggs to whatever they were the last time a stage was started
    LDX #$0C
    -
        LDA !last_level_eggs_size,x : STA !egg_inv_size,x
        DEX #2
        BPL -

    LDA.w #!gm_levelfadeout : STA !gamemode
.ret
    PLP
    RTS

; reset the HUD level timer to whatever it was when entering the room by subtracting the room timer
calc_level_timer:
    PHP
    %a8()

    ; first, subtract RF from LF
    LDA !level_frames : SEC : SBC !room_frames
    ; if carry bit set, no underflow occurred, proceed
    BCS +
    ; else, add 60, decrement LS
    CLC : ADC #60
    DEC !level_seconds
    +
    STA !level_frames

    ; second, subtract RS from LS
    LDA !level_seconds : SEC : SBC !room_seconds
    ; if carry bit set, no underflow occurred, proceed
    BCS +
    ; else, add 60, decrement LM
    CLC : ADC #60
    DEC !level_minutes
    +
    STA !level_seconds

    ; finally, subtract RM from LM
    LDA !level_minutes : SEC : SBC !room_minutes : STA !level_minutes
.ret
    PLP
    RTS
