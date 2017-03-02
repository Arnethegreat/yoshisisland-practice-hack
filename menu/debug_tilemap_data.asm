; 25 bytes
!title_tilemap_size = #$0032
!title_tilemap_dest = $0006
title_tilemap:
; CuteShrug
dw $0040, $0041, $0042
; PRACTICE HACK V
dw $0019, $001b, $000a, $000c
dw $001d, $0012, $000c, $000e
dw $003f, $0011, $000a, $000c
dw $0014, $003F 
; 0.3.0
dw $0000, $0024, $0003, $0024, $0000
; CuteShrug
dw $0040, $0041, $0042


!option_1_tilemap_size = #$0024
!option_1_tilemap_dest = $00C2
option_1_tilemap:
; DISABLE AUTOSCROLL
dw $000D, $0012, $001C, $000A
dw $000B, $0015, $000E, $003F
dw $000A, $001E, $001D, $0018
dw $001C, $000C, $001B, $0018
dw $0015, $0015


!option_2_tilemap_size = #$0018
!option_2_tilemap_dest = $0142
option_2_tilemap:
; WARP TO BOSS
dw $0020, $000A, $001B, $0019
dw $003F, $001D, $0018, $003F
dw $000B, $0018, $001C, $001C


!option_3_tilemap_size = #$0018
!option_3_tilemap_dest = $01C2
option_3_tilemap:
; MUSIC TOGGLE
dw $0016, $001E, $001C, $0012, $000C, $003F, $001D, $0018, $0010, $0010, $0015, $000E


!option_4_tilemap_size = #$001A
!option_4_tilemap_dest = $0254
option_4_tilemap:
; FREE MOVEMENT
dw $000F, $001B, $000E, $000E, $003F, $0016, $0018, $001F, $000E, $0016, $000E, $0017, $001D


!option_5_tilemap_size = #$0014
!option_5_tilemap_dest = $02D4
option_5_tilemap:
; EGG EDITOR
dw $000E, $0010, $0010, $003F, $000E, $000D, $0012, $001D, $0018, $001B

!option_6_tilemap_size = #$001E
!option_6_tilemap_dest = $0354
option_6_tilemap:
; SLOWDOWN AMOUNT
dw $001C, $0015, $0018, $0020, $000D, $0018, $0020
dw $0017, $003F, $000A, $0016, $0018, $001E, $0017, $001D


!option_7_tilemap_size = #$0028
!option_7_tilemap_dest = $03D4
option_7_tilemap:
; FULL LOAD AS DEFAULT
dw $000F, $001E, $0015, $0015, $003F, $0015, $0018, $000A, $000D
dw $003F, $000A, $001C, $003F, $000D, $000E, $000F, $000A, $001E, $0015, $001D


!option_8_tilemap_size = #$0024
!option_8_tilemap_dest = $0454
option_8_tilemap:
; SET TUTORIAL FLAGS
dw $001C, $000E, $001D, $003F, $001D, $001E, $001D, $0018
dw $001B, $0012, $000A, $0015, $003F, $000F, $0015, $000A, $0010, $001C


!option_9_tilemap_size = #$002A
!option_9_tilemap_dest = $04D4
option_9_tilemap:
; DISABLE KAMEK AT BOSS
dw $000D, $0012, $001C, $000A, $000B, $0015, $000E, $003F, $0014, $000A, $0016
dw $000E, $0014, $003F, $000A, $001D, $003F, $000B, $0018, $001C, $001C

;====================================

init_option_tilemaps:
    REP #$30
    LDX #$0000
    .loop
        LDA title_tilemap,x
        STA !menu_tilemap_mirror+!title_tilemap_dest,x
        INX
        INX
        CPX !title_tilemap_size
        BNE .loop

    LDX #$0000
    -
        LDA option_1_tilemap,x
        STA !menu_tilemap_mirror+!option_1_tilemap_dest,x
        INX
        INX
        CPX !option_1_tilemap_size
        BNE -

    LDX #$0000
    -
        LDA option_2_tilemap,x
        STA !menu_tilemap_mirror+!option_2_tilemap_dest,x
        INX
        INX
        CPX !option_2_tilemap_size
        BNE -

    LDX #$0000
    -
        LDA option_3_tilemap,x
        STA !menu_tilemap_mirror+!option_3_tilemap_dest,x
        INX
        INX
        CPX !option_3_tilemap_size
        BNE -

    LDX #$0000
    -
        LDA option_4_tilemap,x
        STA !menu_tilemap_mirror+!option_4_tilemap_dest,x
        INX
        INX
        CPX !option_4_tilemap_size
        BNE -

    LDX #$0000
    -
        LDA option_5_tilemap,x
        STA !menu_tilemap_mirror+!option_5_tilemap_dest,x
        INX
        INX
        CPX !option_5_tilemap_size
        BNE -

    LDX #$0000
    -
        LDA option_6_tilemap,x
        STA !menu_tilemap_mirror+!option_6_tilemap_dest,x
        INX
        INX
        CPX !option_6_tilemap_size
        BNE -

    LDX #$0000
    -
        LDA option_7_tilemap,x
        STA !menu_tilemap_mirror+!option_7_tilemap_dest,x
        INX
        INX
        CPX !option_7_tilemap_size
        BNE -

    LDX #$0000
    -
        LDA option_8_tilemap,x
        STA !menu_tilemap_mirror+!option_8_tilemap_dest,x
        INX
        INX
        CPX !option_8_tilemap_size
        BNE -

    LDX #$0000
    -
        LDA option_9_tilemap,x
        STA !menu_tilemap_mirror+!option_9_tilemap_dest,x
        INX
        INX
        CPX !option_9_tilemap_size
        BNE -

.ret
    RTS