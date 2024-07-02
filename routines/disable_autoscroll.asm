disable_autoscroll:
    PHP
    %a16()
    STZ $0C1C
    STZ $0C1E
    STZ $0C20
.ret
    PLP
    RTS