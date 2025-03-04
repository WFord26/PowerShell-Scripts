
<#
.SYNOPSIS
    Disable Home Folder for users in Active Directory, and add them to a Secrutiy Group
.DESCRIPTION
    This script will disable the Home Folder for users in Active Directory, and add them to a Security Group.
    The script will read a CSV file with the following headers: Name, UserPrincipalName
    The script will then disable the Home Folder for each user in the CSV file.
    If the user is not found in Active Directory, the script will write the user's Name and UserPrincipalName to an error log file.
    The error log file will be created in the same directory as the script, and will be named error.log
    The error log file will have the following headers: NAME, UPN, ERROR
    The script will output a message to the console when it is complete.
    The script requires the Active Directory module to be installed.
.PARAMETER userFilePath
    The path to the CSV file containing the users to disable the Home Folder for.
.PARAMETER errorLog
    Switch to enable error logging.
.EXAMPLE
    Disable-HomeFolder -userFilePath "C:\Users\user\Documents\users.csv"
    This example will disable the Home Folder for the users in the CSV file located at "C:\Users\user\Documents\users.csv"
.EXAMPLE
    Disable-HomeFolder -userFilePath "C:\Users\user\Documents\users.csv" -errorLog
    This example will disable the Home Folder for the users in the CSV file located at "C:\Users\user\Documents\users.csv"
    and log any errors to an error log file.
.EXAMPLE
    Disable-HomeFolder -userFilePath "C:\Temp\users.csv" -errorLog -securityGroup "SG-TestUser"
    This example will disable the Home Folder for the users in the CSV file located at "C:\Temp\users.csv",
    add users to the "SG-TestUser" securit group, and log any errors to an error log file.
.NOTES
    File Name      : Disable-HomeFolder.ps1
    Author         : William Ford (@WFord26)
    Date           : 2024-07-11
    Prerequisite   : PowerShell V2
    Version History: 1.2
#>
Function Disable-HomeFolder {
    param (
        [parameter(
            Mandatory = $true,
            HelpMessage = "Enter the path to the CSV file containing the users to disable the Home Folder for."
        )]
        [ValidateScript({Test-Path $_ -PathType 'Leaf'})]
        [string]$userFilePath,
        [switch]$errorLog,
        [string]$securityGroup
    )
    begin {
        # Import the Active Directory Module if it doesn't exist.
        if (-not (Get-Module -Name ActiveDirectory)) {
            Import-Module ActiveDirectory
        }
        # Check if the errorLog switch is enabled
        if ($errorLog) {
            Write-Host "Error logging is enabled"
            # Default location for the error log file
            $errorLogPath = ".\error.log"
            # Create error file if it doesn't exist
            if (-not (Test-Path -Path $errorLogPath)) {
                New-Item -Path $errorLogPath -ItemType File
            } else {
                # Clear the error log file if it exists
                Clear-Content -Path $errorLogPath
            }    
            $errors = @("NAME,UPN,ERROR")
            } else {
               Write-Host "Error logging is disabled"
            }
        }
    process {
        # Import the CSV file
        $users = Import-Csv -Path $userFilePath
        # Confirm file has a header with UserPrincipalName
        if ($users[0].PSObject.Properties.Name -notcontains "UserPrincipalName") {
            Write-Host "CSV file must have a header with UserPrincipalName"
            break
        }
        # Loop through each user in the CSV file
        foreach ($user in $users) {
            # Get the user from Active Directory
            $adUser = Get-ADUser -Identity $user.UserPrincipalName -Properties homeDirectory
            # If the user is found in Active Directory
            if ($adUser) {
                # Disable the Home Folder for the user
                Set-ADUser -Identity $adUser -HomeDrive "H:" -HomeDirectory $null
                Write-Host "Home Folder disabled for: $($user.UserPrincipalName)"
                # Add the user to the Security Group if one is provided
                if ($securityGroup) {
                    Add-ADGroupMember -Identity $securityGroup -Members $adUser
                    Write-Host "User added to Security Group: $($securityGroup)"
                }
            
            } else {
                # If the user is not found in Active Directory write a message to the console.
                Write-Host "User not found in AD: $($user.UserPrincipalName)"
                # Log the error if the errorLog switch is enabled
                if ($errorLog) {
                    $errorLogEntry = @( $user.Name, $user.UserPrincipalName, "USER IS NOT FOUND IN AD" )
                    $errors += $errorLogEntry -join ","
                }
            }
        }
    }
    end {
        # If the errorLog switch is enabled, write the errors to the error log file
        if ($errorLog) {
            $errors | Out-File -FilePath $errorLogPath
            Write-Host "Script is complete, any errors have logged to $errorLogPath"
        } else {
            Write-Host "Script is complete"
        }
}
}