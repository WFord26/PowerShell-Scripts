
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
    Version History: 1.1
#>
Function Disable-HomeFolder {
    param (
        [Parameter(Mandatory = $true), ValueFromPipeline = $true, Position = 0, HelpMessage = "Please provide the path to the CSV file containing the users."]
        [string]$userFilePath,
        [Parameter(Mandatory = $false), Position = 1, HelpMessage = "Please provide the name of the Security Group to add the users to."]
        [string]$securityGroup,
        [Parameter(Mandatory = $false), Position = 2, HelpMessage = "Enable error logging."]
        [switch]$errorLog
    )
    # Conditional Parameter
    if ($errorLog) {
        # Location for the error log file
        $errorLogPath = "C:\Users\user\Documents\error.log"
        # Create error file if it doesn't exist
        if (-not (Test-Path -Path $errorLogPath)) {
            New-Item -Path $errorLogPath -ItemType File
        } else {
            Clear-Content -Path $errorLogPath
        }
        # create an array to store the errors, with headers NAME, UPN.
        $errors = @("NAME,UPN,ERROR")
    }
    # Check if the File exists
    if (-not (Test-Path -Path $userFilePath)) {
        Write-Host "File not found: $userFilePath" -ForegroundColor Red
        end
    }
    # Import the CSV file
    $users = Import-Csv -Path $userFilePath
    # Loop through each user in the CSV file
    foreach ($user in $users) {
        # Get the user from Active Directory
        $adUser = Get-ADUser -Filter {UserPrincipalName -eq $user.UserPrincipalName} -Properties homeDirectory
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
                $error = @( $user.Name, $user.UserPrincipalName, "USER IS NOT FOUND IN AD" )
                $errors += $error -join ","
            }
        }
    }
    # If the errorLog switch is enabled, write the errors to the error log file
    if ($errorLog) {
        $errors | Out-File -FilePath $errorLogPath
        Write-Host "Script is complete, any errors have logged to $errorLogPath"
    } else {
        Write-Host "Script is complete"
    }
}