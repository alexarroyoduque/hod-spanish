# ============================================================
# CONFIGURACION
# ============================================================

$Parche1 = "C:\parches\parche1.bps"
$Parche2 = "C:\parches\parche2.ips"
$Parche3 = "C:\parches\parche3.ips"

# ============================================================
# SCRIPT
# ============================================================

param(
    [Parameter(Mandatory = $true)]
    [string]$Rom
)

$ErrorActionPreference = "Stop"

# flips.exe debe estar en la misma carpeta que este script
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$Flips = Join-Path $ScriptDir "flips.exe"

if (-not (Test-Path $Flips)) {
    Write-Error "No se encuentra flips.exe en: $ScriptDir"
    exit 1
}

if (-not (Test-Path $Rom)) {
    Write-Error "No se encuentra la ROM: $Rom"
    exit 1
}

foreach ($Parche in @($Parche1, $Parche2, $Parche3)) {
    if (-not (Test-Path $Parche)) {
        Write-Error "No se encuentra el parche: $Parche"
        exit 1
    }
}

# Obtener carpeta y nombre de la ROM original
$Rom = (Resolve-Path $Rom).Path
$RomDir = Split-Path -Parent $Rom
$RomBase = [System.IO.Path]::GetFileNameWithoutExtension($Rom)

$RomParche1 = Join-Path $RomDir "$RomBase-parche1.gba"
$RomParche2 = Join-Path $RomDir "$RomBase-parche2.gba"
$RomParche3 = Join-Path $RomDir "$RomBase-parche3.gba"

# El resultado final debe poder sobrescribirse
if (Test-Path $RomParche3) {
    Remove-Item $RomParche3 -Force
}

try {
    Write-Host "Aplicando parche 1..."
    & $Flips --apply $Parche1 $Rom $RomParche1

    if ($LASTEXITCODE -ne 0 -or -not (Test-Path $RomParche1)) {
        throw "Error aplicando el parche 1."
    }

    Write-Host "Aplicando parche 2..."
    & $Flips --apply $Parche2 $RomParche1 $RomParche2

    if ($LASTEXITCODE -ne 0 -or -not (Test-Path $RomParche2)) {
        throw "Error aplicando el parche 2."
    }

    Write-Host "Aplicando parche 3..."
    & $Flips --apply $Parche3 $RomParche2 $RomParche3

    if ($LASTEXITCODE -ne 0 -or -not (Test-Path $RomParche3)) {
        throw "Error aplicando el parche 3."
    }

    Write-Host ""
    Write-Host "Proceso completado correctamente."
    Write-Host "ROM final:"
    Write-Host $RomParche3
}
finally {
    # Los archivos intermedios se eliminan incluso si falla un parche posterior
    if (Test-Path $RomParche1) {
        Remove-Item $RomParche1 -Force
    }

    if (Test-Path $RomParche2) {
        Remove-Item $RomParche2 -Force
    }
}