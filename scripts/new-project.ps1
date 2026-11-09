<#
.SYNOPSIS
  Creates a new project from the AI-ready template.
.DESCRIPTION
  Asks for whatever is not passed as a parameter:
    -Name         project folder name
    -Destination  parent folder for the new project (default: the folder that contains this template)
.EXAMPLE
  powershell -ExecutionPolicy Bypass -File .\scripts\new-project.ps1
.EXAMPLE
  powershell -ExecutionPolicy Bypass -File .\scripts\new-project.ps1 -Name "MyProject" -Destination "D:\code"
#>
param(
    [string]$Name,
    [string]$Destination,
    [switch]$NoGit
)

$ErrorActionPreference = 'Stop'
$template = Split-Path -Parent $PSScriptRoot

while (-not $Name) { $Name = (Read-Host 'Project name').Trim() }

if (-not $Destination) {
    $default = Split-Path -Parent $template
    $answer  = (Read-Host "Parent folder for the project [$default]").Trim()
    $Destination = if ($answer) { $answer } else { $default }
}
if (-not (Test-Path $Destination -PathType Container)) { throw "Folder not found: $Destination" }

$project = Join-Path (Resolve-Path $Destination).Path $Name

if (Test-Path $project) { throw "Already exists: $project" }

# Copy everything except what belongs to the template itself
New-Item -ItemType Directory -Path $project | Out-Null
Get-ChildItem -Path $template -Force |
    Where-Object { $_.Name -notin @('scripts', 'README.md', 'LICENSE', '.git') } |
    ForEach-Object { Copy-Item -Path $_.FullName -Destination $project -Recurse -Force }

# The project keeps the sync script (skills -> Claude / Cursor / Antigravity / Copilot)
New-Item -ItemType Directory -Path (Join-Path $project 'scripts') | Out-Null
Copy-Item -Path (Join-Path $PSScriptRoot 'sync-agents.ps1') -Destination (Join-Path $project 'scripts')

# Project README
# ASCII only in this script: PowerShell 5.1 reads BOM-less .ps1 files as ANSI
$readme = "# $Name`r`n`r`n<what it is, in one sentence>`r`n`r`n- AI context: ``AGENTS.md```r`n- Docs: ``docs/README.md```r`n"
$utf8 = New-Object System.Text.UTF8Encoding($false)
[IO.File]::WriteAllText((Join-Path $project 'README.md'), $readme, $utf8)

# Replace the placeholders already known (/configure fills in the rest)
$date = Get-Date -Format 'yyyy-MM-dd'
Get-ChildItem -Path $project -Recurse -File -Force -Include *.md, *.mdc, *.json, *.example |
    ForEach-Object {
        $text = [IO.File]::ReadAllText($_.FullName, $utf8)
        $new  = $text.Replace('{{PROJECT}}', $Name).Replace('{{DATE}}', $date)
        if ($new -ne $text) { [IO.File]::WriteAllText($_.FullName, $new, $utf8) }
    }

if (-not $NoGit -and (Get-Command git -ErrorAction SilentlyContinue)) {
    git -C $project init --quiet
    Write-Host "Git repo initialized (no commits)."
}

Write-Host ""
Write-Host "Project created at $project"
Write-Host "Next: open your AI tool (Claude Code, Cursor, Codex, Antigravity or Copilot) in that folder and run /configure"
