# Primary Goal
# ********************************************************
# Write a powershell script to clone and pull
# a private git repo.

# Can be used in an azure cloud shell
# into a cloud shell mounted drive in the azure cloud
#
# can be used anywhere to copy code for deployments
# where the transfer mechanism is a git repo
# Uses an access token from Github or git repo
#
# Secondary Goal
# ************************
# Exercise basic first time powershell write
#
# Prerequisites
# ******************
# 1. there is an access token
# 2. Change the configuration section to set 
#    a) loal repo directories
#    b) remote repo URLs
#
#
# Caution
# ************************
# 1. Please test/modify for your needs
# 2. As is. There could be bugs
#
# Name
# ************************
# azure-shell-git-utils.ps1
#
# Approach
# **************
# 1. Use access tokens from git
# 2. Set it in the environment for the length of the session
# 3. You can do clone the first time
# 4. you can do multiple pulss
# 5. Use vscode locally and push to the repo
# 6. Pull the repo from azure servers
#
# Aleternatively
# **************
# It may be just easier to use the Export commandlet
# to upload the scripts one at a time
#
# Further more
# **************
# There is probably far better to write this code
# using advanced syntax for commandlet functions.
# that is for another day.
#
# ********************************************************

# ********************************************************
# Comandlets used
# ********************************************************
# Read-Host: to read user input from command line
# Write-Host: printf
# Get-Childitem: To read environment variables
# Set-Item: to set env variable
# Get-Location: pwd
# Set-Location: cd
# ********************************************************

# ********************************************************
# Concepts used
# ********************************************************
# Simple functions
# calling functions (grouping - () operator )
# if/elseif
# printfs
# ********************************************************


# ********************************************************
# Configuration
# ********************************************************

#
#1. Configure this section correctly
#2. Rename the utility to your prefered name
#3. Set that in a path
#Set this to $true 
#

#$configured = $true
$configured=$false

# Real configuration follow
# ************************************

# $accessToken This will be read from the environment
# Look for this in the environment
$repoAccessTokenName = "GitRepoPowershell_AccessToken"

#This is where git repo will be cloned to
$gitLocalDir = "c:\satya\data\code\git-test"

#This is where this scripts is locatedfile is located
$scriptsDir = "C:\satya\data\code\power-shell-scripts\individual\satya\git-util"

#This is the URI of the private repo
function getRepoUri($accessToken){
    return "https://$accessToken@gitlab.com/rest-of-repo-url"
}


# ********************************************************
# End Configuration
# ********************************************************


function getEnvVariable($name)
{
    $value = Get-ChildItem -Path "Env:$name" -ErrorAction Ignore
    return $value.value
}

function setEnvVariaable ($name, $value)
{
    Set-Item -Path "Env:$name" -Value $value -ErrorAction Ignore
}

function getTokenAndSetIfNotAvailable(){
    $at = getEnvVariable $repoAccessTokenName
    if ($null -ne $at)
    {
        return $at
    }
    Write-host "Ouptut token is null"
    $atnew = Read-Host -Prompt "Provide the access token" 
    setEnvVariaable -name $repoAccessTokenName  -value $atnew
    return $atnew
}

function setAccessToken {
    getTokenAndSetIfNotAvailable
    showAccessToken
}
function resetAccessToken {
    setEnvVariaable -name $repoAccessTokenName  -value $null
}

function showAccessToken {
    Write-Host "Name: $repoAccessTokenName, Value:$(getEnvVariable -name $repoAccessTokenName)"
}

function getAccessToken {
    return getEnvVariable -name $repoAccessTokenName
}

function cdGitLocalDir {
    Set-Location $gitLocalDir -ErrorAction Ignore
}

function cdScriptsDir {
    #alias: cd
    Set-Location $scriptsDir -ErrorAction Ignore
}

function getCurDir {
    #alias: pwd
    $curdir = Get-Location
    return $curDir
}

function validateContext {
    #There must be an access token
    $token = getAccessToken
    if ($token -eq $null)
    {
        Write-Host "Access token is not in the environment"
        Write-Host "Use Set command to set it"
        return $false
    }
    Write-Host "Access token is available. Use show command to see it"

    #Make sure you are in the right location to clone or pull
    #cd to git location
    cdGitLocalDir

    [String]$curDir = getCurDir
    if ($curDir.ToLower() -ne $gitLocalDir.ToLower()) 
    {
        Write-Host "Your directory doesnt match"
        Write-Host "Curdir: $curDir"
        Write-Host "git directory to clone or pull: $gitLocalDir"
        return $false
    }
    #you are good
    #access key is there
    #you switched to the right directory
    return $true
}

function getValidGitUri {
    $token = getTokenAndSetIfNotAvailable
    $context = validateContext
    if ($context -eq $false)
    {
        Write-Host "Invalid environment. Check."
        return
    }
    $uri = getRepoUri -accessToken $token
    return $uri
}
function clone {
    $uri = getValidGitUri
    Write-Host "Gotten Uri: $uri"
    Write-Host "Going to use command git clone $uri"
    [String]$ans = Read-Host "Going to use command git clone $uri : Y/N?"
    if ($ans.ToLower() -eq "y")
    {
        git.exe clone $uri
    }
}

function pull {
    $uri = getValidGitUri
    Write-Host "Gotten Uri: $uri"
    Write-Host "Going to use command git pull $uri"
    [String]$ans = Read-Host "Going to use command git pull $uri : Y/N?"
    if ($ans.ToLower() -eq "y")
    {
        git.exe pull $uri
    }
}

function main {

    if ($configured -eq $false)
    {
        Write-Host "You need to configure this first. Read the comments section"
        return
    }
    $cmdset1 = "reset, show, set, gitlocal, scripts"
    $cmdset2 = "clone,pull,otherwise"
    $what = Read-Host -Prompt "What command: $cmdset1,$cmdset2"
    if ($what -eq "reset")
    {
        Write-Host "Resetting token"
        resetAccessToken
        return
    }
    elseif ($what -eq "show")
    {
        Write-Host "Showing the Access token that is in the enviornment"
        showAccessToken
        return
    }
    elseif ($what -eq "set")
    {
        Write-Host "Prompt and set the variable"
        setAccessToken
        return
    }
    elseif ($what -eq "gitlocal")
    {
        Write-Host "Changing directory to $gitLocalDir"
        cdGitLocalDir
        return
    }
    elseif ($what -eq "scripts")
    {
        Write-Host "Changing directory to $scriptsDir"
        cdScriptsDir
        return
    }
    elseif ($what -eq "pull")
    {
        Write-Host "Git Pull"
        pull
        return
    }
    elseif ($what -eq "clone")
    {
        Write-Host "Git clone"
        clone
        return
    }
    Write-Host "Default. Running None"
}

#Run the show
main