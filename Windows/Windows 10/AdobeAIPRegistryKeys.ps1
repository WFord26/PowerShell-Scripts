param(
[Parameter(
    Mandatory = $true,
    HelpMessage = "Select the sovereign cloud that you want to connect to. (Default is 1) 'n https://learn.microsoft.com/en-us/dotnet/api/microsoft.informationprotection.cloud?view=mipsdk-dotnet-1.6"
)]
[string]$cloudLocation = 3
)
Reg add "HKCU\SOFTWARE\Adobe\Adobe Acrobat\DC\MicrosoftAIP" /v bShowDMB /t REG_SZ /d 1
Reg add "HKLM\SOFTWARE\WOW6432Node\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown" /v bMIPLabelling /t REG_SZ /d 1
Reg add "HKLM\SOFTWARE\Policies\Adobe\Adobe Acrobat\Trunk\FeatureLockDown" /v iMIPCloud /t REG_DWORD /d $cloudLocation
Reg add "HKLM\SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown" /v iMIPCloud /t REG_DWORD /d $cloudLocation
