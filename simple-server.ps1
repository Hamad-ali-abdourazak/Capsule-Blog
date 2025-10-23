<#
Simple static file server for PowerShell (works in Windows PowerShell 5.1)
Usage:
  powershell -ExecutionPolicy Bypass -File .\simple-server.ps1 -Port 8000 -Root .
Then open http://localhost:8000
#>
param(
  [int]$Port = 8000,
  [string]$Root = "."
)

$Root = Resolve-Path $Root
Write-Output "Serving files from: $Root"
Write-Output "Listening on http://localhost:$Port/"

$listener = New-Object System.Net.HttpListener
$prefix = "http://localhost:$Port/"
$listener.Prefixes.Add($prefix)
try {
  $listener.Start()
} catch {
  Write-Error "Impossible de démarrer le serveur. Vérifie que le port n'est pas utilisé et que tu as les permissions nécessaires."
  throw $_
}

while ($listener.IsListening) {
  $context = $listener.GetContext()
  $req = $context.Request
  $res = $context.Response

  $raw = $req.RawUrl
  # Normalise l'URL
  $path = $raw.TrimStart('/')
  if ($path -eq '') { $path = 'index.html' }

  # Empêche les accès hors du répertoire racine
  $filePath = Join-Path $Root $path
  $filePath = [System.IO.Path]::GetFullPath($filePath)
  if (-not $filePath.StartsWith($Root.Path, [System.StringComparison]::OrdinalIgnoreCase)) {
    $res.StatusCode = 403
    $bytes = [System.Text.Encoding]::UTF8.GetBytes("Forbidden")
    $res.OutputStream.Write($bytes,0,$bytes.Length)
    $res.Close()
    continue
  }

  if (-not (Test-Path $filePath)) {
    $res.StatusCode = 404
    $bytes = [System.Text.Encoding]::UTF8.GetBytes("Not Found")
    $res.ContentType = 'text/plain'
    $res.OutputStream.Write($bytes,0,$bytes.Length)
    $res.Close()
    continue
  }

  try {
    $bytes = [System.IO.File]::ReadAllBytes($filePath)
    $ext = [System.IO.Path]::GetExtension($filePath).ToLower()
    switch ($ext) {
      '.html' { $type = 'text/html; charset=utf-8' }
      '.css'  { $type = 'text/css' }
      '.js'   { $type = 'application/javascript' }
      '.json' { $type = 'application/json' }
      '.png'  { $type = 'image/png' }
      '.jpg'  { $type = 'image/jpeg' }
      '.jpeg' { $type = 'image/jpeg' }
      '.svg'  { $type = 'image/svg+xml' }
      default { $type = 'application/octet-stream' }
    }

    $res.StatusCode = 200
    $res.ContentType = $type
    $res.ContentLength64 = $bytes.Length
    $res.OutputStream.Write($bytes,0,$bytes.Length)
    $res.Close()
  } catch {
    $res.StatusCode = 500
    $err = [System.Text.Encoding]::UTF8.GetBytes("Server error")
    $res.OutputStream.Write($err,0,$err.Length)
    $res.Close()
  }
}

$listener.Stop()
$listener.Close()
