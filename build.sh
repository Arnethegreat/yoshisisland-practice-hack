#!/bin/sh

if [ "$1" != "U" ]; then
    cp "ROMs\JP_clean.sfc" "ROMs\J1.0_prac.sfc"
    ./asar.exe assemble.asm ROMs/J1.0_prac.sfc
fi

if [ "$1" != "J" ]; then
    cp "ROMs\NA_clean.sfc" "ROMs\U1.0_prac.sfc"
    ./asar.exe assemble.asm ROMs/U1.0_prac.sfc
fi

NOW=$(date +"%T")
echo "Assembled at $NOW"
