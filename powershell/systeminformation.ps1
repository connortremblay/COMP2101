function Get-SystemInfo {
    # System Hardware Information
    $systemInfo = Get-WmiObject Win32_ComputerSystem
    $osInfo = Get-WmiObject Win32_OperatingSystem
    $processorInfo = Get-WmiObject Win32_Processor
    $memoryInfo = Get-WmiObject Win32_PhysicalMemory
    $diskInfo = Get-WmiObject Win32_DiskDrive
    $partitionInfo = Get-WmiObject Win32_DiskPartition
    $logicalDiskInfo = Get-WmiObject Win32_LogicalDisk
    $networkInfo = Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled }

    # System Hardware Description
    Write-Host "System Hardware Description:"
    Write-Host "Manufacturer: $($systemInfo.Manufacturer)"
    Write-Host "Model: $($systemInfo.Model)"
    Write-Host "Serial Number: $($systemInfo.SerialNumber)"
    Write-Host ""

    # Operating System Information
    Write-Host "Operating System:"
    Write-Host "Name: $($osInfo.Caption)"
    Write-Host "Version: $($osInfo.Version)"
    Write-Host ""

    # Processor Information
    Write-Host "Processor:"
    Write-Host "Description: $($processorInfo.Name)"
    Write-Host "Speed: $($processorInfo.MaxClockSpeed) MHz"
    Write-Host "Number of Cores: $($processorInfo.NumberOfCores)"
    Write-Host "L1 Cache: $($processorInfo.L2CacheSize) KB"
    Write-Host "L2 Cache: $($processorInfo.L2CacheSize) KB"
    Write-Host "L3 Cache: $($processorInfo.L3CacheSize) KB"
    Write-Host ""

    # Memory Information
    Write-Host "Memory:"
    $memoryTable = @()
    foreach ($memory in $memoryInfo) {
        $memoryTable += [PSCustomObject]@{
            Vendor = $memory.Manufacturer
            Description = $memory.Caption
            Size = "$($memory.Capacity / 1GB) GB"
            BankSlot = "$($memory.BankLabel) $($memory.DeviceLocator)"
        }
    }
    $memoryTable | Format-Table -AutoSize
    Write-Host "Total RAM Installed: $($memoryInfo | Measure-Object Capacity -Sum | ForEach-Object { "$($_.Sum / 1GB) GB" })"
    Write-Host ""

    # Disk Information
    Write-Host "Disk Drives:"
    $diskTable = @()
    foreach ($disk in $diskInfo) {
        $partition = $partitionInfo | Where-Object { $_.DeviceID -eq $disk.DeviceID }
        $logicalDisk = $logicalDiskInfo | Where-Object { $_.DeviceID -eq $partition.DeviceID }
        $diskTable += [PSCustomObject]@{
            Vendor = $disk.Manufacturer
            Model = $disk.Model
            Size = "$($disk.Size / 1GB) GB"
            FreeSpace = "$($logicalDisk.FreeSpace / 1GB) GB"
            PercentageFree = "$([math]::Round(($logicalDisk.FreeSpace / $logicalDisk.Size) * 100, 2))%"
        }
    }
    $diskTable | Format-Table -AutoSize
    Write-Host ""

    # Network Adapter Configuration
    Write-Host "Network Adapter Configuration:"
    foreach ($networkAdapter in $networkInfo) {
        Write-Host "Adapter: $($networkAdapter.Description)"
        Write-Host "IP Address: $($networkAdapter.IPAddress)"
        Write-Host "MAC Address: $($networkAdapter.MACAddress)"
        Write-Host ""
    }

    # Video Card Information
    $videoInfo = Get-WmiObject Win32_VideoController
    Write-Host "Video Card Information:"
    foreach ($video in $videoInfo) {
        Write-Host "Vendor: $($video.VideoProcessor)"
        Write-Host "Description: $($video.Description)"
        Write-Host "Screen Resolution: $($video.CurrentHorizontalResolution) x $($video.CurrentVerticalResolution)"
        Write-Host ""
    }
}

# Call the function to generate the system information report
Get-SystemInfo





