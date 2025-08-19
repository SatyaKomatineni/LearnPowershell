# git-utils.ps1
# Modular Git Utilities Script


# Base class for all git utilities
class GitUtility {
    GitUtility() {}
    [string] Name() {
        throw "Name() not implemented in base class."
    }
    [string] Description() {
        throw "Description() not implemented in base class."
    }
    Execute() {
        throw "Execute() not implemented in base class."
    }
}





# Utility function to run any command line with header/footer
function Run-Command {
    param(
        [string]$CommandLine
    )
    $Header = "===================[ Command Output ]===================="
    $Footer = "=================[ End Command Output ]==================="
    Write-Host "\n$Header"
    Write-Host ("PS> $CommandLine") -ForegroundColor Yellow
    $parts = $CommandLine -split ' '
    $exe = $parts[0]
    $args = $parts[1..($parts.Length-1)]
    $output = & $exe @args
    foreach ($line in $output) {
        Write-Host $line
    }
    Write-Host $Footer
}

# Derived classes for each utility
class ShowGitStatusUtility : GitUtility {
    ShowGitStatusUtility() : base() {}
    [string] Name() {
        return 'Show-GitStatus'
    }
    [string] Description() {
        return 'Display git status in the current repo'
    }
    Execute() {
        Run-Command 'git status'
    }
}

class ShowGitRemotesUtility : GitUtility {
    ShowGitRemotesUtility() : base() {}
    [string] Name() {
        return 'Show-GitRemotes'
    }
    [string] Description() {
        return 'Show all git remotes'
    }
    Execute() {
        Run-Command 'git remote -v'
    }
}

class ShowGitRemoteOriginUtility : GitUtility {
    ShowGitRemoteOriginUtility() : base() {}
    [string] Name() {
        return 'Show-GitRemoteOrigin'
    }
    [string] Description() {
        return 'Show remote origin details'
    }
    Execute() {
        Run-Command 'git remote show origin'
    }
}



function Show-Menu {
    param([GitUtility[]]$utilities)
    Write-Host "\nAvailable Git Utilities:"
    for ($i = 0; $i -lt $utilities.Count; $i++) {
        Write-Host ("[$i] {0} - {1}" -f $utilities[$i].Name(), $utilities[$i].Description())
    }
    Write-Host ("[{0}] Exit" -f $utilities.Count)
}


function Main {
    $utilities = @(
        [ShowGitStatusUtility]::new(),
        [ShowGitRemotesUtility]::new(),
        [ShowGitRemoteOriginUtility]::new()
    )
    while ($true) {
        Show-Menu -utilities $utilities
        $choice = Read-Host "Select a function by number"
        if ($choice -eq $utilities.Count) {
            Write-Host "Exiting."
            break
        }
        if ($choice -match '^[0-9]+$' -and $choice -ge 0 -and $choice -lt $utilities.Count) {
            $utilities[$choice].Execute()
            break
        } else {
            Write-Host "Invalid selection. Try again."
        }
    }
}

Main
