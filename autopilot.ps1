Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Confirm:$false
Install-Script -Name Get-WindowsAutoPilotInfo -Force -Confirm:$false
Get-Windowsautopilotinfo -online -assign -AddtoGroup "Intune-Devices"
