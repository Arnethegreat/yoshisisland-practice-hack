; palette selection for 2bpp tiles is 3 bits, so we can choose from a selection of 8 groups of 4 colours each
; colours are represented in BGR555: 15-bit RGB value, 5 bits per channel, xBBB BBGG GGGR RRRR
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

    ; if we're on the yoshi palette customiser, set dynamic palettes
    LDA !current_menu_data_ptr : CMP #submenu_yoshipalette_ctrl : BNE .ret
    JSR set_palettepicker_submenu_palette
.ret
    PLP
    RTS

set_palettepicker_submenu_palette:
    PHP
    %a16()

    ; set the colours for each palette
    LDA !yoshi_custom_palette+0 : STA !s_cgram_mirror+8+2
    LDA !yoshi_custom_palette+2 : STA !s_cgram_mirror+8+4
    LDA !yoshi_custom_palette+4 : STA !s_cgram_mirror+8+6

    LDA !yoshi_custom_palette+6 : STA !s_cgram_mirror+16+2
    LDA !yoshi_custom_palette+8 : STA !s_cgram_mirror+16+4
    LDA #$30C5 : STA !s_cgram_mirror+16+6 ; unused

    LDA !yoshi_custom_palette+10 : STA !s_cgram_mirror+24+2
    LDA !yoshi_custom_palette+12 : STA !s_cgram_mirror+24+4
    LDA !yoshi_custom_palette+14 : STA !s_cgram_mirror+24+6

    LDA !yoshi_custom_palette+16 : STA !s_cgram_mirror+48+2
    LDA !yoshi_custom_palette+18 : STA !s_cgram_mirror+48+4
    LDA !yoshi_custom_palette+20 : STA !s_cgram_mirror+48+6

    ; set the palette index for each tile in the tilemap
    %a8()
    LDA #%00000100 : STA !menu_tilemap_mirror+$1DC+1
    LDA #%00001000 : STA !menu_tilemap_mirror+$2DC+1
    LDA #%00001100 : STA !menu_tilemap_mirror+$3DC+1
    LDA #%00011000 : STA !menu_tilemap_mirror+$4DC+1
.ret
    PLP
    RTS
