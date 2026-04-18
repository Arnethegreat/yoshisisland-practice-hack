param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("U", "J")]
    [string]$Region,

    [Parameter()]
    [switch]$Dbg,

    [Parameter()]
    [string]$DbgPath
)

$rom_path = "ROMs/${Region}1.0_prac.sfc"
$sym_path = "ROMs/${Region}1.0_prac.sym"

# resolve debugger path
if ($Dbg) {
    if (-not $DbgPath) {
        $DbgPath = $env:MESEN_PATH
    }

    if (-not $DbgPath) {
        Write-Error "No debugger specified. Use -Debugger <path> or set MESEN_PATH"
        exit 1
    }

    if (-not (Test-Path $DbgPath)) {
        Write-Error "Debugger not found: $DbgPath"
        exit 1
    }
}

switch ($Region) {
    "U" {
        Copy-Item -Path ROMs\NA_clean.sfc -Destination $rom_path
    }
    "J" {
        Copy-Item -Path ROMs\JP_clean.sfc -Destination $rom_path
    }
}

if ($Dbg) {
    .\asar.exe --symbols=wla --symbols-path=$sym_path assemble.asm $rom_path
} else {
    .\asar.exe assemble.asm $rom_path
}

$now = Get-Date -Format "HH:mm:ss"
Write-Host "$rom_path built at $now"

# optional debugger
if ($Dbg) {
    Write-Host "Launching debugger..."
    & "$DbgPath" "$rom_path"
}
