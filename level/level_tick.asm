; ~~~ performance critical code ~~~
; (if anything looks strange, it's because of that [and/or because I suck])

level_tick:
    PHP
    PHB
    PHK
    PLB

    LDA !debug_control_scheme : TSB !s_control_scheme ; hacky, just set force hasty every frame

    %a16()

    JSR tick_timers

    LDY !hud_displayed : BEQ .ret

    JSR count_active_sprites
    JSR display_common
    JSR display_input
    LDY !null_egg_mode_enabled
    BNE +
    JSR display_items
    BRA ++
+
    JSR display_nullegg
++

    LDA !ramwatch_addr : ORA !ramwatch_addr+1 : ORA !ramwatch_addr+2
    BEQ + ; don't show when set to $000000
    JSR display_ramwatch
    +

    JSR display_misc

.ret
    PLB
    PLP
    RTL

display_common:
    REP #$20
    LDA !yoshi_x_speed
    LDY #$02
    JSR print_16_abs

    ; egg aiming angle
    LDA !s_egg_cursor_angle
    LDY #$42
    JSR print_16

    ; room lag (3 digits)
    LDA !lag_counter
    LDY #$A4
    JSR print_16
    SEP #$20
    LDA #$3F : STA !hud_buffer+$A4 ; hide the leftmost digit

    ; sprite count
    LDA !active_sprites
    LDY #$4E
    JSR print_8_dec

    ; level timer
    LDA !level_minutes : STA !hud_buffer+$1E
    LDA !level_seconds
    LDY #$22
    JSR print_8_dec
    LDA !level_frames
    LDY #$28
    JSR print_8_dec

    ; room timer
    LDA !room_minutes : STA !hud_buffer+$5E
    LDA !room_seconds
    LDY #$62
    JSR print_8_dec
    LDA !room_frames
    LDY #$68
    JSR print_8_dec

    ; clock thingy
    LDY #$34
    LDA !total_frames
    AND #$20
    BEQ .draw_clock
    LDY #$3F
.draw_clock
    STY !hud_buffer+$1C
    RTS

display_items:
    SEP #$20

    ; red coins
    LDA !red_coin_count
    LDY #$0E
    JSR print_8_dec

    ; stars
    SEP #$20
    LDA $03A1 ; first digit of star counter
    STA !hud_buffer+$16
    LDA $03A3 ; second digit of star counter
    STA !hud_buffer+$18

    ; flowers
    LDA !flower_count
    LDY #$56
    JSR print_8_dec
    RTS

display_ramwatch:
    %a16()
    PHD
    LDA #!ramwatch_addr : TCD
    LDA [$00]
    PLD
    LDY #$8E
    JSR print_16
.ret
    RTS

display_nullegg:
    REP #$20

    ; clear some previously used hud tiles, where the icons used to be
    LDA #$303F
    STA !hud_buffer+$0C
    STA !hud_buffer+$14
    STA !hud_buffer+$54

    ; yossy x pos
    LDA !yoshi_x_pos
    LDY #$0C
    JSR print_16

    ; bg3 y pos
    LDA !s_camera_layer3_y
    LDY #$54
    JSR print_16

    SEP #$20

    ; yossy x subpixel
    LDA !yoshi_x_subpixel
    LDY #$16
    JSR print_8

    RTS

display_misc:
    REP #$20
    LDA !s_spr_id+$5C
    CMP #$0045
    BNE +

    ; Prince Froggy current damage
    LDA $7A94
    LDY #$82
    JSR print_16
    BRA .ret
+
    LDA !current_level
    AND #$00FF
    CMP #$0032 ; 6-6
    BNE .ret
    JSR rockless_trainer
    LDA !trainer_result
    LDY #$82
    JSR print_16
.ret
    RTS

macro display_input_btn(buffer_offset, pressed_value)
    LSR : BCC ?not_pressed ; rightmost bit clear = button not pressed
    LDX #$3000+<pressed_value> : STX <buffer_offset> ; store pressed
    BRA ?+
?not_pressed:
    STY <buffer_offset> ; store default unpressed
?+
endmacro

display_input:
    %ai16()
    PHD
    LDA #!hud_buffer : TCD

    LDA !controller_data1
    LSR #4 ; get rid of the empty rightmost 4 bits
    LDY #$3027 ; default tile value

    %display_input_btn($36, $1B)
    %display_input_btn($34, $15)
    %display_input_btn($3A, $21)
    %display_input_btn($7C, $0A)
    %display_input_btn($72, $33)
    %display_input_btn($6E, $32)
    %display_input_btn($B0, $31)
    %display_input_btn($30, $30)
    %display_input_btn($B6, $1D)
    %display_input_btn($B4, $0E)
    %display_input_btn($78, $22)
    %display_input_btn($BA, $0B)

    PLD
    %i8()
    RTS

input_tiles:
    db $0B, $22, $0E, $1D, $30, $31, $32, $33, $0A, $21, $15, $1B
input_locations:
    db $BA, $78, $B4, $B6, $30, $B0, $6E, $72, $7C, $3A, $34, $36

count_active_sprites:
    LDY #$00
    ; 24 4-byte entries, one sprite per
    LDX #$14 ; 6*4-4
.count_loop
    LDA !s_spr_state+$00,x : BEQ +
    INY
    +
    LDA !s_spr_state+$18,x : BEQ +
    INY
    +
    LDA !s_spr_state+$30,x : BEQ +
    INY
    +
    LDA !s_spr_state+$48,x : BEQ +
    INY
    +
    DEX #4
    BPL .count_loop

    STY !active_sprites
    RTS

; ticks all timers
tick_timers:
    LDY !gamemode : CPY #!gm_level : BNE .skip_tick

    PHP
    LDA !frames_passed
    AND #$00FF
    CLC
    ADC !total_frames
    STA !total_frames

    SEP #$20
    REP #$10

    LDA !frames_passed
    LDX #!level_frames
    JSR add_frames_to_timer

    LDA !frames_passed
    LDX #!room_frames
    JSR add_frames_to_timer

    PLP

.skip_tick
    LDY #$00
    STY !frames_passed
    RTS

; A = frames to add, X = address of timer
add_frames_to_timer:
    CLC
    ADC $00,x
    CMP #60
    STA $00,x
    BCC .ret
    SEC
    SBC #60
    STA $00,x

    INC $01,x
    LDA $01,x
    CMP #60
    BCC .ret
    STZ $01,x

    LDA $02,x
    CMP #9
    BCC .tick_minutes

    LDA #59
    STA $01,x
    LDA #59
    STA $00,x
.tick_minutes
    INC $02,x
.ret
    RTS

decimal_lut:
for i = 0..10
    for j = 0..10
        db $!i!j
    endfor
endfor

; value in A (8), offset in Y
; assume valid input: A = 0-99 ($00-$63)
print_8_dec:
    TAX : LDA decimal_lut,x

; value in A (8), offset in Y
print_8:
    PHA
    LSR #4
    STA !hud_buffer,y
    PLA
    AND #$0F
    STA !hud_buffer+2,y
    RTS

; value in A (16), offset in Y
print_16_abs:
    CMP #$0000
    BPL print_16
    EOR #$FFFF
    INC

; value in A (16), offset in Y
print_16:
    PHD
    STA $00
    LDA #!hud_buffer : TCD

    LDA $0000
    ROR #4
    AND #$0F0F

    ; $--X-
    TAX : STX $04,y

    ; $X---
    XBA
    TAX : STX $00,y

    LDA $0000
    AND #$0F0F

    ; $---X
    TAX : STX $06,y

    ; $-X--
    XBA
    TAX : STX $02,y

    PLD
    RTS
