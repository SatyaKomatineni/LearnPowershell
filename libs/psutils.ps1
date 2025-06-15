
<#
#**********************************************
# name: psutils.ps1
#
# A common utility file for powershell
# Note: ps function names are case sensitive.
#
# for nulls
# ********************
# isNull, isNotNull
#
# printing
# ********************
# p, pt, pd, pe, pw, ps, hp, mhp
#
# Utils
# ********************
# FileUtils.fExists, dExists
# EnvUtils.getEnvVariable, getEnvVariableWithDefault
# TimeUtils.convertToISOTime, convertToISOTime2, getDateForISOString
# TimeUtils.getMinutePortion, getMinutePortion1, testISODate
# ErrorUtils.getANewErrorArray, testErrorArray, getExceptionMessage, printErrorRecordDetails
#
#**********************************************
#>
function IsNull([object]$value) {
    return $null -eq $value
}
function IsNotNull([object]$value) {
    return $null -ne $value
}
function p($message)
{
    Write-Host $message
}
function pt($message)
{
    $d = Get-Date
    p -message "$d : $message"
}

$script:debug = $true

function turnOnDebug()
{
    $script:debug = $true
}

function turnOffDebug()
{
    $script:debug = $false
}

function pd($message)
{
    #debug message
    if ($script:debug -eq $true)
    {
        p -message $message
    }
}

function pe($message)
{
    Write-Host "Error: $message"
}
function pw($message)
{
    Write-Host "Warn: $message"
}

#Secure version
function ps($message)
{
    Write-Host "Secure: $message"
}

#subheading print
function hp($message)
{
    Write-Host ""
    pt -message $message
    Write-Host "***************************************"
}

#Main heading print
function mhp($message)
{
    Write-Host ""
    #Write-Host $message
    Write-Host "************************************************************"
    pt -message $message
    Write-Host "************************************************************"
}


function ErrorUtils.getExceptionMessage($errorRecord)
{
    if (isNull $errorRecord)
    {
        return "Sorry Error Record itself is null."
    }

    [System.Management.Automation.ErrorRecord]$er = $errorRecord
    if (IsNotNull $er.ErrorDetails)
    {
        return $er.ErrorDetails.ToString()
    }

    #errordetails is null. See for exceptions
    if ($er.Exception -eq $null)
    {
        return "Sorry Error details is null and the Exception object is null in the error record"
    }

    #Exception exists
    $baseException = $er.Exception.GetBaseException()
    if ($baseException -ne $null)
    {
        return $baseException.Message
    }

    #base exception doesn't exist
    return $er.Exception.Message
}
function ErrorUtils.printErrorRecordDetails($errorRecord)
{
    if ($errorRecord -eq $null)
    {
        pe -message "A null error record is passed in to print its details"
        return
    }

    [System.Management.Automation.ErrorRecord]$er = $errorRecord
    if ($er.ErrorDetails -eq $null)
    {
        pe -message "ErrorDetail is null"
    }
    else {
        pe -message "Error Details follow"
        pe -message $er.ErrorDetails
    }
    if ($er.Exception -eq $null)
    {
        pe -message "Exception of the error record is null"
    }
    else {
        pe -message "Exception message: $($er.Exception.Message)"
    }

    # possibly [System.Management.Automation.RuntimeException]
    $baseException = $er.Exception.GetBaseException()
    #printSimpleTypeInfo -inputObject $baseException

    pe -message "Script Stack trace for the error is below"
    pe -message $er.ScriptStackTrace

    if ($baseException -eq $null)
    {
        pe -message "Base exception is null"
    }
    else {
        pe -message "Base Exception message is: $($baseException.Message)"
        pe -message "Base Exception is: $baseException"
    }
}

 # **********************************************
 # It is useful to know what are the types of 
 # variables in powershell scripts
 # **********************************************
 function TypeUtils.printTypeInformation ($inputobject)
 {
     Write-Host "printing type information for type: $($inputobject.GetType())"
     $typeDetails = $inputobject  | Get-Member
     $typeDetails
     $inputObject.GetType()
 }

 function TypeUtils.printSimpleTypeInfo($inputObject)
 {
    if (isNull $inputObject) {
        p -message "The input object you passed is null."
        return
    }
    $typeObject = $inputObject.GetType()
    $typename = $typeObject.FullName
    $typeShortName = $typeObject.name

    p -message "Fullname of the type is: $typename"
    p -message "Short name is: $typeShortName"
    $typeObject
 }

 function TypeUtils.getTypeFullname($inputObject)
 {
    if (isNull $inputObject)
    {
        p -message "The input object you passed is null."
        return $null
    }
    return $inputObject.GetType().FullName
 }
