<#
 #*******************************************************
 # List and change directories on a command line
 # Also execute commands via functions
 #
 # version 2 (vscode variant)
 # ***************
 # This file: /learn-power-shell/chdirs2-vscode.ps1
 # based on: /learn-power-shell/chdirs2.ps1
 #
 # 4/5/25
 # Added few additional source directories
 # no functionality changes.
 #
 # previous ver 2
 # **********************
 # added functions as options as well
 #
 # Version 1
 # ********************
 # Only change directory
 #
 #*******************************************************
 #>

 #
 #*******************************************************
 # Configuration
 #*******************************************************
 #

 #
 # This is a better way to initialize
 # as this allows calling functions inside the initialization
 #
 # without this approach, the functions must be defined
 # prior to the initialization. 
 # That forces all dependent functions to be before as well
 #
 $script:dirDictionary = $null
 function init()
 {
    $script:dirDictionary = [ordered]@{
        mcp="c:\satya\data\code\mcp-repo"
        crew="c:\satya\data\code\indent-agentic-repo"
        home = 'c:\satya\data\code'
        pslearn = 'C:\satya\data\code\LearnPowershellRepo'
        vsworkspaces = "C:\satya\data\code\vs-workspaces"
        aiux = "C:\satya\data\code\assistant-ui-testrepo"
        mcpservers = "C:\satya\data\code\mcp-servers-testrepo"
        test_func=createTestFunc
        vscode=createVSCodeCommand
    }
}


#*******************************************************
# Config Functions
#*******************************************************
function createVSCodeCommand
 {
     [LCommand]$cmd = createNewCommand -name "vscode"  -functionName "invokeVSCode"
     $cmd.desc = "Invoke VSCode on the main workspace"
     return $cmd
 }

 function invokeVSCode()
 {
     $vscodeWS = "C:\satya\data\code\vs-workspaces\agentic.code-workspace"
     code $vscodeWS
 }
 
 function createTestFunc
 {
     $cmd = createNewCommand -name "Test Func"  -functionName "invokeTestFunc"
     return $cmd
 }
 function invokeTestFunc()
 {
     p -message "Invoking test func"
 }

#*******************************************************
# Config Functions
#*******************************************************

class LCommand
 {
     [String]$name
     [String]$functionName
     [String]$desc
     
     [string]ToString(){
        return ("{0}:{1}" -f `
            $this.name, $this.desc)
     }
}
 function createNewCommand($name, $functionName)
 {
    $cmd = [LCommand]::new()
    $cmd.name = $name
    $cmd.functionName = $functionName
    $cmd.desc = "No desc provided"
    return $cmd
 }



 function testCommandFunction()
 {
     p -message "Hello there"
 }

 function testCommand()
 {
     $cmd = createNewCommand -name "test func" -functionName "testCommandFunction"
     p -message $cmd.function
     Invoke-Expression $cmd.functionName
     $cmdS =""
     printSimpleTypeInfo -inputObject $cmd
     printSimpleTypeInfo -inputObject $cmdS

 }
 function execCommand($lcommand)
 {
     p -message "invoking $($lcommand.functionName)"
     Invoke-Expression $lcommand.functionName
 }

 #
 # **********************************************
 # Few Utility functions
 # **********************************************
 function p($message)
{
    Write-Host $message
}
function hp($message)
{
    Write-Host ""
    Write-Host $message
    Write-Host "***************************************"
}
function readHostWithDefault($prompt, $default)
 {
     $ans = Read-Host $prompt
     if ((isValid -somestring $ans) -eq $true)
     {
         return $ans
     }
     return $default
 }

 function getTypeName($inputObject)
 {
    $typeObject = $inputObject.GetType()
    $typename = $typeObject.FullName
    $typeShortName = $typeObject.name
    return $typeShortName
 }
 
 function printSimpleTypeInfo($inputObject)
 {
    if ($inputObject -eq $null)
    {
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

 function isValid($somestring)
{
    if ($somestring -eq $null)
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


  #Get an element from an ordered dictionary
 function getADirectory ($seq) {
#    [System.Collections.Hashtable]$d = $dirDictionary;
    $d = $dirDictionary;
    [System.Collections.ICollection]$list = $d.Keys
    [string[]]$keyList = @($list.GetEnumerator())
    $dirKey = $keyList.Get($seq)
    return $d.Item($dirKey)
}

 function chdir2
 {
     #Prompt all the directories in the list
    hp -message "Here are the list of directories"
    $seq = 1
    foreach ($item in $dirDictionary.Keys) {
        $value = $dirDictionary.Item($item)
        p -message "$seq. $item : $($value.ToString())"
        $seq++
    }
    
    #Pick one of the directories
    hp -message "Pick one of the directories"
    $pickOne = readHostWithDefault -prompt "Pick a directory or a Command:" -default "n"
    if ($pickOne -eq "n")
    {
        Write-Host "No directory picked. Returning"
        return
    }

    #Identify the name of the directory
    $pickedDir = getADirectory($pickOne - 1)
    if ((getTypeName -inputObject $pickedDir) -eq "LCommand")
    {
        p -message "It is a command"
        execCommand -lcommand $pickedDir
        return
    }

    hp -message "Confirm the change of directory"
    Write-Host "Going to change curworking directory to: $pickedDir" 

    #Change the directory in the powershell
    Set-Location -Path $pickedDir
    p -message ""
 }
 
 function test()
 {
    #testCommand
    #invokeVSCode
    $cmd = createVSCodeCommand
    p -message "function: $($cmd.functionName)"
    #execCommand -lcommand $cmd
 }
# Run the show 
init
chdir2
#test 