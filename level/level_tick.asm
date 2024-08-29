; ~~~ performance critical code ~~~
; (if anything looks strange, it's because of that [and/or because I've lost my mind])
; every JSR/RTS is 12 cycles; they must all be sacrificed. 2x JMP is 6, and inlining is best at 0

incsrc "print_macros.asm"

; carry should be clear on entry, and is always clear on return
macro add_frames_to_timer(timer_address)
?aftt:
    LDA !frames_passed
    ADC <timer_address>
    CMP #60
    STA <timer_address>
    BCC ?.ret

    ; frames > 59, increment seconds and overflow frames
    SBC #60 ; subtract instead of doing a STZ because more than 1 frame may have passed
    STA <timer_address>
    INC <timer_address>+1
    LDA <timer_address>+1
    CMP #60 : BCC ?.ret

    ; seconds > 59, increment minutes and overflow seconds
    STZ <timer_address>+1
    LDA <timer_address>+2
    CMP #9 : BCC ?.tick_minutes

    ; trying to increment but minutes >= 9, display 9'59"59
    LDA #59 : STA <timer_address>+1
    LDA #59 : STA <timer_address>
    CLC
    BRA ?.ret
?.tick_minutes
    INC <timer_address>+2
?.ret
endmacro

level_tick:
    LDA #$10 : STA $0B83 ; hijacked code
    PHP
    PHB
    PHK
    PLB

    LDA !debug_control_scheme : TSB !s_control_scheme ; hacky, just set force hasty every frame

    %a16()

.tick_timers
{
    LDY !gamemode : CPY #!gm_level : BNE +

    LDA !frames_passed
    CLC : ADC !total_frames ; this won't overflow (and set carry) until approx. 18 minutes have passed
    STA !total_frames

    %a8()
    %add_frames_to_timer(!level_frames)
    %add_frames_to_timer(!room_frames)
    %a16()
    +

    LDY #$00 : STY !frames_passed
}

    LDY !hud_displayed : BEQ .ret
{
    LDA #!hud_buffer : TCD
.cas
    JMP count_active_sprites ; needs a16i8
.din
    JMP display_input ; needs a16i8
.dc
    JMP display_common ; needs a16, sets a8

    LDY !null_egg_mode_enabled : BNE +
    JMP display_items ; needs a8
+
    JMP display_nullegg ; needs a8
.end_display
    LDA #$00 : TCD ; assume DP was zero and the high byte of A is zero, saves 4 cycles over PHD/PLD
}
.ret
    PLB
    PLP
    RTL

display_common:
    LDA !yoshi_x_speed
    %print_12_abs($04)

    LDA !s_egg_cursor_angle
    %print_12_upper($44)

    LDA !lag_counter
    %print_12($A6)

    ; misc
    LDA !s_spr_id+$5C : CMP #$0045 : BNE +
    LDA $7A94 ; Prince Froggy current damage
    %print_16($82)
    BRA ++
+
    LDY !current_level
    CPY #$32 : BNE ++ ; 6-6
    JSR rockless_trainer
    LDA !trainer_result
    %print_12_upper($84)
++

    ; ramwatch
    LDA !ramwatch_addr
    ORA !ramwatch_addr+1 : BEQ + ; don't show when set to $000000
    LDA #$3C1B : STA $8C ; icon
    ; DP is set to the hud buffer here, but we will be overwriting offset $8E so we can actually use it before printing
    LDA !ramwatch_addr : STA $8E
    LDY !ramwatch_addr+2 : STY $8E+2
    LDA [$8E]
    %print_16($8E)
    LDX #$30 : STX $8F ; we use $8F (a palette byte) but it is not overwritten by the print, so fix it
    TXA ; this is the last point when A is 16-bit, so clear the high byte in preparation for resetting DP with 8-bit A
    +

    %a8()

    LDA !active_sprites
    %print_8_dec($4E)

    ; level timer
    LDA !level_minutes : STA $1E
    LDA !level_seconds
    %print_8_dec($22)
    LDA !level_frames
    %print_8_dec($28)

    ; room timer
    LDA !room_minutes : STA $5E
    LDA !room_seconds
    %print_8_dec($62)
    LDA !room_frames
    %print_8_dec($68)

    ; clock thingy
    LDY #$34
    LDA !total_frames
    AND #$20
    BEQ .draw_clock
    LDY #$3F
.draw_clock
    STY $1C
.ret
    JMP level_tick_dc+3

display_items:
    LDA !red_coin_count
    %print_8_dec($0E)

    LDA !star_count_digit_1 : STA $16
    LDA !star_count_digit_2 : STA $18

    LDA !flower_count : STA $56
.ret
    JMP level_tick_end_display

display_nullegg:
    LDA !yoshi_x_subpixel
    %print_8($16)

    %a16()

    LDA !yoshi_x_pos
    %print_12($0E)

    LDA !s_camera_layer3_y
    %print_12($54)

    LDA #$0000
    %a8()
.ret
    JMP level_tick_end_display

macro display_input_btn(buffer_offset, pressed_value)
    ASL : BCC ?not_pressed ; leftmost bit clear = button not pressed
    LDX #<pressed_value> : STX <buffer_offset> ; store pressed
    BRA ?+
?not_pressed:
    STY <buffer_offset> ; store default unpressed
?+
endmacro

display_input:
    LDA !controller_data1
    LDY #$27 ; default tile value

    %display_input_btn($BA, $0B)
    %display_input_btn($78, $22)
    %display_input_btn($B4, $0E)
    %display_input_btn($B6, $1D)
    %display_input_btn($30, $30)
    %display_input_btn($B0, $31)
    %display_input_btn($6E, $32)
    %display_input_btn($72, $33)
    %display_input_btn($7C, $0A)
    %display_input_btn($3A, $21)
    %display_input_btn($34, $15)
    %display_input_btn($36, $1B)
.ret
    JMP level_tick_din+3

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
 .ret
    JMP level_tick_cas+3
