Param (    
    [string]$OutputCSV = $null,
    [string[]]$RemoteComputers,
    [switch]$EmailCSV
)

Import-Module $PSScriptRoot\SystemInfoCollection.psd1
Write-Output "Imported Module: SystemInfoCollection"

# Get Time
$time = Get-WinForensicsTime
$time | Format-Table -AutoSize

# Get Windows Version
$version = Get-WinForensicsVersion
$version.WinVer | Format-Table -AutoSize
$version.OSName | Format-Table -AutoSize

# Get Machine's Hardware Info
$hardware = Get-WinForensicsHardware
$hardware.ProcessorName | Format-Table -AutoSize
$hardware.ProcessorVersion | Format-Table -AutoSize
$hardware.Memory | Format-Table -AutoSize
$hardware.LogicalDisks | Format-Table -AutoSize
$hardware.Volumes | Format-Table -AutoSize

# Check if this machine is a DC
#$role = (Get-WmiObject Win32_ComputerSystem).DomainRole
#if($role -eq 4 -or $role -eq 5) {
#    $DCInfo = Get-WinForensicsDCInfo
#    $DCInfo | Format-Table -AutoSize
#}

$hostname = Get-WinForensicsHostname
$hostname.Hostname | Format-Table -AutoSize
$hostname.WorkgroupOrDomain | Format-Table -AutoSize

$user = Get-WinForensicsUser
$user | Format-Table -AutoSize

$autorun = Get-WinForensicsAutorun
$autorun.Services | Format-Table -AutoSize
$autorun.Programs | Format-Table -AutoSize

$tasks = Get-WinForensicsScheduledTasks
$tasks | Format-Table -AutoSize

$netInfo = Get-WinForensicsNetworkInfo
$netInfo.ARPTable | Format-Table -AutoSize
$netInfo.Interfaces | Format-Table -AutoSize
$netInfo.RoutingTable | Format-Table -AutoSize
$netInfo.AdvancedInfo | Format-Table -AutoSize
$netInfo.ListeningProcesses | Format-Table -AutoSize
$netInfo.UDPEndpoints | Format-Table -AutoSize
$netInfo.EstablishedConnections | Format-Table -AutoSize
$netInfo.DNSCache | Format-Table -AutoSize

$netObj = Get-WinForensicsNetworkObjects
$netObj.Share | Format-Table -AutoSize
$netObj.Printers | Format-Table -AutoSize
$netObj.WirelessProfiles | Format-Table -AutoSize

$pList = Get-WinForensicsProcessList
$pList | Format-Table -AutoSize

$drivers = Get-WinForensicsDriverList
$drivers | Format-Table -AutoSize

$userFiles = Get-WinForensicsUserFiles
$userFiles.Documents | Format-Table -AutoSize
$userFiles.Downloads | Format-Table -AutoSize

$services = Get-WinForensicsServices
$services | Format-Table -AutoSize

