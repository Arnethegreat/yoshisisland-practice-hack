; we store certain variables in uninitialised SRAM in order to persist them across sessions
; their initial state is therefore undefined, so this routine is used to force correct them if needed
sram_boot_check:
    PHP
    %a8()
    LDA !debug_control_scheme : BEQ + : CMP #$02 : BEQ +
    LDA #$00 : STA !debug_control_scheme
    +
    LDA !disable_music : BEQ + : CMP #$01 : BEQ +
    LDA #$00 : STA !disable_music
    +
    LDA !full_load_default : BEQ + : CMP #$01 : BEQ +
    LDA #$00 : STA !full_load_default
    +
    %a16()
    LDA !skip_kamek : BEQ + : CMP #$0001 : BEQ +
    LDA #$0000 : STA !skip_kamek
    +
.ret
    PLP
    RTL
