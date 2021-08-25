lorom
;=================================
; check for version in internal header
; error if bad version
if read1($00FFDB) != $00
    print "1.1 ROM version are not supported yet (ask me about it)"
    error "Version Error"
endif
;=================================
; read destination code
; set labels for org during hijacks depending on version
if read1($00FFD9) == $00
    print "Japan 1.0 ROM"
;=================================
; save_level_hijack
    save_current_area = $01C2B6
; level_load_hijack
    level_load_camera = $04DBC9
; debug hijacks
    start_select_check = $01D31D

    file_select_check = $179890
        !file_select_check_jump = $992B

    free_movement = $04F5E7

    level_intro_wait = $01C3FA
    
    map_icon_rotation = $17E700

    world_map_prev_fold_away = $17CD3C

    world_map_new_fold_in = $17CEC5

    vram_dma_01 = $00BC47

elseif read1($00FFD9) == $01
    print "North American 1.0 ROM"
;=================================
; save_level_hijack
    save_current_area = $01B084
; level_load_hijack
    level_load_camera = $04DC2E
; debug hijacks
    start_select_check = $01C13D

    file_select_check = $179897
        !file_select_check_jump = $9932

    free_movement = $04F64C

    level_intro_wait = $01B1C8

    map_icon_rotation = $17E73E

    world_map_prev_fold_away = $17CD76

    world_map_new_fold_in = $17CEFB

    vram_dma_01 = $00BEA6

;=================================
else
    print "Unknown Region"
    error "Bad Region"

endif