if($OutputCSV -ne $null) {
    $time.CurrentTime | Export-Csv -NoTypeInformation -Path ./time.csv
    Get-Content ./time.csv >> $OutputCSV
    Remove-Item ./time.csv
    $time.TimeZone | Export-Csv -NoTypeInformation -Path ./time.csv
    Get-Content ./time.csv >> $OutputCSV
    Remove-Item ./time.csv
    $time.Uptime | Export-Csv -NoTypeInformation -Path ./time.csv
    Get-Content ./time.csv >> $OutputCSV
    Remove-Item ./time.csv

    $version.WinVer | Export-Csv -NoTypeInformation -Path ./version.csv
    Get-Content ./version.csv >> $OutputCSV
    Remove-Item ./version.csv
    $version.OSName | Export-Csv -NoTypeInformation -Path ./version.csv
    Get-Content ./version.csv >> $OutputCSV
    Remove-Item ./version.csv

    $hardware.ProcessorName | Export-Csv -NoTypeInformation -Path ./hardware.csv
    Get-Content ./hardware.csv >> $OutputCSV
    Remove-Item ./hardware.csv
    $hardware.ProcessorVersion | Export-Csv -NoTypeInformation -Path ./hardware.csv
    Get-Content ./hardware.csv >> $OutputCSV
    Remove-Item ./hardware.csv
    $hardware.Memory | Export-Csv -NoTypeInformation -Path ./hardware.csv
    Get-Content ./hardware.csv >> $OutputCSV
    Remove-Item ./hardware.csv
    $hardware.LogicalDisks | Export-Csv -NoTypeInformation -Path ./hardware.csv
    Get-Content ./hardware.csv >> $OutputCSV
    Remove-Item ./hardware.csv
    $hardware.Volumes | Export-Csv -NoTypeInformation -Path ./hardware.csv
    Get-Content ./hardware.csv >> $OutputCSV
    Remove-Item ./hardware.csv

    #if($role -eq 4 -or $role -eq 5) {
    #    $DCInfo | Export-Csv -NoTypeInformation -Path ./DCInfo.csv
    #    Get-Content ./DCInfo.csv >> $OutputCSV
    #    Remove-Item ./DCInfo.csv
    #}

    $hostname.Hostname | Export-Csv -NoTypeInformation -Path ./hostname.csv
    Get-Content ./hostname.csv >> $OutputCSV
    Remove-Item ./hostname.csv
    $hostname.WorkgroupOrDomain | Export-Csv -NoTypeInformation -Path ./hostname.csv
    Get-Content ./hostname.csv >> $OutputCSV
    Remove-Item ./hostname.csv

    $user | Export-Csv -NoTypeInformation -Path ./user.csv
    Get-Content ./user.csv >> $OutputCSV
    Remove-Item ./user.csv

    $autorun.Services | Export-Csv -NoTypeInformation -Path ./autorun.csv
    Get-Content ./autorun.csv >> $OutputCSV
    Remove-Item ./autorun.csv
    $autorun.Programs | Export-Csv -NoTypeInformation -Path ./autorun.csv
    Get-Content ./autorun.csv >> $OutputCSV
    Remove-Item ./autorun.csv

    $tasks | Export-Csv -NoTypeInformation -Path ./tasks.csv
    Get-Content ./tasks.csv >> $OutputCSV
    Remove-Item ./tasks.csv

    $netInfo.ARPTable | Export-Csv -NoTypeInformation -Path ./netInfo.csv
    Get-Content ./netInfo.csv >> $OutputCSV
    Remove-Item ./netInfo.csv
    $netInfo.Interfaces | Export-Csv -NoTypeInformation -Path ./netInfo.csv
    Get-Content ./netInfo.csv >> $OutputCSV
    Remove-Item ./netInfo.csv
    $netInfo.RoutingTable | Export-Csv -NoTypeInformation -Path ./netInfo.csv
    Get-Content ./netInfo.csv >> $OutputCSV
    Remove-Item ./netInfo.csv
    $netInfo.AdvancedInfo | Export-Csv -NoTypeInformation -Path ./netInfo.csv
    Get-Content ./netInfo.csv >> $OutputCSV
    Remove-Item ./netInfo.csv
    $netInfo.ListeningProcesses | Export-Csv -NoTypeInformation -Path ./netInfo.csv
    Get-Content ./netInfo.csv >> $OutputCSV
    Remove-Item ./netInfo.csv
    $netInfo.UDPEndpoints | Export-Csv -NoTypeInformation -Path ./netInfo.csv
    Get-Content ./netInfo.csv >> $OutputCSV
    Remove-Item ./netInfo.csv
    $netInfo.EstablishedConnections | Export-Csv -NoTypeInformation -Path ./netInfo.csv
    Get-Content ./netInfo.csv >> $OutputCSV
    Remove-Item ./netInfo.csv
    $netInfo.DNSCache | Export-Csv -NoTypeInformation -Path ./netInfo.csv
    Get-Content ./netInfo.csv >> $OutputCSV
    Remove-Item ./netInfo.csv

    $netObj.Shares | Export-Csv -NoTypeInformation -Path ./netObj.csv
    Get-Content ./netObj.csv >> $OutputCSV
    Remove-Item ./netObj.csv
    $netObj.Printers | Export-Csv -NoTypeInformation -Path ./netObj.csv
    Get-Content ./netObj.csv >> $OutputCSV
    Remove-Item ./netObj.csv
    $netObj.WirelessProfiles | Export-Csv -NoTypeInformation -Path ./netObj.csv
    Get-Content ./netObj.csv >> $OutputCSV
    Remove-Item ./netObj.csv

    $pList | Export-Csv -NoTypeInformation -Path ./pList.csv
    Get-Content ./pList.csv >> $OutputCSV
    Remove-Item ./pList.csv

    $drivers | Export-Csv -NoTypeInformation -Path ./drivers.csv
    Get-Content ./drivers.csv >> $OutputCSV
    Remove-Item ./drivers.csv

    $userFiles.Documents | Export-Csv -NoTypeInformation -Path ./userFiles.csv
    Get-Content ./userFiles.csv >> $OutputCSV
    Remove-Item ./userFiles.csv
    $userFiles.Downloads | Export-Csv -NoTypeInformation -Path ./userFiles.csv
    Get-Content ./userFiles.csv >> $OutputCSV
    Remove-Item ./userFiles.csv

    $services | Export-Csv -NoTypeInformation -Path ./services.csv
    Get-Content ./services.csv >> $OutputCSV
    Remove-Item ./services.csv
}

Remove-Module SystemInfoCollection
Write-Output "Removed Module: SystemInfoCollection"
