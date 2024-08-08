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
    LDX #!sram_map16_size
    BEQ .ret
.loop 
    LDA !sram_map16_source-2,x
    STA !sram_map16_savestate-2,x
    DEX
    DEX
    BNE .loop
.ret
    RTS
;=================================
load_sram_map16:
    LDX #!sram_map16_size
    BEQ .ret
.loop 
    LDA !sram_map16_savestate-2,x
    STA !sram_map16_source-2,x
    DEX
    DEX
    BNE .loop
.ret
    RTS
;=================================
save_dyntile_buffer:   
    LDX #!sram_dyntile_size
    BEQ .ret
.loop 
    LDA !sram_dyntile_source-2,x
    STA !sram_dyntile_savestate-2,x
    DEX
    DEX
    BNE .loop
.ret
    RTS
;=================================
load_dyntile_buffer:
    LDX #!sram_dyntile_size
    BEQ .ret
.loop 
    LDA !sram_dyntile_savestate-2,x
    STA !sram_dyntile_source-2,x
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

load_wram_map16_delta:
    PHP
    PHB
    LDX !map16delta_index : BEQ .ret
    %a8()
    LDA #$7F : PHA : PLB
    %ai16()

-
    LDA !wram_map16delta_savestate-2,x : TAY ; Y = map16 table offset
    LDA !wram_map16delta_savestate-4,x : STA.w !r_map16_table,y
    DEX #4
    BPL -
.ret
    PLB
    PLP
    RTS

;=================================
; Generic WRAM and SRAM blocks
;=================================
save_ram:
{
    PHP
    %ai16()

    LDX #datasize(ram_save_table)-8 ; X = index into the save table
- {
        LDY ram_save_table,x ; Y = index into the current block
        DEY #2

        ; store source pointer in $00-$02 and savestate pointer in $03-$05
        LDA ram_save_table+2,x : STA $00
        LDA ram_save_table+4,x : STA $02
        LDA ram_save_table+6,x : STA $04

        ; move data to savestate location
    -- {
            LDA [$00],y
            STA [$03],y
            DEY #2
            BPL --
        }

        DEX #8
        BPL -
    }
.ret
    PLP
    RTS
}

load_ram:
{
    PHP
    %ai16()

    LDX #datasize(ram_save_table)-8 ; X = index into the save table
- {
        LDY ram_save_table,x ; Y = index into the current block
        DEY #2

        ; store source pointer in $00-$02 and savestate pointer in $03-$05
        LDA ram_save_table+2,x : STA $00
        LDA ram_save_table+4,x : STA $02
        LDA ram_save_table+6,x : STA $04

        ; move data from savestate to original location
    -- {
            LDA [$03],y
            STA [$00],y
            DEY #2
            BPL --
        }

        DEX #8
        BPL -
    }
.ret
    PLP
    RTS
}

ram_save_table:
    dw !sram_block_00_size : dl !sram_block_00_source, !sram_block_00_savestate
    dw !sram_block_01_size : dl !sram_block_01_source, !sram_block_01_savestate
    dw !sram_block_02_size : dl !sram_block_02_source, !sram_block_02_savestate
    dw !sram_block_03_size : dl !sram_block_03_source, !sram_block_03_savestate
    dw !sram_block_04_size : dl !sram_block_04_source, !sram_block_04_savestate
    dw !wram_block_00_size : dl !wram_block_00_source, !wram_block_00_savestate
    dw !wram_block_01_size : dl !wram_block_01_source, !wram_block_01_savestate
    dw !wram_block_02_size : dl !wram_block_02_source, !wram_block_02_savestate
    dw !wram_block_03_size : dl !wram_block_03_source, !wram_block_03_savestate
    dw !wram_block_04_size : dl !wram_block_04_source, !wram_block_04_savestate
    dw !wram_block_05_size : dl !wram_block_05_source, !wram_block_05_savestate

;=================================
;=================================
;=================================

save_dma_channel_settings:
    SEP #$30
    LDX #$09
-
    LDA $4300,x : STA !dma_channel_0_savestate,x
    LDA $4310,x : STA !dma_channel_1_savestate,x
    LDA $4320,x : STA !dma_channel_2_savestate,x
    LDA $4330,x : STA !dma_channel_3_savestate,x
    LDA $4340,x : STA !dma_channel_4_savestate,x
    LDA $4350,x : STA !dma_channel_5_savestate,x
    LDA $4360,x : STA !dma_channel_6_savestate,x
    LDA $4370,x : STA !dma_channel_7_savestate,x
    DEX
    BPL -

.ret
    REP #$30
    RTS
;=================================
load_dma_channel_settings:
    SEP #$30
    LDX #$09
-
    LDA !dma_channel_0_savestate,x : STA $4300,x
    LDA !dma_channel_1_savestate,x : STA $4310,x
    LDA !dma_channel_2_savestate,x : STA $4320,x
    LDA !dma_channel_3_savestate,x : STA $4330,x
    LDA !dma_channel_4_savestate,x : STA $4340,x
    LDA !dma_channel_5_savestate,x : STA $4350,x
    LDA !dma_channel_6_savestate,x : STA $4360,x
    LDA !dma_channel_7_savestate,x : STA $4370,x
    DEX
    BPL -

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