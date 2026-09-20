# ============================================================
# INSTALL flips.exe https://www.romhacking.net/utilities/1040/
# ============================================================

# ============================================================
# CONFIGURACION
# ============================================================

$RomOriginal         = ".\rom-harmony-usa.gba"
$RomTraducido        = "C:\Users\Irene Solana\OneDrive - Kairos Digital Solution SL\Documentos\Extracted files rom-harmony-usa-spanish-chars9.2\built_rom_hod.gba"
$ParcheREharmonized  = ".\REharmonized-usa.bps"
$ParcheVisual        = ".\visual1.2.8.ips"
$ParcheSpanishChars  = ".\spanish-chars.ips"

$ParcheTraduccion    = ".\spanish.ips"

$RomREharmonized                    = ".\rom-harmony-usa-REharmonized.gba"
$RomREharmonizedSpanish             = ".\rom-harmony-usa-REharmonized-spanish.gba"
$RomREharmonizedVisual              = ".\rom-harmony-usa-REharmonized-visual.gba"
$RomREharmonizedVisualSpanishChars  = ".\rom-harmony-usa-REharmonized-visual-spanish-chars.gba"

$RomFinal            = ".\rom-reharmonized-visual-spanish-final.gba"


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

Remove-Item $ParcheTraduccion -Force -ErrorAction SilentlyContinue
Remove-Item $RomREharmonized       -Force -ErrorAction SilentlyContinue
Remove-Item $RomREharmonizedSpanish       -Force -ErrorAction SilentlyContinue
Remove-Item $RomREharmonizedVisual       -Force -ErrorAction SilentlyContinue
Remove-Item $RomREharmonizedVisualSpanishChars       -Force -ErrorAction SilentlyContinue
Remove-Item $RomFinal         -Force -ErrorAction SilentlyContinue


try {

    # ========================================================
    # 1. GENERAR PARCHE DE TRADUCCION
    # ========================================================

    Write-Host ""
    Write-Host "========================================"
    Write-Host "1. GENERANDO spanish.ips"
    Write-Host "========================================"
    Write-Host ""

    .\flips.exe --create `
        "$RomOriginal" `
        "$RomTraducido" `
        "$ParcheTraduccion"

    Esperar-Archivo $ParcheTraduccion

    Write-Host "OK: spanish.ips generado"
    Write-Host ""


    # ========================================================
    # 2. APLICAR REHARMONIZED
    # ========================================================

    Write-Host "========================================"
    Write-Host "2. APLICANDO REharmonized"
    Write-Host "========================================"
    Write-Host ""

    .\flips.exe --apply `
        "$ParcheREharmonized" `
        "$RomOriginal" `
        "$RomREharmonized"

    Esperar-Archivo $RomREharmonized

    Write-Host "OK: parche REharmonized"
    Write-Host ""

    # ========================================================
    # 2. APLICAR REHARMONIZED
    # ========================================================

    Write-Host "========================================"
    Write-Host "2.5 APLICANDO Spanish a REharmonized"
    Write-Host "========================================"
    Write-Host ""

    .\flips.exe --apply `
        "$ParcheTraduccion" `
        "$RomREharmonized" `
        "$RomREharmonizedSpanish"

    Esperar-Archivo $RomREharmonizedSpanish

    Write-Host "OK: rom REharmonized + spanish"
    Write-Host ""


    # ========================================================
    # 3. APLICAR VISUAL
    # ========================================================

    Write-Host "========================================"
    Write-Host "3. APLICANDO visual1.2.8.ips"
    Write-Host "========================================"
    Write-Host ""

    .\flips.exe --apply `
        "$ParcheVisual" `
        "$RomREharmonized" `
        "$RomREharmonizedVisual"

    Esperar-Archivo $RomREharmonizedVisual

    Write-Host "OK: rom REharmonized + visual"
    Write-Host ""

    # ========================================================
    # 4B. APLICAR TRADUCCION
    # ========================================================

    Write-Host "========================================"
    Write-Host "4B. APLICANDO spanish-chars.ips"
    Write-Host "========================================"
    Write-Host ""

    .\flips.exe --apply `
        "$ParcheSpanishChars" `
        "$RomREharmonizedVisual" `
        "$RomREharmonizedVisualSpanishChars"

    Esperar-Archivo $RomREharmonizedVisualSpanishChars

    Write-Host "OK: ROM REharmonized + visual + spanish chars"
    Write-Host ""


    # ========================================================
    # 4. APLICAR TRADUCCION
    # ========================================================

    Write-Host "========================================"
    Write-Host "4. APLICANDO spanish.ips"
    Write-Host "========================================"
    Write-Host ""

    .\flips.exe --apply `
        "$ParcheTraduccion" `
        "$RomREharmonizedVisual" `
        "$RomFinal"

    Esperar-Archivo $RomFinal

    Write-Host "OK: ROM final REharmonized + visual + spanish"
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

    Write-Host "ROM final:"
    Write-Host $RomFinal
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

    # Remove-Item $RomREharmonized -Force -ErrorAction SilentlyContinue
    # Remove-Item $RomREharmonizedVisual -Force -ErrorAction SilentlyContinue

    Write-Host "Limpieza terminada."
    Write-Host ""
}