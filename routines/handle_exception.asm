; This routine will be jumped to from the BRK / COP
; Cleans some stuff up and goes to debug menu
handle_exception:
    CLI
    %a16()
    LDA #submenu_exception_ctrl : STA !current_menu_data_ptr
    LDA #$0000
    TCD
    ; Reset the stack to prevent stack overflows
    LDA #$01FF
    TCS
    %ai8()
    ; hacky push data bank as 00 as it expects it later in game_loop
    LDA #$00
    PHA

    ; reset menu cursor state so exception submenu opens cleanly
    STZ !warps_page_depth_index
    STZ !cursor_stack_offset
    STZ !dbc_index_col
    STZ !dbc_index_row
    INC !dbc_index_row

    JML init_debug_menu

.ret
    ; go back to crash cuz the user quit the debug menu and wanted to have some fun maybe
    RTI