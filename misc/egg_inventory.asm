;================================
; word 1: sprite ID
; word 2: tilemap ID
egg_inv_tilemap:
.no_egg
dw $0000, $0039
.huffin_puffin
dw $0028, $083C
.flashing_egg
dw $0022, $203A
.red_egg
dw $0023, $0C3A
.yellow_egg
dw $0024, $083A
.green_egg
dw $0025, $043A
.skull_mouser
dw $01A3, $1843
.seesaw_log
dw $007F, $0844
.boss_explosion
dw $0013, $0845
.boss_key
dw $0014, $C03D
.key
dw $0027, $083D
.red_giant_egg
dw $002A, $0C3B
.green_giant_egg
dw $002B, $043B
.yoshi_egg
dw $0029, $0026
.unknown
dw $000D, $0026

!egg_inv_tilemap_count = ((egg_inv_tilemap_unknown-egg_inv_tilemap)/4+1)

;================================
; Loop through egg inventory
; Mark eggs as empty if after
clean_egg_inv_mirror:
    PHP
    %a16()
    %i8()

    LDY #$05
  - {
        TYA
        CMP !debug_egg_count_mirror : BCC +
        ASL
        TAX
        STZ !debug_egg_inv_mirror,x
        BRA .end
        +
        ASL
        TAX
        LDA !debug_egg_inv_mirror,x : BNE .end
        LDA #$0005 : STA !debug_egg_inv_mirror,x
        .end
        DEY
        BPL -
    }
.ret
    PLP
    RTS

;================================
; Read inventory and translate sprite ID to 
; proper index for debug egg inv
egg_inv_wram_to_debug:
    PHP
    %ai16()

    LDA !egg_inv_size : LSR : STA !debug_egg_count_mirror
    LDX #$000A
  - {
        LDA !egg_inv_items,x
        LDY.w #!egg_inv_tilemap_count*4-8 ; don't need the empty and unknown values
        .translate_loop
            CMP egg_inv_tilemap,y : BEQ .match
            DEY #4
            BNE .translate_loop
        ; no match, set as unknown sprite
        LDY.w #!egg_inv_tilemap_count*4-4
    .match
        TYA
        LSR #2
        STA !debug_egg_inv_mirror,x
        DEX #2
        BPL -
    }
.ret
    PLP
    RTS

;================================
; Read debug inventory and transfer to real inventory
egg_inv_debug_to_wram:
    PHP
    %ai16()

    LDA !debug_egg_count_mirror : ASL : STA !egg_inv_size
    BEQ .ret
    TAY
  - {
        ; if null egg/unknown index (final index), don't set
        LDA !debug_egg_inv_mirror-2,y : CMP.w #!egg_inv_tilemap_count-1 : BCS +
        ASL #2
        TAX
        LDA egg_inv_tilemap,x
        TYX
        STA !egg_inv_items-2,x
        +
        DEY #2
        BNE -
    }
.ret
    PLP
    RTS

;================================
; Despawn current egg sprites when opening the debug 
; menu so that a different set can be loaded when resuming gameplay
despawn_egg_sprites:
    PHP
    %ai16()

    LDY !egg_inv_size_cur : BEQ .ret
  - {
        LDX !egg_inv_items_cur-2,y ; grab the sprite slot from egg memory and store it in x
        PHY
        JSL despawn_sprite_free_slot
        PLY
        DEY #2
        BNE -
    }
    STZ !egg_inv_size_cur
.ret
    PLP
    RTS

;================================
; Stolen from $029A1A
spawn_big_yoshi_egg:
    PHP
    %a16()
    %i8()
    PHD
    LDA #$7960 : TCD ; effectively base address $701960

    LDA #$0029
    LDY #$00 ; always slot 0
    TYX
    STX $12 ; $701972, sprite slot # of sprite being currently processed = 0
    JSL spawn_sprite
    LDA #$0010 : STA !s_spr_state ; sprite state = active
    LDA !s_spr_y_pixel_pos : SEC : SBC #$0008 : STA !s_spr_y_pixel_pos
    JSL acquire_egg
.ret
    PLD
    PLP
    RTS
