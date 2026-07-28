$ErrorActionPreference = 'Stop'
$scriptPath = Join-Path $PSScriptRoot '..\reorganize-vault.ps1'
if (-not (Test-Path -LiteralPath $scriptPath)) {
    throw "Expected migration script at $scriptPath"
}
& $scriptPath -WhatIf
if ($LASTEXITCODE -ne 0) {
    throw "Expected -WhatIf migration run to exit 0; got $LASTEXITCODE"
}
