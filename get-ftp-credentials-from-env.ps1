<#
# *************************************************
#
# Read Credentials for an ftp host
#
# A formulated $credential object is returned
# Object type is:
# System.Management.Automation.PSCredential
#
# From the environment:

# the following from the environment
#
# Assuming an ftp host name is: ftphost
# ftp.ftphost.host
# ftp.ftphost.username
# ftp.ftphost.password
#
# *************************************************
#>
function isValid($somestring)
{
    if ($somestring -eq $null)
    {
        return $false
    }
    
    if ($something -eq "")
    {
        return $false`
    }
    return $true
}

function getEnvVariable($name)
{
    $valid = isValid($name)
    if ($valid -eq $false)
    {
        throw "Invalid environment variable name: null or empty"
    }
    $value = Get-ChildItem -Path "Env:$name" -ErrorAction Ignore
    $returnValue = $value.value

    if ((isValid($returnValue)) -eq $fasle)
    {
        throw "Empty environment output for variable:$name"
    }
    return $returnValue
}


function getCredentials($hostname)
{
    $env_username = "ftp." + $hostname + ".username"
    $env_password = "ftp." + $hostname + ".password"

    $username = getEnvVariable -name $env_username
    $passwordPlain = getEnvVariable -name $env_password

    $password = ConvertTo-SecureString $passwordPlain -AsPlainText -Force

    $credential = New-Object System.Management.Automation.PSCredential($username, $password)
    return $credential
}

$credentials = getCredentials -hostname "ftphost"
#Will loo

Write-Host "Username $($credentials.username)"
Write-Host "Password: $($credentials.password)"