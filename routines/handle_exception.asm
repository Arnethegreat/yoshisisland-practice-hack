; This routine will be jumped to from the BRK / COP
; Lets mess with things here and see if we can get the game to continue instead of crashing
print pc
handle_exception:
    CLI
    %a16()
    LDA #$0000
    TCD

    %ai8()
    ; hacky push data bank as 00 as it expects it later in game_loop
    LDA #$00
    PHA 
    JML init_debug_menu

.ret
    ; go back to crash cuz the user quit the debug menu and wanted to have some fun maybe
    RTI