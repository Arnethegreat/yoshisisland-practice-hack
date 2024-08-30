; Edit level load (with text) timer
; Now starts as soon as there is input
org level_intro_wait
    JSL wait_for_input
    NOP #4

; Skip icon rotating on world map
org map_icon_rotation
    LDA #$0000

; speed up world map transition
org world_map_prev_fold_away
    NOP #19

org world_map_new_fold_in
    NOP #14

; post-level score screen animations
org scorescreen_state_pointers+$19 ; screen transition complete, wait for counting stars
    dw !scorescreen_skip_state
org scorescreen_state_pointers+$1D ; finish counting stars, wait for red coins
    dw !scorescreen_skip_state
org scorescreen_state_pointers+$21 ; finish counting red coins, wait for flowers
    dw !scorescreen_skip_state
org scorescreen_state_pointers+$25 ; finish counting flowers, wait for points
    dw !scorescreen_skip_state
org scorescreen_state_pointers+$2D ; counting points
    dw !scorescreen_skip_state
org scorescreen_state_pointers+$2F ; draw circle around points
    dw !scorescreen_skip_state
org scorescreen_state_pointers+$31 ; waiting
    dw !scorescreen_skip_state
org scorescreen_state_pointers+$35 ; draw flower around points
    dw !scorescreen_skip_state
org scorescreen_state_pointers+$37 ; waiting while fanfare plays
    dw !scorescreen_skip_state

; skip overworld high score update animations
org game_mode_26
    LDA #!gm_overworld : STA !gamemode
    JMP game_mode_22
