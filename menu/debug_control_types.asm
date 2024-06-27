; Control type inits
;

init_highnib_memchanger:
  JSR draw_highnib
.ret
  RTS

init_lownib_memchanger:
  JSR draw_lownib
.ret
  RTS

init_toggle_changer:
  JSR draw_toggle
.ret
  RTS

init_egg_changer:
  JSR clean_egg_inv_mirror
  JSR draw_egg_changer
.ret
  RTS

init_call_function:
.ret
  RTS

init_warps_function:
.ret
  RTS

init_submenu_loader:
.ret
  RTS

;================================
; Control type cleanups

cleanup_highnib_memchanger:
.ret
  RTS

cleanup_lownib_memchanger:
.ret
  RTS

cleanup_toggle_changer:
.ret
  RTS

cleanup_egg_changer:
  PHP
  %ai16()
  ; remove old egg helper tiles
  LDX !debug_base+!dbc_tilemap
  LDA #$003F
  STA !menu_tilemap_mirror-!tilemap_line_width_single-2,x
  STA !menu_tilemap_mirror-!tilemap_line_width_single+2,x
.ret
  PLP
  RTS

cleanup_call_function:
.ret
  RTS

cleanup_warps_function:
.ret
  RTS

cleanup_submenu_loader:
.ret
  RTS

;================================
; Control type main routines

main_highnib_memchanger:
  SEP #$20

; pressing A?
.check_increment
  LDA !controller_data1_press
  AND #!controller_data1_A
  BEQ .check_decrement

  ; increment only high nibble
  LDA [!dbc_memory]
  STA $0000
  CLC
  ADC #$10
  AND #$F0
  STA $0002

  ; compare to wild card (max)
  LDA $0000
  CMP !dbc_wildcard
  BCC +
  LDA !dbc_wildcard+1
  STA $0002

+
  LDA $0000
  AND #$0F
  ORA $0002
  STA [!dbc_memory]
  LDA #!sfx_shell_07
  BRA .update_draw

; pressing Y?
.check_decrement
  LDA !controller_data2_press
  AND #!controller_data2_Y
  BEQ .ret

  ; decrement only high nibble
  LDA [!dbc_memory]
  STA $0000
  AND #$F0

  ; compare to wild card (min)
  CMP !dbc_wildcard+1
  BNE .normal_dec
  LDA !dbc_wildcard
  STA $0002
  BRA .wrap

.normal_dec
  LDA $0000
  AND #$F0
  SEC
  SBC #$10
  STA $0002
.wrap
  LDA $0000
  AND #$0F
  ORA $0002
  STA [!dbc_memory]
  LDA #!sfx_shell_06

.update_draw
  STA !sound_immediate
  JSR draw_highnib

.ret
  RTS

;================================

main_lownib_memchanger:
  SEP #$20

; pressing A?
.check_increment
  LDA !controller_data1_press
  AND #!controller_data1_A
  BEQ .check_decrement

  ; increment only low nibble
  LDA [!dbc_memory]
  STA $0000
  INC A
  AND #$0F
  STA $0002

  ; compare to wild card (max)
  LDA $0000
  AND #$0F ; make sure we're only comparing the low nibble
  CMP !dbc_wildcard
  BCC +
  LDA !dbc_wildcard+1
  STA $0002
+
  LDA $0000
  AND #$F0
  ORA $0002
  STA [!dbc_memory]
  LDA #!sfx_shell_07
  BRA .update_draw

; pressing Y?
.check_decrement
  LDA !controller_data2_press
  AND #!controller_data2_Y
  BEQ .ret

  ; decrement only low nibble
  LDA [!dbc_memory]
  STA $0000
  AND #$0F

  ; compare to wild card (min)
  CMP !dbc_wildcard+1
  BNE .normal_dec
  LDA !dbc_wildcard
  STA $0002
  BRA .wrap

.normal_dec
  DEC A
  STA $0002
.wrap
  LDA $0000
  AND #$F0
  ORA $0002
  STA [!dbc_memory]
  LDA #!sfx_shell_06

.update_draw
  STA !sound_immediate
  JSR draw_lownib
; hacky because don't feel like doing a seperate egg count type
  JSR clean_egg_inv_mirror
  JSR draw_all_egg_changer

.ret
  RTS

;================================

main_toggle_changer:
  SEP #$30

  LDA !controller_data1_press
  ORA !controller_data2_press
; B/Y/X/A buttons
  AND #!controller_data1_A|!controller_data1_X
  BEQ .ret

  LDA [!dbc_memory]
  BEQ .set
  LDA #$00
  BRA .reset
.set
  AND !dbc_wildcard
  EOR !dbc_wildcard
.reset
  STA [!dbc_memory]
  LDA #!sfx_key_chink : STA !sound_immediate
  JSR draw_toggle

