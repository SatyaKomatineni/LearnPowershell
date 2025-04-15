<!-- ********************* -->
# PowerShell Help Comments and Programming Documentation (v2)
<!-- ********************* -->

This document explains how to use PowerShell comment-based help blocks effectively, including documenting help sections, multi-line usage, handling multiple parameters, documenting programming logic, and best practices.

<!-- ********************* -->
# 1. What is a Help Comment Block in PowerShell?
<!-- ********************* -->

A help comment block is a special multi-line comment placed at the top of a PowerShell script or function that describes its usage and parameters.

```powershell
<#
.SYNOPSIS
    Brief summary.
.DESCRIPTION
    Longer explanation.
.PARAMETER paramName
    Explanation for the parameter.
.EXAMPLE
    Example usage.
.NOTES
    Additional notes.
#>
```

Run `Get-Help` to display this information.

<!-- ********************* -->
# 2. Available Help Tags (Dot Commands)
<!-- ********************* -->

| Tag             | Purpose                                              |
|-----------------|------------------------------------------------------|
| .SYNOPSIS        | One-line summary of the script/function              |
| .DESCRIPTION     | Detailed explanation of functionality                |
| .PARAMETER       | Describe each input parameter (repeatable)           |
| .EXAMPLE         | Provide usage examples (repeatable)                  |
| .INPUTS          | Expected input types                                 |
| .OUTPUTS         | Types of output returned                             |
| .NOTES           | Author, file info, extra details                     |
| .LINK            | Provide related links                                |
| .COMPONENT       | Categorize the component (optional)                  |
| .ROLE            | Describe the script's role (optional)                |
| .FUNCTIONALITY   | Categorize functionality (optional)                  |

<!-- ********************* -->
# 3. Writing Multi-line Content in Help Sections
<!-- ********************* -->

PowerShell help blocks handle multi-line content naturally. No escapes are needed:

```powershell
.DESCRIPTION
    This script performs:
    - Step 1: Load config
    - Step 2: Validate inputs
    - Step 3: Extract data
```

<!-- ********************* -->
# 4. Documenting Multiple Parameters
<!-- ********************* -->

Use one `.PARAMETER` per input:

```powershell
.PARAMETER ControlFile
    Path to control file.

.PARAMETER OutputDir
    Optional output folder.
```

<!-- ********************* -->
# 4A. Example Usage of .EXAMPLE Tag
<!-- ********************* -->

The `.EXAMPLE` tag documents how to run the script. Use multiple `.EXAMPLE` blocks for multiple examples:

```powershell
.EXAMPLE
    Example 1: Running with mandatory parameter

    PS> .\crew-extract.ps1 -ControlFile config.json

    Extracts data using config.json file.

.EXAMPLE
    Example 2: Running with optional output directory

    PS> .\crew-extract.ps1 -ControlFile config.json -OutputDir C:\Data\Extracts

    Extracts data using config.json and stores output in the specified directory.
```

Displayed using:
```powershell
Get-Help .\crew-extract.ps1 -Examples
```

<!-- ********************* -->
# 5. Documenting Programming Logic and Design Notes
<!-- ********************* -->

Use a separate block comment for internal notes:

```powershell
<#
PROGRAMMER NOTES:
-----------------
- Control Flow:
  * Validate Inputs
  * Extract Data
  * Log Output

- Design Decisions:
  * Config-driven
  * No hardcoded paths

TODO:
- Add retry logic
- Parameterize logging
#>
```

<!-- ********************* -->
# 6. Summary of . Commands in PowerShell Help
<!-- ********************* -->

| Tag | Purpose |
|-----|---------|
| .SYNOPSIS | One-line summary |
| .DESCRIPTION | Longer explanation |
| .PARAMETER | Document each parameter |
| .EXAMPLE | Usage examples (repeatable) |
| .INPUTS | Input types |
| .OUTPUTS | Output types |
| .NOTES | Extra notes, authorship |
| .LINK | URLs or related topics |
| .COMPONENT | Categorization (optional) |
| .ROLE | Script role (optional) |
| .FUNCTIONALITY | High-level category (optional) |

<!-- ********************* -->
# 7. Other Ways to Write Comments in PowerShell
<!-- ********************* -->

In addition to comment-based help blocks, PowerShell supports several types of comments that are useful for documentation and inline notes.

### 🔹 Single Line Comment
Use `#` at the start of the line:

```powershell
# This is a comment
$var = 5  # This is also a comment at the end of a line
```

### 🔹 Multi-line Block Comment
Use `<# ... #>` anywhere in the code for larger comments (not processed by Get-Help unless it's a help block at the top):

```powershell
<#
This is a general block comment.
It can span multiple lines.
Used for explanations or large notes.
#>
```

### 🔹 Commenting Out Code
Temporarily disable code:

```powershell
# $result = Do-Something -Param1 "value"
```

This is helpful during debugging.

### 🔹 Best Practices
- Use `#` for inline or short comments.
- Use `<# ... #>` for multi-line or architecture notes.
- Reserve comment-based help (`.<TAG>`) blocks only for help documentation.

<!-- ********************* -->
# 8. References
<!-- ********************* -->

1. [PowerShell Comment-Based Help - Microsoft Docs](https://learn.microsoft.com/en-us/powershell/scripting/developer/help/comment-based-help)  
   Complete guide to help block tags and usage.

2. [Get-Help Cmdlet - Microsoft Docs](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/get-help)  
   Shows how to display help content from scripts/functions.

3. [Best Practices for PowerShell Script Design](https://devblogs.microsoft.com/scripting/creating-effective-help-for-your-powershell-scripts-and-functions/)  
   PowerShell team blog with help documentation tips.

4. [PowerShell Parameters Documentation](https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-parameters)  
   Details on parameters and documentation techniques.

