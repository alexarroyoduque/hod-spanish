# ============================================================
# CONFIGURACION
# ============================================================

$RomOriginal         = ".\rom-harmony-usa.gba"
$RomTraducido        = ".\built_rom_hod.gba"
$ParcheREharmonized  = ".\REharmonized-usa.bps"
$ParcheVisual        = ".\visual1.2.8.ips"


# ============================================================
# ARCHIVOS GENERADOS
# ============================================================

$ParcheTraduccion = ".\spanish.ips"
$RomParche1       = ".\rom-parche1.gba"
$RomParche2       = ".\rom-parche2.gba"
$RomFinal         = ".\rom-reharmonized-visual-spanish.gba"


# ============================================================
# LIMPIEZA PREVIA
# ============================================================

Remove-Item $ParcheTraduccion -Force -ErrorAction SilentlyContinue
Remove-Item $RomParche1       -Force -ErrorAction SilentlyContinue
Remove-Item $RomParche2       -Force -ErrorAction SilentlyContinue
Remove-Item $RomFinal         -Force -ErrorAction SilentlyContinue


# ============================================================
# 1. GENERAR PARCHE DE TRADUCCION
# ============================================================

Write-Host ""
Write-Host "Generando spanish.ips..."

.\flips.exe --create `
    "$RomOriginal" `
    "$RomTraducido" `
    "$ParcheTraduccion"


# ============================================================
# 2. APLICAR REHARMONIZED
# ============================================================

Write-Host ""
Write-Host "Aplicando REharmonized..."

.\flips.exe --apply `
    "$ParcheREharmonized" `
    "$RomOriginal" `
    "$RomParche1"


# ============================================================
# 3. APLICAR VISUAL
# ============================================================

Write-Host ""
Write-Host "Aplicando Visual..."

.\flips.exe --apply `
    "$ParcheVisual" `
    "$RomParche1" `
    "$RomParche2"


# ============================================================
# 4. APLICAR PARCHE DE TRADUCCION
# ============================================================

Write-Host ""
Write-Host "Aplicando spanish.ips..."

.\flips.exe --apply `
    "$ParcheTraduccion" `
    "$RomParche2" `
    "$RomFinal"


# ============================================================
# 5. BORRAR ARCHIVOS INTERMEDIOS
# ============================================================

Write-Host ""
Write-Host "Eliminando archivos intermedios..."

Remove-Item $RomParche1 -Force -ErrorAction SilentlyContinue
Remove-Item $RomParche2 -Force -ErrorAction SilentlyContinue


# ============================================================
# FIN
# ============================================================

Write-Host ""
Write-Host "============================================="
Write-Host "Proceso terminado."
Write-Host "============================================="
Write-Host ""
Write-Host "Parche de traduccion:"
Write-Host $ParcheTraduccion
Write-Host ""
Write-Host "ROM final:"
Write-Host $RomFinal
Write-Host ""
