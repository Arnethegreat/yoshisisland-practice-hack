!frame_skip = $012F
!frame_skip_timer = $0130

!controller_on_press_store = $CC
!controller_2_on_press_store = $CE

end_frame = $00813A
continue_frame = $008130



handle_frame_skip:
  LDA !controller_2_data1_press
  ; R controller 2
  BIT #$10
  BEQ .test_l
.inc_skip
  INC !frame_skip
.test_l
  BIT #$20
  BEQ .continue
.dec_skip
  DEC !frame_skip
  BPL .continue
  STZ !frame_skip
.continue
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
  JML end_frame

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
  JML continue_frame
