org interrupt_freespace ; everything in the interrupt region in bank 00 gets copied to WRAM 7E for execution, so adjust breakpoints accordingly

; IRQ at the bottom of the screen (irq_2) at the start of vblank
; DP is $2100
vbirq:
    LDA !hud_displayed : BNE .vbirq_with_hud

    ; no HUD, so just set the registers that were skipped in the hijack and return
    LDA !r_reg_tm_mirror : STA.b !reg_tm
    LDA !r_reg_ts_mirror : STA.b !reg_ts
    LDA !r_reg_bg3sc_mirror : STA.b !reg_bg3sc
    LDA !r_reg_bgmode_mirror : STA.b !reg_bgmode

    JMP vbirq_hijack_ret

.vbirq_with_hud
    ; backup the BG3 camera after the game code has run (e.g. for falling walls in 1-4 which modify $41)
    ; also, modifying the BG3 camera can break OPT rendering, which this avoids
    ; if the flags are set then the backup has already been set to the correct value
    LDA !hud_fixed_bg3hofs_flag : BNE +
    LDA !r_camera_layer3_x : STA !irq_bg3_cam_x_backup
    LDA !r_camera_layer3_x+1 : STA !irq_bg3_cam_x_backup+1
    +

    LDA !hud_fixed_bg3vofs_flag : BNE +
    LDA !r_camera_layer3_y : STA !irq_bg3_cam_y_backup
    LDA !r_camera_layer3_y+1 : STA !irq_bg3_cam_y_backup+1
    +

    ; set BG3 scroll to (0,-9) here even though HDMA usually makes it redundant
    ; this is mainly for the score screen, since HDMA gets reset a bunch of times when it loads
    LDA.b #!hud_hofs : STA.b !reg_bg3hofs
    LDA.b #!hud_hofs>>8 : STA.b !reg_bg3hofs
    LDA.b #!hud_vofs : STA.b !reg_bg3vofs
    LDA.b #!hud_vofs>>8 : STA.b !reg_bg3vofs

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

    %a16()

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
    LDA #!hud_buffer_size : STA !reg_das0l ; and !reg_das0h - hud buffer size
    LDX #$01 : STX !reg_mdmaen ; enable DMA channel 0

    %a8()

    LDA !hud_fixed_tm : BEQ +
    STA !irq_tm_backup
    +

    JMP vbirq_hijack_ret

hud_hdma_table: ; put this table here so it's available in work ram (GSU can take exclusive ROM access)
    db $98 ; $80 (repeat bit) + 24 ($18) -> 3 lines of tiles, each 8 pixels tall
    for i = 0..24
        dw !hud_hofs
        dw !hud_vofs
    endfor
    db $00

; apply the scroll values from the BG3 camera into the BG3 offset registers
restore_bg3_xy:
	LDA.b !r_camera_layer3_x : STA !reg_bg3hofs
    LDA.b !r_camera_layer3_x+1 : STA !reg_bg3hofs
    LDA.b !r_camera_layer3_y : STA !reg_bg3vofs
    LDA.b !r_camera_layer3_y+1 : STA !reg_bg3vofs
    JMP $C57B

check_lag:
    LDA !r_game_loop_complete ; Full Game Mode completion flag - $00: Game Mode still running (set by NMI/IRQ), $FF: Game Mode complete (set by end of game loop)
    BNE .no_lag
    REP #$20
    INC !lag_counter
    SEP #$20
.no_lag
    INC !frames_passed
    LDA !r_game_loop_complete ; A is not modified by this routine, but we need to load this again to ensure correct flags are set on return
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

test_soft_reset:
    LDA !controller_data1 : CMP #!controller_data1_L|!controller_data1_R : BNE +
    LDA !controller_data2 : CMP #!controller_data2_start|!controller_data2_select : BNE +
    INC !soft_reset_timer
    LDA !soft_reset_timer : CMP #$20 : BNE .ret
    JML $008000
    +
    STZ !soft_reset_timer
.ret
    LDX !r_interrupt_mode ; hijacked code
    JMP nmi_hijack+3

incsrc "music/prevent_change.asm"

assert pc() <= interrupt_freespace+!interrupt_freespace_size ; warn if our code overflows the freespace region
