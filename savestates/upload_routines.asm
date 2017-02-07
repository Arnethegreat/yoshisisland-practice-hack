; Blocks that needs to uploaded before state is loaded
; TODO: Eventually replace with DMA and MOV
; Still in testing stage
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

; $0000 -> $2200 
!sram_block_00_source = $700000
!sram_block_00_savestate = $7F0300
!sram_block_00_size = #$2200

; $2600 -> $449E 
!sram_block_01_source = $702600
!sram_block_01_savestate = $7F2500
!sram_block_01_size = #$1E9E

; Not used
!sram_block_02_source = $7E0B0F
!sram_block_02_savestate = $7F439E
!sram_block_02_size = #$06A8

; Not used
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
; WRAM blocks
;
;

; $0306 -> $03BE
!wram_block_00_source = $7E0306
!wram_block_00_savestate = $7F0000
!wram_block_00_size = #$00B8

; $0B0F -> $11B7 
!wram_block_01_source = $7E0B0F
!wram_block_01_savestate = $7F439E
!wram_block_01_size = #$06A8

; Not used
!wram_block_02_source = $7E409E
!wram_block_02_savestate = $7F3F9E
!wram_block_02_size = #$1A9E

; Not used
!wram_block_03_source = $70409E
!wram_block_03_savestate = $7F3E96
!wram_block_03_size = #$0400
;=================================
save_wram_block_00: 
    LDX !wram_block_00_size
.loop 
    LDA !wram_block_00_source-2,x
    STA !wram_block_00_savestate-2,x
    DEX
    DEX
    BNE .loop
.ret
    RTS
;=================================
save_wram_block_01: 
    LDX !wram_block_01_size
.loop 
    LDA !wram_block_01_source-2,x
    STA !wram_block_01_savestate-2,x
    DEX
    DEX
    BNE .loop
.ret
    RTS
;=================================
save_wram_block_02: 
    LDX !wram_block_02_size
.loop 
    LDA !wram_block_02_source-2,x
    STA !wram_block_02_savestate-2,x
    DEX
    DEX
    BNE .loop
.ret
    RTS
;=================================
save_wram_block_03: 
    LDX !wram_block_03_size
.loop 
    LDA !wram_block_03_source-2,x
    STA !wram_block_03_savestate-2,x
    DEX
    DEX
    BNE .loop
.ret
    RTS
;=================================
;=================================
;=================================
load_wram_block_00: 
    LDX !wram_block_00_size
.loop 
    LDA !wram_block_00_savestate-2,x
    STA !wram_block_00_source-2,x
    DEX
    DEX
    BNE .loop
.ret
    RTS
;=================================
load_wram_block_01: 
    LDX !wram_block_01_size
.loop 
    LDA !wram_block_01_savestate-2,x
    STA !wram_block_01_source-2,x
    DEX
    DEX
    BNE .loop
.ret
    RTS
;=================================
load_wram_block_02: 
    LDX !wram_block_02_size
.loop 
    LDA !wram_block_02_savestate-2,x
    STA !wram_block_02_source-2,x
    DEX
    DEX
    BNE .loop
.ret
    RTS
;=================================
load_wram_block_03: 
    LDX !wram_block_03_size
.loop 
    LDA !wram_block_03_savestate-2,x
    STA !wram_block_03_source-2,x
    DEX
    DEX
    BNE .loop
.ret
    RTS
;=================================