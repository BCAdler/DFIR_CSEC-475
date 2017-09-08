function Get-Time {
    $time = @{}
    $time.CurrentTime = Get-Date -Format U
    $time.TimeZone = $(Get-TimeZone).DisplayName

    $os = Get-WmiObject Win32_OperatingSystem
    $uptime = (Get-Date) - ($os.ConvertToDateTime($os.LastBootUpTime))
    $time.Uptime = "Uptime: " + $Uptime.Days + " days, " + $Uptime.Hours + 
                        " hours, " + $Uptime.Minutes + " minutes"

    return $time
}

function Get-Version {
    $version = @{}

    $version.WinVer = [System.Environment]::OSVersion.Version
    $version.OSName = Get-CimInstance Win32_OperatingSystem | 
                            Select-Object  Caption, InstallDate, ServicePackMajorVersion, OSArchitecture

    return $version
}

function Get-Hardware {
    $hardware = @{}

    $cpu = Get-WmiObject Win32_Processor
    $hardware.ProcessorName = $cpu.Name
    $hardware.ProcessorVersion = $cpu.Description

    $hardware.Memory = Get-WmiObject CIM_PhysicalMemory | 
                            Measure-Object -Property capacity -Sum | 
                            ForEach-Object { [Math]::Round(($_.sum / 1GB), 2) }

    $hardware.LogicalDisks = Get-WmiObject Win32_LogicalDisk -Filter "DriveType = '3'"
    $hardware.Volumes = Get-WmiObject Win32_Volume | Select-Object Name, Label, FreeSpace, Capacity

    return $hardware
}

function Get-Hostname {
    $hostname = @{}

    $hostname.Hostname = $env:COMPUTERNAME
    try {
        $hostname.FQDN = ([System.Net.Dns]::GetHostByName(($env:COMPUTERNAME))).HostName
    }
    catch {}
    $hostname.WorkgroupOrDomain = $env:USERDOMAIN

    return $hostname
}

function Get-User {
    return Get-LocalUser | Select-Object Name,LastLogon,SID
}

function Get-Autorun {
    $autoruns = @{}
    
    $autoruns.Services = Get-WmiObject Win32_Service | Where-Object { $_.StartMode -eq "Auto"} | Select-Object Name
    $autoruns.Programs = Get-CimInstance Win32_StartupCommand | 
                            Select-Object Name, command, Location, User

    return $autoruns
}

function Get-ScheduledTasks {
    return Get-ScheduledTask
}

function Get-NetworkInfo {
    $networkInfo = @{}
    
    $networkInfo.ARPTable = Get-NetNeighbor
    $networkInfo.Interfaces = Get-NetAdapter | Select-Object Name, InterfaceDescription, MacAddress
    $networkInfo.RoutingTable = Get-NetRoute
    $networkInfo.AdvancedInfo = (ipconfig /all)

    $ListeningTCPConnections = (Get-NetTCPConnection | Where-Object {($_.State -eq "Listen")})
    $networkInfo.ListeningProcesses = $ListeningTCPConnections

    $UDPEndpoints = Get-NetUDPEndpoint
    $networkInfo.UDPEndpoints = $UDPEndpoints

    $EstablishedTCPConnections = (Get-NetTCPConnection | Where-Object {($_.State -eq "Established")})
    $networkInfo.EstablishedConnections = $EstablishedTCPConnections

    $networkInfo.DNSCache = Get-DnsClientCache

    return $networkInfo
}

function Get-NetworkObjects {
    $networkObjects = @{}
    
    $networkObjects.Shares = Get-SmbShare
    $networkObjects.Printers = Get-Printer
    $networkObjects.WirelessProfiles = (netsh wlan show profiles)

    return $networkObjects
}

function Get-InstalledSoftware {
    return Get-WmiObject -Class Win32_Product
}

function Get-ProcessList {
    return Get-CimInstance Win32_Process | Select-Object ProcessName,ProcessID,ParentProcessID,ExecutablePath
}

function Get-DriverList {
    return Get-WindowsDriver -Online -All | Select-Object Driver, BootCritical, OriginalFileName, Version, Date, ProviderName
}

function Get-UserFiles {
    $userFiles = @{}

    foreach($folder in Get-ChildItem -Path 'C:\Users') {
        if(Test-Path "C:\Users\$($folder.Name)\Documents") {
            $userFiles.Documents = Get-ChildItem -Path "C:\Users\$($folder.Name)\Documents" -Recurse -File
        }
        if(Test-Path "C:\Users\$($folder.Name)\Downloads") {
            $userFiles.Documents = Get-ChildItem -Path "C:\Users\$($folder.Name)\Downloads" -Recurse -File
        }
    }

    return $userFiles
}

function Get-Services {
    return Get-Service
}

