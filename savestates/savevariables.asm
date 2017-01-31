!loaded_state = $140A

; persistent save data (keeps on reset)
    !save_level = $707F0A
    !save_x_pos = $707F0C
    !save_y_pos = $707F0E

    ; egg inventory
    !save_egg_inv_size = $707F10
    !save_egg_inv_items = $707F12

    ; melon
    !save_mouth_sprite_id = $707F20
    !save_mouth_melon_type = $707F22
    !save_mouth_melon_count = $707F24

    ; speed
    !save_yoshi_x_speed = $707F26
    !save_yoshi_y_speed = $707F28

    ; jump state
    !save_jump_state = $707F2A

    ; flutter state
    !save_flutter_state = $707F2C

;---------------
; non-persistent

; item memory
; 128 bytes per page
!save_item_mem_page0 = $7F0100
!save_item_mem_page1 = $7F0180
!save_item_mem_page2 = $7F0200
!save_item_mem_page3 = $7F0280

; Sprite Spawn Table
; 256 bytes
!save_sprite_despawn_table = $7F0300