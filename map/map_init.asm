map_init:
    PHP
    PHB
    PHK
    PLB
    SEP #$30

    LDA #$21 : STA !gamemode ; mode = fade into overworld

    LDA #$01 : STA !is_audio_fixed ; the overworld automatically loads some audio required for normal gameplay

    STZ !hud_displayed
    STZ !level_frames
    STZ !level_seconds
    STZ !level_minutes
    STZ !total_frames

    JSR detect_null_egg

    STZ !trainer_state

    PLB
    PLP
    RTL


; if at least one null egg "egg-sists" in the inventory, enable the null egg hud
; retrieve sprite IDs from WRAM egg inventory and check each sprite slot in $701360 for anything that shouldn't be there
detect_null_egg:
    PHP
    REP #$30
    LDA !egg_inv_size
    BEQ .normal_eggs
    TAX

-
    LDA !egg_inv_items-2,x
    JSR is_egg_sprite
    BEQ .null_egg_found
    DEX
    DEX
    BNE -

.normal_eggs
    SEP #$20
    STZ !null_egg_mode_enabled
    BRA .ret
.null_egg_found
    INC !null_egg_mode_enabled
.ret
    PLP
    RTS

; A=sprite ID
; on return, A=0001 if the sprite is a normal egg inventory sprite, 0000 otherwise
is_egg_sprite:
    ; 21 < ID < 2C == normal egg range
    CMP #$0022
    BCC .null_egg ; if A is less than $22
    CMP #$002C
    BCS .null_egg ; if A is greater than or equal to $2C
    LDA #$0001
    BRA .ret
.null_egg
    LDA #$0000
.ret
    RTS
