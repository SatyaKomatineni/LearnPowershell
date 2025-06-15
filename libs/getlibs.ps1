function getlib() {
    param([string]$scriptName)

    if (-not $env:MY_PS_LIB) {
        Write-host "Missing MY_PS_LIB"
        return $null
    }

    $fullPath = Join-Path $env:MY_PS_LIB $scriptName
    $noopPath = Join-Path $env:MY_PS_LIB "__noop.ps1"

    if (-not (Test-Path $fullPath)) {
        Write-host "Missing file: $fullPath"
        return $noopPath
    }

    if (-not $script:__use_cache) {
        $script:__use_cache = @{}
    }

    if ($script:__use_cache[$fullPath]) {
        return $noopPath
    }

    $script:__use_cache[$fullPath] = $true
    return $fullPath
}
