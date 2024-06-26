toggle_control_scheme:
    PHP
    %a8()
    LDA !s_control_scheme ; $00 = patient; $02 = hasty
    EOR #$02
    STA !s_control_scheme
.ret
    PLP
    RTS
