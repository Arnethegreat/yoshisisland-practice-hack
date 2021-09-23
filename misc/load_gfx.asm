load_font:
    PHP
    REP #$30
    ; DMA font tile data to VRAM $6000 ($C000)
    LDA #font_gfx>>8 : STA $00
    LDX #font_gfx ; source address
    LDY #$6000 ; VRAM destination
    LDA #$0600 ; DMA size
    JSL vram_dma_01
    PLP
    RTS

font_gfx:
    incbin "../gfx/font.bin":0-600
