<!-- ********************* -->
# Working with and Manipulating Strings in PowerShell: Operators and Functions
<!-- ********************* -->

Strings are among the most commonly manipulated data types in PowerShell, and the language offers a flexible set of tools to work with them. This guide introduces the concept of operators in PowerShell and explains how they can be used alongside built-in string functions for effective text processing.

<!-- ********************* -->
# 1. What Are Operators in PowerShell?
<!-- ********************* -->

Operators are special symbols or keywords that perform actions on one or more values (operands). In PowerShell, operators are used to compare, assign, match, split, and manipulate data.

For example:
```powershell
"apple" -eq "apple"  # Equality comparison
"one,two" -split "," # Splits a string into an array
```

Operators are concise and powerful, offering functionality that would otherwise require longer code or function calls.

<!-- ********************* -->
# 2. String Comparison Operators
<!-- ********************* -->

These operators compare string values and return Boolean results.

### Case-insensitive (default):
```powershell
"hello" -eq "HELLO"    # True
"abc" -ne "xyz"        # True
```

### Case-sensitive versions:
```powershell
"hello" -ceq "HELLO"    # False
"abc" -cne "ABC"        # True
```

Other comparisons:
```powershell
"abc" -lt "bcd"         # True
"z" -ge "a"             # True
```

<!-- ********************* -->
# 3. Pattern Matching and Regular Expressions
<!-- ********************* -->

### Wildcard Matching with `-like`, `-notlike`
```powershell
"report.txt" -like "*.txt"        # True
"error.log" -notlike "*.csv"      # True
```

### Regex Matching with `-match`, `-notmatch`
```powershell
"abc123" -match "\d+"             # True
"note" -notmatch "\d"             # True
```

The automatic variable `$matches` stores the matched parts when `-match` is used.

### Regex Replacement with `-replace`
```powershell
"file001.txt" -replace "\d+", "#"  # "file#.txt"
```

<!-- ********************* -->
# 4. Splitting Strings with `-split`
<!-- ********************* -->

PowerShell provides `-split` to divide strings based on a delimiter or regex pattern:
```powershell
"a,b,c" -split ","        # ["a", "b", "c"]
"a  b   c" -split "\s+"   # ["a", "b", "c"]
```

Limit the number of splits:
```powershell
"one,two,three" -split ",", 2  # ["one", "two,three"]
```

<!-- ********************* -->
# 5. Useful String Methods (Functions)
<!-- ********************* -->

PowerShell strings are .NET objects, so they support methods like:

```powershell
" Hello ".Trim()            # "Hello"
"text".ToUpper()            # "TEXT"
"TEXT".ToLower()            # "text"
"data".Contains("a")        # True
"hello.ps1".EndsWith(".ps1")# True
```

You can chain them too:
```powershell
"  script.ps1  ".Trim().ToLower()  # "script.ps1"
```

<!-- ********************* -->
# 6. Using String Operators in Filtering and Pipelines
<!-- ********************* -->

String operators are often used with `Where-Object` in pipelines:

```powershell
Get-ChildItem | Where-Object { $_.Name -like "*.log" }
Get-Content log.txt | Where-Object { $_ -match "ERROR" }
```

These expressions are useful in file filtering, log parsing, and pattern detection scenarios.

<!-- ********************* -->
# 7. Summary of Common String Operators
<!-- ********************* -->

| Operator      | Description                                |
|---------------|--------------------------------------------|
| `-eq`, `-ne`  | Equality and inequality comparisons         |
| `-lt`, `-gt`  | Lexicographic less/greater comparisons     |
| `-like`       | Wildcard pattern match                     |
| `-match`      | Regex pattern match                        |
| `-replace`    | Regex-based replacement                    |
| `-split`      | Splits strings into arrays                 |

You can also use methods like `.Trim()`, `.Split()`, `.Replace()` for additional manipulation options.

<!-- ********************* -->
# 8. Operators vs Functions in PowerShell
<!-- ********************* -->

While both operators and functions (or methods) can be used to manipulate strings in PowerShell, they differ in syntax and usage style.

### ✅ Operators
- Use symbolic or keyword-based syntax (e.g., `-eq`, `-split`, `-replace`).
- Often used **between values** (infix notation).
- Work outside the object — they take inputs and act on them.

