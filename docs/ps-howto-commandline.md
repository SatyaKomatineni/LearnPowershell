# PowerShell Command Line

    Author: Satya Komatineni
    Version: 2.0
    Last updated: 6/15/24
    Started: 6/15/24
    Goal: Use command line powershell on windows computers

# Introduction
With MS Windows PowerShell (often just called "PS" ) you can do the following

### As a shell
    1. Use as a shell for windows locall
    2. Or as a shell in cloud environments like Azure

### As a fully object oriented scripting language you can use it for things like

    1. Local automation
    2. Azure automation
    3. Automate and Control on premise deployments
    4. Or even write fairly complex ETL code 
    5. Use it for simple data science

### Challenges to overcome

One drawback with PS is, it will take some getting used to both of the following

1. as a shell
2. and scripting language

### This article's goal
This article will explore how to use PS as a command shell.

Yes, you will need this. For me as well when I had to revisit.

Among other things you will learn

    1. List objects like files (similar to a database query)
    2. Select column of your interest from the output
    3. Apply where clause to eliminate some rows
    4. A list of very useful commands (like dir, cp, mv, ls, etc.)
    5. Note, most windows OS is exposed as a set of commands and ripe for automation

# What are some essential elements of PS
The following are the essential elements of PS. Good to point out what these are.

### Comands

1. Like all shells it has a collection of commands
2. It has an excellent built in help system, a bit like "man" in unix. It backs it up with a website as well
3. Online help is integrated with the command line help system nicely
4. A command has options
5. Options can be discovered by using get-help <command-name>
6. get-commannd "command" lists all commands installed (via modules) and available
7. get-command "wild-cards" can identify commands listed so

### Modules

