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
    AND #%00000001
    EOR #$01
    STA <address>
endmacro

; Strings
; ===================

!lf = $FFFF ; used as lf char
; writes an array of strings, with each char as a two-byte tile
; each string and the entire array are terminated by a sentinel newline value
macro store_text(...)
incsrc "../resources/string_font_map.asm"
    for i = 0..sizeof(...)
        dw "<...[!i]>"
        dw !lf
    endfor
    dw !lf
endmacro

; Functions
; ===================

function hirom_mirror(label) = $400000+(((bank(label))*$8000)+((label&$FFFF)-$8000))
