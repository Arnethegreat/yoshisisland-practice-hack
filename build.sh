#!/usr/bin/env bash

set -e

# no args provided - show usage
if [ $# -lt 1 ]; then
    echo "Usage: $0 <region> [--debug [debugger_path]]"
    echo "Regions: U | J"
    echo "Options:"
    echo "  --debug [path]   Launch debugger after build"
    echo "                   If no path is provided, uses \$MESEN_PATH"
    exit 1
fi

# handle region argument (default to U)
REGION=${1:-U}
ROM_PATH="ROMs/${REGION}1.0_prac.sfc"
SYM_PATH="ROMs/${REGION}1.0_prac.sym"
DEBUGGER=""
shift

while [[ $# -gt 0 ]]; do
    case "$1" in
        --debug)
            DEBUGGER=${2:-$MESEN_PATH}
            if [ ! -n "$DEBUGGER" ]; then
                echo "[Error] No debugger specified. Use --debug <path> or set MESEN_PATH"
                exit 1
            fi
            break
            ;;
        *)
            echo "[Error] Unknown option: $1"
            exit 1
    esac
done

# copy clean ROM
if [ $REGION = "U" ]; then
    cp "ROMs/NA_clean.sfc" $ROM_PATH
elif [ $REGION = "J" ]; then
    cp "ROMs/JP_clean.sfc" $ROM_PATH
else
    echo "[Error] Unknown region: $REGION"
    exit 1
fi

if [ -n "$DEBUGGER" ]; then
    ./asar.exe --symbols=wla --symbols-path=$SYM_PATH assemble.asm $ROM_PATH
else
    ./asar.exe assemble.asm $ROM_PATH
fi

# check for success
if [ $? -eq 0 ]; then
    NOW=$(date +"%T")
    echo "[Success] $ROM_PATH built at $NOW"
else
    echo "[Error] Build failed."
    exit 1
fi

# optionally launch debugger
if [ -n "$DEBUGGER" ]; then
    if [ ! -x "$DEBUGGER" ]; then
        echo "[Error] Debugger not found: $DEBUGGER"
        exit 1
    fi
    echo "Launching debugger..."
    "$DEBUGGER" "$ROM_PATH" > /dev/null 2>&1 &
fi
