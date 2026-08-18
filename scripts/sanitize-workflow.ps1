param(
  [Parameter(Mandatory = $true)][string]$Source,
  [Parameter(Mandatory = $true)][string]$Destination
)

$workflow = Get-Content -Raw -LiteralPath $Source | ConvertFrom-Json
$placeholders = @{
  '86698797088972@lid' = 'YOUR_CHAT_ID@lid'
  '3bf981c6-2ad2-8029-b930-000bd2a15909' = 'YOUR_NOTION_DATA_SOURCE_ID'
  'https://app.notion.com/p/3bf981c62ad2804ca2cfc7e295c95ed0' = 'https://www.notion.so/YOUR_NOTION_DATABASE'
  'ahorros-api-2026' = 'YOUR_LOCAL_API_KEY'
}

$json = $workflow | ConvertTo-Json -Depth 100
foreach ($entry in $placeholders.GetEnumerator()) {
  $json = $json.Replace($entry.Key, $entry.Value)
}

$directory = Split-Path -Parent $Destination
New-Item -ItemType Directory -Force -Path $directory | Out-Null
[System.IO.File]::WriteAllText($Destination, $json, [System.Text.UTF8Encoding]::new($false))
