level_room_preinit:
    JSR load_required_audio
    RTL

; when warping before the map screen has loaded, we won't have death/goal ring sound data prepared
; the music header is used to lookup a set of max 4 SPC data blocks to load
; track $12 is used for the overworld and gives blocks $25, $22, $1C
; $1C : $1EC122 is overworld music data
; $22 : $1EEE5A is intro, map, castle/fort samples
; $25 : $1F82E6 is default music track
; I think we only need $1C, so it's faster to ignore the 2 unnecessary blocks and go straight to .UploadDataToSPC
load_required_audio:
    PHP
    %ai8()
    LDA !is_audio_fixed : BNE .ret ; only do this once per power-on
    LDA.b #!music_overworld : STA $00
    LDA.b #!music_overworld>>8 : STA $01
    LDA.b #!music_overworld>>16 : STA $02
    STZ $0C ; block counter, 0 = 1 block
    STZ $0D
    JSL upload_data_to_spc
    INC !is_audio_fixed
.ret
    PLP
    RTS

level_init:
    PHP
    REP #$30
    PHB
    PHK
    PLB

    JSR level_room_init_common
    JSR reset_hud

    ; save eggs for full level reset
    LDX #$000A : STX !last_level_eggs_size
    -
        LDA !egg_inv_items,x
        BNE +
        ; level init code seems to clear the size before this for some reason, so store it manually
        STX !last_level_eggs_size
        +
        STA !last_level_eggs,x
        DEX #2
        BPL -

    PLB
    PLP
    RTL

reset_hud:
    PHP
    %a16()
    STZ !total_frames
    STZ !lag_counter
    %a8()
    STZ !level_frames
    STZ !level_seconds
    STZ !level_minutes
    STZ !room_frames
    STZ !room_seconds
    STZ !room_minutes
.ret
    PLP
    RTS

room_init:
    PHP
    REP #$30
    PHB
    PHK
    PLB

    JSR level_room_init_common

    STZ !lag_counter
    SEP #$20
    STZ !room_frames
    STZ !room_seconds
    STZ !room_minutes

    PLB
    PLP
    RTL

level_room_init_common:
    PHP
    %a8()

    JSR handle_flags
    JSR per_level_hud_bg3ofs_fix
    STZ !map16delta_index

    LDA !hud_enabled : BEQ .ret
    JSR init_hud
.ret
    PLP
    RTS

; some rooms use HDMA to set stuff at the top of the screen, which means we won't save the correct value during NMI
; this routine sets flags to be used during post-HUD restore
per_level_hud_bg3ofs_fix:
    PHP
    %ai8()
    LDX #$00
    LDA !current_level
    CMP #$CE : BEQ .3d_rotating_platforms ; 2-4
    CMP #$BC : BEQ .3d_rotating_platforms ; 2-5
    CMP #$B3 : BEQ .3d_rotating_platforms ; 5-8
    CMP #$7A : BEQ .underwater ; 3-3
    CMP #$D7 : BEQ .underwater ; 3-4
    CMP #$C0 : BEQ .underwater ; 3-7
    LDA #$00
    BRA .ret
.3d_rotating_platforms
    LDA #$01
    BRA .ret
.underwater
    LDA #$01
    TAX
.ret
    STA !hud_fixed_bg3hofs_flag
    STX !hud_fixed_bg3vofs_flag
    STZ !hud_fixed_tm
    PLP
    RTS

score_screen_hud_fix:
    PHP
    %a8()
    STZ !hud_fixed_tm
    STZ !hud_fixed_bg3hofs_flag
    STZ !hud_fixed_bg3vofs_flag
    LDA #$FF : STA !s_cgram_mirror+$22 ; load white into index 4 ($702020 mirror) so we can see the hud text
    LDA #$7F : STA !s_cgram_mirror+$23
.ret
    PLP
    LDA #$01 : STA !r_reg_ts_mirror ; hijacked code
    RTL

init_hud:
    PHP
    %i8()

    LDY #$01 : STY !hud_displayed
    JSR load_font ; guarantee the HUD font is available e.g. if we load a savestate, VRAM can change
    JSR init_hud_hdma

    %ai16() ; use 16-bit X since the buffer size is over $80 and will therefore set the N flag and break the BPL loop immediately

    ; init hud buffer
    LDX #!hud_buffer_size-2
-
    LDA hud_tilemap_template,x : STA !hud_buffer,x
    DEX #2
    BPL -

    LDY !null_egg_mode_enabled : BEQ .ret
    ; clear the icon tiles if doing null egg display
    LDA #$303F
    STA !hud_buffer+$0C ; red coin
    STA !hud_buffer+$14 ; star
    STA !hud_buffer+$54 ; flower
.ret
    PLP
    RTS

