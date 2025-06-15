function use {
    param($n)
    if (-not $env:MY_PS_LIB) { Write-Warning "Missing MY_PS_LIB"; exit }
    $p = Join-Path $env:MY_PS_LIB $n
    if (-not (Test-Path $p)) { Write-Warning "Missing: $p"; exit }
    if (-not $script:__use_cache) { $script:__use_cache = @{} }
    if ($script:__use_cache[$p]) { return }
    
    $cmd = ". `"$p`""
    Invoke-Command -ScriptBlock ([scriptblock]::Create($cmd)) -NoNewScope

    $script:__use_cache[$p] = $true
}
