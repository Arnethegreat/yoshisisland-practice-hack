save_inventory:
    SEP #$10
    LDA !egg_inv_size_cur
    STA !save_egg_inv_size
    BEQ .ret
    TAX

.loop_inventory
    LDY !egg_inv_size_cur,x
    LDA !s_spr_id,y
    STA !save_egg_inv_items-2,x
    DEX
    DEX
    BNE .loop_inventory

.ret
    REP #$30
    RTS


load_inventory:
    SEP #$10
    LDA !save_egg_inv_size
    STA !egg_inv_size
    BEQ .ret
    TAX

.loop_inventory
    LDA !save_egg_inv_items-2,x
    STA !egg_inv_items-2,x
    DEX
    DEX
    BNE .loop_inventory

.ret
    REP #$30
    RTS


save_item_memory:
    LDX #$01FE
.loop 
    LDA !item_mem_page0,x
    STA !save_item_mem_page0,x
    DEX
    DEX
    BNE .loop

.ret
    RTS


load_item_memory:
    LDX #$01FE
.loop 
    LDA !save_item_mem_page0,x
    STA !item_mem_page0,x
    DEX
    DEX
    BNE .loop

.ret
    RTS

;
; routines needing load after level load
;

save_sprite_spawns:
    LDX #$00FE
.loop 
    LDA !sprite_despawn_table,x
    STA !save_sprite_despawn_table,x
    DEX
    DEX
    BNE .loop

.ret
    RTS


load_sprite_spawns:
    LDX #$00FE
.loop 
    LDA !save_sprite_despawn_table,x
    STA !sprite_despawn_table,x
    DEX
    DEX
    BNE .loop

.ret
    RTS


save_yoshi_states:

    LDA $60D2
    STA $7F0402

    LDA $60C0
    STA $7F0400

    LDA !yoshi_x_speed 
    STA !save_yoshi_x_speed
    
    LDA !yoshi_y_speed 
    STA !save_yoshi_y_speed

    LDA !mouth_sprite_id
    STA !save_mouth_sprite_id

    LDA !mouth_melon_type
    STA !save_mouth_melon_type

    LDA !mouth_melon_count
    STA !save_mouth_melon_count

.ret
    RTS


load_yoshi_states:

    LDA $7F0402
    STA $7000D2

    LDA $7F0400
    STA $7000C0

    LDA !save_yoshi_x_speed
    STA !yoshi_x_speed 

    LDA !save_yoshi_y_speed
    STA !yoshi_y_speed 

    LDA !save_mouth_sprite_id
    STA !mouth_sprite_id

    LDA !save_mouth_melon_type
    STA !mouth_melon_type

    LDA !save_mouth_melon_count    
    STA !mouth_melon_count

.ret
    RTS


; kek

save_all_sram:   
    LDX #$0DA8
.loop 
    LDA $700000,x
    STA $7F0300,x
    DEX
    DEX
    BNE .loop

    LDX #$35E8
.loop_2
    LDA $700EB6,x
    STA $7F10AA,x
    DEX
    DEX
    BNE .loop_2
.ret
    RTS

load_all_sram:
    LDX #$0DA8
.loop 
    LDA $7F0300,x
    STA $700000,x
    DEX
    DEX
    BNE .loop

    LDX #$35E8
.loop_2
    LDA $7F10AA,x
    STA $700EB6,x
    DEX
    DEX
    BNE .loop_2
.ret
    RTS

save_some_ram: 
    LDX #$004A
.loop 
    LDA $0372,x
    STA $7F0000,x
    DEX
    DEX
    BNE .loop

    LDX #$047E
.loop_2
    LDA $0C04,x
    STA $7F4692,x
    DEX
    DEX
    BNE .loop_2
.ret
    RTS

load_some_ram: 
    LDX #$004A
.loop 
    LDA $7F0000,x
    STA $0372,x
    DEX
    DEX
    BNE .loop
.ret
    RTS
