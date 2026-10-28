# Запуск «МИР ОХОТЫ»: игра + бот в одном процессе.
#   .\start.ps1                      — спросит токен и запустит
#   .\start.ps1 -Token 123:AAH...    — запустить с токеном сразу
#   $env:PUBLIC_URL="https://..."    — задать внешний адрес для Mini App
param(
  [string]$Token = $env:BOT_TOKEN,
  [string]$PublicUrl = $env:PUBLIC_URL,
  [int]$Port = 8080
)

$ErrorActionPreference = 'Stop'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path

# чтобы русские строки из node не превращались в кашу в консоли
try {
  [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
  $OutputEncoding = [System.Text.Encoding]::UTF8
} catch { }

if (-not $Token) {
  Write-Host ""
  Write-Host "  Токен берётся у @BotFather в Telegram: /newbot" -ForegroundColor Cyan
  Write-Host "  Формат: 8123456789:AAHxxxxxxxxxxxxxxxxxxxxxxxxxxx" -ForegroundColor DarkGray
  Write-Host ""
  $Token = Read-Host "  Вставь токен бота"
}
if (-not $Token -or $Token -notmatch '^\d+:[\w-]{20,}$') {
  Write-Host "  Похоже, это не токен. Выхожу." -ForegroundColor Red
  exit 1
}

$env:BOT_TOKEN   = $Token
$env:PUBLIC_URL  = $PublicUrl
$env:PORT        = "$Port"

# node из комплекта DSH, иначе — системный
$node = "C:\Users\Max\.dsh\dsh-runtimes\dsh-primary-runtime\dependencies\node\bin\node.exe"
if (-not (Test-Path $node)) { $node = "node" }

Write-Host ""
Write-Host "  МИР ОХОТЫ — сервер игры и бота" -ForegroundColor Green
Write-Host "  локально:  http://127.0.0.1:$Port/" -ForegroundColor Gray
if ($PublicUrl) { Write-Host "  публично:  $PublicUrl" -ForegroundColor Gray }
Write-Host "  стоп: Ctrl+C" -ForegroundColor DarkGray
Write-Host ""

& $node (Join-Path $here 'server.mjs')
