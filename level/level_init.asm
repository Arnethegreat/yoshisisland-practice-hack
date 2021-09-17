level_init:
    PHP
    REP #$30
    PHB
    PHK
    PLB

    JSR set_hud_hdma_channels
    JSR level_room_init_common

    STZ !total_frames
    STZ !lag_counter
    SEP #$20
    STZ !level_frames
    STZ !level_seconds
    STZ !level_minutes
    STZ !room_frames
    STZ !room_seconds
    STZ !room_minutes

    PLB
    PLP
    RTL

room_init:
    PHP
    REP #$30
    PHB
    PHK
    PLB

    JSR set_hud_hdma_channels
    JSR level_room_init_common

    STZ !lag_counter
    SEP #$20
    STZ !room_frames
    STZ !room_seconds
    STZ !room_minutes

    PLB
    PLP
    RTL

; dynamically allocate HDMA channels for the HUD, since the game uses different ones in some rooms
; e.g. big bowser uses 1100 0110, baby bowser shockwaves use 0010 0000, kamek magic dust uses 0011 0110
set_hud_hdma_channels:
    PHP
    REP #$20
    SEP #$10

    ; might have to do this more intelligently depending on how many rooms we need to switch out
    LDA !last_exit_1
    AND #$00FF
    CMP #$00DD
    BEQ .bowser
    CMP #$0086
    BEQ .hookbill

    ; default
    LDA #$4360 : STA !hud_hdma_table_h_channel
    LDA #$4370 : STA !hud_hdma_table_v_channel
    LDX #%11000000 : STX !hud_hdma_channels
    BRA .ret
.bowser
    LDA #$4300 : STA !hud_hdma_table_h_channel
    LDA #$4330 : STA !hud_hdma_table_v_channel
    LDX #%00001001 : STX !hud_hdma_channels
    BRA .ret
.hookbill ; uses channels 6/7 in addition to kamek magic and mist (channel 3)
    LDA #$4340 : STA !hud_hdma_table_h_channel
    LDA #$4300 : STA !hud_hdma_table_v_channel
    LDX #%00010001 : STX !hud_hdma_channels
.ret
    PLP
    RTS

level_room_init_common:
    PHP

    JSR load_font

    LDA !hud_enabled
    BNE .draw_hud
.ret
    PLP
    RTS

.draw_hud
    SEP #$30

    LDA #$01 : STA !hud_displayed

    ; hdma to override any other hdmas in a given level which mess with BG3 offsets, in the hud region only
    ; e.g. 1-4 falling walls use channel 4 to set bg3vofs
    PHD
    REP #$20
    LDA #!vars_ram
    TCD
    SEP #$20
    LDY #$04
-
    LDA hud_hdma_table_h_controls,y : STA (!hud_hdma_table_h_channel_dp),y ; indirect indexed only available with DP
    LDA hud_hdma_table_v_controls,y : STA (!hud_hdma_table_v_channel_dp),y
    DEY
    BPL -
    PLD

    LDA !hud_hdma_channels : TSB !r_reg_hdmaen_mirror ; hdmaen gets started at the top of the screen

    REP #$30

    ; init hud buffer, 3 lines * 64 bytes per line = 192 ($C0) bytes from $1E00-$1EC0
    LDX #$00BE
-
    LDA hud_tilemap,x
    STA !hud_buffer,x
    DEX
    DEX
    BPL -

    BRA .ret

hud_hdma_table_h_controls: db %00000010, $11, hud_hdma_table_h, hud_hdma_table_h>>8, $7E
hud_hdma_table_v_controls: db %00000010, $12, hud_hdma_table_v, hud_hdma_table_v>>8, $7E

; 3 lines, 32 columns
; tilemap format: 2 bytes per entry
;   vhop ppcc cccc cccc
;   v/h        = Vertical/Horizontal flip
;   o          = Tile priority
;   ppp        = Tile palette index (0-7)
;   cccccccccc = Tile number
hud_tilemap:
    dw $303F, $303F, $303F, $303F, $303F, $303F, $2437, $303F ; 00-0F
    dw $303F, $303F, $2036, $303F, $303F, $303F, $3034, $303F ; 10-1F
    dw $302B, $303F, $303F, $302C, $303F, $303F, $303F, $303F ; 20-2F
    dw $303F, $303F, $303F, $303F, $303F, $303F, $303F, $303F ; 30-3F

    dw $303F, $303F, $303F, $303F, $303F, $303F, $303E, $303F ; 40-4F
    dw $303F, $303F, $3838, $303F, $303F, $303F, $303F, $303F ; 50-5F
    dw $302B, $303F, $303F, $302C, $303F, $303F, $303F, $303F ; 60-6F
    dw $303F, $303F, $303F, $303F, $303F, $303F, $303F, $303F ; 70-7F

    dw $303F, $303F, $303F, $303F, $303F, $303F, $303F, $303F ; 80-8F
    dw $303F, $303F, $303F, $303F, $303F, $303F, $303F, $303F ; 90-9F
    dw $303F, $303F, $303F, $303F, $303F, $303F, $303F, $303F ; A0-AF
    dw $303F, $303F, $303F, $303F, $303F, $303F, $303F, $303F ; B0-BF

    ; extra (not in the buffer)
    dw $303F, $303F, $303F, $303F, $303F, $303F, $303F, $303F
    dw $303F, $303F, $303F, $303F, $303F, $303F, $303F, $303F
    dw $303F, $303F, $303F, $303F, $303F, $303F, $303F, $303F
    dw $303F, $303F, $303F, $303F, $303F, $303F, $303F, $303F
