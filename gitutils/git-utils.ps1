
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
<#



#*************************************************
# Place your new utility classes from here on, below this line.
# Because they are only valid after the base class is defined.
#*************************************************
#>

# Utility: Show remote git tags
class ShowGitRemoteTagsUtility : GitUtility {
    ShowGitRemoteTagsUtility() : base() {}
    [string] Name() {
        return 'Show-GitRemoteTags'
    }
    [string] Description() {
        return 'Show all remote git tags (from origin)'
    }
    Execute() {
        Run-Command 'git ls-remote --tags origin'
    }
}

# Utility: Push a local git tag
class PushGitTagUtility : GitUtility {
    PushGitTagUtility() : base() {}
    [string] Name() {
        return 'Push-GitTag'
    }
    [string] Description() {
        return 'Push a local git tag to remote (choose tag or push all)'
    }
    Execute() {
        $tagOutput = git tag
        $tags = @()
        if ($tagOutput) {
            $tags = @($tagOutput -split "`r?`n" | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne '' })
        }
        if (-not $tags -or $tags.Count -eq 0) {
            Write-Host 'No local tags found.'
            return
        }
        Write-Host "\nAvailable Local Tags: $tags"
        for ($i = 0; $i -lt $tags.Count; $i++) {
            Write-Host ("[$i] $($tags[$i])")
        }
        $allOption = $tags.Count
        Write-Host ("[$allOption] Push ALL tags")
        $choice = Read-Host "Select a tag to push by number, or $allOption for all"
        if ($choice -eq $allOption) {
            Run-Command 'git push --tags'
            Write-Host 'All tags pushed to remote.'
        } elseif ($choice -match '^[0-9]+$' -and $choice -ge 0 -and $choice -lt $tags.Count) {
            $tagToPush = $tags[$choice]
            Run-Command ("git push origin $tagToPush")
            Write-Host "Tag '$tagToPush' pushed to remote."
        } else {
            Write-Host 'Invalid selection. Aborting.'
        }
    }
}

# Utility: Show local git tags
class ShowGitLocalTagsUtility : GitUtility {
    ShowGitLocalTagsUtility() : base() {}
    [string] Name() {
        return 'Show-GitLocalTags'
    }
    [string] Description() {
        return 'Show all local git tags'
    }
    Execute() {
        Run-Command 'git tag'
    }
}

# Utility: Create a new git tag
class CreateGitTagUtility : GitUtility {
    CreateGitTagUtility() : base() {}
    [string] Name() {
        return 'Create-GitTag'
    }
    [string] Description() {
        return 'Create a new git tag (prompts for tag name)'
    }
    Execute() {
        $tagName = Read-Host 'Enter new tag name'
        if ([string]::IsNullOrWhiteSpace($tagName)) {
            Write-Host 'No tag name provided. Aborting.'
            return
        }
        Run-Command ("git tag $tagName")
        Write-Host "Tag '$tagName' created (if no errors above)."
    }
}

class ShowGitAllBranchesUtility : GitUtility {
    ShowGitAllBranchesUtility() : base() {}
    [string] Name() {
        return 'Show-GitAllBranches'
    }
    [string] Description() {
        return 'Show all local and remote git branches'
    }
    Execute() {
        Run-Command 'git branch -a'
    }
}

class ShowGitLocalBranchesUtility : GitUtility {
    ShowGitLocalBranchesUtility() : base() {}
    [string] Name() {
        return 'Show-GitLocalBranches'
    }
    [string] Description() {
        return 'Show all local git branches'
    }
    Execute() {
        Run-Command 'git branch'
    }
}

class ShowGitRemoteBranchesUtility : GitUtility {
    ShowGitRemoteBranchesUtility() : base() {}
    [string] Name() {
        return 'Show-GitRemoteBranches'
    }
    [string] Description() {
        return 'Show all remote git branches'
    }
    Execute() {
        Run-Command 'git branch -r'
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
        [ShowGitRemoteOriginUtility]::new(),
        [ShowGitLocalBranchesUtility]::new(),
        [ShowGitRemoteBranchesUtility]::new(),
        [ShowGitAllBranchesUtility]::new(),
        [ShowGitLocalTagsUtility]::new(),
        [ShowGitRemoteTagsUtility]::new(),
        [CreateGitTagUtility]::new(),
        [PushGitTagUtility]::new()
    )
    while ($true) {
        Show-Menu -utilities $utilities
        $choice = Read-Host "Select a function by number"
        if ($choice -match '^[0-9]+$') {
            $choiceInt = [int]$choice
            if ($choiceInt -eq $utilities.Count) {
                Write-Host "Exiting."
                break
            }
            if ($choiceInt -ge 0 -and $choiceInt -lt $utilities.Count) {
                $utilities[$choiceInt].Execute()
                break
            } else {
                Write-Host "Invalid selection. Try again."
            }
        } else {
            Write-Host "Invalid selection. Try again."
        }
    }
}

Main
