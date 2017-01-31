lorom

; check for version in internal header
; error if bad version
if read($00FFDB) != $00
    print "1.1 version are not supported"
    error "Version Error"
endif

; read destination code
; set labels for org during hijacks depending on version
if read1($00FFD9) == $00
    print "Japan 1.0 ROM"

    save_current_area = $01C2B6
    level_load_camera = $04DBC9

elseif read1($00FFD9) == $01
    print "North American 1.0 ROM"

    save_current_area = $01B084
    level_load_camera = $04DC2E

else
    print "Unknown Region"
    error "Bad Region"

endif