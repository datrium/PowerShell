﻿<#
    .SYNOPSIS
    Push Datrium VSS Provider to a VM.    
    
    .DESCRIPTION
    This script will install the SQL VSS package on Servers which require the Datrium VSS Agent. You will need
    You will need to be able to hit all SQL servers and the Management IP of the Datrium Data Node from the
    system you run this script on. It is assumed that both local and remote hosts are running Powershell 3.0 or newer.

    Prior to running this script in any environment users should read the README.md file within the package.

    .Notes
    NAME:  DA_VSS.ps1
    AUTHOR(S):  CLINT WYCKOFF (@CLINTWYCKOFF) & CAMERON JOYCE (@DNASDF)
    LASTEDIT: 06/22/2018
    VERSION: 1.0
    KEYWORDS: Datrium, VSS, SQL
    BASED ON: http://mycloudrevolution.com/2016/03/21/veeam-prtg-sensor-reloaded/
   
    .Link
    http://mycloudrevolution.com/
 
 #Requires PS -Version 3.0
 #Requires Datrium DVX version 4.0.1.x or greater    
 #>

# Input Variables
$vm = Read-Host "Please enter the FQDN or IP of the VM to deploy Datrium VSS Agent to?"
$damgmtfloat = Read-Host "Please enter the IP address of the Datrium Data Node?"
$dapw = Read-Host "Please enter the Admin password to the Datrium Data Node?"

# Download a copy of the VSS MSI from Datrium Data Node
Try{
    If(!(Test-Path C:\Temp\Datrium-VSS-Provider-1.1.0.0.msi)){
        wget https://$damgmtfloat/static/Datrium-VSS-Provider-1.1.0.0.msi -outfile C:\temp\davss.msi
    }
}
Catch{
    Write-Warning "Failed Downloading the MSI package from Data Node. Manually download from Support.Datrium.com site or locally at https://$damgmtfloat:7443 and copy to the C:\Temp Folder of $vms."
    Break
}

# Attempt to connect to each VM and install the MSI package.
    If(Test-Connection -ComputerName $vm -count 1 -Quiet){
        Write-Host "Checking WMI on $vm"}
        
        # Try / Catch block for WMI errors. A client that passes Test-Connection may not have PSRemoting enabled and will error. This will handle that.
        Try{
            $ErrorActionPreference = "Stop"
            Invoke-Command -ComputerName $vm -ScriptBlock {If(!(Test-Path "C:\Temp")){New-Item "C:\Temp" -Type Directory}}
        }
        Catch [System.Management.Automation.Remoting.PSRemotingTransportException]{
            Write-Warning "$vm :Failed connecting to WMI."
            Write-Output "$vm :Failed on WMI" | Out-File "C:\Temp\failed_$date.txt" -Append
            Continue
        }
        Finally{
            $ErrorActionPreference = "Continue"
        }

# Install Datrium VSS Agent                
                Write-Host "Checking: \\$vm\c$\Temp exists" -ForegroundColor Yellow
                If(!(Test-Path "\\$vm\C$\Temp\"))
                {
                    Write-Host "\\$vm\c$\Temp DOES NOT EXIST ->> CREATING DIRECTORY \\$vm\c$\Temp" -ForegroundColor Yellow
                    New-Item "\\$vm\c$\Temp" -ItemType Directory
                }
                Else
                    {
                        Write-Host "C:\Temp DOES EXIST" -ForegroundColor Yellow
                    }

                Write-Host "Copying DAVSS.msi to \\$vm\c$\Temp" -ForegroundColor Yellow
                Copy-Item "C:\temp\davss.msi" -Destination "\\$vm\C$\Temp\davss.msi " -force

                Write-Host "Modifying UAC for installation" -ForegroundColor Yellow
                Invoke-Command -ComputerName $vm -ScriptBlock {& cmd.exe /c "C:\Windows\System32\reg.exe ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d 0 /f"}

                Write-Host "Installing MSI package" -ForegroundColor Yellow
                Invoke-Command -ComputerName $vm -ArgumentList $damgmtfloat, $dapw -ScriptBlock {& cmd.exe /c "C:\Temp\davss.msi /quiet NETSHELF_IP=$($args[0]) ADMIN_PASSWD=$($args[1])"}

                Write-Host "Installation of Datrium VSS Agent SUCCESSFUL on $VM" -ForegroundColor Green