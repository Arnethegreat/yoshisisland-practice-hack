@echo off

if not "%1"=="U" (
    copy /y ROMs\JP_clean.sfc ROMs\J1.0_prac.sfc
    asar.exe assemble.asm ROMs/J1.0_prac.sfc
)

if not "%1"=="J" (
    copy /y ROMs\NA_clean.sfc ROMs\U1.0_prac.sfc
    asar.exe assemble.asm ROMs/U1.0_prac.sfc
)

echo Assembled at %TIME%
