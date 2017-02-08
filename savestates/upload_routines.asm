; TODO: Eventually replace with DMA and MOV
;       Still in testing stage
;       Move block settings into seperate file?
;=================================
; Blocks that needs to uploaded before state is loaded
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

; Register mirrors test
!wram_block_02_source = $7E094A
!wram_block_02_savestate = $7F4A46
!wram_block_02_size = #$0024

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
;=================================
;=================================

; TODO: Make a nice tight loop
save_dma_channel_settings:
    SEP #$30
    LDX #$0A
.channel_0
    LDA $4300,x
    STA $1500,x
    DEX
    BPL .channel_0
    LDX #$0A
.channel_1
    LDA $4310,x
    STA $1510,x
    DEX
    BPL .channel_1
    LDX #$0A
.channel_2
    LDA $4320,x
    STA $1520,x
    DEX
    BPL .channel_2
    LDX #$0A
.channel_3
    LDA $4330,x
    STA $1530,x
    DEX
    BPL .channel_3
    LDX #$0A
.channel_4
    LDA $4340,x
    STA $1540,x
    DEX
    BPL .channel_4
    LDX #$0A
.channel_5
    LDA $4350,x
    STA $1550,x
    DEX
    BPL .channel_5
    LDX #$0A
.channel_6
    LDA $4360,x
    STA $1560,x
    DEX
    BPL .channel_6
    LDX #$0A
.channel_7
    LDA $4370,x
    STA $1570,x
    DEX
    BPL .channel_7

.ret
    REP #$30
    RTS
;=================================
load_dma_channel_settings:
    SEP #$30
    LDX #$0A
.channel_0
    LDA $1500,x
    STA $4300,x
    DEX
    BPL .channel_0
    LDX #$0A
.channel_1
    LDA $1510,x
    STA $4310,x
    DEX
    BPL .channel_1
    LDX #$0A
.channel_2
    LDA $1520,x
    STA $4320,x
    DEX
    BPL .channel_2
    LDX #$0A
.channel_3 
    LDA $1530,x
    STA $4330,x
    DEX
    BPL .channel_3
    LDX #$0A
.channel_4
    LDA $1540,x
    STA $4340,x
    DEX
    BPL .channel_4
    LDX #$0A
.channel_5
    LDA $4350,x
    STA $1550,x
    DEX
    BPL .channel_5
    LDX #$0A
.channel_6
    LDA $4360,x
    STA $1560,x
    DEX
    BPL .channel_6
    LDX #$0A
.channel_7
    LDA $4360,x
    STA $1560,x
    DEX
    BPL .channel_7

.ret
    REP #$30
    RTS
;=================================
;=================================
;=================================