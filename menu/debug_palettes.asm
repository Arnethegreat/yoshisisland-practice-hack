; palette selection for 2bpp tiles is 3 bits, so we can choose from a selection of 8 groups of 4 colours each
; each colour is represented by a 15-bit RGB value, 5 bits per channel: xBBB BBGG GGGR RRRR
menu_palette:
.flashing
dw $0000, $FFFF, $0000, $789F
.green_egg
dw $0000, $FFFF, $0000, $05E0
.yellow
dw $0000, $FFFF, $0000, $033F
.red
dw $0000, $FFFF, $0000, $001F
.red_text
dw $0000, $001F, $0000, $001F
.green_text
dw $0000, $05E0, $0000, $001F
.blue
dw $0000, $FFFF, $0000, $5DE2
.highlight_text
dw $0000, $FFFF, $498A, $0000

submenu_config_palette:
.flashing
dw $0000, $FFFF, $0000, $789F
.red_text
dw $0000, $001F, $0000, $0000
.green_text
dw $0000, $03E0, $0000, $0000
.yellow_text
dw $0000, $033F, $0000, $0000
.blue_text
dw $0000, $6DEC, $0000, $0000
.unused
dw $0000, $0000, $0000, $0000
dw $0000, $0000, $0000, $0000
.highlight_text
dw $0000, $FFFF, $498A, $0000


init_current_menu_palette:
    PHP
    %ai16()

    LDA !current_menu_palette_ptr
    BNE +
    LDA #menu_palette ; if ptr is zero, load the default palette
    +
    STA $00
    LDX #!palette_backup_size-2
  - {
        TXY
        LDA ($00),y : STA !s_cgram_mirror,x
        DEX #2
        BPL -
    }
.ret
    PLP
    RTS
