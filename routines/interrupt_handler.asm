org interrupt_freespace ; everything in the interrupt region in bank 00 gets copied to WRAM 7E for execution, so adjust breakpoints accordingly

; "NMI" really refers to the IRQ at the bottom of the screen (irq_2) at the start of vblank
nmi:
    ; DP is $2100

    ; backup the BG3 camera after the game code has run (e.g. for falling walls in 1-4 which modify $41)
    ; also, modifying the BG3 camera can break OPT rendering, which this avoids
    LDA $0041 : STA !irq_bg3_cam_x_backup
    LDA $0042 : STA !irq_bg3_cam_x_backup+1
    LDA $0043 : STA !irq_bg3_cam_y_backup
    LDA $0044 : STA !irq_bg3_cam_y_backup+1

    LDA !hud_displayed : BNE .nmi_with_hud

    ; no HUD, so just set the registers that were skipped in the hijack and return
    REP #$20
    LDA !r_reg_tm_mirror : STA.b !reg_tm

    SEP #$20
    LDA !r_reg_bg3sc_mirror : STA.b !reg_bg3sc
    LDA !r_reg_bgmode_mirror : STA.b !reg_bgmode

    RTS

.nmi_with_hud
    ; set 8x8 BG3 tile size, BG3 priority, mode 1
    LDA !r_reg_bgmode_mirror : STA !irq_bgmode_backup
    AND #%10110000 ; DCBA emmm, D/C/B/A = BG4/3/2/1 tile size (0=8x8; 1=16x16), e = mode 1 BG3 priority bit, mmm = BG mode
    ORA #%00001001
    STA.b !reg_bgmode

    ; set BG3 tile character address to word $6000 ($C000)
    LDA !r_reg_bg34nba_mirror : STA !irq_bg34nba_backup
    AND #%11110000 ; bbbb aaaa, bbbb = Base address for BG4, aaaa = Base address for BG3
    ORA #%00000110
    STA.b !reg_bg34nba

    ; set BG3 tilemap address to word $6400 ($C800)
    LDA !r_reg_bg3sc_mirror : STA !irq_bg3sc_backup
    LDA #$64 ; !r_reg_bg3sc_mirror  aaaa aayx, a = map address>>10, x = horizontal flip, y = vertical flip
    STA.b !reg_bg3sc

    REP #$20

    ; set BG3 as a main screen
    LDA !r_reg_tm_mirror : STA !irq_tm_backup ; tm and ts are adjacent in memory, so this sets both
    ORA #$0004 ; ---o 4321, 1/2/3/4/o = Enable BG1/2/3/4/OBJ for display on the main screen
    AND #~$0400 ; unset BG3 as a subscreen
    STA.b !reg_tm

    ; DMA tilemap to VRAM $6400 ($C800)
    LDX #$80 : STX.b !reg_vmain ; increment after writing to $2119
    LDX #$7E : STX !reg_a1b0 ; source bank
    LDA #$6400 : STA.b !reg_vmadd ; VRAM destination
    LDA #$1801 : STA !reg_dmap0 ; and !reg_bbad0 - set lower 8 bits of dest to $18 ($2118) and write 1 word increments
    LDA #!hud_buffer : STA !reg_a1t0l ; and !reg_a1t0h - hud buffer source address
    LDA #$00C0 : STA !reg_das0l ; and !reg_das0h - hud buffer size
    LDX #$01 : STX !reg_mdmaen ; enable DMA channel 0

    SEP #$20

    ; set BG3 scroll to (0,-9) here even though HDMA usually makes it redundant
    ; this is mainly for the score screen, since HDMA gets reset a bunch of times when it loads
    LDA.b #!hud_hofs : STA.b !reg_bg3hofs
    LDA.b #!hud_hofs>>8 : STA.b !reg_bg3hofs
    LDA.b #!hud_vofs : STA.b !reg_bg3vofs
    LDA.b #!hud_vofs>>8 : STA.b !reg_bg3vofs

    ; if in score screen, skip the level-specific stuff
    LDA !gamemode
    CMP #$31
    BEQ .post_boss_hacks
    CMP #$10
    BEQ .ret
    BRA .per_level_hacks
.post_boss_hacks
    LDA #$01 : TRB !r_reg_tm_mirror ; unset BG1 as a main screen so that we can see the score text
    JSR set_hud_palette
    BRA .ret