.ret
  RTS

;================================

main_egg_changer:
  SEP #$20

  JSR draw_egg_selection_helpers ; this runs every frame in order to trigger on initial select, not ideal

  ; egg inventory number
  LDA !dbc_wildcard
  ASL A
  TAX

; pressing A?
.check_increment
  LDA !controller_data1_press
  AND #!controller_data1_A
  BEQ .check_decrement

; wrap from 1-12
  LDA !debug_egg_inv_mirror,x
  INC A
  CMP #$0D
  BCC .inc
  LDA #$01

.inc
  STA !debug_egg_inv_mirror,x
  LDA #!sfx_collect_egg
  BRA .update_draw

; pressing Y?
.check_decrement
  LDA !controller_data2_press
  AND #!controller_data2_Y
  BEQ .ret

  LDA !debug_egg_inv_mirror,x
  DEC A
  BNE .dec
  LDA #$0C

.dec
  STA !debug_egg_inv_mirror,x
  LDA #!sfx_collect_egg

.update_draw
  STA !sound_immediate
  JSR clean_egg_inv_mirror
  JSR draw_egg_changer

.ret
  RTS

;================================

main_call_function:
  SEP #$30
  LDA !controller_data1_press
  ORA !controller_data2_press
; B/Y/X/A buttons
  AND #!controller_data1_A|!controller_data1_X
  BEQ .ret

  LDA !dbc_wildcard
  ASL A
  TAX
  JSR (control_function_calls,x)
  LDA #!sfx_midway_tape : STA !sound_immediate

.ret
  RTS

;================================

main_warps_function:
  SEP #$30
  LDA !controller_data1_press
  ORA !controller_data2_press
; B/Y/X/A buttons
  AND #!controller_data1_A|!controller_data1_X
  BEQ .ret
  LDA !controller_data2_press ; if just B, go back
  AND #!controller_data2_B
  BEQ +
  LDX #$00 ; set X to zero to indicate that we want to go back
  BRA ++
+
  LDA !dbc_wildcard
  TAX
++
  JSR warp_menu
.ret
  RTS

;================================

main_submenu_loader:
  %ai8()
  LDA !controller_data1_press
  ORA !controller_data2_press
; B/Y/X/A buttons
  AND #!controller_data1_A|!controller_data1_X
  BEQ .ret
  { ; load submenu
    %a16()
    LDA.w #!sfx_move_cursor : STA !sound_immediate
    LDA !dbc_wildcard
    BNE +
    { ; wildcard == zero means back
      LDA.w !sfx_poof : STA !sound_immediate
      LDA !parent_menu_data_ptr
  + }
    STA !current_menu_data_ptr
    STZ !dbc_index_row
    STZ !dbc_index_col
    JSR init_current_menu
  }
.ret
  RTS

;================================
; Loop through egg inventory
; Mark eggs as empty if after
clean_egg_inv_mirror:
  REP #$20
  SEP #$10
  LDY #$05
  .loop
  TYA
  CMP !debug_egg_count_mirror
  BCC +
  ASL A
  TAX
  STZ !debug_egg_inv_mirror,x
  BRA .end
  +
  ASL A
  TAX
  LDA !debug_egg_inv_mirror,x
  BNE .end
  LDA #$0005
  STA !debug_egg_inv_mirror,x
  .end
  DEY
  BPL .loop
.ret
  RTS

;================================
; Read inventory and translate sprite ID to 
; proper index for debug egg inv

egg_inv_to_debug_mirror:
  REP #$30
  LDA !egg_inv_size
  LSR A
  STA !debug_egg_count_mirror
  LDX #$000A
  .loop
    LDA !egg_inv_items,x
    LDY #!egg_inv_tilemap_count*4-8 ; don't need the empty and unknown values
    .translate_loop
      CMP egg_inv_tilemap,y
      BEQ .match
      DEY
      DEY
      DEY
      DEY
      BNE .translate_loop
  ; no match, set as unknown sprite
    LDY #!egg_inv_tilemap_count*4-4
  .match
    TYA
    LSR A
    LSR A
    STA !debug_egg_inv_mirror,x
    DEX
    DEX
    BPL .loop

.ret
  RTS

;================================
; Read debug inventory and transfer to real inventory
;

debug_inv_to_egg_inv:
  REP #$30

  LDA !debug_egg_count_mirror
  ASL A
  STA !egg_inv_size
  BEQ .ret
  TAY
  .loop
    LDA !debug_egg_inv_mirror-2,y
    ; if null egg/unknown index, don't set
    CMP.w #!egg_inv_tilemap_count-1
    BCS +
    ASL A
    ASL A
    TAX
    LDA egg_inv_tilemap,x
    TYX
    STA !egg_inv_items-2,x
    +
    DEY
    DEY
    BNE .loop

.ret
  RTS