**Example (Operator usage):**
```powershell
"PowerShell" -match "Shell"      # Returns True
"apple,banana" -split ","        # Returns ["apple", "banana"]
```

### ✅ Functions (Methods)
- Are called **on the string object itself** using dot notation.
- Tend to be more flexible and readable in object-oriented contexts.

**Example (Method usage):**
```powershell
" PowerShell ".Trim()             # Removes whitespace
"PowerShell".Contains("Shell")   # Returns True
```

### 🧠 Key Differences

| Feature         | Operators                        | Functions (Methods)           |
|-----------------|----------------------------------|-------------------------------|
| Syntax          | `-split`, `-match`, `-eq`        | `.Trim()`, `.ToLower()`       |
| Usage style     | Keyword/operator between values  | Dot notation on an object     |
| Input format    | Values passed to operator        | Called on the object itself   |
| Flexibility     | Often simpler for quick tasks    | Richer options and chaining   |
| Regex support   | Built-in (e.g., `-match`)         | Limited unless manually used  |

These approaches are interchangeable in many cases, but choosing between them depends on what feels more readable and expressive for your use case.

### 📦 Example: Using Operators and Methods in an Object or Class
You can also define custom operators and methods within PowerShell classes. Here's how you might define both a method and an overloaded operator:

### 🛠️ Defining Methods and Operators in a PowerShell Class

Choosing whether to define an operator or a method depends on the intended usage:

- Define an **operator** if you want your class to support natural syntax comparisons (e.g., `$obj1 -eq $obj2`).
- Define a **method** when you want to expose custom logic or transformations (e.g., `$obj.Format()`, `$obj.ToUpperWord()`).

Operators are great for comparison logic, while methods are better for transformations, formatting, and actions specific to the object.

```powershell
class Word {
    [string]$Value

    Word([string]$text) {
        $this.Value = $text
    }

    [string] ToUpperWord() {
        return $this.Value.ToUpper()
    }

    static [bool] operator -eq ([Word]$a, [Word]$b) {
        return $a.Value.ToLower() -eq $b.Value.ToLower()
    }
}

$a = [Word]::new("hello")
$b = [Word]::new("HELLO")
$a -eq $b          # True — uses custom operator
$a.ToUpperWord()   # "HELLO" — uses method
```

In PowerShell classes or custom objects, you often use string methods inside properties or methods for formatting or checking values:

```powershell
class Person {
    [string]$Name

    [string] GetGreeting() {
        return "Hello, $($this.Name.ToUpper())"  # using string method
    }

    [bool] HasPrefix([string]$prefix) {
        return $this.Name -like "$prefix*"       # using string operator
    }
}

$p = [Person]::new()
$p.Name = "sathya"
$p.GetGreeting()         # => Hello, SATHYA
$p.HasPrefix("sa")       # => True
```

<!-- ********************* -->
# 9. Initializing and Formatting Strings in PowerShell
<!-- ********************* -->

Below are various ways to create and format strings, followed by a few advanced formatting tips experienced developers may find handy.

PowerShell offers flexible ways to create and format strings, whether in simple scripts or inside functions and classes.

### 🔹 String Initialization
You can declare strings with single or double quotes:
```powershell
$str1 = 'Hello world'         # Literal string
$str2 = "User: $env:USERNAME" # Expands variables
```

### 🔹 Multi-line Strings
```powershell
$multi = @"
Line 1
Line 2
"@
```

### 🔹 Concatenation
```powershell
$first = "Hello"
$second = "World"
$combined = $first + " " + $second  # Hello World
```

