org main_spinning_wooden_platform_hijack
    JSR fix_hud_spinning_wooden_platform_hook

org $02FFD7 ; freespace in bank 02

fix_hud_spinning_wooden_platform_hook:
    ; N.B. this just grabs the first table entry (scanline 0). If another entry runs before the HUD region ends, then this may be incorrect
    LDA !r_hdma_table2+1 : STA !irq_bg3_cam_x_backup
.ret
    LDA #$0004 ; hijacked code
    RTS
