<!-- ********************* -->
# 🧾 PowerShell String Cheat Sheet
<!-- ********************* -->

### 🔹 Common Operators
| Operator    | Purpose                        | Example                            |
|-------------|--------------------------------|------------------------------------|
| `-eq`       | Equal                          | `"abc" -eq "abc"`                 |
| `-ne`       | Not equal                      | `"abc" -ne "def"`                 |
| `-like`     | Wildcard match                 | `"log.txt" -like "*.txt"`         |
| `-match`    | Regex match                    | `"abc123" -match "\d+"`          |
| `-replace`  | Regex replace                  | `"file1" -replace "\d", "X"`     |
| `-split`    | Split string                   | `"a,b" -split ","`                |

---

### 🔹 Useful String Methods
| Method             | Result                            |
|--------------------|------------------------------------|
| `.Trim()`          | Removes whitespace                |
| `.ToUpper()`       | Converts to uppercase             |
| `.ToLower()`       | Converts to lowercase             |
| `.Contains()`      | Checks if substring exists        |
| `.Replace()`       | Replaces substrings               |
| `.Split(',')`      | Splits string into array          |
| `.StartsWith()`    | Checks prefix                     |
| `.EndsWith()`      | Checks suffix                     |

---

### 🔹 Static Methods
| Method | Example |
|--------|---------|
| `[string]::IsNullOrEmpty($str)` | Check if string is null/empty |
| `[string]::IsNullOrWhiteSpace($str)` | Check if null/whitespace only |
| `[string]::Join(",", @("a", "b"))` | Join array into string |
| `[string]::Format("Hello, {0}", "World")` | Format string |

---

### 🔹 Formatting Strings
```powershell
"{0} is {1}" -f "PowerShell", "awesome"
# => PowerShell is awesome

"{0,10}" -f "right"     # Right-align
"{0,-10}" -f "left"     # Left-align
"{0:C}" -f 19.99        # $19.99 (currency)
"{0:N2}" -f 1234.56     # 1,234.56
```

---

### 🔹 Interpolation
```powershell
$name = "Sathya"
"Hello, $name!"            # => Hello, Sathya
"$($name.ToUpper())"       # => SATHYA
```

---

### 🔹 Escaping
```powershell
"Quote: `"text`""
'Showing `$dollar and `"quote`" characters'
```

---

### 🔹 Raw String (PowerShell 7+)
```powershell
@'
This is a raw string.
No escapes. $verbatim.
'@
```

---

### 🔹 Helpful Checks
```powershell
[string]::IsNullOrEmpty($str)
[string]::IsNullOrWhiteSpace($str)
```

This cheat sheet condenses common string operations, formatting tricks, and method references for quick use in scripts and pipelines.

### Reference
[Working with strings, an elaborate sister article](https://tbd)