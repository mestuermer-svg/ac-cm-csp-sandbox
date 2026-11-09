<#
.SYNOPSIS
    Synchronisiert Content Manager (CM), Custom Shaders Patch (CSP) & Assetto Corsa Core
    aus dem SimRacer (192.168.178.68) ohne Content-Ballast in dieses Repository
    (mestuermer-svg/ac-cm-csp-sandbox) und steuert Git-Commits und GitHub-Pushes.

.PARAMETER FromSimRacer
    Synchronisiert die Daten live ueber das LAN (SMB \\192.168.178.68\c$) vom SimRacer.

.PARAMETER PushToGitHub
    Pusht neue oder geaenderte Pakete nach GitHub origin/main.

.PARAMETER RestoreToLocal
    Stellt die Konfigurationen in den lokalen Benutzerordnern wieder her.

.PARAMETER AssembleSlimAC
    Baut aus den Repository-Paketen eine lauffaehige AC+CM+CSP Installation unter 'dist/AssettoCorsa_Slim' zusammen.
#>

[CmdletBinding()]
param(
    [string]$SimRacerHost = "192.168.178.68",
    [switch]$FromSimRacer = $true,
    [switch]$PushToGitHub,
    [switch]$RestoreToLocal,
    [switch]$AssembleSlimAC,
    [string]$AssembleTarget = "dist\AssettoCorsa_Slim"
)

$ErrorActionPreference = "Continue"
$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$env:Path += ";C:\Program Files\Git\cmd"

Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host "  ASSETTO CORSA - CM / CSP / ENGINE SLIM REPO SYNC MANAGER       " -ForegroundColor Cyan
Write-Host "  Repository: $RepoRoot" -ForegroundColor Gray
Write-Host "  SimRacer:   $SimRacerHost" -ForegroundColor Gray
Write-Host "=================================================================" -ForegroundColor Cyan

# -------------------------------------------------------------------------
# 1. Restore-Modus
# -------------------------------------------------------------------------
if ($RestoreToLocal) {
    Write-Host "`n[RESTORE] Stelle Content-Manager- und AC-Ordner aus dem Git-Repository auf diesem PC wieder her..." -ForegroundColor Cyan
    $DocAC = Join-Path ([Environment]::GetFolderPath("MyDocuments")) "Assetto Corsa"
    $AppCM = Join-Path $env:LOCALAPPDATA "AcTools Content Manager"

    robocopy "$RepoRoot\01_Documents_AC_Setups" "$DocAC\setups" /E /R:1 /W:1 /NFL /NDL /NJH /NJS | Out-Null
    robocopy "$RepoRoot\02_Documents_AC_Cfg" "$DocAC\cfg" /E /R:1 /W:1 /NFL /NDL /NJH /NJS | Out-Null
    robocopy "$RepoRoot\03_CM_AppData_Presets_Data" $AppCM /E /R:1 /W:1 /NFL /NDL /NJH /NJS | Out-Null
    Write-Host "      [OK] Setups, AC-Cfg und Content Manager AppData-Profile lokal wiederhergestellt!" -ForegroundColor Green
    return
}

