fix_camera:
    LDA !loaded_state
    BEQ .ret
.in_load_state

; camera moving direction
    LDA !save_camera_direction_x
    BNE .moving_left
.moving_right
    LDA !save_camera_layer1_x
; values will be 2 off for when normal gameplay starts
    CLC
    ADC #$0002
    STA !s_camera_layer1_x
    STA $0039
    BRA .y_camera
.moving_left
    LDA !save_camera_layer1_x
; values will be 2 off for when normal gameplay starts
    SEC
    SBC #$0002
    STA !s_camera_layer1_x
    STA $0039

.y_camera
    LDA !save_camera_layer1_y
    SEC
    SBC #$0004
    STA !s_camera_layer1_y
    STA $003B

.ret
    LDA #$0061
    LDY #$00
    RTL