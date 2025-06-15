<#
.SYNOPSIS
    Associates the current directory with a matching empty GitHub repository.

.DESCRIPTION
    This script is designed to help you safely and defensively associate a local directory (whose name ends with 'repo') to an existing, empty GitHub repository under your account. It performs a series of checks to ensure you do not accidentally overwrite or misconfigure your local or remote repositories. The script is modular, with each major step encapsulated in its own function for easy extension and maintenance.

    Key features:
    - Verifies the directory name ends with 'repo'.
    - Ensures the directory is not already a git repository.
    - Checks that the GITHUB_USER environment variable is set.
    - Confirms the remote repository exists and is empty.
    - Supports dry-run, mimic, and listing modes for safe operation.
    - All user-facing errors are presented in a friendly, actionable format.

    This script is ideal for automating the initial association of a new project directory to a GitHub repository, and can be extended for more advanced workflows as needed.

    Git COMMANDS it will run:
    *************************************
    The following git commands will be executed by this script:
        git init
        git remote add origin <remote-url>
        git branch -M main

    Applicability:
    *************************************
    1. you cloned a directory
    2. deleted the .git folder
    3. you want to associate it with a new GitHub repo (which must be empty and created beforehand)
    4. you want to push the local code to the remote repo using vscode or other git clients

    Also applicable:
    *************************************
    1. you have a directory that you want to associate with a new GitHub repo
    2. you want to push the local code to the remote repo using vscode or other git clients
    
    Diretory name for path (temporary)
    ************************************
    $env:path += ";C:\satya\data\code\LearnPowershellRepo\gitutils"
#>

# Associate a directory to a matching empty GitHub repo
param(
    [switch]$Help,
    [switch]$Run,
    [switch]$Mimic,
    [switch]$List
)

# Utility: User-friendly error output
function Show-UserError {
    param([string]$message)
    # create an empty line for better readability before and after the error message
    Write-Host ""  
    Write-Host "[ERROR] $message" 
    Write-Host "Please run this script with -Help to see usage instructions."
    write-host ""  # create an empty line for better readability after the error message
}

# Utility: Get and check current directory name for 'repo' suffix
function Get-CheckedRepoName {
    $dir = Split-Path -Leaf (Get-Location)
    if (-not ($dir -match 'repo$')) {
        Show-UserError "The current directory is named '$dir'. This script expects the directory name to end with 'repo'."
        exit 1
    }
    return $dir
}

# Utility: Check if already a git repo
function Check-NotGitRepo {
    if (Test-Path -Path .git) {
        $remote = try { git remote get-url origin 2>$null } catch { $null }
        if ($remote) {
            Show-UserError "Current directory is already a Git repository. Remote: $remote. Aborting."
        } else {
            Show-UserError "Current directory is already a Git repository. Aborting."
        }
        exit 1
    }
}

# Utility: Check if remote repo exists (HEAD request)
function RemoteRepo-Exists {
    param([string]$user, [string]$reponame)
    $url = "https://github.com/$user/$reponame"
    try {
        $resp = Invoke-WebRequest -Uri $url -Method Head -UseBasicParsing -ErrorAction Stop
        return $true
    } catch {
        if ($_.Exception.Response.StatusCode -eq 404) {
            return $false
        } else {
            Show-UserError "Failed to check remote repo existence: $_"
            exit 1
        }
    }
}

# Utility: Print help
function Show-Help {
    Write-Host ""
    Write-Host "Usage: .\git-associate-repo.ps1 [-Help] [-Run] [-Mimic] [-List]"
    Write-Host ""
    Write-Host "Associates the current directory to a matching empty GitHub repo."
    Write-Host ""
    Write-Host "PREREQUISITES:"
    Write-Host "  - Directory name must end with 'repo' (e.g., 'myproject-repo')"
    Write-Host "  - Not already a git repo (no .git folder present)"
    Write-Host "  - GITHUB_USER environment variable must be set to your GitHub username"
    Write-Host "  - Remote repo must already exist on GitHub and be empty"
    Write-Host ""
    Write-Host "OPTIONS:"
    Write-Host "  -Help  : Show this help text"
    Write-Host "  -Run   : Associate and push after confirmation"
    Write-Host "  -Mimic : Show planned actions and options"
    Write-Host "  -List  : List the git commands that would be executed"
    Write-Host ""
}

# Utility: Show mimic
function Show-Mimic 
{
    Utils-Ph "Mimic mode: Input options."
    $reponame = Get-CheckedRepoName
    $user = Get-CheckedUser
    Write-Host "Options: Help=$Help, Run=$Run, Mimic=$Mimic, List=$List"
    Write-Host "Repo: $reponame, User: $user"
    Write-Host "(No actions will be taken)"
}

