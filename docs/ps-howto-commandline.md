# PowerShell Command Line

PowerShell is a powerful command-line shell and scripting language that is designed for system administration and automation. It provides a rich set of commands and features that can be used to manage and manipulate various aspects of the Windows operating system.

## Getting Started

To start using PowerShell, follow these steps:

1. Open the **PowerShell** application.
2. The PowerShell prompt will appear as `PS C:\>`, indicating that you are now in the PowerShell command line environment.

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