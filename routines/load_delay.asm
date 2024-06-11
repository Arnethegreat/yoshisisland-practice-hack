load_delay:
  PHP
  SEP #$20

  LDA !load_delay_timer ; if timer is 0, reset it, deactivate load delay, and resume normal gameplay
  BNE +
  {
    LDA !load_delay_timer_init : STA !load_delay_timer
    STZ !is_load_delay_timer_active
    PLP
    JML continue_frame
  }
  +
  DEC !load_delay_timer ; else, decrement timer and skip this frame
  PLP
  JML end_frame
