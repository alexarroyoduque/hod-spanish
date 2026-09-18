```powershell
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

# flips.exe debe estar en la misma carpeta que este script
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$Flips = Join-Path $ScriptDir "flips.exe"

# Convertimos las rutas relativas en rutas absolutas
$RomOriginal  = Join-Path $ScriptDir "rom-harmony-usa.gba"
$RomTraducido = Join-Path $ScriptDir "built_rom_hod.gba"
$Parche1      = Join-Path $ScriptDir "REharmonized-usa.bps"
$Parche2      = Join-Path $ScriptDir "visual1.2.8.ips"

# Directorio de salida: el mismo donde esta la ROM original
$RomDir = Split-Path -Parent $RomOriginal

# Archivos intermedios y finales
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
    Write-Host "Ruta esperada:"
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

# Borrar resultados/intermedios anteriores
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
    # PASO 1
    # GENERAR rom-parche3.ips
    # comparando la ROM original con la ROM traducida
    # ========================================================

    Write-Host ""
    Write-Host "========================================"
    Write-Host "1. GENERANDO PARCHE 3 IPS"
    Write-Host "========================================"

    Write-Host "ROM original : $RomOriginal"
    Write-Host "ROM traducida: $RomTraducido"
    Write-Host "Parche salida: $Parche3"
    Write-Host ""

    & "$Flips" --create "$RomOriginal" "$RomTraducido" "$Parche3"

    $CodigoSalida = $LASTEXITCODE

    if ($CodigoSalida -ne 0) {
        throw "Error generando rom-parche3.ips. Codigo de salida: $CodigoSalida"
    }

    if (-not (Test-Path $Parche3)) {
        throw "flips.exe termino sin error, pero no se ha generado rom-parche3.ips"
    }

    Write-Host "OK: rom-parche3.ips generado correctamente."


    # ========================================================
    # PASO 2
    # APLICAR PARCHE 1 BPS
    # ========================================================

    Write-Host ""
    Write-Host "========================================"
    Write-Host "2. APLICANDO PARCHE 1"
    Write-Host "========================================"

    Write-Host "Parche:"
    Write-Host $Parche1
    Write-Host ""

    & "$Flips" --apply "$Parche1" "$RomOriginal" "$RomParche1"

    $CodigoSalida = $LASTEXITCODE

    if ($CodigoSalida -ne 0) {
        throw "Error aplicando REharmonized-usa.bps. Codigo: $CodigoSalida"
    }

    if (-not (Test-Path $RomParche1)) {
        throw "No se ha generado rom-parche1.gba"
    }

    Write-Host "OK: rom-parche1.gba generado."


    # ========================================================
    # PASO 3
    # APLICAR PARCHE 2 IPS
    # ========================================================

    Write-Host ""
    Write-Host "========================================"
    Write-Host "3. APLICANDO PARCHE 2"
    Write-Host "========================================"

    Write-Host "Parche:"
    Write-Host $Parche2
    Write-Host ""

    & "$Flips" --apply "$Parche2" "$RomParche1" "$RomParche2"

    $CodigoSalida = $LASTEXITCODE

    if ($CodigoSalida -ne 0) {
        throw "Error aplicando visual1.2.8.ips. Codigo: $CodigoSalida"
    }

    if (-not (Test-Path $RomParche2)) {
        throw "No se ha generado rom-parche2.gba"
    }

    Write-Host "OK: rom-parche2.gba generado."


    # ========================================================
    # PASO 4
    # APLICAR PARCHE 3 IPS GENERADO
    # ========================================================

    Write-Host ""
    Write-Host "========================================"
    Write-Host "4. APLICANDO PARCHE 3"
    Write-Host "========================================"

    Write-Host "Parche:"
    Write-Host $Parche3
    Write-Host ""

    & "$Flips" --apply "$Parche3" "$RomParche2" "$RomParche3"

    $CodigoSalida = $LASTEXITCODE

    if ($CodigoSalida -ne 0) {
        throw "Error aplicando rom-parche3.ips. Codigo: $CodigoSalida"
    }

    if (-not (Test-Path $RomParche3)) {
        throw "No se ha generado rom-parche3.gba"
    }

    Write-Host "OK: rom-parche3.gba generado."


    # ========================================================
    # RESULTADO FINAL
    # ========================================================

    Write-Host ""
    Write-Host "========================================"
    Write-Host "PROCESO COMPLETADO CORRECTAMENTE"
    Write-Host "========================================"
    Write-Host ""

    Write-Host "Parche 3 generado:"
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
    # LIMPIEZA DE ARCHIVOS INTERMEDIOS
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
```