### 🔹 Escaping Characters
Use backtick (`` ` ``) to escape special characters:
```powershell
"He said, `"PowerShell!`""
```
Or use single quotes to avoid expansion/escaping altogether:
```powershell
'Showing `$dollar and `"quote" characters'
```

### 🔹 String Formatting with `-f`
```powershell
$name = "Alice"
$age = 30
"Name: {0}, Age: {1}" -f $name, $age  # => Name: Alice, Age: 30
```
Supports .NET-style formatting tokens like `{0:N2}`, `{1:D}`.

### 🔹 String Interpolation (Double Quotes)
```powershell
$name = "Bob"
"Hello, $name!"          # => Hello, Bob!
"Path is $env:PATH"      # Expands environment variable
```

Use subexpressions when combining expressions:
```powershell
"Today is $([DateTime]::Now.DayOfWeek)"
```

### 🔹 Advanced Formatting Techniques

#### Padding and Alignment
```powershell
"{0,-10} | {1,5}" -f "Name", "Age"  # Left-align Name, right-align Age
"{0,10}" -f "right"                 # Right-align in a 10-char field
"{0,-10}" -f "left"                  # Left-align in a 10-char field
```

#### Numeric Formatting
```powershell
"{0:C}" -f 19.99       # => $19.99 (Currency)
"{0:P1}" -f 0.2345     # => 23.5% (Percent with 1 decimal place)
"{0:N3}" -f 1234.5678  # => 1,234.568 (Thousands separator + 3 decimals)
```

#### Null or Whitespace Checks
```powershell
[string]::IsNullOrEmpty($val)
[string]::IsNullOrWhiteSpace($val)
```

#### Raw String Literals (PowerShell 7+)
```powershell
@'
This is a raw string:
  No escaping \ or $ expansion needed.
'@
```

<!-- ********************* -->
# 10. Key String Members in PowerShell
<!-- ********************* -->

PowerShell strings are based on the .NET `System.String` type. This provides access to a large set of useful methods and static members. Here are some of the most relevant ones for PowerShell users:

### 🔹 Instance Methods
These are called on string objects:
```powershell
"hello".ToUpper()
"  padded  ".Trim()
"data".Replace("d", "D")
"power".Contains("ow")
"text.ps1".EndsWith(".ps1")
"one,two".Split(',')
"path".Insert(0, "C:\")
```

### 🔹 Static Methods
These are called on the `[string]` class itself:
```powershell
[string]::IsNullOrEmpty($str)
[string]::IsNullOrWhiteSpace($str)
[string]::Join(",", @("a", "b"))
[string]::Format("Hello, {0}", "World")
```

### 🔹 Other Common Methods
| Method             | Description                                 |
|--------------------|---------------------------------------------|
| `.ToUpper()`       | Converts to uppercase                       |
| `.ToLower()`       | Converts to lowercase                       |
| `.Trim()`          | Removes leading/trailing whitespace         |
| `.Replace()`       | Replaces characters or substrings           |
| `.Split()`         | Splits into array by delimiter              |
| `.Contains()`      | Checks for substring existence              |
| `.StartsWith()`    | Checks string prefix                        |
| `.EndsWith()`      | Checks string suffix                        |
| `.Substring()`     | Extracts part of a string                   |
| `.IndexOf()`       | Returns position of a substring             |
| `.Insert()`        | Inserts a string at a specific index        |
| `.Remove()`        | Removes characters by index and length      |
| `.PadLeft()`       | Pads string on the left                     |
| `.PadRight()`      | Pads string on the right                    |

These methods make it easy to build, transform, and query strings directly from PowerShell scripts.

<!-- ********************* -->
# 11. References
<!-- ********************* -->

1. [PowerShell About Comparison Operators](https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-comparison-operators)  
   Covers equality, string, and case-sensitive comparison operators.

2. [PowerShell About Operators](https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-operators)  
   Overview of all operators including arithmetic and string-specific ones.

3. [PowerShell About Strings](https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-strings)  
   Deep dive into PowerShell string handling, methods, interpolation, escaping, and formatting.

4. [Regular Expressions in PowerShell](https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-regular-expressions)  
   Guide to using regex with `-match`, `-replace`, and related scenarios.

5. [Where-Object Cmdlet](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/where-object)  
   Describes how to filter data in pipelines, often with string comparison and matching.

6. [PowerShell Class Syntax](https://learn.microsoft.com/en-us/powershell/scripting/developer/class/about-classes)  
   Reference for defining methods and operators in PowerShell classes.

7. [PowerShell String Formatting -f Operator](https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-strings#using-the--f-operator)  
   Covers formatting strings with placeholders, alignment, currency, and numeric formatting.

8. [PowerShell Quoting Rules](https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-quoting)  
   Explanation of single vs double quotes, escape sequences, and raw string literals.

