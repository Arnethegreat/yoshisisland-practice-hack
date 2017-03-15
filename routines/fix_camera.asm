fix_camera:
    LDA !loaded_state
    BEQ .last_exit_setup
.in_load_state

; camera moving direction
    LDA $7F4991
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

.last_exit_setup

    LDA !last_exit_loading_flag
    BNE .ret
    PHX
    PHB
    PHK
    PLB

    LDA !item_mem_current_page
    ASL A
    TAX
    LDA item_memory_page_pointers,x
    STA $00

    LDY #$7E
    .save_item_memory
        LDA ($00),y
        STA !last_exit_item_mem_backup,y
        DEY
        DEY
        BPL .save_item_memory
        
    PLB
    PLX
.ret
    STZ !last_exit_loading_flag
    LDA #$0061
    LDY #$00
    RTL