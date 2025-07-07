# ------------------------------------------------------------
# pathutils.ps1
# Work with Windows environment path variables
#
# Description : Utility script for viewing and updating Windows environment PATH variables (system, user, and session).
# Author      : Satya Komatineni
# Created     : June 2025
# Last Edited : June 28, 2025
#
# Features:
#   - List system, user, and current session PATH variables
#   - Add new paths to system, user, or session PATH
#   - Prevents duplicate entries and prompts for confirmation
#   - Menu-driven, modular, and defensive coding style
#   - Color-coded output for clarity
# ------------------------------------------------------------


function Show-Help {
    Write-Host
    Write-Host "Path Utilities - Menu"
    Write-Host "1. Show system paths"
    Write-Host "2. Show user paths"
    Write-Host "3. Update system path"
    Write-Host "4. Update user path"
    Write-Host "5. Update current session path"
    Write-Host "6. Show total paths for current environment"
    Write-Host "7. Help"
    Write-Host "8. Exit"
}

function Get-SystemPaths {
    [Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine) -split ';' | Sort-Object
}

function Get-UserPaths {
    [Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User) -split ';' | Sort-Object
}

function Show-SystemPaths {
    Write-Host
    Write-Host "System Paths:" -ForegroundColor Cyan
    Get-SystemPaths | ForEach-Object { Write-Host $_ }
}

function Show-UserPaths {
    Write-Host
    Write-Host "User Paths:" -ForegroundColor Cyan
    Get-UserPaths | ForEach-Object { Write-Host $_ }
}

function Show-TotalPaths {
    Write-Host
    Write-Host "All Paths (Current Environment):" -ForegroundColor Cyan
    Write-Host
    $allPaths = $env:Path -split ';' | Sort-Object 

    $systemPaths = Get-SystemPaths | Sort-Object
    $userPaths = Get-UserPaths | Sort-Object

    # show system paths only first
    foreach ($path in $systemPaths) {
        Write-Host "(sys) $path" -ForegroundColor Yellow
    }
    # show user paths only next
    foreach ($path in $userPaths) {
        Write-Host "(usr) $path" -ForegroundColor Green
    }
    # show current session paths last
    $currentSessionPaths = $allPaths | Where-Object { $_ -notin $systemPaths -and $_ -notin $userPaths }
    foreach ($path in $currentSessionPaths) {
        Write-Host "(cur) $path" -ForegroundColor Gray
    }   
}

function Update-UserPath {
    $currentDir = Get-Location
    $userPaths = Get-UserPaths
    $systemPaths = Get-SystemPaths
    $newPath = Read-Host "Enter the path to add to user PATH (default: $currentDir)"
    if ([string]::IsNullOrWhiteSpace($newPath)) { $newPath = $currentDir }
    if ($userPaths -contains $newPath -or $systemPaths -contains $newPath) {
        Write-Host "Path already exists in user or system PATH. No changes made." -ForegroundColor Yellow
        return
    }
    $confirm = Read-Host "Append '$newPath' to user PATH? (Y/N)"
    if ($confirm -match '^(Y|y|Yes|yes)$') {
        $updated = ($userPaths + $newPath) -join ';'
        [Environment]::SetEnvironmentVariable("Path", $updated, [System.EnvironmentVariableTarget]::User)
        Write-Host "User PATH updated successfully." -ForegroundColor Green
        Show-UserPaths
    } else {
        Write-Host "No changes made to user PATH." -ForegroundColor Yellow
    }
}

function Update-SystemPath {
    $currentDir = Get-Location
    $userPaths = Get-UserPaths
    $systemPaths = Get-SystemPaths
    $newPath = Read-Host "Enter the path to add to system PATH (default: $currentDir)"
    if ([string]::IsNullOrWhiteSpace($newPath)) { $newPath = $currentDir }
    if ($systemPaths -contains $newPath -or $userPaths -contains $newPath) {
        Write-Host "Path already exists in system or user PATH. No changes made." -ForegroundColor Yellow
        return
    }
    $confirm = Read-Host "Append '$newPath' to system PATH? (Y/N)"
    if ($confirm -match '^(Y|y|Yes|yes)$') {
        $updated = ($systemPaths + $newPath) -join ';'
        [Environment]::SetEnvironmentVariable("Path", $updated, [System.EnvironmentVariableTarget]::Machine)
        Write-Host "System PATH updated successfully." -ForegroundColor Green
        Show-SystemPaths
    } else {
        Write-Host "No changes made to system PATH." -ForegroundColor Yellow
    }
}

function Update-CurrentSessionPath {
    $currentDir = Get-Location
    $currentPaths = $env:Path -split ';'
    $newPath = Read-Host "Enter the path to add to current session PATH (default: $currentDir)"
    if ([string]::IsNullOrWhiteSpace($newPath)) { $newPath = $currentDir }
    if ($currentPaths -contains $newPath) {
        Write-Host "Path already exists in current session PATH. No changes made." -ForegroundColor Yellow
        return
    }
    $confirm = Read-Host "Append '$newPath' to current session PATH? (Y/N)"
    if ($confirm -match '^(Y|y|Yes|yes)$') {
        $env:Path = ($currentPaths + $newPath) -join ';'
        Write-Host "Current session PATH updated successfully." -ForegroundColor Green
        Show-TotalPaths
    } else {
        Write-Host "No changes made to current session PATH." -ForegroundColor Yellow
    }
}

function Exit-PathUtils {
    Write-Host "Exiting Path Utilities. Goodbye!" -ForegroundColor Cyan
    Write-Host
    exit
}

function Main {
    while ($true) {
        Show-Help
        Write-Host
        $choice = Read-Host "Enter the number of the function to execute"
        switch ($choice) {
            1 { Show-SystemPaths }
            2 { Show-UserPaths }
            3 { Update-SystemPath }
            4 { Update-UserPath }
            5 { Update-CurrentSessionPath }
            6 { Show-TotalPaths }
            7 { Show-Help }
            8 { Exit-PathUtils }
            default { Write-Host "Invalid selection. Please try again." -ForegroundColor Red }
        }
    }
}

Main