function vutils.isNotValid($somestring) {
    return !(vutils.isValid($somestring))
}

function vutils.isValid($somestring)
{
    if (isNull $somestring)
    {
        return $false
    }
    
    if ($somestring -eq "")
    {
        return $false
    }

    $b = [String]::IsNullOrWhiteSpace($somestring)
    if ($b -eq $true)
    {
        #it is null or white space
        return $false
    }
    return $true
}


function EnvUtils.getEnvVariableWithDefault($name, $defaultValue)
{
    $valid = isValid($name)
    if ($valid -eq $false)
    {
        p -message "Empty environment key. Returning default value"
        return $defaultValue
    }
    $value = Get-ChildItem -Path "Env:$name" -ErrorAction Ignore
    $returnValue = $value.value

    if ((isValid($returnValue)) -eq $fasle)
    {
        p -message "Empty environment output for variable:$name. Returning default value"
        return $defaultValue
    }
    return $returnValue
}

function EnvUtils.getEnvVariable($name)
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
function TimeUtils.convertToISOTime($datetime)
 {
     $iso = $datetime.ToString("yyyy-MM-ddTHH:mm:ss")
     return $iso
}

function TimeUtils.convertToISOTime2($datetime)
 {
     if (isnull $datetime)
     {
         throw "Date time cannot null: from convertToISOTime2"
     }
     $iso = $datetime.ToString("yyyy-MM-dd HH:mm:ss")
     return $iso
}

function TimeUtils.getDateForISOString($isoDateString)
{
    return [DateTime]::ParseExact($isoDateString, "yyyy-MM-dd HH:mm:ss",$null)
}

function TimeUtils.testISODate()
{
    hp -message "Testing iso date"
    $ds = "2020-01-30 00:54:09"
    [DateTime]$date = getDateForISOString -isoDateString $ds
    printSimpleTypeInfo($date)
    p -message "The minute: $($date.Minute)"

    p -message "Converting to string: $(convertToISOTime -datetime $date)"

    getMinutePortion1 -time $ds
}

function TimeUtils.getMinutePortion($isoDateString)
{
    [DateTime]$date = getDateForISOString -isoDateString $isoDateString
    return $date.Miniute
}
function TimeUtils.getMinutePortion1($time)
{
    $pair = $time -split " "
    $time = $pair[1]
    #p -message $time
    $hms = $time -split ":"
    [int]$min = $hms[1]
    #p -message $min
    return $min
}

class ErrorArray {
    [String []]$errorArray = @()

    [void]addError($message)
    {
        $this.errorArray += ("Error:" + $message)
    }

    [void]addVREEnvError($envKey)
    {
        $this.errorArray += ("Error: VRE_" + $envKey)
    }

    [void]addDBEnvError($envKey)
    {
        $this.errorArray += ("Error:VRE_DB_" + $envKey)
    }
    [bool] areThereErros()
    {
        if ($this.errorArray.Count -eq 0)
        {
            return $false
        }
        else {
            return $true
        }
    }

    [void] printErrorArray()
    {
        foreach($error in $this.errorArray)
        {
            p -message $error
        }
    }
}

function ErrorUtils.getANewErrorArray
{
    return [ErrorArray]::new()
}

function ErrorUtils.testErrorArray() 
{
    [ErrorArray]$errorArray = getANewErrorArray
    $errorArray.addError("first one")
    $errorArray.addError("second one")
    if ($errorArray.areThereErros() -eq $true)
    {
        $errorArray.printErrorArray()
    }
}

function ScriptUtils.getScriptDir()
{
    $script_path    =  $myinvocation.PSCommandPath
    $script_folder  = split-path $script_path -parent
    $script_name    = split-path $script_path -leaf    
    return $script_folder
}

function TypeUtils.testSimpleTypeInfo()
{
    $s = "hello"
    printSimpleTypeInfo -inputObject $s
}

<#
#*************************************************
# FileUtils section
#*************************************************
#>
function FileUtils.countFiles($fileList)
{
    if ($fileList -eq $null)
    {
        return 0
    }
    $fullname = getTypeFullname -inputObject $fileList
    if ($fullname -eq 'System.Object[]')
    {
        [System.Object[]]$a = $fileList
        return $a.Count
    }
    if ($fullname -eq "System.IO.FileInfo")
    {
        return 1
    }
    return $null
}

