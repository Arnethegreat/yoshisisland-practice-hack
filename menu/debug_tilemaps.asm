; Loads each char sequentially from tilemap into the mirror offset by tilemap_dest
macro load_text(tilemap, tilemap_dest)
    LDX #$0000
    ?-
        LDA <tilemap>,x : STA !menu_tilemap_mirror+<tilemap_dest>,x
        INX
        INX
        CPX #datasize(<tilemap>)
        BNE ?-
endmacro


; initialize tilemap with blank tiles
blank_tilemap:
    PHA
    PHX
    PHP
    %ai16()
    LDX !menu_tilemap_size
    - {
        LDA #$003F : STA !menu_tilemap_mirror-2,x
        DEX #2
        BNE -
    }
.ret
    PLP
    PLX
    PLA
    RTS

; subroutine to load each char sequentially from tilemap into the mirror offset by tilemap_dest_start_offset
; takes a newline when a sentinel char is encountered and stops writing when two sentinels in a row
; set tilemap_src and tilemap_dest_start_offset before calling
!tilemap_src = $00
!tilemap_dest_start_offset = $02
load_text_page:
!tilemap_dest_char_offset = $04

    STZ !tilemap_dest_char_offset
    LDY #$0000
    -
        LDA (!tilemap_src),y
        CMP #!lf ; if lf, we reached the end of the line
        BEQ .eol

        ; we need to combine two indices (line start offset, char offset) into the base tilemap mirror address
        ; which is a long situated in bank 7E, plus the char offset (currently in y)
        ; absolute long indexed (x) is the only addressing mode that works here
        ; so we can use the mirror as the STA operand, with the relative dest + offset in x
        
        PHA ; save current tilemap on stack
        LDA !tilemap_dest_start_offset ; fetch the relative dest
        PHA ; save the relative dest cos we can't just add registers directly (i think?)
        LDA !tilemap_dest_char_offset
        CLC
        ADC $01,s ; add the stored relative dest to the offset
        TAX ; move the combined relative dest/offset into X
        PLA ; pop the saved relative dest (not needed)
        PLA ; pop the saved current tilemap
        STA !menu_tilemap_mirror,x
        BRA .next
    .eol
        INY
        INY
        LDA (!tilemap_src),y
        CMP #!lf ; 2 lfs in a row, we reached the end of the page
        BEQ .ret
        ; add 1 line width to tilemap_dest - basically a line feed
        LDA !tilemap_dest_start_offset
        CLC
        ADC #!tilemap_line_width
        STA !tilemap_dest_start_offset
        STZ !tilemap_dest_char_offset ; reset the char offset
        BRA -
    .next
        INY
        INY
        INC !tilemap_dest_char_offset
        INC !tilemap_dest_char_offset
        BRA -
.ret
    RTS

init_main_menu_tilemap:
    PHD
    PHP
    %ai16()
    %zero_dp()

    %load_text(title_tilemap, !title_tilemap_dest)

    LDA #option_mainmenu_tilemap : STA !tilemap_src
    LDA #!first_option_tilemap_dest : STA !tilemap_dest_start_offset
    JSR load_text_page
.ret
    PLP
    PLD
    RTS

init_warp_option_worlds_tilemaps:
    PHD
    PHP
    %ai16()
    %zero_dp()

    %load_text(title_tilemap, !title_tilemap_dest)
    %load_text(option_back_tilemap, !first_option_tilemap_dest)

    LDA #option_worlds_tilemap : STA !tilemap_src
    LDA #!first_option_tilemap_dest+!tilemap_line_width : STA !tilemap_dest_start_offset
    JSR load_text_page
.ret
    PLP
    PLD
    RTS

init_warp_option_levels_tilemaps:
    PHD
    PHP
    %ai16()
    %zero_dp()

    %load_text(title_tilemap, !title_tilemap_dest)
    %load_text(option_back_tilemap, !first_option_tilemap_dest)

    LDA !warps_current_world_index
    ASL A ; offset is 2 bytes per index
    TAX
    LDA option_world_tilemaps_addr_table,x : STA !tilemap_src
    
    ; set page title to the first char of the world tilemap e.g. 1, 5, etc.
    LDA (!tilemap_src)
    STA !menu_tilemap_mirror+!warps_title_tilemap_dest

    LDA #!first_option_tilemap_dest+!tilemap_line_width : STA !tilemap_dest_start_offset
    JSR load_text_page
.ret
    PLP
    PLD
    RTS

init_warp_option_rooms_tilemaps:
    PHD
    PHP
    %ai16()
    %zero_dp()

    %load_text(title_tilemap, !title_tilemap_dest)
    %load_text(option_back_tilemap, !first_option_tilemap_dest)
    %load_text(option_start_tilemap, !first_option_tilemap_dest+!tilemap_line_width)
    
    LDA #!first_option_tilemap_dest+!tilemap_line_width*2 : STA !tilemap_dest_start_offset
    LDA !warps_current_world_index
    ASL A
    TAX
    LDA .world_ptrs,x : STA $06
    LDA !warps_current_level_index
    ASL A ; index --> offset
    TAY
    LDA ($06),y : STA !tilemap_src

    ; set page title using `world-level` notation
    LDA !warps_current_world_index
    INC
    STA !menu_tilemap_mirror+!warps_title_tilemap_dest+0
    LDA #$0027 ; hyphen
    STA !menu_tilemap_mirror+!warps_title_tilemap_dest+2
    ; this method runs into an issue when dealing with the extra levels, printing `x-9` instead of `x-E`
    LDA !warps_current_level_index
    ; check if A == 8
    CMP #$0008
    BNE +
    { ; if true, it's an extra - set the tilemap to 'E'
        LDA #$000E : STA !menu_tilemap_mirror+!warps_title_tilemap_dest+4
        BRA ++
    }
    + { ; else, just print the number
        INC
        STA !menu_tilemap_mirror+!warps_title_tilemap_dest+4
    }
    ++

    JSR load_text_page
.ret
    PLP
    PLD
    RTS
.world_ptrs
    dw option_world1_tilemaps_addr_table, option_world2_tilemaps_addr_table, option_world3_tilemaps_addr_table, option_world4_tilemaps_addr_table, option_world5_tilemaps_addr_table, option_world6_tilemaps_addr_table

undef "tilemap_src"
undef "tilemap_dest_start_offset"
