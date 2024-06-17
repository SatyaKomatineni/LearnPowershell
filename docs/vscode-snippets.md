<!-- ********************* -->
# Profit of VSCode Snippets
<!-- ********************* -->

Say you are writing a markdown file like this for instance.

I want my heading to look like this so that it is clearly separated from the rest

```markdown
<!-- ********************* -->
# Profit of VSCode Snippets
<!-- ********************* -->
```

Or I want a code snippet for PowerShell that automatically inserts for me on cue the following

````markdown
```powershell
code
```
````

<!-- ********************* -->
# How to see what snippets you already have
<!-- ********************* -->

```markdown
ctrl-shift-p
snippets: insert snippet
```

This will display the existing snippets. 

These include what you defined and also the built-in snippets for the type of file you have opened.

<!-- ********************* -->
# How to create a snippet(s) of your own
<!-- ********************* -->

```markdown
ctrl-shift-p and "snippets"
use "configure user snippets"
```

Few notes:
1. Instead of choosing global you may want to chose your local project root for the snippet target
2. This file is saved in *your-project-root/.vscode/file.code-snippets*
3. Note: You can have multiple snippet files (to be elaborated later)
4. Doing in the scope of your project gives you better visibility to adjust/modify

As a result of this the named snippet file is created and opened in the editor.

This file looks like the following

```json
{
	// Place your LearnPowershellRepo workspace snippets here. Each snippet is defined under a snippet name and has a scope, prefix, body and 
	// description. Add comma separated ids of the languages where the snippet is applicable in the scope field. If scope 
	// is left empty or omitted, the snippet gets applied to all languages. The prefix is what is 
	// used to trigger the snippet and the body will be expanded and inserted. Possible variables are: 
	// $1, $2 for tab stops, $0 for the final cursor position, and ${1:label}, ${2:another} for placeholders. 
	// Placeholders with the same ids are connected.
	// Example:
	// "Print to console": {
	// 	"scope": "javascript,typescript",
	// 	"prefix": "log",
	// 	"body": [
	// 		"console.log('$1');",
	// 		"$2"
	// 	],
	// 	"description": "Log output to console"
	// }
}
```

Here are two snippets I have added to this snippet file

```json
{
	// Place your LearnPowershellRepo workspace snippets here. Each snippet is defined under a snippet name and has a scope, prefix, body and 
	// description. Add comma separated ids of the languages where the snippet is applicable in the scope field. If scope 
	// is left empty or omitted, the snippet gets applied to all languages. The prefix is what is 
	// used to trigger the snippet and the body will be expanded and inserted. Possible variables are: 
	// $1, $2 for tab stops, $0 for the final cursor position, and ${1:label}, ${2:another} for placeholders. 
	// Placeholders with the same ids are connected.
	// Example:
	// "Print to console": {
	// 	"scope": "javascript,typescript",
	// 	"prefix": "log",
	// 	"body": [
	// 		"console.log('$1');",
	// 		"$2"
	// 	],
	// 	"description": "Log output to console"
	// }
	"md-heading": {
		"prefix": "md-heading",
		"body": [
		"<!-- ********************* -->",
		"# Some heading",
		"<!-- ********************* -->",
		"$0"
		],
		"description": "Insert a commented heading"
	},
	"md-python": {
		"prefix": "md-python",
		"body": [
		"```python",
		"code",
		"```",
		"$0"
		],
		"description": "Python segment"
	},
	"md-powershell": {
		"prefix": "md-powershell",
		"body": [
		"```powershell",
		"code",
		"```",
		"$0"
		],
		"description": "Powershell segment"
	}
}
```

Few notes

1. Each snippet definition is json and ends with a ","
2. If this file is misformatted it won't work
3. So play special attention to the json format
4. I tend to ask "ChatGPT" to fill the json given the "text segment" I want
5. Notice "no comma" if this is the last snippet

<!-- ********************* -->
# Multiple snippet files
<!-- ********************* -->
There can be multiple snippet files in .vscode sub directory.

So once you have one, or another friend of yours have one, you can just copy them here with the same ".code-snippets" extension.

<!-- ********************* -->
# How to do you cue vscode to place the snippet at the cursor
<!-- ********************* -->

By default the key sequence "ctrl-space" invokes a "suggest" feature and shows you the prefixes in the snippet. You just pick one and it will replace the snippet at the cursor.

You can figure out what key combination invvokes this "Trigger Suggest"

1. File
2. Preferences
3. Key board short cuts
4. search for "trigger suggest"

You can also control where your snippet suggestion should appear in the list of available suggestion on the press of "ctrl-space" or if there is intellisense the first few characters.

For this

You have the option in settings to

1. Go to settings (ctrl-shift-p: search for settings)
2. Editor: snippet suggestion
3. options: top, bottom, inline (default), none
4. I chose "top"



<!-- ********************* -->
# Understanding tabbing in the snippets
<!-- ********************* -->

1. The body of a snippet can contain things like: $1, $2, $3
2. These are also called place holders.
3. The snippet body is fully filled out with default values, as if they the place holders are highlighted ready to be replaced
4. Each "tab" then will take you to the right spot to replace the high lighted text.


Consider this snippet definition

```json
{
  "Function Definition": {
    "prefix": "func",
    "body": [
      "function ${1:FunctionName}(${2:parameters}) {",
      "    ${0:// body}",
      "}"
    ],
    "description": "Insert a function definition"
  }
}
```
Here is its behavior

The following will show up first

```python
function FunctionName(parameters) {
    // body
}
```
The place holders are

1: FunctionName
2: parameters
3: //body

Each tab will take you to that place and allows you to replace that word or segment

<!-- ********************* -->
# Reference
<!-- ********************* -->
[VSCode official documentation on snippets. A good one](https://code.visualstudio.com/docs/editor/userdefinedsnippets)

You will find here lot of details and future possibilities.

<!-- ********************* -->
# Using selections and variables
<!-- ********************* -->

1. You can use in the snippet body variables like current highlighted selection
2. Or current line etc.
3. See the VScode docs on snippets included earlier here for using them

<!-- ********************* -->
# Notes on the insertion point
<!-- ********************* -->

1. There is some confusion for me
2. It ought to be the current cursor
3. However using a selection as a variable may replace that whole selection to arrive at a new cursor position which is at the beginning of the selection and may remove that selection