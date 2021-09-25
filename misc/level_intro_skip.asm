; turn off "hold-to-skip" intro when doing null-egg, since intro length matters in those routes
wait_for_input:
    LDA !null_egg_mode_enabled
    AND #$00FF
    BNE .original_code

-
    LDA !controller_data1
    ORA !controller_2_data1
    BEQ -
    BRA .ret

.original_code
    LDA $0D23
    CMP #$00C0
    BCC .original_code

.ret
    RTL
