<#
#*************************************************
# Lib includes
# . (Join-Path $env:MY_PS_LIB "psutils.ps1")
#*************************************************
#>

# if it is not included
<#
***********************************************************************
* Global area for commenting out
***********************************************************************
$libpath = $env:MY_PS_LIB
if ($psutilsIncluded -eq $null)
{
    Write-Host "Invoking psutils.ps1 Common utilities"
    ."$libpath\psutils.ps1"
}

$path = (use "psutils.ps1")
write-host $path

Import-Module lightinclude


$lib1 = (getlib "testlib.ps1")
$lib2 =  (getlib "testlib2.ps1")
. $lib1
. $lib2

write-host $lib1
write-host $lib2

$libpath = $env:MY_PS_LIB
if ($psutilsIncluded -eq $null)
{
    Write-Host "Invoking psutils.ps1 Common utilities"
    ."$libpath\psutils.ps1"
}


***********************************************************************
* End of global area for commenting out
***********************************************************************
#>

# Fundamental includes
. "$env:MY_PS_LIB\getlibs.ps1"
. (getlib "psutils.ps1")

# Additional includes
hp -message "Library includes"
. (getlib "testlib.ps1")
. (getlib "testlib2.ps1")


<#
#*************************************************
# Set MY_PS_LIB to C:\satya\data\code\LearnPowershellRepo\libs
# Expect to find: psutils.ps1 there as a file
#*************************************************
#>
function test 
{
    hp -message "Testing functions from libraries"
    testlib1Function
    testlib2Function
}

<#
#*************************************************
Drivers
#*************************************************
#>

test