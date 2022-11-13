<#
.Synopsis
  Get all rules from users mailboxes

.DESCRIPTION
  This script will do the following.
  - Check if directory exists then creates one
  - Creats an array with all users 
  - Checks for users mailboxes for rules and exports them if the exist to CSV
  - Writes output where files are located.
   
.NOTES
  Name: Get-MailboxRules
  Author: W. Ford
  Version: 1.1
  DateCreated: nov 2022
  Change: Added parameter, added if statement for file creation 
.EXAMPLE
  .\Get-MailboxRules.ps1 -outDIR C:\script\

#>

param(
  [Parameter(
    Mandatory = $false,
    HelpMessage = "Enter path to where you would like your exported csv file to be. (Default $home\script\mail)"
  )]
  [string]$outDIR = "$home\script\mail"
)
Connect-ExchangeOnline -
#Checks if directory exists then creates it.
if (Test-Path $outDIR){
    Write-Host "Folder Exist"
    Write-Host $outDIR
} else {
    md $outDIR
}
#Creates array with all mailboxes in tenant
$users = (get-mailbox -resultsize unlimited).UserPrincipalName

#Checks each user for mailbox rules and exports all rules to a CSV file 
foreach ($user in $users)
{
Get-InboxRule -Mailbox $user | Select-Object MailboxOwnerID,Name,Description,Enabled,RedirectTo, MoveToFolder,ForwardTo | Export-CSV $outDIR\RulesOutput.csv -NoTypeInformation -Append
}

#Write out to message on console
Write-Host "File Export Complete"
Write-Host "Files can be found here - $outDIR"