; hijack at level load after it sets camera
; checks if we're loading a savestate and override camera if we are

org level_load_camera
    autoclean JSL fix_camera
    nop

; freecode $FF

; fix_camera:
;     LDA !loaded_state
;     BEQ .cont
; .in_load_state

; ; camera moving direction
;     LDA $7F4991
;     BNE .moving_left
; .moving_right
;     LDA !save_camera_layer1_x
; ; values will be 2 off for when normal gameplay starts
;     CLC
;     ADC #$0002
;     STA !s_camera_layer1_x
;     STA $0039
;     BRA .y_camera
; .moving_left
;     LDA !save_camera_layer1_x
; ; values will be 2 off for when normal gameplay starts
;     SEC
;     SBC #$0002
;     STA !s_camera_layer1_x
;     STA $0039

; .y_camera
;     LDA !save_camera_layer1_y
;     SEC
;     SBC #$0004
;     STA !s_camera_layer1_y
;     STA $003B

; .cont

;     PHX

;     LDA !item_mem_current_page
;     ASL A
;     TAX
;     LDA item_memory_page_pointers,x
;     STA $00

;     LDY #$7E
;     .save_item_memory
;         LDA ($00),y
;         STA $151C,y
;         DEY
;         DEY
;         BPL .save_item_memory

;     PLX
; .ret
;     LDA #$0061
;     LDY #$00
;     RTL