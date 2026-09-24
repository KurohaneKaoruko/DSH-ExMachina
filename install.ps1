# DSH-ExMachina installer. Copies the preset into the DSH user preset root.
# Usage: .\install.ps1   (idempotent; overwrites a previous exmachina preset)
#Requires -Version 5.1
$ErrorActionPreference = 'Stop'

$src = $PSScriptRoot
if (-not (Test-Path (Join-Path $src 'agent.cordis.yml'))) {
    throw "agent.cordis.yml not found beside installer; run from the repository root."
}

$dshHome = $env:DSH_HOME
if (-not $dshHome) { $dshHome = Join-Path $HOME '.dsh' }
$dest = Join-Path $dshHome '.agent-presets\exmachina'

$files = @(
    'agent.cordis.yml',
    'preset.yml',
    'skills\exmachina-dispatch\SKILL.md',
    'skills\exmachina-protocol\SKILL.md'
)

foreach ($rel in $files) {
    $from = Join-Path $src $rel
    if (-not (Test-Path $from)) { throw "missing source file: $rel" }
    $to = Join-Path $dest $rel
    $toDir = Split-Path $to -Parent
    if (-not (Test-Path $toDir)) { New-Item -ItemType Directory -Force -Path $toDir | Out-Null }
    Copy-Item $from $to -Force
    Write-Host "installed: $to"
}

Write-Host ''
Write-Host 'done. preset id: exmachina'
Write-Host 'next: (re)start DSH, pick the preset named 机械智能, and confirm subagent tools are present.'
Write-Host 'uninstall: remove the directory above.'
