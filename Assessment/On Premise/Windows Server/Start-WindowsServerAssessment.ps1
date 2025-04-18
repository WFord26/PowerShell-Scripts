function Start-WindowsServerAssessment {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [array]$servers,
        [Parameter(Mandatory=$false)]
        [switch]$getGPOs = $false,
        [Parameter(Mandatory=$false)]
        [switch]$getUsersAndGroups = $false,
        [Parameter(Mandatory=$false)]
        [string]$domain
    )
    write-host ""
    Write-Host "+============================================================+"
    Write-Host "|                                                            |"
    Write-Host "|                                                            |"
    Write-Host "|   ____                                                     |"
    Write-Host "|  / ___|  ___ _ ____   _____ _ __                           |"
    Write-Host "|  \___ \ / _ \ '__\ \ / / _ \ '__|                          |"
    Write-Host "|   ___) |  __/ |   \ V /  __/ |                             |"
    Write-Host "|  |____/ \___|_|    \_/ \___|_|                       _     |"
    Write-Host "|     / \   ___ ___  ___  ___ ___ _ __ ___   ___ _ __ | |_   |"
    Write-Host "|    / _ \ / __/ __|/ _ \/ __/ __| '_ ` _ \ / _ \ '_ \| __|  |"
    Write-Host "|   / ___ \\__ \__ \  __/\__ \__ \ | | | | |  __/ | | | |_   |"
    Write-Host "|  /_/   \_\___/___/\___||___/___/_| |_| |_|\___|_| |_|\__|  |"
    Write-Host "|                                                            |"
    Write-Host "|                                                            |"
    Write-Host "+============================================================+"
    Write-Host ""

    # pause for 2 seconds
    Start-Sleep 2


    <#
    # Check if the server list file exists
    if (-not (Test-Path -Path $serverList)) {
        Write-Host "The server list file does not exist."
        exit
    }

    # Check if the server list file is empty
    if ((Get-Content -Path $serverList).Count -eq 0) {
        Write-Host "The server list file is empty."
        exit
    }
    #>

    # Check if running as administrator
    if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Warning "You need to run this script as an administrator."
        exit
    }

    if ($null -eq $domain){
        # Check if the Active Directory module is installed
        if (-not (Get-Module -Name ActiveDirectory)) {
            Write-Host "The Active Directory module is not installed."
            $domain = Read-Host "Enter the domain name: (Example: contoso.com)"
        } else{
            # Get Domain Name
            $domain = Get-ADDomain | Select-Object -ExpandProperty DistinguishedName

            # Replace the DC= part of the domain name
            $domain = $domain -replace 'DC=', '' -replace ',', '.'
        }
    }

    # Get the hostname of the local machine
    $hostname = hostname

    # Define the Output folder
    $outputFolder = "C:\Temp\$($domain)_WinServer_Assessment"

    # Create the output folder if it doesn't exist
    if (-not (Test-Path -Path $outputFolder)) {
        try {
            New-Item -Path $outputFolder -ItemType Directory 
        } catch {
            Write-Host "Error creating the output folder: $($_.Exception.Message)"
            exit
        }
    }

    # Check if the output folder has contents and delete them
    if ((Get-ChildItem -Path $outputFolder).Count -gt 0) {
        Remove-Item -Path $outputFolder\* -Recurse -Force
        Write-Host "Removed all files in the output folder." -ForegroundColor Yellow
    }

    # Change to the output folder
    Set-Location -Path $outputFolder

    # Create a log file if logging is enabled
    $logfile = "$outputFolder\assessment_$($domain)_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"


    #### START LOGGING ####

    # Create an empty server array
    $serversInfo = @()

    # Create A Domain Controller Array
    $domainControllers = @()
    $primaryDomainController = @()

    # Create a Raw Data Folder if it doesn't exist
    if (-not (Test-Path -Path "$outputFolder\RawData")) {
        New-Item -Path "$outputFolder\RawData" -ItemType Directory
    } else {
        if ((Get-ChildItem -Path "$outputFolder\RawData").Count -gt 0) {
            # Remove all files in the RawData folder
            Remove-Item -Path "$outputFolder\RawData\*" -Force
            Write-Host "Removed all files in the RawData folder." -ForegroundColor Yellow
        }

    }

    Write-Host ""
    Write-Host "Starting Server Assessment for $($domain)..." -ForegroundColor Green

    # Loop through the servers
    foreach ($server in $servers) {
        Write-Host "Assessing $($server)..."
        # Check if the server is reachable
        if (-not (Test-Connection -ComputerName $server -Count 1 -Quiet)) {
            Write-Host "The server $($server) is not reachable." -ForegroundColor Red
            Write-Host "Skipping $($server)..." -ForegroundColor Red
            Write-Host ""
            Add-Content -Path $logfile -Value "The server $($server) is not reachable."
            continue
        } else {
            # SECTION 1: Get the server information
            # Get the server information
            # Export the server information to an array
            try {
                Write-Host "Server information for $($server):" -nonewline 
                # Try CIM first with timeout
                if ($hostname -ne $server) {
                    $cimSession = New-CimSession -ComputerName $server 
                    $serverInfo = Get-CimInstance -CimSession $cimSession -ClassName Win32_ComputerSystem 
                    $ipaddr = invoke-command -ComputerName $server {Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true } | Select-Object -ExpandProperty IPAddress}
                    $gateway = invoke-command -ComputerName $server {Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true } | Select-Object -ExpandProperty DefaultIPGateway}
                    $dnsIP = invoke-command -ComputerName $server {Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true } | Select-Object -ExpandProperty DNSServerSearchOrder}
                } else {
                    $serverInfo = Get-WmiObject -Class Win32_ComputerSystem 
                    $ipaddr = Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true } | Select-Object -ExpandProperty IPAddress
                    $gateway = Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true } | Select-Object -ExpandProperty DefaultIPGateway
                    $dnsIP = Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true } | Select-Object -ExpandProperty DNSServerSearchOrder
                }
                $serversInfo += [psobject]@{
                    ServerName = $server
                    Domain = $serverInfo.Domain
                    IP = $ipaddr
                    Gateway = $gateway
                    DNS = $dnsIP
                    Manufacturer = $serverInfo.Manufacturer
                    Model = $serverInfo.Model
                    SystemType = $serverInfo.SystemType
                    TotalPhysicalMemory = $serverInfo.TotalPhysicalMemory
                    NumberOfProcessors = $serverInfo.NumberOfProcessors
                    NumberOfLogicalProcessors = $serverInfo.NumberOfLogicalProcessors
                    DomainRole = $serverInfo.DomainRole
                    PartOfDomain = $serverInfo.PartOfDomain
                    Workgroup = $serverInfo.Workgroup
                    PrimaryOwnerName = $serverInfo.PrimaryOwnerName
                    UserName = $serverInfo.UserName
                    Organization = $serverInfo.Organization
                    Roles = $roles | Where-Object { $_.Installed -eq $true } | Select-Object -ExpandProperty Name
                    Status = $serverInfo.Status
                }
                Add-Content -Path $logfile -Value "Successfully retrieved server information for $($server)"
                Write-Host " Done." -ForegroundColor Green
            } catch [System.Runtime.InteropServices.COMException]{
                Write-Host " Error. -See Log File for Details." -ForegroundColor Red
                Add-Content -Path $logfile -Value "Error getting server information for $($server): $($_.Exception.Message)"
            }

            # SECTION 2: Get the server roles and features
            # Get the installed roles and features
            # Export the roles and features to a CSV file
            try {
                Write-Host "Installed roles and features on $($server):" -NoNewline
                if ($hostname -ne $server) {
                    $roles = invoke-command -ComputerName $server {Get-WindowsFeature}
                } else {
                    $roles = Get-WindowsFeature
                }
                # Export the roles and features to a CSV file
                $roles | Select-Object -Property Name, DisplayName, Description, Installed, FeatureType, Path, Parent | Export-Csv -Path "RawData\roles_$($server).csv" -NoTypeInformation
                Add-Content -Path $logfile -Value "Successfully retrieved roles and features for $($server)"
                # If no errors, write Done in Green
                Write-Host " Done." -ForegroundColor Green
            } catch [System.Runtime.InteropServices.COMException] {
                Write-Host "Error. -See Log File for Details." -ForegroundColor Red
                Add-Content -Path $logfile -Value "Error getting roles and features for $($server): $($_.Exception.Message)"
            }

            # SECTION 3: Get the services
            # Get the status of the services
            try {
                Write-Host "Service status on $($server):" -nonewline
                if ($hostname -ne $server) {
                    $services = Invoke-Command -ComputerName $server {Get-Service}
                } else {
                    $services = Get-Service
                }
                $services | Select-Object -Property Name, DisplayName, Status, StartType, ServiceType, CanPauseAndContinue, CanShutdown, CanStop, DependentServices | Export-Csv -Path "RawData\services_$($server).csv" -NoTypeInformation
                Add-Content -Path $logfile -Value "Successfully retrieved service status for $($server)"
                # If no errors, write Done in Green
                Write-Host " Done." -ForegroundColor Green
            } catch {
                Write-Host "Error. -See Log File for Details." -ForegroundColor Red
                Add-Content -Path $logfile -Value "Error getting service status for $($server): $($_.Exception.Message)"
            }

            # SECTION 4: Check if the server is a domain controller
            # Check if the server is a domain controller
            try {
                $isDomainController = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $server | Select-Object -ExpandProperty DomainRole
                if ($isDomainController -ge 4) {
                    Write-Host "$server is a domain controller, adding:" -nonewline
                    $domainControllers += @{
                        ServerName = $server
                        DomainRole = $serverInfo.DomainRole
                        PartOfDomain = $serverInfo.PartOfDomain
                        Workgroup = $serverInfo.Workgroup
                        PrimaryOwnerName = $serverInfo.PrimaryOwnerName
                        UserName = $serverInfo.UserName
                        Organization = $serverInfo.Organization
                        Roles = $serverInfo.Roles
                        Status = $serverInfo.Status
                    }
                    Add-Content -Path $logfile -Value "$server is a domain controller."
                    if ($isDomainController -eq 5) {
                        $primaryDomainController += $server
                        Add-Content -Path $logfile -Value "$server is the primary domain controller."
                    }
                    write-host " Done." -ForegroundColor Green
                } else {
                    Add-Content -Path $logfile -Value "$server is not a domain controller."
                }
            } catch {
                Write-Host "Error checking domain controller status for $($server): $($_.Exception.Message)"
                Add-Content -Path $logfile -Value "Error checking domain controller status for $($server): $($_.Exception.Message)"
            }
            
            #SECTION 5: Check DNS is installed
            # Check if DNS is installed
            # Get the DNS zones and records
            # Export the DNS zones and records to CSV files
            $dnsInstalled = $roles | Where-Object { $_.Name -eq 'DNS' -and $_.Installed -eq $true }
            if ($dnsInstalled) {
                Add-Content -Path $logfile -Value "DNS is installed on $server."

                # Get the DNS zones
                Write-Host "DNS zones on $($server):" -nonewline
                try {
                    if ($hostname -ne $server) {
                        Write-verbose " Getting DNS zones on $($server)" -nonewline
                        $dnsZones = Invoke-Command -ComputerName $server {Get-DnsServerZone}
                    } else {
                        Write-Verbose " Getting DNZ zone locally" - nonewline
                        $dnsZones = Get-DnsServerZone
                    }
                    $dnsZones | Select-Object -Property ZoneName, ZoneType, IsAutoCreated, IsDsIntegrated, IsReverseLookupZone, IsSigned, IsPaused, IsShutdown, IsDirectoryPartition, IsReadOnly | Export-Csv -Path "RawData\dns_zones_$($server).csv" -NoTypeInformation
                    Add-Content -Path $logfile -Value "Successfully retrieved DNS zones for $($server)"
                    Write-Host " Done." -ForegroundColor Green
                } catch {
                    Write-Host " Error. -See Log File for Details." -ForegroundColor Red
                    Add-Content -Path $logfile -Value "Error getting DNS zones for $($server): $($_.Exception.Message)"
                }

                ForEach ($zone in $dnsZones) {
                    try {
                        Write-Host "DNS records on $($zone):" -nonewline
                        # Get the DNS records
                        if ($hostname -ne $server) {
                            $dnsRecords = Invoke-Command -ComputerName $server {Get-DnsServerResourceRecord -ZoneName $zone.ZoneName}
                        } else {
                            $dnsRecords = Get-DnsServerResourceRecord -ZoneName $zone.ZoneName
                        }
                        $dnsRecords | Export-Csv -Path "RawData\dns_records_$($server)_$($zone.ZoneName).csv" -NoTypeInformation
                        Add-Content -Path $logfile -Value "Successfully retrieved DNS records for zone $($zone.ZoneName) on $($server)"
                        Write-Host " Done." -ForegroundColor Green
                    } catch {
                        Write-Host " Error. -See Log File for Details." -ForegroundColor Red
                        Add-Content -Path $logfile -Value "Error getting DNS records for zone $($zone.ZoneName) on $($server): $($_.Exception.Message)"
                    }
                }
            } else {
                Add-Content -Path $logfile -Value "DNS is not installed on $server."
            }

            # SECTION 6: Check if DHCP is installed
            # Check if DHCP is installed
            # Get the DHCP scopes
            # Export the DHCP scopes to a CSV file
            $dhcpInstalled = $roles | Where-Object { $_.Name -eq 'DHCP' -and $_.Installed -eq $true }
            if ($dhcpInstalled) {
                Add-Content -Path $logfile -Value "DHCP is installed on $server."

                # Get the DHCP scopes
                try {
                    if ($hostname -ne $server) {
                        $dhcpScopes = Invoke-Command -ComputerName $server {Get-DhcpServerv4Scope}
                    } else {
                        $dhcpScopes = Get-DhcpServerv4Scope
                    }
                    Write-Host "DHCP scopes on $($server):"
                    $dhcpScopes | Select-Object -Property ScopeId, Name, SubnetMask, StartRange, EndRange, LeaseDuration, State | Export-Csv -Path "RawData\dhcp_scopes_$($server).csv" -NoTypeInformation
                    Add-Content -Path $logfile -Value "Successfully retrieved DHCP scopes for $($server)"
                } catch {
                    Write-Host "Error getting DHCP scopes for $($server): $($_.Exception.Message)"
                    Add-Content -Path $logfile -Value "Error getting DHCP scopes for $($server): $($_.Exception.Message)"
                }
            } else {
                Add-Content -Path $logfile -Value "DHCP is not installed on $server."
            }

            # SECTION 7: Check if File Services is installed
            # Check if File Services is installed
            # Get the shared folders
            # Export the shared folders to a CSV file
            $fileServicesInstalled = $roles | Where-Object { $_.Name -eq 'File-Services' -and $_.Installed -eq $true }
            if ($fileServicesInstalled) {
                Add-Content -Path $logfile -Value "File Services is installed on $server."

                # Get the shared folders
                try {
                    if ($hostname -ne $server) {
                        $sharedFolders = Invoke-Command -ComputerName $server {Get-SmbShare}
                    } else {
                        $sharedFolders = Get-SmbShare
                    }
                    Write-Host "Shared folders on $($server):" -nonewline
                    $sharedFolders | Select-Object -Property Name, Path, Description, ScopeName, CimSession, ShareType, ShareState, PSComputerName | Export-Csv -Path "RawData\shared_folders_$($server).csv" -NoTypeInformation
                    Add-Content -Path $logfile -Value "Successfully retrieved shared folders for $($server)"
                    Write-Host " Done." -ForegroundColor Green
                } catch {
                    Write-Host " Error. -See Log File for Details." -ForegroundColor Red
                    Add-Content -Path $logfile -Value "Error getting shared folders for $($server): $($_.Exception.Message)"
                }
            } else {
                Add-Content -Path $logfile -Value "File Services is not installed on $server."
            }

            # SECTION 8: Check if Hyper-V is installed
            # Check if Hyper-V is installed
            # Get the virtual machines
            # Export the virtual machines to a CSV file
            $hyperVInstalled = $roles | Where-Object { $_.Name -eq 'Hyper-V' -and $_.Installed -eq $true }
            if ($hyperVInstalled) {
                Add-Content -Path $logfile -Value "Hyper-V is installed on $server."

                # Get the virtual machines
                try {
                    Write-Host "Virtual machines on $($server):" -nonewline
                    if ($hostname -ne $server) {
                        $virtualMachines = Invoke-Command -ComputerName $server {Get-VM}
                    } else {
                        $virtualMachines = Get-VM -ComputerName $server
                    }
                    $virtualMachines | Export-Csv -Path "RawData\virtual_machines_$($server).csv" -NoTypeInformation
                    Add-Content -Path $logfile -Value "Successfully retrieved virtual machines for $($server)"
                    Write-Host " Done." -ForegroundColor Green
                } catch {
                    Write-Host " Error. -See Log File for Details." -ForegroundColor Red
                    Add-Content -Path $logfile -Value "Error getting virtual machines for $($server): $($_.Exception.Message)"
                }
            } else {
                Add-Content -Path $logfile -Value "Hyper-V is not installed on $server."
            }

            #SECTION 9: Check if Web Server is installed
            # Check if Web Server is installed
            # Get the websites
            # Export the websites to a CSV file
            $webServerInstalled = $roles | Where-Object { $_.Name -eq 'Web-Server' -and $_.Installed -eq $true }
            if ($webServerInstalled) {
                Write-Host "Websites on $($server):" -nonewline
                # Get the websites
                if ($hostname -ne $server) {
                    $websites = Invoke-Command -ComputerName $server {Get-Website}
                } else {
                    $websites = Get-Website
                }
                $websites | Select-Object -Property Name, State, PhysicalPath, ApplicationPool, Bindings, SSLFlags, PSComputerName | Export-Csv -Path "RawData\websites_$($server).csv" -NoTypeInformation
                Write-Host " Done." -ForegroundColor Green
            } 
            # SECTION 10: Check if Print Services is installed
            # Check if Print Services is installed
            # Get the printers
            # Export the printers to a CSV file
            $printServicesInstalled = $roles | Where-Object { $_.Name -eq 'Print-Services' -and $_.Installed -eq $true }
            try{
                if ($printServicesInstalled) {
                    Write-Host "Printers on $($server):" -nonewline
                    if ($hostname -ne $server) {
                        # Check if Service is running
                        $printServiceRunning = Invoke-Command -ComputerName $server {Get-Service -Name Spooler}
                        if ($printServiceRunning.Status -eq 'Running') {
                            $printers = Invoke-Command -ComputerName $server {Get-Printer}
                        } else {
                            # Start the Print Spooler Service
                            Invoke-Command -ComputerName $server {Start-Service -Name Spooler}
                            Start-Sleep -Seconds 5
                            $printers = Invoke-Command -ComputerName $server {Get-Printer}
                            # Stop service 
                            Invoke-Command -ComputerName $server {Stop-Service -Name Spooler}
                        }
                        
                    } else {
                        $printServiceRunning = Get-Service -Name Spooler
                        if ($printServiceRunning.Status -eq 'Running') {
                            $printers = Get-Printer
                        } else {
                            # Start the Print Spooler Service
                            Start-Service -Name Spooler
                            Start-Sleep -Seconds 5
                            $printers = Get-Printer
                            # Stop service 
                            Stop-Service -Name Spooler
                        }
                    }
                    # Get the printers        
                    $printers | Select-Object -Property Name, DriverName, PortName, Shared, Published, Location, Comment, PSComputerName | Export-Csv -Path "RawData\printers_$($server).csv" -NoTypeInformation
                    Write-Host " Done." -ForegroundColor Green
                }
            } catch {
                Write-Host " Error. -See Log File for Details." -ForegroundColor Red
                Add-Content -Path $logfile -Value "Error getting printers for $($server): $($_.Exception.Message)"
            }
            <#
            # SECTION 11: Check if Remote Desktop Services is installed
            # Check if Remote Desktop Services is installed
            # Get the Remote Desktop Services roles
            # Export the Remote Desktop Services roles to a CSV file
            $remoteDesktopServicesInstalled = $roles | Where-Object { $_.Name -eq 'RDS-RD-Server' }
            if ($remoteDesktopServicesInstalled) {

                # Get the Remote Desktop Services roles
                $remoteDesktopServicesRoles = Get-WindowsFeature -ComputerName $server | Where-Object { $_.Installed -eq $true -and $_.FeatureType -eq 'Role' -and $_.Name -like 'RDS-*' }
                Write-Host "Remote Desktop Services roles on $($server):"
                $remoteDesktopServicesRoles | ConvertTo-Json
                $remoteDesktopServicesRoles | ConvertFrom-Json | Format-Table -AutoSize
                $remoteDesktopServicesRoles | Select-Object -Property Name, DisplayName, Description, Installed, FeatureType, Path, Parent | Export-Csv -Path "RawData\remote_desktop_services_roles_$($server).csv" -NoTypeInformation
            } else {
                Write-Host "Remote Desktop Services is not installed on $server."
            }
            #>

            # SECTION 12: Get the installed software
            # Get the installed software
            # Export the installed software to a CSV file
            try{
                Write-Host "Installed software on $($server):" -nonewline
                if ($hostname -ne $server) {
                    # Try CIM first with timeout
                    $cimSession = New-CimSession -ComputerName $server 
                    $software = Get-CimInstance -CimSession $cimSession -ClassName Win32_Product 
                } else {
                    $software = Get-WmiObject -Class Win32_Product
                }
                # Export the installed software to a CSV file
                $software | Select-Object -Property Name, Version, Vendor, InstallDate, InstallLocation, InstallState, PackageCache, PSComputerName | Export-Csv -Path "RawData\software_$($server).csv" -NoTypeInformation
                Add-Content -Path $logfile -Value "Successfully retrieved installed software for $($server)"
                Write-Host " Done." -ForegroundColor Green
            } catch [System.Runtime.InteropServices.COMException] {
                Write-Host " Error. -See Log File for Details." -ForegroundColor Red
                Add-Content -Path $logfile -Value "Error getting installed software for $($server): $($_.Exception.Message)"
            }
            # SECTION 13: Get the disk space
            # Get the disk space
            # Export the disk space to a CSV file
            try {
                Write-Host "Disk space on $($server):" -nonewline
                if ($hostname -ne $server) {
                    # Try CIM first with timeout
                    $cimSession = New-CimSession -ComputerName $server 
                    $diskSpace = Get-CimInstance -CimSession $cimSession -ClassName Win32_LogicalDisk 
                } else {
                    $diskSpace = Get-WmiObject -Class Win32_LogicalDisk
                }
                # Export the disk space to a CSV file
                $diskSpace | Select-Object -Property DeviceID, DriveType, ProviderName, VolumeName, Size, FreeSpace, PSComputerName | Export-Csv -Path "RawData\disk_space_$($server).csv" -NoTypeInformation
                Add-Content -Path $logfile -Value "Successfully retrieved disk space for $($server)"
                Write-Host " Done." -ForegroundColor Green
            } catch [System.Runtime.InteropServices.COMException] {
                Write-Host " Error. -See Log File for Details." -ForegroundColor Red
                Add-Content -Path $logfile -Value "Error getting disk space for $($server): $($_.Exception.Message)"
            }

            
            # SECTION 14: Get the network adapters
            # Get the network adapters
            # Export the network adapters to a CSV file
            try {
                Write-Host "Network adapters on $($server):" -nonewline
                if ($hostname -ne $server) {
                    # Try CIM first with timeout
                    $cimSession = New-CimSession -ComputerName $server 
                    $networkAdapters = Get-CimInstance -CimSession $cimSession -ClassName Win32_NetworkAdapter 
                } else {
                    $networkAdapters = Get-WmiObject -Class Win32_NetworkAdapter
                }
                # Export the network adapters to a CSV file
                $networkAdapters | Select-Object -Property Name, AdapterType, AdapterTypeID, DeviceID, InterfaceIndex, MACAddress, Manufacturer, NetConnectionID, NetEnabled, PhysicalAdapter, Speed, Status, PSComputerName | Export-Csv -Path "RawData\network_adapters_$($server).csv" -NoTypeInformation
                Add-Content -Path $logfile -Value "Successfully retrieved network adapters for $($server)"
                Write-Host " Done." -ForegroundColor Green
            } catch [System.Runtime.InteropServices.COMException] {
                Write-Host " Error. -See Log File for Details." -ForegroundColor Red
                Add-Content -Path $logfile -Value "Error getting network adapters for $($server): $($_.Exception.Message)"
            }

            # SECTION 15: Check if ADCS is installed
            # Check if ADCS is installed
            # If it is installed get reports on what is running
            # Get Cert environment information
            $adcsInstalled = $roles | Where-Object { $_.Name -Contains 'ADCS-Cert-Authority' -and $_.Installed -eq $true }
            if ($adcsInstalled) {
                Write-Host "ADCS is installed, reviwing the configuration on $($server)."
                Add-Content -Path $logfile -Value "ADCS is installed on $server."
                
                # Get the ADCS information using https://github.com/PKISolutions/PSPKI
                try {
                    Write-Host "|-ADCS information on $($server):" -nonewline
                    if ($hostname -ne $server) {
                        # check if PSPKI is installed
                        if (-not (Invoke-Command -ComputerName $server {Get-Module -Name PSPKI})) {
                            Add-Content -Path $logfile -Value "PSPKI module is not installed on $server."
                            # Attempt to install 
                            try {
                                Invoke-Command -ComputerName $server {Install-Module -Name PSPKI -Force -AllowClobber -Scope CurrentUser -ErrorAction Stop}
                                Add-Content -Path $logfile -Value "PSPKI module installed on $server."
                            } catch {
                                Add-Content -Path $logfile -Value "Error installing PSPKI module on $($server): $($_.Exception.Message)"
                            }
                        }
                        $adcsInfo = Invoke-Command -ComputerName $server {Get-CertificationAuthority}
                    } else {
                        # check if PSPKI is installed
                        if (-not (Get-Module -Name PSPKI)) {
                            Add-Content -Path $logfile -Value "PSPKI module is not installed on $server."
                            # Attempt to install 
                            try {
                                Install-Module -Name PSPKI -Force -AllowClobber -Scope CurrentUser -ErrorAction Stop
                                Add-Content -Path $logfile -Value "PSPKI module installed on $server."
                            } catch {
                                Add-Content -Path $logfile -Value "Error installing PSPKI module on $($server): $($_.Exception.Message)"
                            }
                        $adcsInfo = Get-CertificationAuthority
                        }
                    }
                    $adcsInfo |  Export-Csv -Path "RawData\adcs_info_$($server).csv" -NoTypeInformation
                    Add-Content -Path $logfile -Value "Successfully retrieved ADCS information for $($server)"
                    Write-Host " Done." -ForegroundColor Green
                } catch {
                    Write-Host " Error. -See log file for details." -ForegroundColor Red
                    Add-Content -Path $logfile -Value "Error getting ADCS information for $($server): $($_.Exception.Message)"
                }

                # Get the ADCS templates
                try {
                    Write-Host "|-ADCS templates on $($server):" -nonewline
                    if ($hostname -ne $server) {
                        $adcsTemplates = Invoke-Command -ComputerName $server {Get-CertificateTemplate}
                    } else {
                        $adcsTemplates = Get-CertificateTemplate
                    }
                    $adcsTemplates | Export-Csv -Path "RawData\adcs_templates_$($server).csv" -NoTypeInformation
                    Add-Content -Path $logfile -Value "Successfully retrieved ADCS templates for $($server)"
                    Write-Host " Done." -ForegroundColor Green
                } catch {
                    Write-Host " Error. -See log file for details." -ForegroundColor Red
                    Add-Content -Path $logfile -Value "Error getting ADCS templates for $($server): $($_.Exception.Message)"
                }

                # Get-ExtensionList
                foreach ($CA in $adcsInfo) {
                    try {
                        Write-Host "|-ADCS extensions on $($CA.Name):" -nonewline
                        if ($hostname -ne $server) {
                            $adcsExtensions = Invoke-Command -ComputerName $server {Get-CertificationAuthority -Name $($CA.Name) | Get-ExtensionList}
                        } else {
                            $adcsExtensions = Get-CertificationAuthority -Name $($CA.Name) | Get-ExtensionList
                        }
                        $adcsExtensions | Select-Object -Property Name, @{Name="EnabledExtensions";Expression={$_.EnabledExtensionList -join ","}}, @{Name="OfflineExtensions";Expression={$_.OfflineExtensionList -join ","}}, @{Name="DisabledExtensions";Expression={$_.DisabledExtensionList -join ","}} | Export-Csv -Path "RawData\adcs_extensions_$($server)_$($CA.Name).csv" -NoTypeInformation
                        Add-Content -Path $logfile -Value "Successfully retrieved ADCS extensions revocation lists for $($server)"
                        Write-Host " Done." -ForegroundColor Green
                    } catch {
                        Write-Host " Error. -See log file for details." -ForegroundColor Red
                        Add-Content -Path $logfile -Value "Error getting ADCS cextensions for $($server): $($_.Exception.Message)"
                    }  
                }              
            } else {
                Add-Content -Path $logfile -Value "ADCS is not installed on $server."
            }
            Write-Host ""
        }
    }

    Write-Host "Server Assessment Complete" -ForegroundColor Green
    write-host ""

    try {
        Write-Host "Exporting server information to CSV file:" -nonewline
        # Export the server information to a CSV file
        # Convert hashtables to PSCustomObjects
        $serversInfoFormatted = $serversInfo | ForEach-Object {
            [PSCustomObject]@{
                ServerName = $_.ServerName
                Domain = $_.Domain
                Manufacturer = $_.Manufacturer
                Model = $_.Model
                SystemType = $_.SystemType
                TotalPhysicalMemory = $_.TotalPhysicalMemory
                NumberOfProcessors = $_.NumberOfProcessors
                NumberOfLogicalProcessors = $_.NumberOfLogicalProcessors
                IP = $_.IP
                Gateway = $_.Gateway
                DNS = $_.DNS

                DomainRole = $_.DomainRole
                PartOfDomain = $_.PartOfDomain
                Workgroup = $_.Workgroup
                PrimaryOwnerName = $_.PrimaryOwnerName
                UserName = $_.UserName
                Organization = $_.Organization
                Status = $_.Status
            }
        }
        # Export the formatted data to CSV
        $serversInfoFormatted | Export-Csv -Path "combined_servers_info_$($domain).csv" -NoTypeInformation
        Add-Content -Path $logfile -Value "Exported server information to combined_servers_info_$($domain).csv"
        Write-Host " Done." -ForegroundColor Green
    } catch {
        Write-Host " Error. -See Log File for Details." -ForegroundColor Red
        Add-Content -Path $logfile -Value "Error exporting server information: $($_.Exception.Message)"
    }
    try {
        write-host "Exporting domain controllers to CSV file:" -nonewline
        # Export the domain controllers to a CSV file
        $domainControllers | Export-Csv -Path "domain_controllers_$($domain).csv" -NoTypeInformation
        Add-Content -Path $logfile -Value "Exported domain controllers to domain_controllers_$($domain).csv"
        Write-Host " Done." -ForegroundColor Green
    } catch {
        Write-Host " Error. -See Log File for Details." -ForegroundColor Red
        Add-Content -Path $logfile -Value "Error exporting domain controllers: $($_.Exception.Message)"
    }

    if ($getGPOs) {
        #Get GPOs
        # Get Check if running from the Primary Domain Controller
        try{
            Write-Host "Getting Group Policy Objects:" -nonewline
            if ($hostname -ne $primaryDomainController) {
                Write-Verbose "Running on $($hostname). Getting GPOs from $($primaryDomainController)"
                $gpos = Invoke-Command -ComputerName $primaryDomainController {Get-GPO -All}
            } else {
                Write-Verbose "Running on $($hostname). Getting GPOs locally"
                $gpos = Get-GPO -All
            }
            Write-Host " Done." -ForegroundColor Green
        } catch {
            Write-Host " Error. -See Log File for Details." -ForegroundColor Red
        }
        try{
            Write-Host "Exporting Group Policy Objects:" -nonewline
            $gpos | Select-Object -Property DisplayName, Id, GpoStatus, CreationTime, ModificationTime, Description, PSComputerName | Export-Csv -Path "group_policy_objects_$($domain).csv" -NoTypeInformation
            foreach ($gpo in $gpos) {
                # Check if Display Name is not empty
                if ($gpo.DisplayName -ne "") {
                    $gpo | Get-GPOReport -ReportType HTML -Path "$($outputFolder)\RawData\gpo_web_$($gpo.DisplayName).html"
                    $gpo | Get-GPOReport -ReportType XML -Path "$($outputFolder)\RawData\gpo_$($gpo.DisplayName).xml"
                } else {
                    $gpo | Get-GPOReport -ReportType HTML -Path "$($outputFolder)\RawData\gpo_web_$($gpo.Id).html"
                    $gpo | Get-GPOReport -ReportType XML -Path "$($outputFolder)\RawData\gpo_$($gpo.Id).xml"
                }
            }
            Add-Content -Path $logfile -Value "Exported Group Policy Objects to RawData\group_policy_objects_$($domain).csv"
            Write-Host " Done." -ForegroundColor Green
        } catch {
            Write-Host " Error. -See Log File for Details." -ForegroundColor Red
            Add-Content -Path $logfile -Value "Error exporting Group Policy Objects: $($_.Exception.Message)"
        }
    }
    # Combine the raw data CSV files
    Combine-ServerRawData -logfile $logfile

    # Get the Users and Groups Information
    if ($getUsersAndGroups) {
        Export-UserandGroups -logfile $logfile -domain $domain -outputFolder $outputFolder -hostname $hostname
    }
    

    # End of script
}