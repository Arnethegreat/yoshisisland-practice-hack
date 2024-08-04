set_yoshi_colour:
    PHP
    %ai16()
    LDX !level_num
    LDA $028000,x
    AND #$00FF
    STA !yoshi_colour
.ret
    PLP
    RTS
