# ============================================================
# CONFIGURACION
# ============================================================

$RomOriginal         = ".\rom-harmony-usa.gba"
$RomTraducido        = ".\built_rom_hod.gba"
$ParcheREharmonized  = ".\REharmonized-usa.bps"
$ParcheVisual        = ".\visual1.2.8.ips"

$ParcheTraduccion    = ".\spanish.ips"

$RomParche1          = ".\rom-parche1.gba"
$RomParche2          = ".\rom-parche2.gba"

$RomFinal            = ".\rom-reharmonized-visual-spanish.gba"


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
Remove-Item $RomParche1       -Force -ErrorAction SilentlyContinue
Remove-Item $RomParche2       -Force -ErrorAction SilentlyContinue
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
        "$RomParche1"

    Esperar-Archivo $RomParche1

    Write-Host "OK: rom-parche1.gba generado"
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
        "$RomParche1" `
        "$RomParche2"

    Esperar-Archivo $RomParche2

    Write-Host "OK: rom-parche2.gba generado"
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
        "$RomParche2" `
        "$RomFinal"

    Esperar-Archivo $RomFinal

    Write-Host "OK: ROM final generada"
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

    Write-Host "Eliminando archivos intermedios..."

    Remove-Item $RomParche1 -Force -ErrorAction SilentlyContinue
    Remove-Item $RomParche2 -Force -ErrorAction SilentlyContinue

    Write-Host "Limpieza terminada."
    Write-Host ""
}
