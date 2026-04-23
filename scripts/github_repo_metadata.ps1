param(
  [string]$Owner = "adndaaryadi",
  [string]$Repo = "dupe-web",
  [switch]$DryRun
)

$description = "Microsite Caturnawa UNAS FEST yang dirombak jadi digital hub statis dengan CI, Pages, release, dan dokumentasi visual."
$homepage = "https://adndaaryadi.github.io/dupe-web/"
$topics = @("static-site", "landing-page", "event-hub", "github-pages", "frontend", "caturnawa", "unas-fest")

$token = if ($env:GITHUB_TOKEN) { $env:GITHUB_TOKEN } else { $null }
if (-not $token -and -not $DryRun) {
  throw "Set env GITHUB_TOKEN dulu sebelum eksekusi tanpa -DryRun."
}

$headers = @{
  Accept = "application/vnd.github+json"
  "X-GitHub-Api-Version" = "2022-11-28"
}

if ($token) {
  $headers.Authorization = "Bearer $token"
}

$payload = @{
  description = $description
  homepage = $homepage
  has_wiki = $false
  has_projects = $true
  has_issues = $true
} | ConvertTo-Json

$topicsPayload = @{ names = $topics } | ConvertTo-Json
$baseUrl = "https://api.github.com/repos/$Owner/$Repo"

if ($DryRun) {
  Write-Output "PATCH $baseUrl"
  Write-Output $payload
  Write-Output "PUT $baseUrl/topics"
  Write-Output $topicsPayload
  exit 0
}

Invoke-RestMethod -Method Patch -Uri $baseUrl -Headers $headers -Body $payload -ContentType "application/json" | Out-Null
Invoke-RestMethod -Method Put -Uri "$baseUrl/topics" -Headers $headers -Body $topicsPayload -ContentType "application/json" | Out-Null
Write-Output "Metadata repo $Owner/$Repo berhasil diupdate."
