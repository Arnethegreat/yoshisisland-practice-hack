map_init:
    PHP
    PHB
    PHK
    PLB
    SEP #$30

    LDA #$21 : STA !gamemode ; mode = fade into overworld

    STZ !hud_displayed
    STZ !timer_enabled
    STZ !level_frames
    STZ !level_seconds
    STZ !level_minutes
    STZ !total_frames

    PLB
    PLP
    RTL
