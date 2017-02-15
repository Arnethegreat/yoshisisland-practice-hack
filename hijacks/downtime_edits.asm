; Edit level load (with text) timer
; Now starts as soon as there is input
org level_intro_wait
wait:
    LDA $0035
    ORA $0940
    BEQ wait
; Skip icon rotating on world map
 ;
org map_icon_rotation
    LDA #$0000