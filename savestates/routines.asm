; Blocks that needs to uploaded before state is loaded
;
;
;=================================
save_item_memory:
    LDX #$0200
.loop 
    LDA !item_mem_page0-2,x
    STA !save_item_mem_page0-2,x
    DEX
    DEX
    BNE .loop

.ret
    RTS
;=================================
load_item_memory:
    LDX #$0200
.loop 
    LDA !save_item_mem_page0-2,x
    STA !item_mem_page0-2,x
    DEX
    DEX
    BNE .loop

.ret
    RTS
;=================================
;=================================
;=================================

; SRAM blocks
;
;

; $0000 -> $0DAA 
!sram_block_00_source = $700000
!sram_block_00_savestate = $7F0300
!sram_block_00_size = #$0DAA

; $0EB2 -> $2200
!sram_block_01_source = $700EB2
!sram_block_01_savestate = $7F10AA
!sram_block_01_size = #$134E

; $2600 -> $409E 
!sram_block_02_source = $702600
!sram_block_02_savestate = $7F23F8
!sram_block_02_size = #$1A9E

; No more SRAM needed?
!sram_block_03_source = $70409E
!sram_block_03_savestate = $7F3E96
!sram_block_03_size = #$0400
;=================================
save_sram_block_00:   
    LDX !sram_block_00_size
.loop 
    LDA !sram_block_00_source-2,x
    STA !sram_block_00_savestate-2,x
    DEX
    DEX
    BNE .loop
.ret
    RTS
;=================================
save_sram_block_01:
    LDX !sram_block_01_size
.loop
    LDA !sram_block_01_source-2,x
    STA !sram_block_01_savestate-2,x
    DEX
    DEX
    BNE .loop
.ret
    RTS
;=================================
save_sram_block_02:   
    LDX !sram_block_02_size
.loop 
    LDA !sram_block_02_source-2,x
    STA !sram_block_02_savestate-2,x
    DEX
    DEX
    BNE .loop
.ret
    RTS
;=================================
save_sram_block_03:

    LDX !sram_block_03_size
.loop
    LDA !sram_block_03_source-2,x
    STA !sram_block_03_savestate-2,x
    DEX
    DEX
    BNE .loop
.ret
    RTS
;=================================
;=================================
;=================================
load_sram_block_00:
    LDX !sram_block_00_size
.loop 
    LDA !sram_block_00_savestate-2,x
    STA !sram_block_00_source-2,x
    DEX
    DEX
    BNE .loop
.ret
    RTS
;=================================
load_sram_block_01:
    LDX !sram_block_01_size
.loop
    LDA !sram_block_01_savestate-2,x
    STA !sram_block_01_source-2,x
    DEX
    DEX
    BNE .loop
.ret
    RTS
;=================================
load_sram_block_02:
    LDX !sram_block_02_size
.loop 
    LDA !sram_block_02_savestate-2,x
    STA !sram_block_02_source-2,x
    DEX
    DEX
    BNE .loop
.ret
    RTS
;=================================
load_sram_block_03:
    LDX !sram_block_03_size
.loop
    LDA !sram_block_03_savestate-2,x
    STA !sram_block_03_source-2,x
    DEX
    DEX
    BNE .loop
.ret
    RTS
;=================================
;=================================
;=================================
save_some_ram: 
    LDX #$004C
.loop 
    LDA $0372,x
    STA $7F0000,x
    DEX
    DEX
    BNE .loop
.ret
    RTS

load_some_ram: 
    LDX #$004C
.loop 
    LDA $7F0000,x
    STA $0372,x
    DEX
    DEX
    BNE .loop
.ret
    RTS



save_bajs_ram:
    LDX #$047E
.loop_2
    LDA $0C04,x
    STA $7F4692,x
    DEX
    DEX
    BNE .loop_2
.ret
    RTS