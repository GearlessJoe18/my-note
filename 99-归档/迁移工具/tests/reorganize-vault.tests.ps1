$ErrorActionPreference = 'Stop'
$scriptPath = Join-Path $PSScriptRoot '..\reorganize-vault.ps1'
if (-not (Test-Path -LiteralPath $scriptPath)) {
    throw "Expected migration script at $scriptPath"
}
$implementation = Get-Content -LiteralPath $scriptPath -Raw
if ($implementation -notmatch 'if \(\$null -eq \$content\) \{ continue \}') {
    throw 'Expected migration script to skip empty Markdown before regex matching.'
}
if (Test-Path -LiteralPath (Join-Path (Get-Location) 'css')) {
    & $scriptPath -WhatIf
    if ($LASTEXITCODE -ne 0) {
        throw "Expected -WhatIf migration run to exit 0; got $LASTEXITCODE"
    }
}
$implementation = Get-Content -LiteralPath $scriptPath -Raw
if ($implementation -notmatch 'Get-ChildItem -Path \$vaultRoot -Recurse -File -Filter \$fileName') {
    throw 'Expected migration script to recover moved image paths by unique filename.'
}
$verifyPath = Join-Path $PSScriptRoot '..\verify-vault-links.ps1'
$verifyImplementation = Get-Content -LiteralPath $verifyPath -Raw
if ($verifyImplementation -notmatch 'if \(\$null -eq \$content\) \{ continue \}') {
    throw 'Expected link verifier to skip empty Markdown before regex matching.'
}
$verifyImplementation = Get-Content -LiteralPath $verifyPath -Raw
if ($verifyImplementation -notmatch '@\(\s*\(Join-Path \$vaultRoot \$target\),') {
    throw 'Expected link verifier to construct each exact candidate separately.'
}

