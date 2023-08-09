# uses get-cimintance to get collection of network adapters
$networkAdapters = get-ciminstance win32_networkadapterconfiguration

# uses where-object to only show enabled adapters
$enabledAdapters = $networkAdapters | Where-Object { $_.IPEnabled -eq $true }

# array for report data
$reportData = @()

# uses adapterinfo data to filter enabled adapters and gathers required information
foreach ($adapter in $enabledAdapters) {
    $adapterInfo = [PSCustomObject]@{
        Description    = $adapter.Description
        Index          = $adapter.Index
        IPAddress      = $adapter.IPAddress -join ', '
        SubnetMask     = $adapter.IPSubnet -join ', '
        DNSDomain      = $adapter.DNSDomain
        DNSServers     = $adapter.DNSServerSearchOrder -join ', '
    }
    $reportData += $adapterInfo
}

# displays report in a formatted table
$reportData | Format-Table -AutoSize




