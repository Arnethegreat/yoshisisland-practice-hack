test_soft_reset:
    LDA !controller_data1 : CMP #!controller_data1_L|!controller_data1_R : BNE +
    LDA !controller_data2 : CMP #!controller_data2_start|!controller_data2_select : BNE +
    INC !soft_reset_timer
    LDA !soft_reset_timer : CMP #$20 : BNE .ret
    JML $008000
    +
    STZ !soft_reset_timer
.ret
    LDX !r_interrupt_mode ; hijacked code
    JMP nmi_hijack+3
