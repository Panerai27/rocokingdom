# Scan root and /wiki HTML files, regenerate sitemap.xml and /wiki/index.html
# Usage: powershell -ExecutionPolicy Bypass -File .\scripts\generate-sitemap.ps1 [-BaseUrl https://rocokingdom.wiki]

param([string]$BaseUrl = 'https://rocokingdom.wiki')

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$BaseUrl = $BaseUrl.TrimEnd('/')

function Get-TitleFromFile([string]$file) {
  $content = Get-Content -Raw -Path $file -Encoding UTF8
  $m = [regex]::Match($content, '<title>(.*?)</title>', 'IgnoreCase, Singleline')
  if ($m.Success) {
    $t = $m.Groups[1].Value
    $t = ($t -replace '\s*\|\s*Rocokingdom Wiki.*$','').Trim()
    return $t
  }
  return [System.IO.Path]::GetFileNameWithoutExtension($file)
}

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$pages = New-Object System.Collections.Generic.List[object]

Get-ChildItem -Path $root -Filter *.html -File | ForEach-Object {
  $rel = '/' + $_.Name
  if ($_.Name -eq 'index.html') { $rel = '/' }
  $pages.Add([pscustomobject]@{
    Loc     = "$BaseUrl$rel"
    File    = $_.FullName
    Title   = (Get-TitleFromFile $_.FullName)
    Section = 'root'
    LastMod = $_.LastWriteTime.ToString('yyyy-MM-dd')
  }) | Out-Null
}

$wikiDir = Join-Path $root 'wiki'
if (Test-Path $wikiDir) {
  Get-ChildItem -Path $wikiDir -Filter *.html -File | Where-Object { $_.Name -ne 'index.html' } | ForEach-Object {
    $pages.Add([pscustomobject]@{
      Loc     = "$BaseUrl/wiki/$($_.Name)"
      File    = $_.FullName
      Title   = (Get-TitleFromFile $_.FullName)
      Section = 'wiki'
      LastMod = $_.LastWriteTime.ToString('yyyy-MM-dd')
    }) | Out-Null
  }
}

$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine('<?xml version="1.0" encoding="UTF-8"?>')
[void]$sb.AppendLine('<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">')
foreach ($p in $pages) {
  if ($p.Loc -eq "$BaseUrl/") { $priority = '1.0' }
  elseif ($p.Section -eq 'wiki') { $priority = '0.8' }
  else { $priority = '0.5' }
  if ($p.Section -eq 'wiki') { $cf = 'weekly' } else { $cf = 'monthly' }
  [void]$sb.AppendLine('  <url>')
  [void]$sb.AppendLine("    <loc>$($p.Loc)</loc>")
  [void]$sb.AppendLine("    <lastmod>$($p.LastMod)</lastmod>")
  [void]$sb.AppendLine("    <changefreq>$cf</changefreq>")
  [void]$sb.AppendLine("    <priority>$priority</priority>")
  [void]$sb.AppendLine('  </url>')
}
[void]$sb.AppendLine('</urlset>')
[System.IO.File]::WriteAllText((Join-Path $root 'sitemap.xml'), $sb.ToString(), $utf8NoBom)
Write-Host ("sitemap.xml updated. urls: " + $pages.Count)

$wikiPages = $pages | Where-Object { $_.Section -eq 'wiki' } | Sort-Object Title
$liLines = foreach ($p in $wikiPages) {
  $name = [System.IO.Path]::GetFileName($p.File)
  '      <li><a href="/wiki/' + $name + '">' + $p.Title + '</a></li>'
}
$items = $liLines -join "`n"

$tplPath = Join-Path $PSScriptRoot 'wiki-index-template.html'
$tpl = Get-Content -Raw -Path $tplPath -Encoding UTF8
$indexHtml = $tpl `
  -replace '\{\{BASE_URL\}\}', $BaseUrl `
  -replace '\{\{COUNT\}\}', "$($wikiPages.Count)" `
  -replace '\{\{ITEMS\}\}', $items

[System.IO.File]::WriteAllText((Join-Path $wikiDir 'index.html'), $indexHtml, $utf8NoBom)
Write-Host "wiki/index.html updated."
