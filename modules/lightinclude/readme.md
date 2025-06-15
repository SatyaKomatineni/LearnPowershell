# lightinclude

`lightinclude` is a lightweight PowerShell module that allows you to include other `.ps1` scripts using a simple `use` command. It supports caching so each script is only loaded once per session.

## Features
- Dot-sources other scripts from a shared folder
- Uses the environment variable `MY_PS_LIB` to locate them
- Prevents double inclusion with caching
- Emits verbose output when loaded