# -------------------------------------------------------------------------
# 2. Assemble-Modus: Baut eine lauffaehige Slim-Installation zusammen
# -------------------------------------------------------------------------
if ($AssembleSlimAC) {
    $targetPath = [System.IO.Path]::GetFullPath((Join-Path $RepoRoot $AssembleTarget))
    Write-Host "`n[ASSEMBLE] Baue lauffaehige Assetto Corsa + CM + CSP Slim-Installation..." -ForegroundColor Yellow
    Write-Host "           Zielverzeichnis: $targetPath" -ForegroundColor Gray

    New-Item -ItemType Directory -Force -Path $targetPath | Out-Null
    New-Item -ItemType Directory -Force -Path "$targetPath\content\cars" | Out-Null
    New-Item -ItemType Directory -Force -Path "$targetPath\content\tracks" | Out-Null

    # 1. Binaries kopieren
    if (Test-Path "$RepoRoot\08_Steam_AC_Binaries") {
        robocopy "$RepoRoot\08_Steam_AC_Binaries" $targetPath /E /R:1 /W:1 /NFL /NDL /NJH /NJS | Out-Null
    }

    # 2. Content Manager Binary
    if (Test-Path "$RepoRoot\07_Content_Manager_Binary\Content Manager.exe") {
        Copy-Item "$RepoRoot\07_Content_Manager_Binary\Content Manager.exe" "$targetPath\Content Manager.exe" -Force
    }

    # 3. System Core (Shader, Fonts, locales, x64, x86)
    if (Test-Path "$RepoRoot\09_Steam_AC_System_Core") {
        robocopy "$RepoRoot\09_Steam_AC_System_Core" "$targetPath\system" /E /R:1 /W:1 /NFL /NDL /NJH /NJS | Out-Null
    }

    # 4. Engine Cfg
    if (Test-Path "$RepoRoot\04_Steam_AC_Cfg\cfg") {
        robocopy "$RepoRoot\04_Steam_AC_Cfg\cfg" "$targetPath\cfg" /E /R:1 /W:1 /NFL /NDL /NJH /NJS | Out-Null
    }

    # 5. Apps Python
    if (Test-Path "$RepoRoot\05_Steam_AC_Apps_Python") {
        robocopy "$RepoRoot\05_Steam_AC_Apps_Python" "$targetPath\apps\python" /E /R:1 /W:1 /NFL /NDL /NJH /NJS | Out-Null
    }

    # 6. CSP Extension Core
    if (Test-Path "$RepoRoot\06_Steam_AC_Extension_Lua_Config") {
        robocopy "$RepoRoot\06_Steam_AC_Extension_Lua_Config" "$targetPath\extension" /E /R:1 /W:1 /NFL /NDL /NJH /NJS | Out-Null
    }

    # 7. Content Core (GUI, Fonts, Weather)
    if (Test-Path "$RepoRoot\10_Steam_AC_Content_Core") {
        robocopy "$RepoRoot\10_Steam_AC_Content_Core" "$targetPath\content" /E /R:1 /W:1 /NFL /NDL /NJH /NJS | Out-Null
    }

    # 8. CSP dwrite.dll vom SimRacer abrufen, falls erreichbar
    $simracerDwrite = "\\$SimRacerHost\c$\Program Files (x86)\Steam\steamapps\common\assettocorsa\dwrite.dll"
    if ((Test-Path $simracerDwrite) -and -not (Test-Path "$targetPath\dwrite.dll")) {
        Write-Host "           Kopiere CSP dwrite.dll vom SimRacer..." -ForegroundColor Gray
        Copy-Item $simracerDwrite "$targetPath\dwrite.dll" -Force
    }

    # 9. Starter Content Placeholder anlegen
    $readmeCar = "$targetPath\content\cars\README_CONTENT_STAGING.txt"
    @"
=== ASSETTO CORSA SLIM STARTER CONTENT ===
Dieses Verzeichnis ist bereit fuer Fahrzeuge.
Um Fahrzeuge aus der SimRacer-Bibliothek einzubinden:
mklink /J "$targetPath\content\cars" "\\$SimRacerHost\c$\Program Files (x86)\Steam\steamapps\common\assettocorsa\content\cars"
Oder einzelne Fahrzeuge hier einfuegen.
"@ | Set-Content $readmeCar -Encoding UTF8

    Write-Host "      [OK] Lauffaehige Slim-Installation erfolgreich assembliert!" -ForegroundColor Green
    Write-Host "           Ausfuehrbar ueber: $targetPath\Content Manager.exe" -ForegroundColor Green
    return
}

