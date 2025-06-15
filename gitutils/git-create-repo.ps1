<#
.SYNOPSIS
    Create a GitHub repository based on the current directory and push local code.
.DESCRIPTION
    - Verifies current directory naming convention.
    - Ensures not already under Git.
    - Provides dry-run, mimic, confirmation, listing, and rejection modes.
    - Modular functions for easy extension.
.PARAMETER Help
    Displays usage information.
.PARAMETER Run
    Executes the creation and push after confirmation.
.PARAMETER Mimic
    Shows which options and actions would run.
.PARAMETER List
    Lists the Git commands to execute without running them.
.PARAMETER Message
    The commit message for the initial commit (default: "Initial commit").
#>
param(
    [switch]$Help,
    [switch]$Run,
    [switch]$Mimic,
    [switch]$List,
    [string]$Message = "Initial commit"
)

function showHelp {
    Write-Host "Usage: .\Create-Repo.ps1 [-Help] [-Run] [-Mimic] [-List] [-Message <commit message>]"
    Write-Host "  -Help   : Show this help text"
    Write-Host "  -Run    : Execute the repository creation and push"
    Write-Host "  -Mimic  : Display the options and planned actions without execution"
    Write-Host "  -List   : List the Git commands to be executed, then exit"
    Write-Host "  -Message: Commit message for the initial commit (default: 'Initial commit')"
}

function checkDirectorySuffix {
    $dir = Split-Path -Leaf (Get-Location).Path
    if (-not ($dir -match 'repo$')) {
        Write-Error "Directory name '$dir' does not end with 'repo'. Rename accordingly or move to correct folder."
        exit 1
    }
}

function checkNotRepo {
    if (Test-Path -Path .git) {
        Write-Error "Current directory is already a Git repository. Aborting."
        exit 1
    }
}

function promptConfirmation {
    param([string]$promptMessage)
    do {
        $resp = Read-Host "$promptMessage [y/n]"
    } while ($resp -notin @('y','n'))
    return $resp -eq 'y'
}

function rejectedConfirmation {
    param([string]$promptMessage)
    return -not (promptConfirmation $promptMessage)
}

function getRepoName {
    return (Split-Path -Leaf (Get-Location))
}

function repoExists {
    param([string]$reponame)
    if (-not $env:GITHUB_USER) {
        Write-Error "GITHUB_USER not set. Export your GitHub username."
        exit 1
    }
    $url = "https://github.com/$($env:GITHUB_USER)/$reponame"
    try {
        $response = Invoke-WebRequest -Uri $url -Method Head -UseBasicParsing -ErrorAction Stop
        return $true
    } catch {
        if ($_.Exception.Response.StatusCode -eq 404) {
            return $false
        } else {
            Write-Error "Failed to check repository existence: $_"
            exit 1
        }
    }
}

function getGitCommands {
    param([string]$cloneUrl, [string]$msg)
    @(
        'git init',
        'git checkout -B main',
        'git add .',
        "git commit -m `"$msg`"",
        "git remote add origin $cloneUrl",
        'git push -u origin main'
    )
}

function invokeCommandOrExit {
    param([string]$command)
    Write-Host "Executing: $command"
    iex $command
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Command failed with exit code $LASTEXITCODE: $command"
        exit $LASTEXITCODE
    }
}

function showMimic {
    Write-Host "Options: Help=$Help, Run=$Run, Mimic=$Mimic, List=$List, Message='$Message'"
    Write-Host "(No actions will be taken)"
}

function showList {
    $reponame = getRepoName
    $user = $env:GITHUB_USER
    if (-not $user) {
        $user = "your-user" # fallback if GITHUB_USER not set
    }
    $clone = "https://github.com/$user/$reponame.git"
    $cmds = getGitCommands -cloneUrl $clone -msg $Message
    Write-Host "Planned Git commands:"; $cmds | ForEach-Object { Write-Host "  $_" }
}

function executeAll {
    checkDirectorySuffix
    checkNotRepo
    $reponame = getRepoName
    $user = $env:GITHUB_USER
    if (-not $user) {
        Write-Error "GITHUB_USER not set. Export your GitHub username."
        exit 1
    }
    if (-not (repoExists -reponame $reponame)) {
        Write-Error "Repository '$reponame' does not exist under user '$user'. Please create it on GitHub first (must be empty)."
        exit 1
    }
    $cloneUrl = "https://github.com/$user/$reponame.git"
    Write-Host "About to push local code to existing repo '$reponame' at $cloneUrl with message '$Message'"
    $cmds = getGitCommands -cloneUrl $cloneUrl -msg $Message
    foreach ($c in $cmds) {
        invokeCommandOrExit -command $c
    }
    Write-Host 'Done.'
}

function main {
    if ($Help) {
        showHelp; return
    }
    if ($Mimic) {
        showMimic; return
    }
    if ($List) {
        showList; return
    }
    if ($Run) {
        showList
        if (rejectedConfirmation "Proceed with creation and push?") {
            Write-Host "Aborted by user."
            return
        }
        executeAll
        return
    }
    showHelp
}

main
