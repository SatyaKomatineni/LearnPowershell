<#
#*************************************************
A class to handle file selection dialogs.
to be used from .ps1 files.
Needs to be commend line.

Base absract class:

inputs: 
- prompt: string to display on the command line
- (optional) currentSelection: string to display the current selection
- (opt) instructions: string to display more about the prompt
- (opt) default: default value to use if the user does not provide a value
- (opt) type: type of file to select (file, folder, etc.)
- (opt) filter: filter to use for the file selection dialog (e.g. *.txt, *.csv, etc.)

methods:
- preSelection(): concrete method
- postSelection(): concrete method
- abstract method select() returns the selected file or folder path
- run: the drieve method that calls the preSelection, select, and postSelection methods in order and reurns the selected file or folder path.

#*************************************************
#>

# **************************************************
# Fundamental includes
# **************************************************
. "$env:MY_PS_LIB\getlibs.ps1"
. (getlib "psutils.ps1")


# **************************************************
# Begin code
# **************************************************
class FileSelector {
    [string] $Prompt
    [string] $CurrentSelection
    [string] $Instructions
    [string] $Default
    [string] $Type
    [string] $Filter
    [string] $selectedFilePath = ""

    FileSelector([string] $Prompt, [string] $CurrentSelection = "", [string] $Instructions = "", [string] $Default = "", [string] $Type = "file", [string] $Filter = "*.*") {
        $this.Prompt = $Prompt
        $this.CurrentSelection = $CurrentSelection
        $this.Instructions = $Instructions
        $this.Default = $Default
        $this.Type = $Type
        $this.Filter = $Filter
    }

    [string] _preSelection() 
    {
        $filename = $this.CurrentSelection
        # validate the current selection
        if (vutils.isNotValid($this.CurrentSelection))
        {
            pd("Current seclecton is not a valid string.")
            return $null
        }
        # valid string. See if it is a valid file and exists
        if (FileUtils.fExists($filename))
        {
            pd("File exists: $filename. likely a full path name Returning it.")
            return $filename
        }
        #valid string but not a file as is. 
        $fullpath = FileUtils.resolveIfExists($filename)
        if (isNotNull($fullpath)) {
            pd("Fullpath is: $fullpath. Accepting it.")
            return $fullpath
        }
        #Not able to resolve the current selection to any valid file
        pw("Current selection $filename is not a valid file or path. Please select a file.")
        return $null
    }

    [void] postSelection() {
        Write-Host "File selected: $($this.selectedFilePath)"
    }

    [string] select() {
        throw [System.NotImplementedException] "The select method must be implemented in a derived class."
    }

    [string] run() 
    {
        # Get the filename based on current selection
        $fullFilename = $this.preSelection()

        # if valid register it as selection and return it
        if ($fullFilename -ne $null) 
        {
            $this.selectedFilePath = $fullFilename
            return $this.selectedFilePath
        }
        # Need to prompt the user for a file selection using the abstract select method
        $selection = $this.select()
        $this.selectedFilePath = $selection
       
        $this.postSelection()
        return $selection
    }
}

# Create a derived class for file selection
class CWDFilePicker : FileSelector 
{
    CWDFilePicker(
        [string] $Prompt, 
        [string] $CurrentSelection = "", 
        [string] $Instructions = "", 
        [string] $Default = "", 
        [string] $Type = "file", 
        [string] $Filter = "*.*"
        ) : base($Prompt, $CurrentSelection, $Instructions, $Default, $Type, $Filter) 
    {
    }

    [string] select() 
    {
        FileUtils.pickFileFromCWD()
    }
}
    
