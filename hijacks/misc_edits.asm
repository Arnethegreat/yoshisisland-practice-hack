; judging by the surrounding code, they meant to store the current sprite slot # in $7E2C instead of $1E2C, the middle of our HUD buffer
; change this to prevent random tiles being added to the HUD when shooting a cloud at the edge of the screen
org $03CCC0
    STX $7E2C

org $03CD0C ; as above
    CPX $7E2C
