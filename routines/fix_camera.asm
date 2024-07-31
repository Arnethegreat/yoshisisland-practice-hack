; game mode 0C messes with the camera, causing it to start shifting during the load and messing up tile column loading
; before our savestate can load the correct values
fix_camera:
    LDA !loaded_state
    BEQ .ret

    LDA !save_camera_layer1_x
    STA !s_camera_layer1_x
    STA !r_camera_layer1_x

    LDA !save_camera_layer1_y
    SEC : SBC #$0018 ; prevent adjustment at $04FDB7 (runs twice?)
    STA !s_camera_layer1_y
    STA !r_camera_layer1_y

.ret
    LDA #$0061
    LDY #$00
    RTL