function FileUtils.fExists($testpath)
{
    $ret = Test-Path -PathType Leaf -Path $testpath
    return $ret
}

function FileUtils.dExists($testpath)
{
    $ret = Test-Path -PathType Container -Path $testpath
    return $ret
}



function FileUtils.moveFile($fullFilename, $toDir)
{
    if ((fExists -testpath $fullFilename) -eq $false)
    {
        throw "File doesn't exist to move: $fullFilename"
    }
    if ((dExists -testpath $toDir) -eq $false)
    {
        throw "Directory to move the file to doesn't exist to move: $toDir"
    }
    return Move-Item -path $fullFilename -Destination $toDir -Force
}
function FileUtils.changeDirectory($toDir)
{
    Set-Location -Path $toDir
}

# ***********************************************
# Returns full path if the file exists, otherwise returns $null
# ***********************************************
function FileUtils.resolveIfExists($FileName) 
{
    $resolved = Resolve-Path -Path $FileName -ErrorAction SilentlyContinue
    if ($resolved) {
        return $resolved.ProviderPath
    } else {
        return $null
    }
}

# Examples:
# FileUtils.resolveIfExists "data.txt"                # -> C:\Path\To\data.txt
# FileUtils.resolveIfExists ".\logs\latest.log"       # -> C:\Path\To\logs\latest.log
# FileUtils.resolveIfExists "..\shared\config.json"   # -> C:\Path\shared\config.json
# FileUtils.resolveIfExists "ghost.txt"               # -> $null
# FileUtils.resolveIfExists "C:\Temp\missing.log"     # -> $null
# FileUtils.resolveIfExists "C:\Users\Me\readme.md"   # -> C:\Users\Me\readme.md

function FileUtils.pickFileFromCWD($Filter = "*")
{
    # Get filtered files in the current directory
    $files = Get-ChildItem -File -Filter $Filter

    if (-not $files)
    {
        Write-Host "No files found matching filter '$Filter' in the current directory."
        return $null
    }

    # Display numbered list
    for ($i = 0; $i -lt $files.Count; $i++)
    {
        Write-Host "[$i] $($files[$i].Name)"
    }

    # Add exit option
    $exitIndex = $files.Count
    Write-Host "[$exitIndex] Exit without selecting"

    # Prompt for selection
    $selection = Read-Host "Enter the number of the file to select"

    # Validate input: only digits allowed (non-negative integer)
    if ($selection -notmatch '^\d+$')
    {
        Write-Host "Invalid selection."
        return $null
    }

    $index = [int]$selection

    if ($index -ge 0 -and $index -lt $files.Count)
    {
        return $files[$index].FullName
    }

    if ($index -eq $exitIndex)
    {
        Write-Host "No file selected."
        return $null
    }

    Write-Host "Invalid selection."
    return $null
}

<#
#*************************************************
# End FileUtils section
#*************************************************
#>

function TimeUtils.testGetDate()
{
    $a = Get-Date -Format s
    printSimpleTypeInfo -inputObject $a
    p -message "Date: $a"

}

<#
#*************************************************
# StringUtils section
#*************************************************
#>

function StringUtils.escapeSingleQuotes($s)
{
    [String]$ns = $s
    return $ns.Replace("'", "''")
}

function StringUtils.testEscapeSingleQuotes()
{
    $a = escapeSingleQuotes -s "hello'single"
    p -message $a

    $a = escapeSingleQuotes -s "hello'''single"
    p -message $a

}

<#
#*************************************************
# End StringUtils section
#*************************************************
#>

function testPsutils()
{
    #testSimpleTypeInfo
    p -message "psutils has been called and utils initialized."

    #testISODate
    #testCSVLine
    #testLogfilename
    #testMoveFile
    #testReqex
    #testErrorArray
    #testExtractDatetimeStringFromForecastFilename
    #testGetDate
    #testEscapeSingleQuotes
    #testIsValid
}

# **********************************************
# Initialization
# **********************************************
function initPSUtils()
{
    p -message "Initializing PSUtils successfully, one time only"
}

# **********************************************
# Drivers
# **********************************************

initPSUtils

#**********************************************
# Do not delete this
# **********************************************
#Do not delete the following line
$psutilsIncluded = $true

# **********************************************
# End block: Do not delete this
# **********************************************
