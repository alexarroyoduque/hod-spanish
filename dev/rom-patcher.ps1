# ============================================================
# INSTALL flips.exe https://www.romhacking.net/utilities/1040
# Move this patcher script to the folder where flips.exe is located
# .\rom-patcher.ps1
# If it doesn't work, run the following command:
# Set-ExecutionPolicy Bypass -Scope Process
# ============================================================

# SOURCES
$RomOriginal         = ".\rom-harmony-usa.gba"

$RomTraducido        = "C:\built_rom_hod.gba"    # from DSVania build
$ParcheVisual        = ".\visual1.2.9.ips"       # download Visual Improvement (Pemburu Vampir)
$ParcheSpanishChars  = ".\hod-spanish-chars.ips" # from dev folder

# RESULTS
$ParcheTraduccion       = ".\hod-spanish.ips" 

$RomVisual              = ".\rom-harmony-usa-visual.gba"
$RomVisualSpanishChars  = ".\rom-harmony-usa-visual-spanish-chars.gba"

# ============================================================
# FUNCION DE ESPERA
# ============================================================

function Esperar-Archivo($Ruta) {

    for ($i = 0; $i -lt 100; $i++) {

        if (Test-Path $Ruta) {

            $Tamano = (Get-Item $Ruta).Length

            if ($Tamano -gt 0) {
                return
            }
        }

        Start-Sleep -Milliseconds 100
    }

    throw "No se genero correctamente el archivo: $Ruta"
}


# ============================================================
# LIMPIEZA PREVIA
# ============================================================

Remove-Item $ParcheTraduccion       -Force -ErrorAction SilentlyContinue
Remove-Item $RomVisual              -Force -ErrorAction SilentlyContinue
Remove-Item $RomVisualSpanishChars  -Force -ErrorAction SilentlyContinue

try {

    Write-Host ""
    Write-Host "========================================"
    Write-Host "GENERANDO parche de traducción"
    Write-Host "========================================"
    Write-Host ""

    .\flips.exe --create `
        "$RomOriginal" `
        "$RomTraducido" `
        "$ParcheTraduccion"

    Esperar-Archivo $ParcheTraduccion

    Write-Host "OK: traducción generada"
    Write-Host $ParcheTraduccion
    Write-Host ""

    Write-Host "========================================"
    Write-Host "APLICANDO Visual a ROM Original"
    Write-Host "========================================"
    Write-Host ""

    .\flips.exe --apply `
        "$ParcheVisual" `
        "$RomOriginal" `
        "$RomVisual"

    Esperar-Archivo $RomVisual

    Write-Host "OK: rom visual"
    Write-Host ""


    Write-Host "========================================"
    Write-Host "APLICANDO spanish-chars a ROM Visual"
    Write-Host "========================================"
    Write-Host ""

    .\flips.exe --apply `
        "$ParcheSpanishChars" `
        "$RomVisual" `
        "$RomVisualSpanishChars"

    Esperar-Archivo $RomVisualSpanishChars

    Write-Host "OK: ROM + visual + spanish chars"
    Write-Host ""


    # ========================================================
    # RESULTADO
    # ========================================================

    Write-Host "========================================"
    Write-Host "PROCESO TERMINADO CORRECTAMENTE"
    Write-Host "========================================"
    Write-Host ""

    Write-Host "Parche de traduccion:"
    Write-Host $ParcheTraduccion
    Write-Host ""

    Write-Host "Para generar el parche de compatibilidad de Visual Improvement:"
    Write-Host "1. Abrir con DSVania: rom-harmony-usa-visual-spanish-chars.gba"
    Write-Host "2. Inyectar textos traducidos y hacer build"
    Write-Host "3. Generar parche con rom-usa-visual y la build"
    Write-Host $RomVisualSpanishChars
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
    # BORRAR ARCHIVOS INTERMEDIOS
    # ========================================================

    # Write-Host "Eliminando archivos intermedios..."

    Write-Host "Proceso finalizado."
    Write-Host ""
}