# -------------------------------------------------------------------------
# 3. Synchronisation vom SimRacer
# -------------------------------------------------------------------------
if ($FromSimRacer) {
    $smbBase = "\\$SimRacerHost\c$"
    if (-not (Test-Path $smbBase)) {
        Write-Error "SimRacer SMB-Freigabe '$smbBase' ist nicht erreichbar! Bitte Netzwerkverbindung pruefen."
        return
    }

    $simDocAC   = "$smbBase\Users\Mike\Documents\Assetto Corsa"
    $simAppCM   = "$smbBase\Users\Mike\AppData\Local\AcTools Content Manager"
    $simSteamAC = "$smbBase\Program Files (x86)\Steam\steamapps\common\assettocorsa"

    Write-Host "`n[1/3] Synchronisiere Pakete live vom SimRacer ($SimRacerHost)..." -ForegroundColor Yellow

    # Paket 01: Documents Setups
    $dst01 = "$RepoRoot\01_Documents_AC_Setups"
    if (Test-Path "$simDocAC\setups") {
        robocopy "$simDocAC\setups" $dst01 /E /R:1 /W:1 /NFL /NDL /NJH /NJS | Out-Null
        Write-Host "      [OK] 01_Documents_AC_Setups" -ForegroundColor Green
    }

    # Paket 02: Documents Cfg
    $dst02 = "$RepoRoot\02_Documents_AC_Cfg"
    if (Test-Path "$simDocAC\cfg") {
        robocopy "$simDocAC\cfg" $dst02 /E /R:1 /W:1 /NFL /NDL /NJH /NJS | Out-Null
        Write-Host "      [OK] 02_Documents_AC_Cfg" -ForegroundColor Green
    }

    # Paket 03: CM AppData Presets & Data
    $dst03 = "$RepoRoot\03_CM_AppData_Presets_Data"
    if (Test-Path $simAppCM) {
        robocopy $simAppCM $dst03 /E /XF *.log *.dmp *.tmp Cache.data /XD Plugins Temporary Static Logs Cache GPUCache CrashDumps cef /R:1 /W:1 /NFL /NDL /NJH /NJS | Out-Null
        Write-Host "      [OK] 03_CM_AppData_Presets_Data" -ForegroundColor Green
    }

    # Paket 04: Steam AC Cfg
    $dst04 = "$RepoRoot\04_Steam_AC_Cfg"
    New-Item -ItemType Directory -Force -Path "$dst04\cfg" | Out-Null
    New-Item -ItemType Directory -Force -Path "$dst04\system_cfg" | Out-Null
    New-Item -ItemType Directory -Force -Path "$dst04\server_cfg" | Out-Null
    if (Test-Path "$simSteamAC\cfg") { robocopy "$simSteamAC\cfg" "$dst04\cfg" /E /R:1 /W:1 /NFL /NDL /NJH /NJS | Out-Null }
    if (Test-Path "$simSteamAC\system\cfg") { robocopy "$simSteamAC\system\cfg" "$dst04\system_cfg" /E /R:1 /W:1 /NFL /NDL /NJH /NJS | Out-Null }
    if (Test-Path "$simSteamAC\server\cfg") { robocopy "$simSteamAC\server\cfg" "$dst04\server_cfg" /E /R:1 /W:1 /NFL /NDL /NJH /NJS | Out-Null }
    Write-Host "      [OK] 04_Steam_AC_Cfg" -ForegroundColor Green

    # Paket 05: Steam AC Python Apps
    $dst05 = "$RepoRoot\05_Steam_AC_Apps_Python"
    if (Test-Path "$simSteamAC\apps\python") {
        robocopy "$simSteamAC\apps\python" $dst05 /E /XF *.pyc /XD __pycache__ /R:1 /W:1 /NFL /NDL /NJH /NJS | Out-Null
        Write-Host "      [OK] 05_Steam_AC_Apps_Python" -ForegroundColor Green
    }

    # Paket 06: Steam AC CSP Extension Lua & Configs
    $dst06 = "$RepoRoot\06_Steam_AC_Extension_Lua_Config"
    New-Item -ItemType Directory -Force -Path "$dst06\config" | Out-Null
    New-Item -ItemType Directory -Force -Path "$dst06\lua" | Out-Null
    if (Test-Path "$simSteamAC\extension\config") { robocopy "$simSteamAC\extension\config" "$dst06\config" /E /XF *.zip *.kn5 /R:1 /W:1 /NFL /NDL /NJH /NJS | Out-Null }
    if (Test-Path "$simSteamAC\extension\lua") { robocopy "$simSteamAC\extension\lua" "$dst06\lua" /E /R:1 /W:1 /NFL /NDL /NJH /NJS | Out-Null }
    Write-Host "      [OK] 06_Steam_AC_Extension_Lua_Config" -ForegroundColor Green

    # Paket 07: Content Manager Binary
    $dst07 = "$RepoRoot\07_Content_Manager_Binary"
    New-Item -ItemType Directory -Force -Path $dst07 | Out-Null
    if (Test-Path "$simSteamAC\Content Manager.exe") {
        Copy-Item "$simSteamAC\Content Manager.exe" "$dst07\Content Manager.exe" -Force
        Write-Host "      [OK] 07_Content_Manager_Binary" -ForegroundColor Green
    }

    # Paket 08: Steam AC Binaries (Core Engine ohne PDB Debug)
    $dst08 = "$RepoRoot\08_Steam_AC_Binaries"
    New-Item -ItemType Directory -Force -Path $dst08 | Out-Null
    $binaryFiles = @(
        "acs.exe", "AssettoCorsa.exe", "acs_x86.exe", "acVideoModes.dll",
        "fmod.dll", "fmod64.dll", "fmodstudio.dll", "fmodstudio64.dll",
        "msvcp100.dll", "msvcp110.dll", "msvcp120.dll",
        "msvcr100.dll", "msvcr110.dll", "msvcr120.dll",
        "steam_api.dll", "steam_api64.dll", "steam_appid.txt",
        "AssettoCorsa.exe.config", "python33.zip"
    )
    foreach ($bin in $binaryFiles) {
        $srcFile = Join-Path $simSteamAC $bin
        if (Test-Path $srcFile) {
            Copy-Item $srcFile "$dst08\$bin" -Force
        }
    }
    Write-Host "      [OK] 08_Steam_AC_Binaries (Engine-Dateien synchronisiert)" -ForegroundColor Green

    # Paket 09: Steam AC System Core (Fonts, Locales, Data, Shaders, x64, x86)
    $dst09 = "$RepoRoot\09_Steam_AC_System_Core"
    New-Item -ItemType Directory -Force -Path $dst09 | Out-Null
    if (Test-Path "$simSteamAC\system") {
        robocopy "$simSteamAC\system" $dst09 /E /XF *.pdb *.dmp /R:1 /W:1 /NFL /NDL /NJH /NJS | Out-Null
        Write-Host "      [OK] 09_Steam_AC_System_Core" -ForegroundColor Green
    }

    # Paket 10: Steam AC Content Core (GUI, Fonts, Weather)
    $dst10 = "$RepoRoot\10_Steam_AC_Content_Core"
    New-Item -ItemType Directory -Force -Path "$dst10\gui" | Out-Null
    New-Item -ItemType Directory -Force -Path "$dst10\fonts" | Out-Null
    New-Item -ItemType Directory -Force -Path "$dst10\weather" | Out-Null
    if (Test-Path "$simSteamAC\content\gui") { robocopy "$simSteamAC\content\gui" "$dst10\gui" /E /R:1 /W:1 /NFL /NDL /NJH /NJS | Out-Null }
    if (Test-Path "$simSteamAC\content\fonts") { robocopy "$simSteamAC\content\fonts" "$dst10\fonts" /E /R:1 /W:1 /NFL /NDL /NJH /NJS | Out-Null }
    if (Test-Path "$simSteamAC\content\weather") { robocopy "$simSteamAC\content\weather" "$dst10\weather" /E /R:1 /W:1 /NFL /NDL /NJH /NJS | Out-Null }
    Write-Host "      [OK] 10_Steam_AC_Content_Core" -ForegroundColor Green
}

