main_bowser:
    LDY !s_spr_wildcard_5_lo_dp,x
    LDA !skip_baby_bowser ; this will be set if the big bowser option was selected from the warps menu
    BEQ .ret
    LDY #$17 : STY !s_spr_wildcard_5_lo_dp,x ; state $17 = prepare big bowser fight after baby expands
    STZ !skip_baby_bowser
.ret
    RTL

;==========================
; HUD rendering stuff

raphael_hud_fix:
    PHP
    %a8()
    ; the entire screen is mode7, so changing the hud region to mode1 just results in garbage underneath
    ; to fix this, prevent BG1 from being displayed and just show the hud tilemap over nothing
    ; this causes some graphical glitches during the boss key animation
    LDA !hud_displayed : BEQ .ret
    LDA #%00010000 : STA !r_reg_tm_mirror ; will be modified and used for the HUD region
    LDA #%00010001 : STA !hud_fixed_tm ; will be restored after the HUD region
.ret
    PLP
    LDA !r_header_level_mode : CMP #$0009 ; hijacked code
    RTL

bank noassume

bowser_mode7_hdma:
    PHP
    %ai8()

    ; main layers are disabled at bottom of screen and then re-enabled at the top with HDMA, resulting in headless bowser when HUD active
    ; save the correct value for post-HUD restore
    LDA #%00010101 : STA !hud_fixed_tm

    LDX #$09
    LDA !hud_enabled
    BNE .load_custom
-
    LDA baby_bowser_hijack+$0F1C,x ; $D477,x - original HDMA table
    STA $7E5040,x
    LDA baby_bowser_hijack+$0F23,x ; $D47E,x
    STA $7E51E4,x
    DEX
    BPL -
    BRA .ret
.load_custom
    LDA hud_bowser_bgmode_hdma_table,x
    STA $7E5040,x
    LDA baby_bowser_hijack+$0F23,x ; $D47E,x
    STA $7E51E4,x
    DEX
    BPL .load_custom
.ret
    PLP
    RTL

hookbill_mode7_hdma: ; these both are only called during the boss init routine, so we need to also manually call them when enabling/disabling the hud
    PHP
    REP #$10
    SEP #$20

    ; main layers are disabled at bottom of screen and then re-enabled at the top with HDMA, resulting in headless hookbill when HUD active
    ; save the correct value for post-HUD restore
    LDA #%00010101 : STA !hud_fixed_tm

    LDX #$0009
    LDA !hud_enabled
    BNE .load_custom
-
    LDA hookbill_mode7_hdma_hijack-$78,x ; $9DD6,x - original HDMA table
    STA $7E5040,x
    LDA hookbill_mode7_hdma_hijack-$71,x ; $9DDD,x  
    STA $7E51E4,x
    DEX
    BPL -
    BRA .ret
.load_custom
    LDA hud_hookbill_bgmode_hdma_table,x
    STA $7E5040,x
    LDA hookbill_mode7_hdma_hijack-$71,x ; $9DDD,x  
    STA $7E51E4,x
    DEX
    BPL .load_custom
.ret
    PLP
    RTL

bank auto

hud_bowser_bgmode_hdma_table:
    db $1A, $09
    db $56, $07
    db $3B, $07
    db $01, $49
    db $00
    db $00 ; unused

hud_hookbill_bgmode_hdma_table:
    db $1A, $09
    db $56, $07
    db $2B, $07
    db $01, $49
    db $00

; the WRAM var $0B83 gets loaded every frame while in IRQ mode 0A so we can just change it here dynamically
; it is used to modify the reg_tm HDMA table for mode7 stuff: by modifying it, we prevent the HDMA from hiding BG3 in the HUD region
; both bowser and hookbill set it to #$0011, ensuring only BG1 and OBJ are enabled as main screens
tm_hdma:
    LDY !hud_enabled
    BNE .load_custom
    LDA $0B83 ; sets only BG1 and O as main screens through HDMA6
    BRA .ret
.load_custom
    LDA #$0015
.ret
    STA $7E51E5
    RTL
