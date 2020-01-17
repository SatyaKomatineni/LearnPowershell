<#
 # A sample Powershell Script
 #
 # Goal
 # ************************************
 # Test RDP connection to an RDP server.
 # Jan, 2019, Satya
 #
 # uses Test-NetConnection Commandlet
 #>

 <#
 # **********************************************
 # Wrap Read-Host to take a default when no input
 # is provided.
 # **********************************************
 #>
 function readHostWithDefault($prompt, $default)
 {
     $ans = Read-Host $prompt
     if ($ans -ne $null)
     {
         return $ans
     }
     return $default
 }

 <#
 # **********************************************
 # To preceed a line with a new line
 # To print associated lines together
 # **********************************************
 #>
 function startSection($line)
 {
     Write-Host "`n$line"
 }

 <#
 # **********************************************
 # It is useful to know what are the types of 
 # variables in powershell scripts
 # **********************************************
 #>
  function printTypeInformation ($inputobject)
 {
     Write-Host "printing type information for type: $($inputobject.GetType())"
     $typeDetails = $inputobject  | Get-Member
     $typeDetails
     $inputObject.GetType()
 }
 <#
 # **********************************************
 # Main program
 # 1. Read an ip address
 # 2. Return if no input is given
 # 3. Use Test-Netconnection to connect to RDP host
 # 4. Report on ping stats and tcp status
 # 5. print full details
 # **********************************************
 #>
 
 function mainProgram()
 {
     $ipaddress = readHostWithDefault -prompt "Enter an RDP ip address" -default "n"

     if ($ipaddress -eq "n")
     {
         Write-Host "No ip address picked. Returning"
         return
     }

     #********************************************************
     startSection "Making a call using Test-NetConnection to an RDP port at ipaddress: $ipaddress"
     #********************************************************

     # [TestNetConnectionResult]
     $netResult = Test-NetConnection -CommonTCPPort RDP -ComputerName $ipaddress
     #Uncomment this to print the full nature of $netResult
     #printTypeInformation -inputobject $netResult


     #********************************************************
     startSection "Reporting on the results of the ping status"
     #********************************************************
     if ($netResult.PingSucceeded -eq $true)
     {
         Write-Host "Ping succeeded. Details will follow"
     }
     else {
         Write-Host "ping failed. Details will follow"
     }

     #********************************************************
     startSection "Reporting on the results of the TcpTestSucceeded status"
     #********************************************************
     
     if ($netResult.TcpTestSucceeded -eq $true)
     {
         Write-Host "TcpTestSucceeded succeeded. Details will follow"
     }
     else {
         Write-Host "TcpTestSucceeded failed. Details will follow"
     }


     #********************************************************
     startSection "Full details of the test"
     #********************************************************
     $netResult
  }

  # Run the program
  mainProgram