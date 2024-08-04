org savefile_check_hijack
    autoclean JSL savefile_check

freespacebyte $FF
freecode

savefile_check:
    PHP
    JSL bindings_boot_check
    JSL sram_boot_check
.ret
    PLP
    LDA $707E7D
    RTL
