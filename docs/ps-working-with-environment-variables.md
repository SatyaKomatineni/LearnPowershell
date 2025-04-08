<!-- ********************* -->
# Understanding Providers and the Environment Provider in PowerShell
<!-- ********************* -->

PowerShell introduces the concept of "providers" as a way to access different data stores using a unified command-line syntax. This article explores what providers are, the types available, and provides an in-depth look at the `Env:` provider, which is commonly used to work with environment variables.

<!-- ********************* -->
# 1. What Are Providers in PowerShell?
<!-- ********************* -->

A PowerShell provider is a .NET-based interface that exposes a data store (such as the file system, registry, or environment variables) as a navigable structure — similar to how you would interact with folders and files.

Providers allow you to use familiar commands like `Get-ChildItem`, `Set-Item`, `Remove-Item`, and others to navigate and manipulate data across different types of stores.

You can think of providers as virtual drives mapped to data sources.

<!-- ********************* -->
# 2. List of Common PowerShell Providers
<!-- ********************* -->

You can see the list of available providers on your system by running:

```powershell
Get-PSProvider
```

Common providers include:

| Provider   | Description                          | Typical Prefix   |
| ---------- | ------------------------------------ | ---------------- |
| FileSystem | Access to files and folders          | `C:\`, `D:\`     |
| Env        | Environment variables                | `env:`           |
| Alias      | PowerShell command aliases           | `alias:`         |
| Function   | PowerShell functions                 | `function:`      |
| Variable   | PowerShell session variables         | `variable:`      |
| Registry   | Windows registry keys (Windows only) | `HKLM:`, `HKCU:` |

<!-- ********************* -->
# 3. How Each Provider Works
<!-- ********************* -->

### FileSystem
Represents the local or network file system. You can use:

```powershell
Get-ChildItem C:\Scripts    # alias: gci, dir, ls
dir C:\Scripts        # or you can use this instead
New-Item C:\Temp\log.txt -ItemType File   # no built-in alias 
Remove-Item C:\OldFiles\*   # alias: ri, del, erase, rm
del C:\OldFiles\*       # or you can use this instead
```

### Env
Exposes system and user-level environment variables as name/value pairs.

### Alias
Contains aliases for cmdlets. Example operations:

```powershell
Get-ChildItem alias:         # alias: gci, dir, ls
dir alias:        # or you can use this instead

# Defines a custom alias 'll' for Get-ChildItem
Set-Alias ll Get-ChildItem
Remove-Item alias:ll         # alias: ri, del, erase, rm
del alias:ll        # or you can use this instead
```

### Function
Stores all available PowerShell functions. Example:

```powershell
Get-ChildItem function:      # alias: gci, dir, ls
dir function:        # or you can use this instead

New-Item function:SayHi -Value { "Hello!" }   # no built-in alias (optional: Set-Alias ni New-Item)
& SayHi
```

### Variable
Provides access to PowerShell session variables:

```powershell
Get-ChildItem variable:      # alias: gci, dir, ls
dir variable:        # or you can use this instead

Set-Item variable:debugFlag -Value $true
$debugFlag
```

### Registry
Treats Windows Registry like a folder structure (Windows only):

```powershell
Get-ChildItem HKCU:\Software  # alias: gci, dir, ls
dir HKCU:\Software        # or you can use this instead
New-Item -Path HKCU:\Software\MyApp   # no built-in alias (optional: Set-Alias ni New-Item)
New-ItemProperty -Path HKCU:\Software\MyApp -Name "Setting" -Value "Enabled"
```

<!-- ********************* -->
# 4. The Environment Provider (`Env:`) in Depth
<!-- ********************* -->

The `Env:` provider maps system and user-level environment variables into PowerShell.

You can view it like a drive:

```powershell
Get-ChildItem env:           # alias: gci, dir, ls
dir env:        # or you can use this instead
```

### 🔹 Read a Specific Environment Variable

```powershell
$env:PATH
(Get-Item env:USERNAME).Value
```

### 🔹 Set an Environment Variable (for the current session)

```powershell
$env:MY_VAR = "hello world"
```

### 🔹 Remove an Environment Variable (for the current session)

```powershell
Remove-Item env:MY_VAR       # alias: ri, del, erase, rm
del env:MY_VAR        # or you can use this instead
```

### 🔹 Export Environment Variables to a File

```powershell
dir env: | Export-Csv env_vars.csv        # using alias for Get-ChildItem
```

### 🔹 Add to the PATH Variable Temporarily

```powershell
$env:PATH += ";C:\MyTools"
```

### 🔹 Split a PATH-like Variable into Individual Entries

```powershell
$env:PATH -split ';'
```

### 🔹 Filter Variables by Name

```powershell
dir env: | Where-Object { $_.Name -like '*TEMP*' }        # using alias for Get-ChildItem
```

### 🔹 Search Environment Variables by Value Content

```powershell
dir env: | Where-Object { $_.Value -like '*Python*' }        # using alias for Get-ChildItem
```

### 🔹 Create Environment Variable in a Script

```powershell
$env:SCRIPTVAR = "From Script"
Write-Output $env:SCRIPTVAR
```

### 🔹 Convert Env Variables to a Hashtable

```powershell
$envTable = @{}
dir env: | ForEach-Object { $envTable[$_.Name] = $_.Value }        # using alias for Get-ChildItem
```

These techniques help with diagnostics, scripting automation, path management, and customization of system-level behaviors.

<!-- ********************* -->
# 5. References
<!-- ********************* -->

1. [PowerShell Providers - Microsoft Docs](https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-providers)  
   Overview of providers and how they function in PowerShell.

2. [About Environment Variables - Microsoft Docs](https://learn.microsoft.com/en-us/powershell/scripting/developer/cmdlet/environment-variables-in-powershell)  
   Describes how to work with environment variables in PowerShell.

3. [Get-PSProvider - Microsoft Docs](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/get-psprovider)  
   Official command documentation for listing providers.

4. [Get-PSDrive - Microsoft Docs](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/get-psdrive)  
   Shows drives attached to providers, like `env:`, `alias:`, etc.

5. [Environment Variables in Windows - Microsoft Docs](https://learn.microsoft.com/en-us/windows/deployment/usmt/usmt-recognized-environment-variables)  
   System-level overview of environment variables on Windows.

6. [PowerShell String Operators - Microsoft Docs](https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-strings)  
   Covers `-split`, `-like`, and other string manipulation tools useful for working with env vars.

