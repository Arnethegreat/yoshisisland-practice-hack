init_cursor_stack:
    PHP
    %a8()
    STZ !cursor_stack_offset
.ret
    PLP
    RTS

push_cursor_stack:
    PHA : PHX : PHP
    %a16()
    %i8()
    ; the upper bytes should always be empty, so combine them as low=row, hi=col in A
    LDA !dbc_index_col
    XBA
    ORA !dbc_index_row
    LDX !cursor_stack_offset
    STA !cursor_stack,x
    INX #2
    STX !cursor_stack_offset
    STZ !dbc_index_row
    STZ !dbc_index_col
.ret
    PLP : PLX : PLA
    RTS

pop_cursor_stack:
    PHA : PHX : PHP
    %a16()
    %i8()
    LDX !cursor_stack_offset
    DEX #2
    STX !cursor_stack_offset
    LDA !cursor_stack,x
    %a8()
    STA !dbc_index_row ; low byte
    XBA
    STA !dbc_index_col ; high byte
.ret
    PLP : PLX : PLA
    RTS