; set a HUD-region HDMA to override any other HDMAs in a given sublevel which mess with BG3 offsets
; examples of things that use HDMA to modify BG3 offset:
; seesaws, falling walls, kebab logs, rotating planks, nep-enuts, squishable blocks, support and caged ghosts
; non-boss salvos, background heat haze, background sky parallax, underwater sections, kamek's magic dust
; we didn't start the fire
init_hud_hdma:
    PHP
    %a16i8()

    ; dynamically set the HUDMA channel based on which channels are unused
    LDX !current_level
    ; CPX #$6D : BEQ .seesaw ; 1-3
    ; CPX #$03 : BEQ .falling_walls ; 1-4 (+ see-saw)
    ; CPX #$9B : BEQ .kebab_logs ; 1-8
    ; CPX #$40 : BEQ .support_ghost ; 1-8
    ; CPX #$73 : BEQ .nep_enut ; 2-3
    CPX #$CE : BEQ .3d_rotating_platforms ; 2-4
    CPX #$BC : BEQ .3d_rotating_platforms ; 2-5
    ; CPX #$76 : BEQ .heat_haze ; 2-6
    ; CPX #$12 : BEQ .heat_haze ; 3-1
    ; CPX #$79 : BEQ .parallax_sky ; 3-1
    ; CPX #$14 : BEQ .nep_enut ; 3-3
    CPX #$7A : BEQ .underwater ; 3-3
    CPX #$D7 : BEQ .underwater ; 3-4
    ; CPX #$4D : BEQ .heat_haze ; 3-4
    CPX #$C0 : BEQ .underwater ; 3-7
    ; CPX #$A6 : BEQ .parallax_sky ; 3-7 (HDMA 7, non-repeating)
    ; CPX #$7E : BEQ .parallax_sky ; 3-7
    ; CPX #$51 : BEQ .caged_ghost ; 3-8
    ; CPX #$55 : BEQ .kebab_logs ; 4-4
    ; CPX #$56 : BEQ .squishable_block ; 4-5
    CPX #!lvl_hookbill : BEQ .disable
    ; CPX #$27 : BEQ .caged_ghost ; 5-4
    ; CPX #$5E : BEQ .support_ghost ; 5-4 (+ see-saw, squishable block)
    CPX #$B3 : BEQ .3d_rotating_platforms ; 5-8
    ; CPX #$67 : BEQ .chameleon_salvo ; 6-4 (boss salvo uses bg2)
    ; CPX #$B8 : BEQ .seesaw ; 6-8
    ; CPX #$C6 : BEQ .caged_ghost ; 6-8 (+ squishable block)
    CPX #!lvl_bowser : BEQ .disable
    ; CPX #$35 : BEQ .caged_ghost ; 6-E (both areas of this room)
    ; CPX #$6C : BEQ .kebab_logs ; 6-E

    ; level intro wipe and other screen transitions use 5 while active
    ; kamek magic dust uses 1/2/4/5 while active (and changes bg3vofs)
    ; background palette transition uses 1/2
.default
    LDX #%01000000
    BRA +
.3d_rotating_platforms ; uses 1/2/3/4/6
    LDX #%10000000
    BRA +
.underwater ; uses 6/7
    LDX #%00010000
    BRA +
.disable
    LDX #$00
+
    STX !hud_hdma_channel

    TXA : BEQ .ret ; skip setting controls if no channel specified

    ; HDMA base register for channel = log2(channel) * 16 + $4300
    LDY #$00
  - {
        LSR : BCS +
        INY
        BRA -
    }
    +
    TYA
    ASL #4
    CLC : ADC #!reg_dmap0
    STA $00

    ; set the HDMA registers for the selected channel
    %a8()
    LDY.b #datasize(hud_hdma_table_controls)-1
-
    LDA hud_hdma_table_controls,y : STA ($00),y
    DEY
    BPL -

    LDA !hud_hdma_channel : TSB !r_reg_hdmaen_mirror
.ret
    PLP
    RTS

; we may use custom flags that control multiple game flags - update the game flags here
; note that they may also need to be updated when leaving the menu
handle_flags:
    PHP
    %a16()
    %i8()

    ; if input bindings have not yet been loaded, or if they have been modified, load them here
    LDX !prep_binds_flag : BNE + ; zero = flag on (leverage WRAM clear on boot)
    JSR prepare_input_bindings
    INC !prep_binds_flag
    +

    LDA !skip_kamek
    AND #$00FF
    STA !skip_kamek ; in case the flag has some garbage in the high nibble initially
    STA !skip_kamek_flag_1
    STA !skip_kamek_flag_2
    LDA !skip_baby_bowser
    BEQ .ret
    STA !skip_kamek_flag_2 ; if skipping baby bowser, must also skip Kamek
.ret
    PLP
    RTS

hud_hdma_table_controls:
    db %00000011 ; !reg_dmap0, 011 => 2 registers write twice each (4 bytes: p, p, p+1, p+1)
    db !reg_bg3hofs ; !reg_bbad0, B bus address (dest)
    dw hud_hdma_table ; !reg_a1t0l, A bus address (src)
    db $7E ; !reg_a1b0, A bus bank

; 3 lines, 32 columns
; 2bpp palette indexes
; 0 ($20), 1 ($24), 2 ($28), 3 ($2C) = dynamic bg3
; 4 ($30), 5 ($34), 6 ($38) = default bg1 (red lava, brown wood platforms etc.)
; 7 ($3C) = dynamic bg1
hud_tilemap_template:
    dw $303F, $303F, $303F, $303F, $303F, $303F, $3C37, $303F ; 00-0F
    dw $303F, $303F, $3C36, $303F, $303F, $303F, $3034, $303F ; 10-1F
    dw $302B, $303F, $303F, $302C, $303F, $303F, $303F, $303F ; 20-2F
    dw $303F, $303F, $303F, $303F, $303F, $303F, $303F, $303F ; 30-3F

    dw $303F, $303F, $303F, $303F, $303F, $303F, $303E, $303F ; 40-4F
    dw $303F, $303F, $3C38, $303F, $303F, $303F, $303F, $303F ; 50-5F
    dw $302B, $303F, $303F, $302C, $303F, $303F, $303F, $303F ; 60-6F
    dw $303F, $303F, $303F, $303F, $303F, $303F, $303F, $303F ; 70-7F

    dw $303F, $303F, $303F, $303F, $303F, $303F, $303F, $303F ; 80-8F
    dw $303F, $303F, $303F, $303F, $303F, $303F, $303F, $303F ; 90-9F
    dw $303F, $303F, $303F, $303F, $303F, $303F, $303F, $303F ; A0-AF
    dw $303F, $303F, $303F, $303F, $303F, $303F, $303F, $303F ; B0-BF
