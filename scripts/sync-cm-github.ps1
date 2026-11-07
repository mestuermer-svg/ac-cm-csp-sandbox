<#
.SYNOPSIS
    Synchronisiert Content Manager, Custom Shaders Patch (CSP) & Assetto Corsa
    Konfigurations-, Setup- und Skript-Ordner aus der Sandbox / SimRacer
    in dieses Repository (ac-cm-csp-sandbox) und laedt sie paketweise zu GitHub hoch.
#>

param(
    [string]$SimRacerHost = "192.168.178.68",
    [string]$SimRacerUser = "Mike",
    [string]$LocalSandboxSyncRoot = "C:\Users\strik\assetto-corsa-content\ac-sandbox\shared\cm-github-sync",
    [switch]$FromSimRacer,
    [switch]$PushToGitHub,
    [switch]$RestoreToLocal
)

$ErrorActionPreference = "Continue"
$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$env:Path += ";C:\Program Files\Git\cmd"

$FolderPackages = @(
    @{ Id = "01_Documents_AC_Setups";          Description = "Assetto Corsa Fahrzeug-Setups und Pitfiles (.ini)" },
    @{ Id = "02_Documents_AC_Cfg";             Description = "Assetto Corsa Benutzer-Konfiguration (race.ini, controls.ini, video.ini, CSP)" },
    @{ Id = "03_CM_AppData_Presets_Data";      Description = "Content Manager User-Presets, Steuerungs-/CSP-Profile und Daten" },
    @{ Id = "04_Steam_AC_Cfg";                 Description = "Steam Assetto Corsa Basis- und System-Cfg (cfg, system/cfg, server/cfg)" },
    @{ Id = "05_Steam_AC_Apps_Python";         Description = "Steam Assetto Corsa Python-Apps (apps/python)" },
    @{ Id = "06_Steam_AC_Extension_Lua_Config";Description = "Custom Shaders Patch (CSP) Lua-Skripte und Configs (ohne 3D-Modelle .kn5)" },
    @{ Id = "07_Content_Manager_Binary";       Description = "Content Manager Programmdatei (Content Manager.exe)" }
)

if ($RestoreToLocal) {
    Write-Host "[RESTORE] Stelle Content-Manager- und AC-Ordner aus dem Git-Repository auf diesem PC wieder her..." -ForegroundColor Cyan
    $DocAC = Join-Path ([Environment]::GetFolderPath("MyDocuments")) "Assetto Corsa"
    $AppCM = Join-Path $env:LOCALAPPDATA "AcTools Content Manager"
    robocopy "$RepoRoot\01_Documents_AC_Setups" "$DocAC\setups" /E /R:1 /W:1 /NFL /NDL /NJH /NJS | Out-Null
    robocopy "$RepoRoot\02_Documents_AC_Cfg" "$DocAC\cfg" /E /R:1 /W:1 /NFL /NDL /NJH /NJS | Out-Null
    robocopy "$RepoRoot\03_CM_AppData_Presets_Data" $AppCM /E /R:1 /W:1 /NFL /NDL /NJH /NJS | Out-Null
    Write-Host "      [OK] Setups, AC-Cfg und Content Manager AppData-Profile wiederhergestellt!" -ForegroundColor Green
    return
}

$SourceRoot = if ($FromSimRacer) { "\\$SimRacerHost\ac-sandbox\shared\cm-github-sync" } else { $LocalSandboxSyncRoot }

Write-Host "[1/2] Synchronisiere die 7 Sandbox-Pakete von '$SourceRoot' nach '$RepoRoot'..." -ForegroundColor Yellow
foreach ($pkg in $FolderPackages) {
    $src = Join-Path $SourceRoot $pkg.Id
    $dst = Join-Path $RepoRoot $pkg.Id
    if (Test-Path $src) {
        robocopy $src $dst /MIR /MAX:45000000 /R:1 /W:1 /NFL /NDL /NJH /NJS | Out-Null
        $files = Get-ChildItem $dst -Recurse -File -ErrorAction SilentlyContinue
        $mb = [math]::Round((($files | Measure-Object Length -Sum).Sum) / 1MB, 2)
        Write-Host ("      [OK] {0,-35} ({1,4} Dateien | {2,6} MB)" -f $pkg.Id, $files.Count, $mb) -ForegroundColor Green
    }
}

if ($PushToGitHub) {
    Write-Host "[2/2] Lade Ordner-Pakete einzeln (paketweise) zu GitHub hoch..." -ForegroundColor Cyan
    Push-Location $RepoRoot
    foreach ($pkg in $FolderPackages) {
        git add $pkg.Id
        $status = git status --porcelain $pkg.Id
        if ($status) {
            Write-Host "      -> Commit & Push: $($pkg.Id) ($($pkg.Description))..." -ForegroundColor Yellow
            git commit -m "sync(cm-csp): $($pkg.Id) - $($pkg.Description)" | Out-Null
            git push origin main
        } else {
            Write-Host "      [BEREITS AKTUELL] $($pkg.Id) (keine Aenderungen)" -ForegroundColor DarkGray
        }
    }
    Pop-Location
}
