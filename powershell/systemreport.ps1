# Connor Tremblay (200451942)

# Specifies parameters for the following using switch
param (
    [switch]$System,
    [switch]$Disks,
    [switch]$Network
)

# function for gaining information about cpu 
function Get-CPUInfo {
    $cpuInfo = Get-WmiObject Win32_Processor
    [PSCustomObject]@{
        Description = $cpuInfo.Name
        Speed = "$($cpuInfo.CurrentClockSpeed) MHz"
        Cores = $cpuInfo.NumberOfCores
        L1Cache = If ($cpuInfo.L2CacheSize) { "$($cpuInfo.L1CacheSize) KB" } else { "N/A" }
        L2Cache = If ($cpuInfo.L2CacheSize) { "$($cpuInfo.L2CacheSize) KB" } else { "N/A" }
        L3Cache = If ($cpuInfo.L3CacheSize) { "$($cpuInfo.L3CacheSize) KB" } else { "N/A" }
    }
}

# function for gaining os information 
function Get-OSInfo {
    $osInfo = Get-WmiObject Win32_OperatingSystem
    [PSCustomObject]@{
        Name = $osInfo.Caption
        Version = $osInfo.Version
    }
}

#function for gaining information of the computers memory 
function Get-RAMInfo {
    $ramInfo = Get-WmiObject Win32_PhysicalMemory
    $ramTable = @()
    
    $ramInfo | ForEach-Object {
        $ramTable += [PSCustomObject]@{
            Vendor = $_.Manufacturer
            Description = $_.PartNumber
            Size = "$([math]::Round($_.Capacity / 1GB, 2)) GB"
            BankSlot = "Bank $($_.BankLabel), Slot $($_.DeviceLocator)"
        }
    }
    
    $totalRAM = [math]::Round(($ramInfo | Measure-Object Capacity -Sum).Sum / 1GB, 2)
    
    [PSCustomObject]@{
        RAMTable = $ramTable
        TotalRAM = "$totalRAM GB"
    }
}

#function that gains disk information, 
function Get-DiskInfo {
    $diskInfo = Get-WmiObject Win32_DiskDrive
    $diskTable = @()

    $diskInfo | ForEach-Object {
        $partitions = Get-WmiObject -Query "ASSOCIATORS OF {Win32_DiskDrive.DeviceID='$($_.DeviceID)'} WHERE AssocClass=Win32_DiskDriveToDiskPartition"
        $totalSize = $_.Size
        $freeSpace = $partitions | ForEach-Object { $_.Size - $_.TotalSize }
        $percentageFree = ($freeSpace / $totalSize) * 100

        $diskTable += [PSCustomObject]@{
            Vendor = $_.Manufacturer
            Model = $_.Model
            Size = "$([math]::Round($_.Size / 1GB, 2)) GB"
            FreeSpace = "$([math]::Round($freeSpace / 1GB, 2)) GB"
            PercentageFree = "$([math]::Round($percentageFree, 2))%"
        }
    }

    $diskTable
}

function Get-NetworkInfo {
    $networkInfo = Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true }
    $networkTable = @()

    $networkInfo | ForEach-Object {
        $networkTable += [PSCustomObject]@{
            Description = $_.Description
            IPAddress = $_.IPAddress[0]
            SubnetMask = $_.IPSubnet[0]
            DefaultGateway = $_.DefaultIPGateway
            DNS = $_.DNSServerSearchOrder -join ', '
        }
    }

    $networkTable
}

function Get-VideoInfo {
    $videoInfo = Get-WmiObject Win32_VideoController
    $videoInfo | ForEach-Object {
        [PSCustomObject]@{
            Vendor = $_.AdapterCompatibility
            Description = $_.Caption
            Resolution = "$($_.CurrentHorizontalResolution) x $($_.CurrentVerticalResolution)"
        }
    }
}

# Defines what functions are called when using parameters defined before script. 

Write-Host "System Information Report"

if ($System) {
    Write-Host "`nCPU Information"
    Get-CPUInfo | Format-List

    Write-Host "`nOperating System Information"
    Get-OSInfo | Format-List

    Write-Host "`nRAM Information"
    $ramInfo = Get-RAMInfo
    $ramInfo.RAMTable | Format-Table -AutoSize
    Write-Host "Total RAM Installed: $($ramInfo.TotalRAM)"

    Write-Host "`nVideo Card Information"
    Get-VideoInfo | Format-List
}

if ($Disks) {
    Write-Host "`nDisk Information"
    Get-DiskInfo | Format-Table -AutoSize
}

if ($Network) {
    Write-Host "`nNetwork Adapter Configuration"
    Get-NetworkInfo | Format-Table -AutoSize
}