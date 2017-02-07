; General Variables

!gamemode = $0118
!level_load_type = $038C

; Screen exit data
!screen_exit_level = $7F7E00
!screen_exit_xpos = $7F7E01
!screen_exit_ypos = $7F7E02
!screen_exit_type = $7F7E02
!current_screen = $038E

; Controller data
!controller_data1 = $093C
!controller_data2 = $093D

!controller_data1_press = $093E
!controller_data2_press = $093F

!controller_data2_press_mode0f = $6072
!controller_data2_press_mode0f = $6073


;Item Memory
!item_mem_current_page = $03BE
; 128 bytes per page
!item_mem_page0 = $03C0
!item_mem_page1 = $0440
!item_mem_page2 = $04C0
!item_mem_page3 = $0540

;Egg Inventory
handle_egg_inv_routine = $01B2B7

!egg_inv_size = $7E5D98
!egg_inv_items = $7E5D9A

!egg_inv_size_cur = $7DF6
!egg_inv_items_cur = $7DF8

; Star/Coin/Flower Counter
!red_coin_count = $03B4
!star_count = $03B6
!flower_count = $03B8

; Sprite Despawn table
; 256 bytes
!sprite_despawn_table = $7028CA

; Yoshi Mouth item (melons)
!mouth_sprite_id = $6162
!mouth_melon_type = $616A
!mouth_melon_count = $6170

; Camera Positions
!r_camera_layer1_x = $0039
!r_camera_layer2_x = $003D
!r_camera_layer3_x = $0041
!r_camera_layer4_x = $0045

!r_camera_layer1_y = $003B
!r_camera_layer2_y = $003F
!r_camera_layer3_y = $0043
!r_camera_layer4_y = $0047

!s_camera_layer1_x = $6094
!s_camera_layer2_x = $6096
!s_camera_layer3_x = $6098
!s_camera_layer4_x = $609A

!s_camera_layer1_y = $609C
!s_camera_layer2_y = $609E
!s_camera_layer3_y = $60A0
!s_camera_layer4_y = $60A2

;??
;Yoshi States / speed
!yoshi_x_pos = $608C
!yoshi_y_pos = $6090

!yoshi_x_speed = $60B4
!yoshi_y_speed = $60AA



;Sprite Data
; $6F00 

;Modified Terrain