# ============================================================
# INSTALL flips.exe https://www.romhacking.net/utilities/1040
# Move this patcher script to the folder where flips.exe is located
# .\rom-patcher.ps1
# If it doesn't work, run the following command:
# Set-ExecutionPolicy Bypass -Scope Process
# ============================================================

# SOURCES
$RomOriginal        = ".\rom-harmony-usa.gba"

$RomTranslated       = "C:\built_rom_hod.gba"    # from DSVania build
$PatchVisual        = ".\visual1.2.9.ips"       # download Visual Improvement (Pemburu Vampir)
$PatchSpanishChars  = ".\hod-spanish-chars.ips" # from dev folder

# RESULTS
$PatchSpanish           = ".\hod-spanish.ips" # Need $RomOriginal and $RomTranslated 

$RomVisual              = ".\rom-harmony-usa-visual.gba"
$RomVisualSpanishChars  = ".\rom-harmony-usa-visual-spanish-chars.gba"

# ============================================================
# WAIT-FILE FUNCTION
# ============================================================

function Wait-File($FilePath) {

    for ($i = 0; $i -lt 100; $i++) {

        if (Test-Path $FilePath) {

            $FileSize = (Get-Item $FilePath).Length

            if ($FileSize -gt 0) {
                return
            }
        }

        Start-Sleep -Milliseconds 100
    }

    throw "File not generated: $FilePath"
}


# ============================================================
# PREVIOUS CLEANUP
# ============================================================

Remove-Item $PatchSpanish       -Force -ErrorAction SilentlyContinue
Remove-Item $RomVisual              -Force -ErrorAction SilentlyContinue
Remove-Item $RomVisualSpanishChars  -Force -ErrorAction SilentlyContinue

try {

    Write-Host ""
    Write-Host "========================================"
    Write-Host "GENERATING translation patch"
    Write-Host "========================================"
    Write-Host ""

    .\flips.exe --create `
        "$RomOriginal" `
        "$RomTranslated" `
        "$PatchSpanish"

    Wait-File $PatchSpanish

    Write-Host "OK: translation generated"
    Write-Host $PatchSpanish
    Write-Host ""

    Write-Host "========================================"
    Write-Host "APPLYING Visual to Original ROM"
    Write-Host "========================================"
    Write-Host ""

    .\flips.exe --apply `
        "$PatchVisual" `
        "$RomOriginal" `
        "$RomVisual"

    Wait-File $RomVisual

    Write-Host "OK: Original ROM + Visual"
    Write-Host ""


    Write-Host "========================================"
    Write-Host "Applying spanish-chars to Visual ROM"
    Write-Host "========================================"
    Write-Host ""

    .\flips.exe --apply `
        "$PatchSpanishChars" `
        "$RomVisual" `
        "$RomVisualSpanishChars"

    Wait-File $RomVisualSpanishChars

    Write-Host "OK: ROM + Visual + Spanish chars"
    Write-Host ""


    # ========================================================
    # RESULTADO
    # ========================================================

    Write-Host "========================================"
    Write-Host "PROCESS COMPLETED SUCCESSFULLY"
    Write-Host "========================================"
    Write-Host ""

    Write-Host "Translation patch:"
    Write-Host $PatchSpanish
    Write-Host ""

    Write-Host "To generate the Visual Improvement compatibility patch:"
    Write-Host "1. Open with DSVania: rom-harmony-usa-visual-spanish-chars.gba"
    Write-Host "2. Inject translated texts and build"
    Write-Host "3. Generate patch with rom-usa-visual and the build"
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
    # CLEANUP
    # ========================================================

    # Write-Host "Deleting intermediate files..."

    Write-Host "Process completed."
    Write-Host ""
}