1. The commands are packaged as modules
2. The modules can be browsed, installed, removed etc
3. Therer are both MS and Non-MS modules
4. [There is a central repository (or gallery) where these modules are kept for downloads](https://www.powershellgallery.com/)

### Objects (as relational tables)

1. This is where PS really shines
2. All commands and functions take objects as input values and return values
3. These objects can be examined for their attributes and methods (using: get-member)
4. Supports SQL like commands to slice and dice a collection of these objects

<!-- ********************************************* -->
# Getting Started
<!-- ********************************************* -->
To start using PowerShell, few of the ways are below.

### From UI

1. Open the **PowerShell** application.
2. The PowerShell prompt will appear as `PS C:\>` , indicating that you are now in the PowerShell command line environment.

### From DOS command prompt
1. Type `powershell`
2. To exit back to the command prompt type `exit`
3. Or open in a separate session `start powershell`
    

### Getting version number
<!-- ********************************************* -->

Once you run the powershell usign those methods, you want to know what version you are running.

One would think there is a command like `get-version`. No!

Instead the version is maintained as an evironment variable in the current session of the shell.

These environment variables can be simple values or objects.

To know what variables are availalbe in the environment use

```powershell
Get-Variable
```

This will print all the variables in the environment.

One of them is `PSVersionTable`

You can print any variable using the `$` value dereference operator like so

```powershell
$PSVersionTable
```

This will print

```
Name                           Value
----                           -----
PSVersion                      5.1.22621.3672
PSEdition                      Desktop
PSCompatibleVersions           {1.0, 2.0, 3.0, 4.0...}
BuildVersion                   10.0.22621.3672
CLRVersion                     4.0.30319.42000
WSManStackVersion              3.0
PSRemotingProtocolVersion      2.3
SerializationVersion           1.1.0.1
```

Current version of Powershell as of 2024 is version 7.

### How to install the latest version
<!-- ********************************************* -->

Looks like the modern version that is at 7 is compatible with 

1. windows
2. unix/linux
3. Mac

Best thing to do is to 

1. [Visit the home page and follow the  instruction links](https://learn.microsoft.com/en-us/powershell/)
2. [For now the 7.x release instructions are here](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-7.4)
3. Note: These URLs have a tendency to drift

A bit of caution though: I haven't installed myself. Do not know the compatibility on home and non-server editions. I have no reason to doubt it won't work, still read up first and choose.

<!-- ********************* -->
# Few early useful meta commands
<!-- ********************* -->

```powershell
exit # exits the powershell
powershell # starts powershell from a dos prompt in the same session
start powershell # in a new shell
cls, clear # clears the session window
ctrl-c # To stop a running process

#Power of tab, cycle through options on command line
Get- (then press) tab #you can cycle through command starting with get
get-command - (press tab) #shows options for get-command

get-computerinfo #info about your computer

get-command # lists all commands from all modules
get-command *co* # lists all commands using a wild card selection

get-alias # listts all aliases for commonly used commands
get-alias *ca* # lists all aliases using wild cards

# get-help common ones
get-help clear-host #lists documentation for clear
get-help clear -examples # with examples on commandline
get-help clear -online # kicks of a web browser (recommended)

# get-help interesting ones
get-help abc # lists all comamnds that has "abc" in them, or in their docs
get-help *abc* # same as abc
get-help about #lists all conceptual articles on powershell (like a language reference)
dir -? # same as get-help dir

get-module # list all (or wildcarded) (imported) modules
get-module -ListAvailable # show all installed modules (in addition to imported)
get-help import-module -online # To import modules from the installed set

find-module # list all (or wildcarded) modules in exernal gallery sources
#This may take a minute
#wild cards are necessary if that is intended

get-help install-module -online
#will take you to the online description of install-module
#Once the module is installed, you 
```

<!-- ********************************************* -->
# Exploring dir command
<!-- ********************************************* -->
Lets jump into some commands.

```powershell
# look for files
dir 
dir *.ps
dir *.*

# equivalent to dir /s *.ppt
dir -Recurse *.ppt

#Shows the attributes of a directory object
dir abc-directory | get-member

#Shows the attributes of a file object
dir some-existing-file | get-member

# Print only the attributes you want
dir some-files | select - property fullname

```

### Discover all the options for "dir"
<!-- ********************************************* -->
```powershell
get-help dir
```

This command will list

1. Options for dir
2. Any aliases it may have
3. online references
4. Examples

### On updating help for modules
<!-- ********************************************* -->

1. You may have to run `update-help` command to download all help files
2. You have to run this command as "admin" by running the ps in admin mode when you start it
3. I still see some errors

### Discovering the output fields available from the output of dir
<!-- ********************************************* -->

The `dir` command produces a set of files as its output.

The default output only shows a limited set of fields.

```
Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----          3/7/2024  11:49 AM                ai
d-----          3/2/2024  11:52 AM                data
d-----          3/2/2024  11:56 AM                teluugu-poetry-100-poems
-a----         8/17/2023  11:15 AM          17690 ai-in-health-care-a-future.docx
-a----         8/17/2023  11:19 AM          21044 apis-or-data-an-integration-question.docx
-a----          3/4/2024   5:11 PM          51270 classes-in-python-a-beginers-guide.docx
-a----         11/8/2023   8:32 AM          23842 enterprise-architect-find-meaning.docx
-a----        10/25/2023  11:56 AM          20458 etl-spark-generally-speaking.docx
-a----         2/10/2024   2:28 PM          58421 general-tech-figures.pptx
-a----        10/13/2023   4:19 PM          50676 guide-to-analysts.docx
-a----         8/19/2023   5:57 PM          22908 Language Critique.docx
-a----         8/27/2023  11:35 AM          26661 on-closures.docx
-a----        11/12/2023   6:41 PM         127558 transactional-reporting-options.docx
```

Each column above is an attribute of the File object, that is outputted by the `dir` command.

You can find other attributes available by doing this

```powershell
dir on-closures.docx | get-member 

#That will print 3 things about an attribute
name
member type #wheter it is a method, or an attribute
Definition (what class it belongs to)
```

### Using Select to choose columns (attributes of an object) of your interesst

To print just the names of the attributes you can do this

```powershell
dir on-closures.docx | get-member | select name
```

This can be explained as follows

1. the `dir` command gave out 1 object of type File
2. That object of type File is fed to `get-member` which produces a list of attributes
3. Each attribute in turn is an object of type "System.IO.FileInfo" with 3 fields as stated above
4. These objects are then filtered with `select command` which takes a series field names
5. In this case we are interested in just printing out the "name" of the attribute

This command willl produce the attribute names of a "System.IO.File" object:

```
Name
----
LinkType
Mode
Target
AppendText
CopyTo
Create
CreateObjRef
CreateText
Decrypt
Delete
Encrypt
Equals
GetAccessControl
GetHashCode
GetLifetimeService
GetObjectData
GetType
InitializeLifetimeService
MoveTo
Open
OpenRead
OpenText
OpenWrite
Refresh
Replace
SetAccessControl
ToString
PSChildName
PSDrive
PSIsContainer
PSParentPath
PSPath
PSProvider
Attributes
CreationTime
CreationTimeUtc
Directory
DirectoryName
Exists
Extension
FullName
IsReadOnly
LastAccessTime
LastAccessTimeUtc
LastWriteTime
LastWriteTimeUtc
Length
Name
BaseName
VersionInfo
```

### Using where clause to eliminate some rows


Say now you want to know how many attributes are there on a file name that are called "name"?

You can attach a where clause to the select

```powershell
dir .\on-closures.docx | get-member | select name | ? {$_.name -like "*name"}
```

This will produce a subset of the attributes from above

```
Name
----
PSChildName
DirectoryName
FullName
Name
BaseName
```
### How to alter the output fields of dir

Now we are in a position to choose a different set of columns to be displayed by `dir` command

```powershell
dir | select -property fullname
```

This will chose a column whose name is `fullname`

This will produce output like this

```
FullName
--------
C:\satya\data\code\articles-repo\ai
C:\satya\data\code\articles-repo\data
C:\satya\data\code\articles-repo\teluugu-poetry-100-poems
C:\satya\data\code\articles-repo\ai-in-health-care-a-future.docx
C:\satya\data\code\articles-repo\apis-or-data-an-integration-question.docx
C:\satya\data\code\articles-repo\classes-in-python-a-beginers-guide.docx
C:\satya\data\code\articles-repo\enterprise-architect-find-meaning.docx
C:\satya\data\code\articles-repo\etl-spark-generally-speaking.docx
C:\satya\data\code\articles-repo\general-tech-figures.pptx
C:\satya\data\code\articles-repo\guide-to-analysts.docx
C:\satya\data\code\articles-repo\Language Critique.docx
C:\satya\data\code\articles-repo\on-closures.docx
C:\satya\data\code\articles-repo\transactional-reporting-options.docx
```

<!-- ********************* -->
# Exploring cat
<!-- ********************* -->

The command `cat` is an alias for `get-content` commmandlet.

```powershell
cat a.txt #display the contents
cat a.txt -TotalCount 5 # show top 5 lines
cat a.txt -Tail 5 # show the last 5 lines

cat a.txt -Raw #Return as a stream

cat a.txt -Encoding Byte -Raw # as a byte stream

get-help cat -online #Readup docs online as it has a number of other nuances
```


<!-- ********************************************* -->
## Very Useful Commands
<!-- ********************************************* -->
get-help
get-command
get-member
get-module
update-help: Updates the help files beyond simple help.

## Basic Commands

Here are some basic commands that you can use in PowerShell:

- `Get-Process`: Retrieves a list of running processes.
- `Get-Service`: Retrieves a list of services running on the system.
- `Get-Help`: Displays help information for a specific command.
- `Set-Location`: Changes the current working directory.
- `Get-ChildItem`: Lists the files and folders in the current directory.

## Command Syntax

PowerShell commands follow a consistent syntax:

- Command: The name of the command you want to execute.
- Parameters: Additional information or options that modify the behavior of the command.
- Arguments: Input values or objects that the command operates on.

For example, let's consider the `Get-Process` command:
Get-Process -Name "chrome"

## Aliases to various commands

1. PS commands are long with elaborate names
2. A way to shorten them
3. Also provide a semblance of compatibility to DOS and even Unix

### How to discover aliases

```ps
get-alias 

```

## Some sample aliases for unix commands

- `ls`: Alias for `Get-ChildItem`.
- `cd`: Alias for `Set-Location`.
- `rm`: Alias for `Remove-Item`.
- `cp`: Alias for `Copy-Item`.
- `mv`: Alias for `Move-Item`.
- `mkdir`: Alias for `New-Item -ItemType Directory`.
- `touch`: Alias for `New-Item -ItemType File`.
- `cat`: Alias for `Get-Content`.
- `grep`: Alias for `Select-String`.
- `chmod`: Alias for `Set-ItemProperty -Path`.
- `chown`: Alias for `Set-ItemOwner`.
- `pwd`: Alias for `Get-Location`.

## Some sample aliases for DOS commands

- `dir`: Alias for `Get-ChildItem`.
- `cd`: Alias for `Set-Location`.
- `del`: Alias for `Remove-Item`.
- `copy`: Alias for `Copy-Item`.
- `move`: Alias for `Move-Item`.
- `ren`: Alias for `Rename-Item`.
- `cls`: Alias for `Clear-Host`.

<!-- ********************* -->
# References
<!-- ********************* -->

1. [Home page](https://learn.microsoft.com/en-us/powershell/)
    1. Overview
    2. Installation
    3. Gallery references
    4. And many more resources. An entry point from MS.
2. [Installation](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-7.4)
    1. Install on windows, unix, mac etc.
    2. Alternate install methods
3. [Language documentation](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about?view=powershell-7.4)
    1. I could not find such a thing as language refereence for PS
    2. Closest thing I can find that can explain variables, functions etc is here
    3. Note: This link may change over time
    4. This is filed under Microsoft.Powershell.core, about
4. [An example language reference: about variables](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_variables)
    1. This is a language reference for variables where PowerShell variables are explained
    2. [Similarly functions and their syntax are explained here](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions)
5. [Core commandlets reference](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core)
    1. Some example commandlets are below
    2. get-command
    3. get-help
    4. get-module
    5. get-history

