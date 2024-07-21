; NOP out branch past save-select debug code
; Edit code so it works on all files if you hold L
; "finish" a level by holding L while doing start-select
org start_select_check
    NOP #3
    LDA !controller_data1_dp
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
    LDA !controller_data1_dp
    AND #$30
; Change branch so it returns completely if user isn't holding L or R
    BEQ $F2

;=================================
; Hijack music routine so we can disable if needed
; $7EC019 runs every frame; if music track to be played (r_apu_io_0_mirror != 0) then go here
; contents of !r_apu_io_0_mirror in A, 8-bit AI
org play_music_track
    autoclean JSL prevent_music_change
    NOP #3

org free_movement
    BRA $1A ; .check_free_movement .. skip past warptoboss (don't need it) and flag toggling (we handle it)

org $17FD73 ; freespace in bank $17

load_file3_debug:
    PHP
    %ai8()
    LDA #$04 : STA !r_cur_save_file ; file 3
    JSR file_select_check+$18 ; post-controller check
.ret
    PLP
    RTL
