%var_00CC(controller_on_press_store, 2)
%var_00CC(controller_2_on_press_store, 2)


slowdown_dec:
  STZ !frame_skip_pause
  DEC !slowdown_mag
  BPL +
  STZ !slowdown_mag
  +
  RTS

slowdown_inc:
  STZ !frame_skip_pause
  INC !slowdown_mag
  RTS

frame_advance:
  LDA #$01 : STA !frame_skip_pause
  DEC #2
  STA !frame_skip_timer ; set timer to -1 so that the next frame runs
  RTS

handle_frame_skip:
  LDA !load_delay_timer
  BEQ +
  {
    DEC !load_delay_timer
    JMP game_loop_skip
  }
  +

  LDA !frame_skip_timer
  CLC : ADC !frame_skip_pause ; pause prevents the timer from decreasing, so it never advances a frame
  STA !frame_skip_timer
  BEQ .reset_timer

.skip_a_frame
  REP #$20

  LDA.b !controller_on_press_store
  ORA.b !controller_data1_press
  STA.b !controller_on_press_store

  LDA.b !controller_2_on_press_store
  ORA !controller_2_data1_press
  STA.b !controller_2_on_press_store

  SEP #$20
  DEC !frame_skip_timer
  JMP game_loop_skip

.reset_timer
  LDA !slowdown_mag
  STA !frame_skip_timer

  REP #$20

  LDA.b !controller_data1_press
  ORA.b !controller_on_press_store
  STA.b !controller_data1_press
  STA.b !controller_data1_press
  STZ.b !controller_on_press_store

  LDA !controller_2_data1_press
  ORA.b !controller_2_on_press_store
  STA !controller_2_data1_press
  STZ.b !controller_2_on_press_store

  SEP #$20

.ret
  JMP game_loop_continue
