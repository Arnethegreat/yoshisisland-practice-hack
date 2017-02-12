; hijack at level load after it sets camera
; checks if we're loading a savestate and override camera if we are

org level_load_camera
    autoclean JSL fix_camera
    nop

freecode $FF

fix_camera:
    LDA !loaded_state
    BEQ .ret
.in_load_state
    LDA !save_camera_layer1_x
; values will be 2 off for when normal gameplay starts
    CLC
    ADC #$0002
    STA !s_camera_layer1_x
    STA $0039

    LDA !save_camera_layer1_y
    SEC
    SBC #$0004
    STA !s_camera_layer1_y
    STA $003B

.ret
    LDA #$0061
    LDY #$00
    RTL