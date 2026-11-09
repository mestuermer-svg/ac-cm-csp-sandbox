# Assetto Corsa – Content Manager & CSP Sandbox (`mestuermer-svg/ac-cm-csp-sandbox`)

Eigenständiges, ultra-schlankes GitHub-Repository für den **Content Manager (CM)**, **Custom Shaders Patch (CSP)** und die **Assetto Corsa Core Engine (AC)** ohne den 140+ GB großen Content-Ballast (Fahrzeuge & Strecken). Gesamtgröße: **nur ca. 181 MB**.

---

## Enthaltene Repository-Pakete (10 Pakete)

| Paket-Ordner | Pfad im AC-System | Beschreibung & Inhalt |
| :--- | :--- | :--- |
| **`01_Documents_AC_Setups`** | `Documents\Assetto Corsa\setups\` | Fahrzeug-Setups & Pitfiles (`.ini`) |
| **`02_Documents_AC_Cfg`** | `Documents\Assetto Corsa\cfg\` | Benutzer- & Session-Configs inkl. `extension/` (CSP User-Configs), `video.ini`, `controls.ini`, `race.ini` |
| **`03_CM_AppData_Presets_Data`** | `AppData\Local\AcTools Content Manager\` | Content Manager Presets, CSP-/Steuerungs-Profile, Server-Favoriten & Datenbanken (`*.data`) |
| **`04_Steam_AC_Cfg`** | `assettocorsa\cfg\`, `system\cfg\`, `server\cfg\` | Engine-Systemkonfiguration, Kamera- & FFB-Templates (`ff_post_process.ini`) |
| **`05_Steam_AC_Apps_Python`** | `assettocorsa\apps\python\` | In-Game Python-Apps & Shared-Memory-Telemetrieskripte |
| **`06_Steam_AC_Extension_Lua_Config`** | `assettocorsa\extension\lua\` & `config\` | **Custom Shaders Patch (CSP)** Lua-Skripte, Physik-Erweiterungen & Shader-Configs |
| **`07_Content_Manager_Binary`** | `assettocorsa\Content Manager.exe` | Content Manager Programmdatei für UI- & Setup-Tests (10.9 MB) |
| **`08_Steam_AC_Binaries`** | `assettocorsa\` Root | Lauffähige Engine-Dateien: `acs.exe`, `AssettoCorsa.exe`, `acs_x86.exe`, DLLs (`fmod`, `steam_api`, `msvc*`), `python33.zip` (65 MB) |
| **`09_Steam_AC_System_Core`** | `assettocorsa\system\` | Engine-Kern: Fonts, Shader, Data, Locales, x64/x86 Bibliotheken (23.2 MB) |
| **`10_Steam_AC_Content_Core`** | `assettocorsa\content\` | GUI-Assets, UI-Schriften & Wetter-Presets (`gui/`, `fonts/`, `weather/`) (51.9 MB) |

---

## Sofort lauffähige Slim-Installation zusammenbauen (`Assemble`)

Über das PowerShell-Skript `scripts/sync-cm-github.ps1` lässt sich mit einem einzigen Befehl eine vollständig lauffähige Installation unter `dist/AssettoCorsa_Slim` erzeugen:

```powershell
# 1. Baut die lauffähige Slim-Installation zusammen:
.\scripts\sync-cm-github.ps1 -AssembleSlimAC

# 2. Ausführen:
# Startet Content Manager direkt in der schlanken Umgebung:
.\dist\AssettoCorsa_Slim\Content Manager.exe
```

Fahrzeuge und Strecken können bei Bedarf per Junction direkt aus der SimRacer-Bibliothek eingebunden werden:
```powershell
mklink /J "dist\AssettoCorsa_Slim\content\cars" "\\192.168.178.68\c$\Program Files (x86)\Steam\steamapps\common\assettocorsa\content\cars"
mklink /J "dist\AssettoCorsa_Slim\content\tracks" "\\192.168.178.68\c$\Program Files (x86)\Steam\steamapps\common\assettocorsa\content\tracks"
```

---

## Synchronisation mit SimRacer & GitHub

```powershell
# 1. Live-Sync direkt vom SimRacer über LAN (SMB) abrufen:
.\scripts\sync-cm-github.ps1 -FromSimRacer

