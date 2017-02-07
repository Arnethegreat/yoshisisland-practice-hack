; hijack at level load after it sets fix_camera
; checks if we're loading a savestate and override camera if so


org level_load_camera
    autoclean JSL fix_camera
    nop

freecode $FF

fix_camera:
    LDA !loaded_state
    BEQ .ret
.save_state
    LDA $7F0394
    STA !s_camera_layer1_x
    LDA $7F039C
    SEC
    SBC #$0004
    STA !s_camera_layer1_y

.ret
    LDA #$0061
    LDY #$00
    RTL