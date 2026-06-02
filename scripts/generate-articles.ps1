# Generate long-tail article HTML files from topics.json + article-template.html
# Usage: powershell -ExecutionPolicy Bypass -File .\scripts\generate-articles.ps1

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$wikiDir = Join-Path $root 'wiki'
if (-not (Test-Path $wikiDir)) { New-Item -ItemType Directory -Path $wikiDir | Out-Null }

$topicsPath  = Join-Path $PSScriptRoot 'topics.json'
$templatePath = Join-Path $PSScriptRoot 'article-template.html'

$topics   = Get-Content -Raw -Path $topicsPath  -Encoding UTF8 | ConvertFrom-Json
$template = Get-Content -Raw -Path $templatePath -Encoding UTF8
$today    = (Get-Date).ToString('yyyy-MM-dd')

$written = 0
foreach ($t in $topics) {
  $path = Join-Path $wikiDir ($t.slug + '.html')
  if (Test-Path $path) { Write-Host ("skip exists: " + $t.slug); continue }
  $html = $template `
    -replace '\{\{TITLE\}\}', $t.title `
    -replace '\{\{DESC\}\}',  $t.desc  `
    -replace '\{\{KW\}\}',    $t.kw    `
    -replace '\{\{SLUG\}\}',  $t.slug  `
    -replace '\{\{H1\}\}',    $t.h1    `
    -replace '\{\{DATE\}\}',  $today
  [System.IO.File]::WriteAllText($path, $html, (New-Object System.Text.UTF8Encoding($false)))
  $written++
  Write-Host ("wrote: " + $t.slug + ".html")
}

Write-Host ("done. total topics: " + $topics.Count + ", newly written: " + $written)