# 2. Synchronisieren und direkt zu GitHub origin/main pushen:
.\scripts\sync-cm-github.ps1 -FromSimRacer -PushToGitHub

# 3. Lokal in Documents / AppData wiederherstellen:
.\scripts\sync-cm-github.ps1 -RestoreToLocal
```

<!-- DOKU-MINIMAP-START -->
<style>
.doku-arch-flow { font-family: var(--vscode-editor-font-family, Consolas, monospace); background: rgba(20, 24, 33, 0.92); border: 1px solid rgba(100, 140, 220, 0.35); border-radius: 10px; padding: 14px 16px; margin: 10px 0; color: #e2e8f0; }
.doku-arch-root { text-align: center; font-weight: 700; font-size: 1.04em; padding: 8px 12px; margin-bottom: 12px; background: linear-gradient(135deg, rgba(37, 99, 235, 0.28), rgba(15, 23, 42, 0.9)); border: 1px solid rgba(96, 165, 250, 0.5); border-radius: 8px; }
.doku-arch-root a { color: #93c5fd !important; text-decoration: none !important; }
.doku-arch-root a:hover { text-decoration: underline !important; }
.doku-arch-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(275px, 1fr)); gap: 10px; }
.doku-arch-card { background: rgba(30, 41, 59, 0.78); border: 1px solid rgba(148, 163, 184, 0.28); border-left: 4px solid #3b82f6; border-radius: 8px; padding: 9px 11px; transition: transform 0.12s ease, border-color 0.12s ease; }
.doku-arch-card:hover { border-color: #60a5fa; transform: translateY(-1px); }
.doku-arch-card.r1 { border-left-color: #22c55e; }
.doku-arch-card.r2 { border-left-color: #3b82f6; }
.doku-arch-card.r3 { border-left-color: #eab308; }
.doku-arch-card.r4 { border-left-color: #ec4899; }
.doku-arch-card.r5 { border-left-color: #a855f7; }
.doku-arch-card-title { font-weight: 700; font-size: 0.95em; margin-bottom: 6px; padding-bottom: 4px; border-bottom: 1px dashed rgba(148, 163, 184, 0.25); }
.doku-arch-card-title a { color: #f8fafc !important; text-decoration: none !important; display: block; }
.doku-arch-card-title a:hover { color: #60a5fa !important; }
.doku-arch-lines { list-style: none; margin: 0; padding: 0; font-size: 0.85em; line-height: 1.5; }
.doku-arch-lines li { margin: 3px 0; padding: 2px 5px; border-radius: 4px; white-space: normal; }
.doku-arch-lines li:hover { background: rgba(59, 130, 246, 0.18); }
.doku-arch-lines a { color: #cbd5e1 !important; text-decoration: none !important; display: inline; }
.doku-arch-lines a:hover { color: #93c5fd !important; text-decoration: underline !important; }
.doku-arch-badge { display: inline-block; font-size: 0.75em; padding: 0 5px; margin-left: 4px; border-radius: 4px; background: rgba(59, 130, 246, 0.22); color: #93c5fd !important; border: 1px solid rgba(96, 165, 250, 0.35); }
details.doku-minimap { position: fixed; bottom: 18px; right: 18px; z-index: 9999; width: 265px; max-height: 76px; overflow: hidden; background: rgba(15, 23, 42, 0.94); border: 1px solid rgba(96, 165, 250, 0.65); border-radius: 10px; box-shadow: 0 8px 26px rgba(0, 0, 0, 0.65); backdrop-filter: blur(8px); transition: width 0.18s ease, max-height 0.18s ease; font-family: var(--vscode-font-family, sans-serif); }
details.doku-minimap:hover { border-color: #60a5fa; }
details.doku-minimap[open] { width: min(880px, 94vw); max-height: 84vh; overflow-y: auto; padding-bottom: 10px; }
details.doku-minimap > summary { cursor: pointer; list-style: none; padding: 8px 12px; font-weight: 700; font-size: 0.84em; color: #f8fafc; background: linear-gradient(90deg, rgba(37, 99, 235, 0.45), rgba(30, 41, 59, 0.9)); border-bottom: 1px solid rgba(148, 163, 184, 0.25); display: flex; align-items: center; justify-content: space-between; user-select: none; }
details.doku-minimap > summary::-webkit-details-marker { display: none; }
details.doku-minimap .minimap-preview-strip { display: flex; gap: 4px; padding: 5px 10px 7px 10px; font-size: 0.72em; color: #94a3b8; justify-content: space-between; }
details.doku-minimap[open] .minimap-preview-strip { display: none; }
details.doku-minimap .minimap-preview-strip span { background: rgba(30, 41, 59, 0.9); padding: 2px 6px; border-radius: 4px; border: 1px solid rgba(148, 163, 184, 0.25); }
details.doku-minimap .minimap-body { padding: 8px 12px 4px 12px; }
</style>
<details class="doku-minimap">
<summary><span>🏎️ AC-Doku-Minimap (SimRacer &amp; Sandbox)</span><span title="Klicken zum Vergrößern / Einklappen">⛶</span></summary>
<div class="minimap-preview-strip"><span>01 SimRacer</span><span>02 Sandbox</span><span>03 Agenten</span><span>04 AC-Sync</span></div>
<div class="minimap-body">
<div class="doku-arch-flow">
<div class="doku-arch-root">🏎️ <a href="../assetto-corsa-content/docs/README.md">Assetto Corsa Content &amp; SimRacer Architektur (Doku-Index)</a>  |  <a href="../assetto-corsa-content/README.md">Repo-README</a>  |  <a href="../assetto-corsa-content/ac-sandbox/README.md">AC-Sandbox</a></div>
<div class="doku-arch-grid">
<div class="doku-arch-card r1">
<div class="doku-arch-card-title">🖥️ <a href="../assetto-corsa-content/docs/01_simracer_architektur/multi-pc-architektur-ki-agents-simracing.md">01_simracer_architektur (Hardware &amp; 4-PC-Netz)</a></div>
<ul class="doku-arch-lines">
<li>├─ <a href="../assetto-corsa-content/docs/01_simracer_architektur/multi-pc-architektur-ki-agents-simracing.md">01 • 4-Knoten-Architektur (SimRacer, Cyborg, Omarchy, Pi)</a></li>
<li>├─ <a href="../assetto-corsa-content/docs/01_simracer_architektur/hardware-analyse-system-stabilitaet-docker-ki.md">02 • Hardware- &amp; Stabilitätsanalyse (Docker, KI &amp; VR)</a></li>
<li>├─ <a href="../assetto-corsa-content/docs/01_simracer_architektur/simracer-system-backup-wiederherstellung-veeam.md">03 • System-Backup &amp; Recovery (Veeam + Sekunden-Backup)</a> <a class="doku-arch-badge" href="../assetto-corsa-content/ac-sandbox/backup-simracer-configs.ps1">Backup.ps1</a></li>
<li>└─ <a href="../assetto-corsa-content/docs/01_simracer_architektur/naechste-schritte-simracer-und-cyborg.md">04 • Roadmap &amp; Nächste Schritte (SimRacer &amp; Cyborg)</a></li>
</ul>
</div>
<div class="doku-arch-card r2">
<div class="doku-arch-card-title">🐳 <a href="../assetto-corsa-content/docs/02_docker_sandbox/SANDBOX_ANLEITUNG.md">02_docker_sandbox (ac-win11-sandbox &amp; sbx)</a></div>
<ul class="doku-arch-lines">
<li>├─ <a href="../assetto-corsa-content/docs/02_docker_sandbox/SANDBOX_ANLEITUNG.md">01 • Handbuch: Remote Windows-11-Sandbox (192.168.178.68)</a> <a class="doku-arch-badge" href="../assetto-corsa-content/ac-sandbox/start-sandbox.ps1">Start.ps1</a></li>
<li>├─ <a href="../assetto-corsa-content/docs/02_docker_sandbox/inside-the-simracing-sandbox-guide.md">02 • Inside the SimRacing Sandbox &amp; Dark-Agent-Betrieb</a></li>
<li>├─ <a href="../assetto-corsa-content/docs/02_docker_sandbox/docker-windows-steam-ki-agent-architektur.md">03 • Prüflabor für Content Manager, Pitfiles (.ini) &amp; KI</a></li>
<li>├─ <a href="../assetto-corsa-content/docs/02_docker_sandbox/sandbox-umzug-skalierung-simracer.md">04 • 64-GB Sandbox-Umzug &amp; Skalierung auf 160 GB</a></li>
<li>└─ <a href="../assetto-corsa-content/docs/02_docker_sandbox/docker-sbx-anleitung.md">05 • Docker Sandboxes CLI (sbx)</a> · <a href="../assetto-corsa-content/docs/02_docker_sandbox/docker.md">Coding Agent Sandbox</a></li>
</ul>
</div>
<div class="doku-arch-card r3">
<div class="doku-arch-card-title">🤖 <a href="../assetto-corsa-content/docs/03_agenten_system/agenten-system-architektur-uebersicht.md">03_agenten_system (5-Rollen-Verbund &amp; REPL)</a></div>
<ul class="doku-arch-lines">
<li>├─ <a href="../assetto-corsa-content/docs/03_agenten_system/agenten-system-architektur-uebersicht.md">01 • KI-Agenten-Systemarchitektur &amp; 5-Rollen-Handbuch</a></li>
<li>├─ <a href="../assetto-corsa-content/docs/03_agenten_system/agenten-konsolen-repl-autostart-und-asset-handshake.md">02 • Agenten-Konsolen (REPL), Auto-Start &amp; Handshake</a> <a class="doku-arch-badge" href="../assetto-corsa-content/ac-sandbox/shared/agents/README.md">Shared-Agents</a></li>
<li>├─ <a href="../assetto-corsa-content/.github/agents/general.agent.md">Ebene 1: @general</a> · <a href="../assetto-corsa-content/.github/agents/light.agent.md">Ebene 2: @light</a> · <a href="../assetto-corsa-content/.github/agents/rig.agent.md">@rig</a></li>
<li>└─ <a href="../assetto-corsa-content/.github/agents/dark.agent.md">Ebene 3 (Gast): @dark</a> · <a href="../assetto-corsa-content/.github/agents/sarah.agent.md">Pitwall: @sarah (Coach)</a></li>
</ul>
</div>
<div class="doku-arch-card r4">
<div class="doku-arch-card-title">⚙️ <a href="../assetto-corsa-content/ac-sandbox/LIGHT-AGENT-UND-AC-STRUKTUR.md">04_ac_sandbox_sync (7-Pakete, Presets &amp; Skripte)</a></div>
<ul class="doku-arch-lines">
<li>├─ <a href="../assetto-corsa-content/ac-sandbox/LIGHT-AGENT-UND-AC-STRUKTUR.md">01 • Light Agent Anweisungen &amp; 7-Pakete AC-Struktur</a> <a class="doku-arch-badge" href="../assetto-corsa-content/ac-sandbox/shared/scripts/sync-cm-github.ps1">Sync.ps1</a></li>
<li>├─ <a href="../assetto-corsa-content/ac-sandbox/README.md">02 • AC-Sandbox Ordnerstruktur &amp; Bootstrap-Ablauf</a> <a class="doku-arch-badge" href="../assetto-corsa-content/ac-sandbox/shared/scripts/bootstrap-guest.ps1">Bootstrap.ps1</a></li>
<li>├─ <a href="../assetto-corsa-content/ac-sandbox/shared/presets_managed/README.md">03 • Managed Settings-Profile (Desktop vs. VR / CSP)</a></li>
<li>└─ <a href="../assetto-corsa-content/ac-sandbox/LIVE-TRANSFER-STATUS.md">04 • Live-Transfer-Status</a> · <a href="../assetto-corsa-content/ac-sandbox/shared/cm-github-sync/03_CM_AppData_Presets_Data/Data/README.md">CM AppData &amp; Presets</a></li>
</ul>
</div>
</div>
</div>
</div>
</details>
<!-- DOKU-MINIMAP-END -->
