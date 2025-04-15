<!-- ********************* -->
# 🧾 PowerShell Comment Syntax Cheat Sheet
<!-- ********************* -->

Quick reference for using comments in PowerShell scripts.

<!-- ********************* -->
# 1. Single-Line Comments
<!-- ********************* -->

Use `#` to add a comment on its own line or at the end of code:
```powershell
# This is a full line comment
$val = 5  # This is an inline comment
```

<!-- ********************* -->
# 2. Multi-Line Block Comments
<!-- ********************* -->

Use `<# ... #>` to span comments across multiple lines:
```powershell
<#
This is a multi-line block comment.
Useful for explanations or disabling code blocks.
#>
```

<!-- ********************* -->
# 3. Help Comment Block (for `Get-Help`)
<!-- ********************* -->

Structured block comment at the top of scripts or functions:
```powershell
<#
.SYNOPSIS
    Brief summary.
.DESCRIPTION
    Detailed explanation.
.PARAMETER Name
    What the Name parameter does.
.EXAMPLE
    Example usage.
#>
```
Call with:
```powershell
Get-Help .\myscript.ps1 -Full
```

<!-- ********************* -->
# 4. Commenting Out Code
<!-- ********************* -->

Temporarily disable execution of code:
```powershell
# Remove-Item $path
```

<!-- ********************* -->
# 5. Best Practices
<!-- ********************* -->

- Use `#` for brief and inline notes.
- Use `<# ... #>` for architectural or long explanations.
- Use comment-based help blocks only for formal script documentation.
- Separate user-facing help from programmer notes when possible.

<!-- ********************* -->
# 6. Helpful Commands
<!-- ********************* -->

```powershell
Get-Help <script>.ps1 -Examples
Get-Help <function> -Full
```

<!-- ********************* -->
# 7. References
<!-- ********************* -->

1. [PowerShell Comment-Based Help - Microsoft Docs](https://learn.microsoft.com/en-us/powershell/scripting/developer/help/comment-based-help)  
   Official guide on comment-based help structure and usage.

2. [Get-Help Cmdlet - Microsoft Docs](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/get-help)  
   Documentation on retrieving help from PowerShell scripts and functions.

3. [PowerShell Scripting Language - Comments](https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-quoting)  
   Covers quoting rules, commenting styles, and more for PowerShell scripts.

