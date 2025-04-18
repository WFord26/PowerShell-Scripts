function Disable-LicenseSubService {
    <#
    .SYNOPSIS
    Disable a license sub service for a user in Microsoft Graph.
    .DESCRIPTION
    This function disables a license sub service for a user in Microsoft Graph.
    .PARAMETER users
    The users to disable the license sub service for. Needs to be a PSObject with UserPrincipalName property.
    .PARAMETER service
    The service to disable the license sub service for.
    .EXAMPLE
    Disable-LicenseSubService -users $users -service "Yammer Enterprise"
    This example disables the Yammer Enterprise service for the specified users.
    .NOTES
    Need to be connected to Microsoft Graph with -Scopes User.ReadWrite.All, Organization.Read.All
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [PSObject[]]$users,
        [Parameter(Mandatory = $true)]
        [string[]]$service
    )
    # Get all SKUs for the tenant
    $allSKUs = Get-MgSubscribedSku -All
    $skuPartNumber = @()
    # For Each SKU find the $SkuPartNumber that have the service and store it in a variable
    foreach ($sku in $allSKUs) {
        $serviceSkus = $sku.ServicePlans | Where-Object { $_.ServicePlanName -eq $service }
        if ($serviceSkus) {
            $skuPartNumber += $sku.SkuPartNumber
            break
        }
    }

    foreach ($user in $users){
        # Get the current license for the user
        $userLicense = Get-MgUserLicenseDetail -UserId $user.UserPrincipalName
        # Check if the SKU contains the service
        $usrLic = @()
        foreach ($Sku in $userLicense){
            if ($Sku.SkuPartNumber -eq $skuPartNumber) {
                $usrLic += $Sku
            }
        }

        if ($usrLic.count -eq 0) {
            Write-Host "User $($user.UserPrincipalName) does not have the service in their licenses."
        } elseif ($usrLic.count -eq 1) {
            try {
                
                $disabledPlans = $usrLic.ServicePlans | Where-Object ServicePlanName -in $($service) | Select-Object -ExpandProperty ServicePlanId
                $addLicenses = @(
                    @{
                        SkuId = $usrLic.SkuId
                        DisabledPlans = $disabledPlans
                    }
                )
                Set-MgUserLicense -UserId $user.UserPrincipalName -AddLicenses $addLicenses -RemoveLicenses @() -ErrorAction SilentlyContinue
                Write-Host "User $($user.UserPrincipalName) has the service in their license: $($usrLic.SkuPartNumber) and has been removed."
            } catch {
                Write-Host "Error removing license for user $($user.UserPrincipalName): $_"
            }
        } elseif ($usrLic.count -gt 1) {
            foreach ($lic in $usrLic){
                try {
                    $disabledPlans = $lic.ServicePlans | Where-Object ServicePlanName -in $($service) | Select-Object -ExpandProperty ServicePlanId
                    $addLicenses =@(
                        @{
                            SkuId = $usrLic.SkuId
                            DisabledPlans = $disabledPlans
                        }
                    )
                    Set-MgUserLicense -UserId $user.UserPrincipalName -AddLicenses $addLicenses -RemoveLicenses @() -ErrorAction SilentlyContinue
                } catch {
                    Write-Host "Error removing license for user $($user.UserPrincipalName): $_"
                }
            }
        } else {
            Write-Host "User $($user.UserPrincipalName) does not have the service in their license."
        }
    }
}