# Enable transcript logging
Start-Transcript -Path C:\Temp\reg_log.txt

# Check if OS is Windows 11
if ([System.Environment]::OSVersion.Version.Build -lt 22000) {
    Write-Verbose "This script is only compatible with Windows 11."
    Stop-Transcript
    exit 1
}

# Define registry keys to set
$registryKeys = @(
    @{
        Path = "HKLM:\System\CurrentControlSet\Services\LanmanServer\Parameters"
        Name = "SMB1"
        Value = 1
        Type = "DWORD"
    },
    @{
        Path = "HKLM:\System\CurrentControlSet\Control\Lsa"
        Name = "LsaCfgFlags"
        Value = 1
        Type = "DWORD"
    },
    @{
        Path = "HKLM:\Software\Policies\Microsoft\Windows\DeviceGuard"
        Name = "LsaCfgFlags"
        Value = 1
        Type = "DWORD"
    }
)

# Loop through registry keys and set values
$errorCount = 0

foreach ($key in $registryKeys) {
    if (!(Test-Path $key.Path)) {
        try {
            New-Item -Path $key.Path -Force | Out-Null
        }
        catch {
            Write-Error "Failed to create registry key $($key.Path): $_"
            $errorCount++
            continue
        }
    }

    try {
        $currentValue = (Get-ItemProperty $key.Path -ErrorAction Stop).$($key.Name)
    }
    catch {
        Write-Error "Failed to read registry value $($key.Path)\$($key.Name): $_"
        $errorCount++
        continue
    }

    if ($currentValue -ne $key.Value) {
        try {
            New-ItemProperty -Path $key.Path -Name $key.Name -Value $key.Value -PropertyType $key.Type -Force | Out-Null
        }
        catch {
            Write-Error "Failed to set registry value $($key.Path)\$($key.Name) to $($key.Value): $_"
            $errorCount++
            continue
        }
    }
}

# Check if there were any errors and return appropriate exit code
if ($errorCount -gt 0) {
    Stop-Transcript
    exit 1
}

Stop-Transcript
exit 0
