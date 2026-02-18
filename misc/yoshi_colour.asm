set_yoshi_colour:
    PHP
    %ai16()
    LDX !level_num
    LDA $028000,x
    AND #$00FF
    STA !yoshi_colour
.ret
    PLP
    RTS

; yoshi 16 colour palette located in CGRAM mirror at $7021A2
; default green yoshi values in parens

; --yoshi
; D9 main ($03E0), D5 shadow ($02A0), D2 darkest shadow ($0180)
; --white bits
; DF main ($7FFF), DD shadow ($571F)
; --baby mario
; DE skin ($6B9F), D7 skin shadow ($467F)
; --outline
; D1 main ($0000)
; --red bits
; D8 main ($111F), DB highlight ($025F), D4 shadow ($10D2)
; --unknown
; D3 ($0012), D6 ($001F), DA ($023F), DC ($271F)

apply_custom_yoshi_colour:
    PHP
    %ai16()
    LDA !enable_yoshi_custom_palette : AND #$0001 : BEQ +
    
    ; yoshi skin
    LDA !yoshi_custom_palette+0 : STA !s_cgram_mirror+!yoshi_palette_offset+18 ; D9
    LDA !yoshi_custom_palette+2 : STA !s_cgram_mirror+!yoshi_palette_offset+10 ; D5
    LDA !yoshi_custom_palette+4 : STA !s_cgram_mirror+!yoshi_palette_offset+4 ; D2

    ; white bits
    LDA !yoshi_custom_palette+6 : STA !s_cgram_mirror+!yoshi_palette_offset+30 ; DF
    LDA !yoshi_custom_palette+8 : STA !s_cgram_mirror+!yoshi_palette_offset+26 ; DD

    ; red bits
    LDA !yoshi_custom_palette+10 : STA !s_cgram_mirror+!yoshi_palette_offset+16 ; D8
    LDA !yoshi_custom_palette+12 : STA !s_cgram_mirror+!yoshi_palette_offset+22 ; DB
    LDA !yoshi_custom_palette+14 : STA !s_cgram_mirror+!yoshi_palette_offset+8 ; D4

    ; outline
    LDA !yoshi_custom_palette+16 : STA !s_cgram_mirror+!yoshi_palette_offset+2 ; D1

    ; baby mario skin
    LDA !yoshi_custom_palette+18 : STA !s_cgram_mirror+!yoshi_palette_offset+28 ; DE
    LDA !yoshi_custom_palette+20 : STA !s_cgram_mirror+!yoshi_palette_offset+14 ; D7

    BRA .ret
    + ; else load original palette

    LDA !yoshi_colour : ASL : TAX
    LDA yoshi_palette_ptrs,x : TAY

    LDA #$A000 : STA $00
    LDA #$5FA0 : STA $01
    LDX #$0000
  - {
        LDA [$00],y : STA !s_cgram_mirror+!yoshi_palette_offset+2,x
        INY #2
        INX #2
        CPX.w #!yoshi_palette_size
        BNE -
    }
.ret
    PLP
    RTS

reset_palette: ; to green yosh
    PHP
    %a16()
    LDA #$03E0 : STA !yoshi_custom_palette+0 ; D9
    LDA #$02A0 : STA !yoshi_custom_palette+2 ; D5
    LDA #$0180 : STA !yoshi_custom_palette+4 ; D2
    LDA #$7FFF : STA !yoshi_custom_palette+6 ; DF
    LDA #$571F : STA !yoshi_custom_palette+8 ; DD
    LDA #$111F : STA !yoshi_custom_palette+10 ; D8
    LDA #$025F : STA !yoshi_custom_palette+12 ; DB
    LDA #$10D2 : STA !yoshi_custom_palette+14 ; D4
    LDA #$0000 : STA !yoshi_custom_palette+16 ; D1
    LDA #$6B9F : STA !yoshi_custom_palette+18 ; DE
    LDA #$467F : STA !yoshi_custom_palette+20 ; D7
    JSR apply_custom_yoshi_colour
    JSR init_controls
.ret
    PLP
    RTS
