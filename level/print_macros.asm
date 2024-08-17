decimal_lut:
for i = 0..10
    for j = 0..10
        db $!i!j
    endfor
endfor

; value in A (8). Assume valid input: A = 0-99 ($00-$63)
macro print_8_dec(offset)
    TAX : LDA decimal_lut,x
    %print_8(<offset>)
endmacro

; value in A (8)
macro print_8(offset)
    TAY
    AND #$0F
    STA <offset>+2
    TYA
    LSR #4
    STA <offset>+0
endmacro

; value in A (16)
macro print_16_abs(offset)
    CMP #$0000 : BPL +
    EOR #$FFFF
    INC
    +
    %print_16(<offset>)
endmacro

; value in A (16)
macro print_16(offset)
    STA $0000

    ROR #4
    AND #$0F0F

    ; $--X-
    TAX : STX <offset>+4

    ; $X---
    XBA
    TAX : STX <offset>+0

    LDA $0000
    AND #$0F0F

    ; $---X
    TAX : STX <offset>+6

    ; $-X--
    XBA
    TAX : STX <offset>+2
endmacro

; value in A (16)
macro print_12(offset)
    STA $0000

    ROR #4
    AND #$000F

    ; $-X-
    TAX : STX <offset>+2

    LDA $0000
    AND #$0F0F

    ; $--X
    TAX : STX <offset>+4

    ; $X--
    XBA
    TAX : STX <offset>+0
endmacro
