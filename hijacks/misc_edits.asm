; judging by the surrounding code, they meant to store the current sprite slot # in $7E2C instead of $1E2C, the middle of our HUD buffer
; change this to prevent random tiles being added to the HUD when shooting a cloud at the edge of the screen
org $03CCC0
    STX $7E2C

org $03CD0C ; as above
    CPX $7E2C

; chomp rock hitting sand has a bug with 8/16 mode and executes a BRK but then recovers
; This triggers our exception handler so fix this bug but keep original behavior (or chomp rock will behave slightly differently)
; This also fixes it accidently shifting $0280 which is free RAM we use

org chomp_rock_sand_break
    NOP #7
    ; One side effect is it does TSB $E6 [$007A46] which might change behavior of some sprite - better keep it in case
    TSB $E6