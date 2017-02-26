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
save_dyntile_buffer:   
    LDX #$0800
    BEQ .ret
.loop 
    LDA $705800-2,x
    STA $7E2740-2,x
    DEX
    DEX
    BNE .loop
.ret
    RTS
;=================================
load_dyntile_buffer:
    LDX #$0800
    BEQ .ret
.loop 
    LDA $7E2740-2,x
    STA $705800-2,x
    DEX
    DEX
    BNE .loop
.copy_to_vram
    SEP #$10

; $5C00 vram destination
    LDA #$5C00
    STA !reg_vmadd
; $705800 source
    LDA #$5800
    STA $4302
    LDY #$70
    STY $4304
; $0800 bytes
    LDA #$0800
    STA $4305
; Enable DMA
    LDX #$01
    STX $420B

    REP #$30
.ret
    RTS

; Generic SRAM blocks
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
save_sram_block_04:
    LDX !sram_block_04_size
    BEQ .ret
.loop
    LDA !sram_block_04_source-2,x
    STA !sram_block_04_savestate-2,x
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
load_sram_block_04:
    LDX !sram_block_04_size
    BEQ .ret
.loop
    LDA !sram_block_04_savestate-2,x
    STA !sram_block_04_source-2,x
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
fixed_vram_dma_full:
; Fixed transfer, write both bytes
; video port control = $80
; DMA control = $09
; DMA dest reg = $2118
  PHB                                       ; $00BEA6 |
  PEA $7E48                                 ; $00BEA7 |\
  PLB                                       ; $00BEAA | | data bank $7E
  PLB                                       ; $00BEAB |/
  PHX                                       ; $00BEAC |
  LDX $4800                                 ; $00BEAD |
  STA $0008,x                               ; $00BEB0 |
  TYA                                       ; $00BEB3 |
  STA $0000,x                               ; $00BEB4 |
  LDA #$0980                                ; $00BEB7 |
  STA $0002,x                               ; $00BEBA |
  LDA #$0018                                ; $00BEBD |
  STA $0004,x                               ; $00BEC0 |
  LDA $0000                                 ; $00BEC3 |
  STA $0006,x                               ; $00BEC6 |
  PLA                                       ; $00BEC9 |
  STA $0005,x                               ; $00BECA |
  TXA                                       ; $00BECD |
  CLC                                       ; $00BECE |
  ADC #$000C                                ; $00BECF |
  STA $000A,x                               ; $00BED2 |
  STA $4800                                 ; $00BED5 |
  PLB                                       ; $00BED8 |
  RTS                                       ; $00BED9 |                                     ; $00BFF5 |
;=================================
fixed_vram_dma_low:
; Fixed transfer, write only low byte
; video port control = $00
; DMA control = $08
; DMA dest reg = $2118
  PHB                                       ; $00BEA6 |
  PEA $7E48                                 ; $00BEA7 |\
  PLB                                       ; $00BEAA | | data bank $7E
  PLB                                       ; $00BEAB |/
  PHX                                       ; $00BEAC |
  LDX $4800                                 ; $00BEAD |
  STA $0008,x                               ; $00BEB0 |
  TYA                                       ; $00BEB3 |
  STA $0000,x                               ; $00BEB4 |
  LDA #$0800                                ; $00BEB7 |
  STA $0002,x                               ; $00BEBA |
  LDA #$0018                                ; $00BEBD |
  STA $0004,x                               ; $00BEC0 |
  LDA $0000                                 ; $00BEC3 |
  STA $0006,x                               ; $00BEC6 |
  PLA                                       ; $00BEC9 |
  STA $0005,x                               ; $00BECA |
  TXA                                       ; $00BECD |
  CLC                                       ; $00BECE |
  ADC #$000C                                ; $00BECF |
  STA $000A,x                               ; $00BED2 |
  STA $4800                                 ; $00BED5 |
  PLB                                       ; $00BED8 |
  RTS                                       ; $00BED9 |  