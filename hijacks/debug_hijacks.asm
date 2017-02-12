; NOP out branch past frame advance code
; Start on controller 2 enables frame advance
;=================================
; L and R to advance (L faster, R slower)
;
; TODO: Add button config
;       Fix so one advance toggles buttons on press
org $0080F6
    JML handle_frame_skip

;=================================
; NOP out branch past save-select debug code
; Edit code so it works on all files if you hold L
; "finish" a level by holding L while doing start-select
org start_select_check
    NOP #3
    LDA $35
    AND #$20
    BEQ $05

;=================================
; Hold L/R while entering File 3 for full save file
; Has all items and all levels unlocked
; Can cause kinda weird savefiles!
org file_select_check
; NOP out JMP past debug code
    NOP #3
; Checks if file 3
    LDA $111D
    CMP #$02
    BEQ $03  
; Jump past if so
    JMP !file_select_check_jump

    LDA #$63
    STA $037B
    LDA $35
    AND #$30
; Change branch so it returns completely if user isn't holding L or R
    BEQ $F2
;=================================
; Toggle Free Movement debug by pressing B on controller 2
; Press A+X on controller 2 to warp to boss room
;
org free_movement-$4C
; use controller 2 instead
    LDA $0940
; A + X
    CMP #$00C0

org free_movement
    NOP
    NOP

    JSR free_movement-$4C

; If B button on pressed on controller 2
    LDA $0943
    AND #$0080
    BEQ $0F
    NOP #6

;=================================

