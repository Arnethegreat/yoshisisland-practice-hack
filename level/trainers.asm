; 6-6 rockless key clip
; start holding right
; press tongue after 49 frames
; press jump after 3 frames
; stop holding right + start holding left after 6 frames

; store difference between current frame and target frame counts, offset by 8 for viewing purposes
; trainer result will display [tongue frame | jump frame | move left frame | unused]
; where a value of 8 indicates frame-perfect input e.g. 8880
rockless_trainer:
    PHP
    REP #$20

    ; if yoshi's in the corner (x: $033F, y: $0675) set 'ready' state
    LDA !yoshi_x_pos
    CMP #$033F
    BNE +
    LDA !yoshi_y_pos
    CMP #$0675
    BNE +
    LDA !controller_data2 : BIT #%0000000000000001 ; prevent trainer state being forced to 1 while holding right before yoshi has a chance to move
    BNE +
    LDA #$0001 : STA !trainer_state
+

    SEP #$20
    LDA !trainer_state
    BEQ .ret ; state 0 is idle
    DEC A
    ASL A
    TAX
    JSR (.state_funcs,x)
.ret
    PLP
    RTS
.state_funcs
    dw .ready, .running, .tonguing, .jumping

.ready
    STZ !trainer_timer
    LDA #$00
    STA !trainer_result
    STA !trainer_result+1
    LDA !controller_data2 : BIT #%00000001 ; dpad right
    BEQ ..ret
    INC !trainer_state
..ret
    RTS

.running
    INC !trainer_timer
    LDA !controller_data2 : BIT #%01000000 ; Y
    BEQ ..ret

    LDA !trainer_timer
    SEC
    SBC #41
    ROL #4
    AND #$F0
    ORA !trainer_result+1
    STA !trainer_result+1

    INC !trainer_state
    STZ !trainer_timer
..ret
    RTS

.tonguing
    INC !trainer_timer
    LDA !controller_data2 : BIT #%10000000 ; B
    BEQ ..ret

    LDA !trainer_timer
    CLC
    ADC #5
    AND #$0F
    ORA !trainer_result+1
    STA !trainer_result+1

    INC !trainer_state
    STZ !trainer_timer
..ret
    RTS

.jumping
    INC !trainer_timer
    LDA !controller_data2 : BIT #%00000010 ; dpad left
    BEQ ..ret

    LDA !trainer_timer
    CLC
    ADC #2
    ROL #4
    AND #$F0
    ORA !trainer_result
    STA !trainer_result

    STZ !trainer_state
    STZ !trainer_timer
..ret
    RTS
