# Assetto Corsa – Content Manager & CSP Sandbox (`mestuermer-svg/ac-cm-csp-sandbox`)

Eigenständiges GitHub-Repository für den **Content Manager (CM)**, **Custom Shaders Patch (CSP)** und alle **7 Sandbox-Pakete** aus der `ac-win11-sandbox` (SimRacer `192.168.178.68` / `assetto-corsa-content`).

---

## Enthaltene Sandbox-Pakete

| Paket-Ordner | Pfad in der Sandbox (`ac-win11-sandbox`) | Beschreibung & Inhalt |
| :--- | :--- | :--- |
| **`01_Documents_AC_Setups`** | `C:\Users\Docker\Documents\Assetto Corsa\setups\` | Fahrzeug-Setups & Pitfiles (`.ini`) |
| **`02_Documents_AC_Cfg`** | `C:\Users\Docker\Documents\Assetto Corsa\cfg\` | Benutzer- & Session-Configs inkl. `extension/` (CSP User-Configs), `video.ini`, `controls.ini`, `race.ini` |
| **`03_CM_AppData_Presets_Data`** | `C:\Users\Docker\AppData\Local\AcTools Content Manager\` | Content Manager Presets, CSP-/Steuerungs-Profile, Server-Favoriten & Datenbanken (`*.data`) |
| **`04_Steam_AC_Cfg`** | `C:\AssettoCorsa\cfg\`, `system\cfg\`, `server\cfg\` | Engine-Systemkonfiguration, Kamera- & FFB-Templates (`ff_post_process.ini`) |
| **`05_Steam_AC_Apps_Python`** | `C:\AssettoCorsa\apps\python\` | In-Game Python-Apps & Shared-Memory-Telemetrieskripte |
| **`06_Steam_AC_Extension_Lua_Config`** | `C:\AssettoCorsa\extension\lua\` & `config\` | **Custom Shaders Patch (CSP)** Lua-Skripte, Physik-Erweiterungen & Shader-Configs |
| **`07_Content_Manager_Binary`** | `C:\AssettoCorsa\Content Manager.exe` | Content Manager Programmdatei für Sandbox-UI- & Preset-Tests |

---

## Synchronisation mit SimRacer & Sandbox

Über `scripts/sync-cm-github.ps1` können die 7 Pakete direkt mit der SimRacer-Workstation (`192.168.178.68`) bzw. dem `assetto-corsa-content`-Workspace abgeglichen und paketweise zu GitHub gepusht werden:

```powershell
# 1. Aus lokaler Sandbox / SimRacer aktualisieren und nach GitHub pushen:
.\scripts\sync-cm-github.ps1 -PushToGitHub

# 2. Lokal in Documents / AppData wiederherstellen:
.\scripts\sync-cm-github.ps1 -RestoreToLocal
```
