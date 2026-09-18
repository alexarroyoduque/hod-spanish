# ============================================================
# CONFIGURACION
# ============================================================

$Parche1 = "C:\parches\parche1.bps"
$Parche2 = "C:\parches\parche2.ips"

# ============================================================
# PARAMETROS
# ============================================================

param(
    [Parameter(Mandatory = $true)]
    [string]$RomOriginal,

    [Parameter(Mandatory = $true)]
    [string]$RomTraducido
)

$ErrorActionPreference = "Stop"

# flips.exe debe estar en la misma carpeta que este script
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$Flips = Join-Path $ScriptDir "flips.exe"

# ============================================================
# COMPROBACIONES
# ============================================================

if (-not (Test-Path $Flips)) {
    Write-Error "No se encuentra flips.exe en: $ScriptDir"
    exit 1
}

if (-not (Test-Path $RomOriginal)) {
    Write-Error "No se encuentra la ROM original: $RomOriginal"
    exit 1
}

if (-not (Test-Path $RomTraducido)) {
    Write-Error "No se encuentra la ROM traducida: $RomTraducido"
    exit 1
}

if (-not (Test-Path $Parche1)) {
    Write-Error "No se encuentra el parche BPS: $Parche1"
    exit 1
}

if (-not (Test-Path $Parche2)) {
    Write-Error "No se encuentra el segundo parche IPS: $Parche2"
    exit 1
}

# ============================================================
# RUTAS DE SALIDA
# ============================================================

$RomOriginal = (Resolve-Path $RomOriginal).Path
$RomTraducido = (Resolve-Path $RomTraducido).Path

$RomDir = Split-Path -Parent $RomOriginal
$RomBase = [System.IO.Path]::GetFileNameWithoutExtension($RomOriginal)

$RomParche1 = Join-Path $RomDir "$RomBase-parche1.gba"
$RomParche2 = Join-Path $RomDir "$RomBase-parche2.gba"
$RomParche3 = Join-Path $RomDir "$RomBase-parche3.gba"

$Parche3 = Join-Path $RomDir "$RomBase-parche3.ips"

# ============================================================
# LIMPIEZA PREVIA
# ============================================================

foreach ($Archivo in @(
    $RomParche1,
    $RomParche2,
    $RomParche3,
    $Parche3
)) {
    if (Test-Path $Archivo) {
        Remove-Item $Archivo -Force
    }
}

try {

    # ========================================================
    # 1. CREAR PARCHE IPS DESDE ORIGINAL -> TRADUCIDO
    # ========================================================

    Write-Host ""
    Write-Host "Creando parche IPS de traduccion..."

    & $Flips --create $RomOriginal $RomTraducido $Parche3

    if ($LASTEXITCODE -ne 0 -or -not (Test-Path $Parche3)) {
        throw "Error creando el parche IPS de traduccion."
    }

    Write-Host "Creado:"
    Write-Host $Parche3


    # ========================================================
    # 2. APLICAR PARCHE BPS
    # ========================================================

    Write-Host ""
    Write-Host "Aplicando parche 1 (BPS)..."

    & $Flips --apply $Parche1 $RomOriginal $RomParche1

    if ($LASTEXITCODE -ne 0 -or -not (Test-Path $RomParche1)) {
        throw "Error aplicando el parche 1."
    }


    # ========================================================
    # 3. APLICAR SEGUNDO PARCHE IPS
    # ========================================================

    Write-Host ""
    Write-Host "Aplicando parche 2 (IPS)..."

    & $Flips --apply $Parche2 $RomParche1 $RomParche2

    if ($LASTEXITCODE -ne 0 -or -not (Test-Path $RomParche2)) {
        throw "Error aplicando el parche 2."
    }


    # ========================================================
    # 4. APLICAR PARCHE DE TRADUCCION GENERADO
    # ========================================================

    Write-Host ""
    Write-Host "Aplicando parche 3 (traduccion)..."

    & $Flips --apply $Parche3 $RomParche2 $RomParche3

    if ($LASTEXITCODE -ne 0 -or -not (Test-Path $RomParche3)) {
        throw "Error aplicando el parche 3."
    }


    # ========================================================
    # RESULTADO
    # ========================================================

    Write-Host ""
    Write-Host "========================================"
    Write-Host "PROCESO COMPLETADO"
    Write-Host "========================================"
    Write-Host ""
    Write-Host "Parche IPS generado:"
    Write-Host $Parche3
    Write-Host ""
    Write-Host "ROM final:"
    Write-Host $RomParche3
    Write-Host ""

}
finally {

    # ========================================================
    # ELIMINAR ROMS INTERMEDIAS
    # ========================================================

    if (Test-Path $RomParche1) {
        Remove-Item $RomParche1 -Force
    }

    if (Test-Path $RomParche2) {
        Remove-Item $RomParche2 -Force
    }
}