# ============================================================
# CONFIGURACION
# ============================================================

$RomOriginal  = ".\rom-harmony-usa.gba"
$RomTraducido = ".\built_rom_hod.gba"
$Parche1      = ".\REharmonized-usa.bps"
$Parche2      = ".\visual1.2.8.ips"


# ============================================================
# CONFIGURACION INTERNA
# ============================================================

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

$Flips = Join-Path $ScriptDir "flips.exe"

$RomOriginal  = Join-Path $ScriptDir "rom-harmony-usa.gba"
$RomTraducido = Join-Path $ScriptDir "built_rom_hod.gba"
$Parche1      = Join-Path $ScriptDir "REharmonized-usa.bps"
$Parche2      = Join-Path $ScriptDir "visual1.2.8.ips"


# ============================================================
# ARCHIVOS DE SALIDA
# ============================================================

$RomDir = Split-Path -Parent $RomOriginal

$RomParche1 = Join-Path $RomDir "rom-parche1.gba"
$RomParche2 = Join-Path $RomDir "rom-parche2.gba"
$RomParche3 = Join-Path $RomDir "rom-parche3.gba"

$Parche3 = Join-Path $RomDir "rom-parche3.ips"


# ============================================================
# COMPROBACIONES
# ============================================================

if (-not (Test-Path $Flips)) {
    Write-Host ""
    Write-Host "ERROR: No se encuentra flips.exe"
    Write-Host $Flips
    exit 1
}

if (-not (Test-Path $RomOriginal)) {
    Write-Host ""
    Write-Host "ERROR: No se encuentra la ROM original"
    Write-Host $RomOriginal
    exit 1
}

if (-not (Test-Path $RomTraducido)) {
    Write-Host ""
    Write-Host "ERROR: No se encuentra la ROM traducida"
    Write-Host $RomTraducido
    exit 1
}

if (-not (Test-Path $Parche1)) {
    Write-Host ""
    Write-Host "ERROR: No se encuentra el parche 1"
    Write-Host $Parche1
    exit 1
}

if (-not (Test-Path $Parche2)) {
    Write-Host ""
    Write-Host "ERROR: No se encuentra el parche 2"
    Write-Host $Parche2
    exit 1
}


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
    # 1. GENERAR PARCHE 3 IPS
    # ========================================================

    Write-Host ""
    Write-Host "========================================"
    Write-Host "1. GENERANDO PARCHE 3 IPS"
    Write-Host "========================================"

    Write-Host "ROM original : $RomOriginal"
    Write-Host "ROM traducida: $RomTraducido"
    Write-Host "Parche salida: $Parche3"
    Write-Host ""

    & $Flips --create $RomOriginal $RomTraducido $Parche3


    # Esperar un poco por si Flips tarda en escribir el archivo
    Start-Sleep -Milliseconds 500


    if (-not (Test-Path $Parche3)) {
        throw "No se ha generado rom-parche3.ips"
    }

    if ((Get-Item $Parche3).Length -eq 0) {
        throw "rom-parche3.ips se ha generado pero esta vacio"
    }

    Write-Host ""
    Write-Host "OK: rom-parche3.ips generado correctamente."
    Write-Host "Tamano: $((Get-Item $Parche3).Length) bytes"


    # ========================================================
    # 2. APLICAR PARCHE 1 BPS
    # ========================================================

    Write-Host ""
    Write-Host "========================================"
    Write-Host "2. APLICANDO REharmonized-usa.bps"
    Write-Host "========================================"

    Write-Host "Entrada : $RomOriginal"
    Write-Host "Parche  : $Parche1"
    Write-Host "Salida  : $RomParche1"
    Write-Host ""

    & $Flips --apply $Parche1 $RomOriginal $RomParche1

    Start-Sleep -Milliseconds 500

    if (-not (Test-Path $RomParche1)) {
        throw "No se ha generado rom-parche1.gba"
    }

    Write-Host ""
    Write-Host "OK: rom-parche1.gba generado."


    # ========================================================
    # 3. APLICAR PARCHE 2 IPS
    # ========================================================

    Write-Host ""
    Write-Host "========================================"
    Write-Host "3. APLICANDO visual1.2.8.ips"
    Write-Host "========================================"

    Write-Host "Entrada : $RomParche1"
    Write-Host "Parche  : $Parche2"
    Write-Host "Salida  : $RomParche2"
    Write-Host ""

    & $Flips --apply $Parche2 $RomParche1 $RomParche2

    Start-Sleep -Milliseconds 500

    if (-not (Test-Path $RomParche2)) {
        throw "No se ha generado rom-parche2.gba"
    }

    Write-Host ""
    Write-Host "OK: rom-parche2.gba generado."


    # ========================================================
    # 4. APLICAR PARCHE 3 IPS
    # ========================================================

    Write-Host ""
    Write-Host "========================================"
    Write-Host "4. APLICANDO rom-parche3.ips"
    Write-Host "========================================"

    Write-Host "Entrada : $RomParche2"
    Write-Host "Parche  : $Parche3"
    Write-Host "Salida  : $RomParche3"
    Write-Host ""

    & $Flips --apply $Parche3 $RomParche2 $RomParche3

    Start-Sleep -Milliseconds 500

    if (-not (Test-Path $RomParche3)) {
        throw "No se ha generado rom-parche3.gba"
    }


    # ========================================================
    # RESULTADO
    # ========================================================

    Write-Host ""
    Write-Host "========================================"
    Write-Host "PROCESO COMPLETADO CORRECTAMENTE"
    Write-Host "========================================"
    Write-Host ""

    Write-Host "Parche generado:"
    Write-Host $Parche3

    Write-Host ""
    Write-Host "ROM final:"
    Write-Host $RomParche3

    Write-Host ""

}
catch {

    Write-Host ""
    Write-Host "========================================"
    Write-Host "ERROR"
    Write-Host "========================================"
    Write-Host ""
    Write-Host $_.Exception.Message
    Write-Host ""

}
finally {

    # ========================================================
    # ELIMINAR ARCHIVOS INTERMEDIOS
    # ========================================================

    Write-Host ""
    Write-Host "Limpiando archivos intermedios..."

    if (Test-Path $RomParche1) {
        Remove-Item $RomParche1 -Force
    }

    if (Test-Path $RomParche2) {
        Remove-Item $RomParche2 -Force
    }

    Write-Host "Limpieza terminada."
    Write-Host ""
}
