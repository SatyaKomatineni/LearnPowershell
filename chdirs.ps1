<#
 #*******************************************************
 # List and change directories on a command line
 #*******************************************************
 #>

 #
 #*******************************************************
 # Configuration
 #*******************************************************
 #
 $dirDictionary = [ordered]@{ 
     psutils = "C:\satya\data\code\power-shell-scripts\individual\satya\git-util";
     home = "c:\satya";
     pslearn = "C:\satya\data\code\power-shell-scripts\individual\satya\learn";
 }
 #
 #*******************************************************
 # Utility function
 #*******************************************************
 #
 function readHostWithDefault($prompt, $default)
 {
     $ans = Read-Host $prompt
     if ($ans -ne $null)
     {
         return $ans
     }
     return $default
 }
 
 #Get an element from an ordered dictionary
 function getADirectory ($seq) {
    [System.Collections.Hashtable]$d = $dirDictionary;
    [System.Collections.ICollection]$list = $d.Keys
    [string[]]$keyList = @($list.GetEnumerator())
    $dirKey = $keyList.Get($seq)
    return $d.Item($dirKey)
}

 function chdir2
 {
     #Prompt all the directories in the list
    $seq = 1
    foreach ($item in $dirDictionary.Keys) {
        $value = $dirDictionary.Item($item)
        Write-Host "$seq. $item : $value"
        $seq++
    }
    
    #Pick one of the directories
    $pickOne = readHostWithDefault -prompt "Pick a directory:" -default "n"
    if ($pickOne -eq "n")
    {
        Write-Host "No directory picked. Returning"
        return
    }

    #Identify the name of the directory
    $pickedDir = getADirectory($pickOne - 1)
    Write-Host "Going to change curworking directory to: $pickedDir" 

    #see if you still want to change it
    # (line continuation used with a line ending char)
    $ans = readHostWithDefault -prompt "Should I change directory?: (y/n:n)" -default "n"

    if ($ans.ToLower() -ne "y")
    {
        #no changing directory
        Write-Host "Not changing directory. Returning"
        return
    }

    #Change the directory in the powershell
    Set-Location -Path $pickedDir
 }
 
# Run the show 
 chdir2
 