# -------------------------------------------------------------------------
# 4. Status-Uebersicht aller Pakete
# -------------------------------------------------------------------------
Write-Host "`n[2/3] Status & Groessen-Uebersicht im Repository:" -ForegroundColor Cyan
$allPackages = Get-ChildItem $RepoRoot -Directory | Where-Object { $_.Name -match "^\d\d_" } | Sort-Object Name
$totalMB = 0
foreach ($pkg in $allPackages) {
    $files = Get-ChildItem $pkg.FullName -Recurse -File -ErrorAction SilentlyContinue
    $mb = [math]::Round((($files | Measure-Object Length -Sum).Sum) / 1MB, 2)
    $totalMB += $mb
    Write-Host ("      {0,-35} | {1,4} Dateien | {2,8} MB" -f $pkg.Name, $files.Count, $mb) -ForegroundColor Gray
}
Write-Host ("      ------------------------------------------------------------") -ForegroundColor DarkGray
Write-Host ("      {0,-35} |              | {1,8} MB" -f "GESAMTPAKET (SLIM RUNNABLE)", [math]::Round($totalMB, 2)) -ForegroundColor Yellow

# -------------------------------------------------------------------------
# 5. Git Commit & Push zu GitHub
# -------------------------------------------------------------------------
if ($PushToGitHub) {
    Write-Host "`n[3/3] Committe und pushe geaenderte Pakete zu GitHub origin/main..." -ForegroundColor Cyan
    Push-Location $RepoRoot
    git add .gitignore scripts/ *.md
    foreach ($pkg in $allPackages) {
        git add $pkg.Name
    }
    
    $status = git status --porcelain
    if ($status) {
        Write-Host "      -> Aenderungen erkannt, erstelle Git-Commit..." -ForegroundColor Yellow
        git commit -m "feat(ac-slim): update runnable CM, CSP & AC engine slim packages from SimRacer"
        Write-Host "      -> Pushe zu GitHub origin/main..." -ForegroundColor Yellow
        git push origin main
        Write-Host "      [OK] Erfolgreich zu GitHub gepusht!" -ForegroundColor Green
    } else {
        Write-Host "      [INFO] Keine neuen Aenderungen zu committen." -ForegroundColor Gray
    }
    Pop-Location
} else {
    Write-Host "`n[HINWEIS] Nutze -PushToGitHub, um die Pakete direkt auf GitHub bereitzustellen." -ForegroundColor DarkCyan
}
