# Create-AppRegistration.ps1

# Create a new Entra AD application registration
# Requires the AzureAD module

param (
    [string]$AppName,
    [string]$AppUri,
    [string]$TenantId,
    [switch]$DelegatedPermissions,
    [switch]$EnableAppPermissions,
    [string]$AppPermissionsFile
)


Function Connect-AAD {
    if (-not (Get-Module -Name AzureAD -ListAvailable)) {
        $null = Install-Module -Name AzureAD -Force -AllowClobber -Scope CurrentUser -ErrorAction SilentlyContinue
        Import-Module AzureAD
    } else {
        Import-Module AzureAD
    }

    Connect-AzureAD -TenantId $TenantId
}

Functiton Create-AppRegistration {
    param (
        [string]$AppName,
        [string]$AppUri
    )

    New-AzureADApplication -DisplayName $AppName -IdentifierUris $AppUri -AvailableToOtherTenants $false 
    $global:app = Get-AzureADApplication -Filter "DisplayName eq '$AppName'"
    New-AzureADServicePrincipal -AppId $app.AppId
}

# Add API permissions to the application
# Permissions needed:
# DeviceManagementApps.ReadWrite.All,
# DeviceManagementConfiguration.ReadWrite.All,
# DeviceManagementRBAC.ReadWrite.All,
# DeviceManagementServiceConfig.ReadWrite.All
# $AppPermissions = @("DeviceManagementApps.ReadWrite.All,DeviceManagementConfiguration.ReadWrite.All,DeviceManagementRBAC.ReadWrite.All,DeviceManagementServiceConfig.ReadWrite.All")
Function Add-ApiPermissions {
    param (
        [string[]]$AppPermissions
    )
    $AppPermissions = Import-Csv -Path $AppPermissionsFile
    $AppPermissions | ForEach-Object {
        # Get the permission from file
        $ApiPermission = $_.Permission

        $ApiPermissionID = (Get-AzureADServicePrincipal -Filter "DisplayName eq 'Microsoft Graph'").AppRoles | Where-Object { $_.Value -eq $permission } | Select-Object -ExpandProperty Id
        Add-AzAdAppPermission -ObjectId $app.AppId -PermissionId $ApiPermissionID -Type "Scope"
    }
Function Add-ApiPermission {
    param (
        [string]$ApiPermission

    )

    
    $api | New-AzureADServiceAppRole -AllowedMemberTypes Application -Description "Access $ApiPermission" -DisplayName $ApiPermission -Value $ApiPermission
}

Where-Object { $_.Value -eq $AppPermission } | Select-Object -ExpandProperty Id