.per_level_hacks
    ; as usual, registers changed by HDMA at top of screen or in the HUD region will be overwritten when we restore the mirror values in the IRQs
    ; in the big bowser fight, main layers are disabled at bottom of screen and then re-enabled at the top, so disabled state is what gets restored
    ; resulting in bowser without a head
    ; hacky workaround here just sets the mirrors to what they should be on restore
    LDA !current_level
    CMP #$DD
    BEQ +
    CMP #$86
    BNE ++
+
    LDA #$11
    TSB !r_reg_tm_mirror
++

    ; in the case of Raphael, the entire screen is mode7, so changing the hud region to mode1 just results in garbage underneath
    ; to fix this, prevent BG1 and 2 from being displayed and just show the hud tilemap over nothing
    LDA !current_level
    CMP #$CB
    BNE +
    LDA #%00010100 : STA $2C
+

.ret
    RTS

hud_hdma_table_h: ; put these tables here so they're available in work ram
    db $98 ; $80 (repeat bit) + 24 ($18) -> 3 lines of tiles, each 8 pixels tall
    for i = 0..24
        dw !hud_hofs  ; 1 per line for $18 lines - kinda gross but necessary?
    endfor
    db $00

hud_hdma_table_v:
    db $98
    for i = 0..24
        dw !hud_vofs
    endfor
    db $00

; load palette into index 4 ($702020 mirror) so we can see the hud text
set_hud_palette:
    REP #$20
    LDA #$FFFF : STA !s_cgram_mirror+$22
    SEP #$20
    RTS

; apply the scroll values from the BG3 camera into the BG3 offset registers
restore_bg3_xy:
	LDA $41 : STA !reg_bg3hofs
    LDA $42 : STA !reg_bg3hofs
    LDA $43 : STA !reg_bg3vofs
    LDA $44 : STA !reg_bg3vofs
    RTS

check_lag:
    LDA !r_game_loop_complete ; Full Game Mode completion flag - $00: Game Mode still running (set by NMI/IRQ), $FF: Game Mode complete (set by end of game loop)
    BNE .no_lag
    REP #$20
    INC !lag_counter
    SEP #$20
.no_lag
    INC !frames_passed
    LDA !r_game_loop_complete
    RTS

load_irq2_vcount:
    STA !reg_htimel
    LDA !hud_displayed : BEQ .skip_hud_irq2
    LDA #!irq_v
    JMP irq_1_set_vcount+$05
.skip_hud_irq2
    LDA #$03
    STA !r_irq_count ; increase the counter to skip over our custom IRQs
    LDA #!nmi_v
    JMP irq_1_set_vcount+$05

irq_2:
    LDA !r_irq_count
    ASL
    TAX
    JMP (.pointers,x)
.pointers
    dw $C417 ; irq_0 - we hijack after 0 and 1 so these won't ever be used - decrementing the index makes sense but it wastes cycles so just leave them
    dw $C440 ; irq_1
    dw irq_2a ; restore original graphics settings after HUD during H-blank
    dw irq_2b ; restore more things 2 lines later
    dw $C46F ; irq_2 (NMI)

macro next_hblank()
-	BIT !reg_hvbjoy
    BVS - ; wait for hblank to end
-	BIT !reg_hvbjoy
    BVC - ; wait for hblank to start
endmacro

irq_2a:
    ; %next_hblank() ; don't really need this due to how the IRQ timing works out - which is good because it wastes valuable processing time

    ; restore stuff, 35 cycles (270 master) - changing 5 registers during 1 H-blank isn't ideal, but the alternative is adding irq_2c
    LDA.b !irq_bgmode_backup : STA !reg_bgmode
    LDA.b !irq_bg3sc_backup : STA !reg_bg3sc
    LDA.b !irq_bg34nba_backup : STA !reg_bg34nba
    LDA.b !irq_tm_backup : STA !reg_tm
    LDA.b !irq_ts_backup : STA !reg_ts

    ; next IRQ
    LDA #!irq_v+2 ; so irq_2a runs at the bottom of the hud, and irq_2b runs 2 scanlines later
    JMP $C431

irq_2b:
    ; %next_hblank()

    ; 28 cycles (216 master)
    LDA.b !irq_bg3_cam_x_backup : STA !reg_bg3hofs
    LDA.b !irq_bg3_cam_x_backup+1 : STA !reg_bg3hofs
    LDA.b !irq_bg3_cam_y_backup : STA !reg_bg3vofs
    LDA.b !irq_bg3_cam_y_backup+1 : STA !reg_bg3vofs

    ; next IRQ
    LDA #!nmi_v
    JMP $C431


assert pc() <= interrupt_freespace+!interrupt_freespace_size ; warn if our code overflows the freespace region
