Start-Transcript

$Errors = 0;

$ComputerInfo = Get-ComputerInfo
if(-not ($ComputerInfo.WindowsProductName -like 'Windows 11')){
    Write-Host 'This script only applies to Windows 11. You are running ' + $ComputerInfo.WindowsProductName
    return 0
}

if(-not(Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Services\LanmanServer\Parameters" -Name "SMB1" -Value 1 -Force)){
    Write-Host 'Unable to set LanManServer\SMB1 parameter.'
    $Errors += 1
}

if(-not(Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Lsa" -Name "LsaCfgFlags" -Value 1 -Force)){
    Write-Host 'Unable to set Lsa\LsaCfgFlags parameter.'
    $Errors += 1
}

if(-not(Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\DeviceGuard" -Name "LsaCfgFlags" -Value 1 -Force)){
    Write-Host 'Unable to set DeviceGuard\LsaCfgFlags parameter.'
    $Errors += 1
}

if(errors -eq 0){
    return 0
}

return 1