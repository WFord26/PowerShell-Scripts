function Set-MailboxForwarder {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Mailbox,
        [Parameter(Mandatory = $false)]
        [string]$ForwardingAddress,
        [Parameter(Mandatory = $false)]
        [Switch]$StoreandForward,
        [Parameter(Mandatory = $false)]
        [Switch]$DisableForwarding,
        [Parameter(Mandatory = $false)]
        [Switch]$Update,
        [Parameter(Mandatory = $false)]
        [Switch]$whatIf
    )
    try {
        # Check if the mailbox exists
        $mbox = Get-Mailbox -Identity $Mailbox -ErrorAction Stop
    } catch {
        Write-Error "Mailbox '$Mailbox' not found."
        return
    }
    if ($mbox) {
        $FWDSMTP = $null
        if ($DisableForwarding) {
            if ($whatIf){
                try{
                    # Disable forwarding
                    Set-Mailbox -Identity $Mailbox -ForwardingSmtpAddress $null -DeliverToMailboxAndForward $false -WhatIf
                    Write-Host "Forwarding disabled for mailbox '$Mailbox'."
                    return
                } catch {
                    Write-Error "Failed to disable forwarding for mailbox '$Mailbox'."
                    return
                }
            } else {
                try{
                    # Disable forwarding
                    Set-Mailbox -Identity $Mailbox -ForwardingSmtpAddress $null -DeliverToMailboxAndForward $false
                    Write-Host "Forwarding disabled for mailbox '$Mailbox'."
                    return
                } catch {
                    Write-Error "Failed to disable forwarding for mailbox '$Mailbox'."
                    return
                }
            }
        }
        $params = @{}
        # Check if $update is set
        if ($update) {
            # if Set take current settings
            $FWDSMTP = $mbox.ForwardingSmtpAddress
            # Confirm if $FWDSMTP is null
            if ($null -eq $FWDSMTP) {
                Write-Error "Forwarding address is not currently set for $Mailbox."
                return
            } else {
                $FWDSMTP = $FWDSMTP.Replace("smtp:","")
                $params += @{ "ForwardingSmtpAddress" = $FWDSMTP }
            }
        } else {
            if ($null -eq $ForwardingAddress) {
                Write-Error "Forwarding address is required."
                return
            } else {
                $FWDSMTP = $ForwardingAddress
                $params += @{ "ForwardingSmtpAddress" = $FWDSMTP }
            }
        }
        # Check if $storeandforward is set
        if ($storeandforward) {
            $params += @{ "DeliverToMailboxAndForward" = $true }
        } else {
            $params += @{ "DeliverToMailboxAndForward" = $false }
        }
        # Set the forwarding address
        if ($WhatIf) {
            try {
                Set-Mailbox -Identity $Mailbox @params -WhatIf
                # Check if the command was successful
                Write-Host "Forwarding address set to '$FWDSMTP' for mailbox '$Mailbox'."
            } catch {
                Write-Error "Failed to set forwarding address for mailbox '$Mailbox'."
            }
        } else {
            try {
                Set-Mailbox -Identity $Mailbox @params -ErrorAction SilentlyContinue
                # Check if the command was successful
                Write-Host "Forwarding address set to '$FWDSMTP' for mailbox '$Mailbox'."
            } catch {
                Write-Error "Failed to set forwarding address for mailbox '$Mailbox'."
            }
        }
    }
}