$ErrorActionPreference = 'Stop'
$vaultRoot = (Get-Location).Path
$notes = Get-ChildItem -Path $vaultRoot -Recurse -File -Filter '*.md' | Where-Object {
    $_.FullName -notmatch '\\(\.git|\.obsidian|\.claudian|\.trash|docs)\\'
}
$allFiles = Get-ChildItem -Path $vaultRoot -Recurse -File | Where-Object {
    $_.FullName -notmatch '\\(\.git|\.obsidian|\.claudian|\.trash|docs)\\'
}
$broken = [System.Collections.Generic.List[string]]::new()
foreach ($note in $notes) {
    $content = Get-Content -LiteralPath $note.FullName -Raw
    if ($null -eq $content) { continue }
    foreach ($match in [regex]::Matches($content, '!?\[\[([^\]]+)\]\]')) {
        $target = ($match.Groups[1].Value -split '[#|]', 2)[0].Trim().Replace('/', '\\')
        if ([string]::IsNullOrWhiteSpace($target)) { continue }
        $hasExtension = [IO.Path]::HasExtension($target)
        $exactCandidates = @(
            Join-Path $vaultRoot $target,
            $(if ($hasExtension) { $null } else { Join-Path $vaultRoot "$target.md" })
        ) | Where-Object { $_ }
        $resolved = $exactCandidates | Where-Object { Test-Path -LiteralPath $_ -PathType Leaf } | Select-Object -First 1
        if (-not $resolved -and $target -notmatch '[\\/]') {
            $name = [IO.Path]::GetFileNameWithoutExtension($target)
            $candidates = $allFiles | Where-Object { [IO.Path]::GetFileNameWithoutExtension($_.Name) -eq $name }
            if ($candidates.Count -eq 1) { $resolved = $candidates[0].FullName }
        }
        if (-not $resolved) { $broken.Add("$($note.FullName.Substring($vaultRoot.Length + 1)): $($match.Value)") }
    }
}
if ($broken.Count -gt 0) {
    $broken | ForEach-Object { Write-Error "Broken link: $_" }
    exit 1
}
Write-Output 'Vault link check passed.'
exit 0

