; This routine will be jumped to from the BRK / COP
; Cleans some stuff up and goes to debug menu
print pc
handle_exception:
    ; guess we're corrupting A here if we return but YOLO for now
    LDA !exception_handler_enabled
    BEQ .ret

    ; Save enough processor/stack context so we can optionally RTI back to the crash site.
    REP #$30
    STA !exception_return_a
    STX !exception_return_x
    STY !exception_return_y
    TDC
    STA !exception_return_d
    TSC
    STA !exception_return_sp
    SEP #$20
    LDA $01,S : STA !exception_return_p
    LDA $02,S : STA !exception_return_pcl
    LDA $03,S : STA !exception_return_pch
    LDA $04,S : STA !exception_return_pbr
    PHB
    PLA
    STA !exception_return_db

    LDA #$01 : STA !exception_return_valid

    ; BRK can happen in the middle of nested calls; preserve the active stack range so RTS/RTL still unwind correctly.
    %i16()
    LDX.w #$0000
  -
    LDA !exception_stack_backup_start,x
    STA.l !exception_stack_backup,x
    INX
    CPX.w #!exception_stack_backup_size
    BCC -

    CLI
    %a16()
    LDA #submenu_exception_ctrl : STA !current_menu_data_ptr
    LDA #$0000
    TCD
    ; Reset the stack to prevent stack overflows?
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

    RTI