# Utility: List git commands
function Show-List 
{
    Utils-Ph "Listing git commands that would be executed."
    $reponame = Get-CheckedRepoName
    $user = Get-CheckedUser
    $clone = "https://github.com/$user/$reponame.git"
    Write-Host "Planned Git commands:"
    Write-Host "  git init"
    Write-Host "  git remote add origin $clone"
    Write-Host "  git branch -M main"
}

# Utility: Prompt for confirmation
function Prompt-Confirmation {
    param([string]$promptMessage)
    do {
        $resp = Read-Host "$promptMessage [y/n]"
    } while ($resp -notin @('y','n'))
    return $resp -eq 'y'
}

# Utility: Get and check GitHub username from environment
function Get-CheckedUser {
    $user = $env:GITHUB_USER
    if (-not $user) {
        Show-UserError "GITHUB_USER environment variable not set. Please export your GitHub username (e.g., $env:GITHUB_USER='your-username') and try again."
        exit 1
    }
    return $user
}

# Utility: Check all prerequisites (directory name, user, not a git repo, remote repo exists)
function Check-Prerequisites 
{
    utils-ph "Checking prerequisites..."

    # Check if the current directory name ends with 'repo'
    $reponame = Get-CheckedRepoName  # Will exit if invalid
    Write-Host "[OK] Directory name ends with 'repo' $reponame."

    $user = Get-CheckedUser      # Will exit if not set
    Write-Host "[OK] GITHUB_USER environment variable is set. $user"

    Check-NotGitRepo             # Will exit if already a git repo
    Write-Host "[OK] Local directory is not already a git repository."

    if (-not (RemoteRepo-Exists -user $user -reponame $reponame)) {
        Show-UserError "Remote repo '$reponame' does not exist for user '$user'. Please create it on GitHub first (must be empty)."
        exit 1
    }
    Write-Host "[OK] Remote repo '$reponame' exists for user '$user'."
    
    write-host "All prerequisites are met. Proceeding with association..."
}

# Main execution logic

# Modular git command functions
function Git-Init {
    Write-Host "Running: git init"
    git init
    if ($LASTEXITCODE -ne 0) {
        Show-UserError "git init failed."; exit $LASTEXITCODE
    }
}

function Git-Remote-Add {
    param([string]$clone)
    Write-Host "Running: git remote add origin $clone"
    git remote add origin $clone
    if ($LASTEXITCODE -ne 0) {
        Show-UserError "git remote add origin failed."; exit $LASTEXITCODE
    }
}

function Git-Branch-Main {
    Write-Host "Running: git branch -M main"
    git branch -M main
    if ($LASTEXITCODE -ne 0) {
        Show-UserError "git branch -M main failed."; exit $LASTEXITCODE
    }
}

# Main execution logic (no add/commit)

# Encapsulated method to run all git commands
function Invoke-GitAssociation {
    param([string]$clone)
    # Initialize a new git repository
    Git-Init
    # Add the remote origin
    Git-Remote-Add -clone $clone
    # Set the main branch
    Git-Branch-Main
    Write-Host 'Done.'
}

# Main execution logic (no add/commit)
function Execute-All {
    $reponame = Get-CheckedRepoName
    Check-NotGitRepo
    $user = Get-CheckedUser
    if (-not (RemoteRepo-Exists -user $user -reponame $reponame)) {
        Show-UserError "Remote repo '$reponame' does not exist for user '$user'. Please create it on GitHub first (must be empty)."
        exit 1
    }
    $clone = "https://github.com/$user/$reponame.git"
    Write-Host "About to associate local directory '$reponame' with remote repo $clone"
    Invoke-GitAssociation -clone $clone
}


# Utility: Pretty header output
function Utils-Ph {
    param([string]$msg)
    Write-Host ""
    Write-Host $msg
    Write-Host "*****************************"
    Write-Host ""
}

# Main method
if ($PSBoundParameters.Count -eq 0) {
    Write-Host "No params running the script with -Help"
    Show-Help
    exit 0
}

function Main {
    # If no options are given, default to help using PSBoundParameters
    if ($Help) {
        Show-Help; exit 0
    }
    Check-Prerequisites
    if ($Mimic) {
        Show-Mimic; exit 0
    }
    if ($List) {
        Show-Mimic
        Show-List; exit 0
    }
    if ($Run) {
        Show-Mimic
        Show-List
        if (-not (Prompt-Confirmation "Proceed with association and push?")) {
            Write-Host "Aborted by user."; exit 0
        }
        Execute-All; exit 0
    }
    Show-Help
}

Main
