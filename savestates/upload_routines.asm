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
save_sram_map16:   
    LDX #$0400
    BEQ .ret
.loop 
    LDA $70409E-2,x
    STA $7E2340-2,x
    DEX
    DEX
    BNE .loop
.ret
    RTS
;=================================
load_sram_map16:
    LDX #$0400
    BEQ .ret
.loop 
    LDA $7E2340-2,x
    STA $70409E-2,x
    DEX
    DEX
    BNE .loop
.ret
    RTS
;=================================

; SRAM blocks
;
;

;=================================
save_sram_block_00:   
    LDX !sram_block_00_size
    BEQ .ret
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
    BEQ .ret
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
    BEQ .ret
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
    BEQ .ret
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
    BEQ .ret
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
    BEQ .ret
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
    BEQ .ret
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
    BEQ .ret
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
save_wram_block_00: 
    LDX !wram_block_00_size
    BEQ .ret
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
    BEQ .ret
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
    BEQ .ret
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
    BEQ .ret
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
    BEQ .ret
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
    BEQ .ret
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
    BEQ .ret
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
    BEQ .ret
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
    STA $1420,x
    DEX
    BPL .channel_0
    LDX #$0A
.channel_1
    LDA $4310,x
    STA $1430,x
    DEX
    BPL .channel_1
    LDX #$0A
.channel_2
    LDA $4320,x
    STA $1440,x
    DEX
    BPL .channel_2
    LDX #$0A
.channel_3
    LDA $4330,x
    STA $1450,x
    DEX
    BPL .channel_3
    LDX #$0A
.channel_4
    LDA $4340,x
    STA $1460,x
    DEX
    BPL .channel_4
    LDX #$0A
.channel_5
    LDA $4350,x
    STA $1470,x
    DEX
    BPL .channel_5
    LDX #$0A
.channel_6
    LDA $4360,x
    STA $1480,x
    DEX
    BPL .channel_6
    LDX #$0A
.channel_7
    LDA $4370,x
    STA $1490,x
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
    LDA $1420,x
    STA $4300,x
    DEX
    BPL .channel_0
    LDX #$0A
.channel_1
    LDA $1430,x
    STA $4310,x
    DEX
    BPL .channel_1
    LDX #$0A
.channel_2
    LDA $1440,x
    STA $4320,x
    DEX
    BPL .channel_2
    LDX #$0A
.channel_3 
    LDA $1450,x
    STA $4330,x
    DEX
    BPL .channel_3
    LDX #$0A
.channel_4
    LDA $1460,x
    STA $4340,x
    DEX
    BPL .channel_4
    LDX #$0A
.channel_5
    LDA $1470,x
    STA $4350,x
    DEX
    BPL .channel_5
    LDX #$0A
.channel_6
    LDA $1480,x
    STA $4360,x
    DEX
    BPL .channel_6
    LDX #$0A
.channel_7
    LDA $1490,x
    STA $4370,x
    DEX
    BPL .channel_7

.ret
    REP #$30
    RTS
;=================================
;=================================
;=================================
fix_cross_section:
; empty out VRAM $5000 -> $5800
; if inside cross section
    LDA $7FEC
    BEQ .ret
    LDA #$7E7E
    STA $0000
    ; STZ $0002
    LDA #$0800
    LDY #$2800
    LDX #$0000
    JSR fixed_vram_dma

.ret
    RTS


;=================================
;=================================
;=================================
fixed_vram_dma:
; video port control = $80
; DMA control = $09
; DMA dest reg = $2118
  PHB                                       ; $00BFBA |
  PEA $7E48                                 ; $00BFBB |\
  PLB                                       ; $00BFBE | | data bank $7E
  PLB                                       ; $00BFBF |/
  PHX                                       ; $00BFC0 |
  LDX $4800                                 ; $00BFC1 |
  STA $0008,x                               ; $00BFC4 |
  TYA                                       ; $00BFC7 |
  STA $0000,x                               ; $00BFC8 |
  LDA #$0980                                ; $00BFCB |
  STA $0002,x                               ; $00BFCE |
  LDA #$0018                                ; $00BFD1 |
  STA $0004,x                               ; $00BFD4 |
  LDA #$7E48                                ; $00BFD7 |
  STA $0006,x                               ; $00BFDA |
  TXA                                       ; $00BFDD |
  CLC                                       ; $00BFDE |
  ADC #$000C                                ; $00BFDF |
  STA $0005,x                               ; $00BFE2 |
  TXA                                       ; $00BFE5 |
  CLC                                       ; $00BFE6 |
  ADC #$000D                                ; $00BFE7 |
  STA $000A,x                               ; $00BFEA |
  STA $4800                                 ; $00BFED |
  PLA                                       ; $00BFF0 |
  STA $000C,x                               ; $00BFF1 |
  PLB                                       ; $00BFF4 |
  RTS                                       ; $00BFF5 |
;=================================