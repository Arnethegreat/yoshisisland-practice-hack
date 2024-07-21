!controller_on_press_store = $CC
!controller_2_on_press_store = $CE


handle_frame_skip:
  LDA !load_delay_timer
  BEQ +
  {
    DEC !load_delay_timer
    JMP game_loop_skip
  }
  +

  LDA !frame_skip
  BEQ frame_skip_main_ret

frame_skip_main:
  LDA !debug_menu
  BNE .ret
  LDA !frame_skip_timer
  BEQ .reset_timer

.skip_a_frame
  REP #$20

  LDA !controller_on_press_store
  ORA !controller_data1_press_dp
  STA !controller_on_press_store

  LDA !controller_2_on_press_store
  ORA !controller_2_data1_press
  STA !controller_2_on_press_store

  SEP #$20
  DEC !frame_skip_timer
  JMP game_loop_skip

.reset_timer
  LDA !frame_skip
  STA !frame_skip_timer

  REP #$20

  LDA !controller_data1_press_dp
  ORA !controller_on_press_store
  STA !controller_data1_press_dp
  STA !controller_data1_press
  STZ !controller_on_press_store

  LDA !controller_2_data1_press
  ORA !controller_2_on_press_store
  STA !controller_2_data1_press
  STZ !controller_2_on_press_store

  SEP #$20

.ret
  JMP game_loop_continue
