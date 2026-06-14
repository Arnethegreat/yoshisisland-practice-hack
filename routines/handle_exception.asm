; This routine will be jumped to from the BRK / COP
; Lets mess with things here and see if we can get the game to continue instead of crashing
print pc
handle_exception:
    %a16()
    LDA #$0001
    STA !debug_menu
    LDA #$0000
    TCD

    %a8()
    %i8()
    JML game_loop

.ret
    ; go back to crash cuz the user has brain problems and tries to fix it with an epileptic fit
    RTI