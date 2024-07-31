org gsu_update_camera_store
    iwt r15,#prevent_cam_update ; jump to freespace
    nop
    nop
    nop

org bank09_freespace
prevent_cam_update:
    iwt r5,#!loaded_state ; if loading savestate, don't update the camera
    ldb (r5) : sub #0 : bne +
    sms ($0094),r1
    sms ($009C),r2
    +
    stop
    nop
