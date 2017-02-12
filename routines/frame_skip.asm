!frame_skip = $012F
!frame_skip_timer = $0130

end_frame = $00813A
continue_frame = $008130

handle_frame_skip:
  NOP
  LDA $0942
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
  LDA !frame_skip_timer
  BEQ .reset_timer

.skip_a_frame
  REP #$20
  LDA $CC
  ORA $37
  STA $CC
  SEP #$20
  DEC !frame_skip_timer
  JML end_frame

.reset_timer
  LDA !frame_skip
  STA !frame_skip_timer

  REP #$20
  LDA $37
  ORA $CC
  STA $37
  STA $093E
  STZ $CC
  SEP #$20

.ret
  JML continue_frame