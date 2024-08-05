org savefile_check_hijack
    JSR savefile_check_hook
    NOP

org $00BFF6 ; bank 00 non-interrupt freespace (only 10 bytes in U1.0!)

savefile_check_hook:
    autoclean JSL sram_boot_check
    LDA $707E7D
    RTS

assert pc() < $00C000 ; warn if our code overflows the freespace region
