macro i8()
    SEP #$10
endmacro

macro i16()
    REP #$10
endmacro

macro a8()
    SEP #$20
endmacro

macro a16()
    REP #$20
endmacro

macro ai8()
    SEP #$30
endmacro

macro ai16()
    REP #$30
endmacro

macro zero_dp()
    LDA #$0000
    TCD
endmacro

macro toggle_byte(address)
    LDA <address>
    EOR #$01
    STA <address>
endmacro

; Strings
; ===================

!lf = $FFFF ; used as lf char
; writes an array of strings, each terminated by a sentinel value, with each char as a two-byte tile
macro store_text(...)
incsrc "../resources/string_font_map.asm"
    for i = 0..sizeof(...)
        dw "<...[!i]>"
        dw !lf
    endfor
endmacro
