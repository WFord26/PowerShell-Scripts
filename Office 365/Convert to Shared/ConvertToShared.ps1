Import-Module ExchangeOnlineManagement
Connect-ExchangeOnline


Get-Content ".\UsersToShared.txt" | ForEach-Object {
    Set-Mailbox $_ -Type Shared
}
#Clean UP Session
Get-PSSession | Remove-PSSession
