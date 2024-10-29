@echo off

REM Function to add network drives
:AddNetworkDrives
    Net Use I: /Delete /yes
    Net Use Y: /Delete /yes
    Net Use L: /Delete /yes
    net use M: /Delete /yes
    Net Use R: /Delete /yes

    Net Use S: "\\bnmgs34\Back Office"
    Net Use Q: \\bu-qb\Quickbooks /persistent:Yes
    Net Use I: "\\bnmgs34\AP_Documents2"
    Net Use Y: \\bnmgs34\Scan
    Net Use L: "\\bnmgs34\Licenses and Permits"
    Net use M: "\\bnmgs34\Medical Offices"
    Net Use R: "\\bnmgs34\RCM"
    exit /b

:Check if host can ping the target 192.168.0.24
ping -n 1 192.168.0.24 >nul
if %errorlevel% equ 0 (
    echo Server is reachable.
    rem Add network drives here
    call :AddNetworkDrives

    Net Time /Domain:BNMG.NET /Set /Y
) else (
    echo Server is not reachable. Waiting for 30 seconds...
    timeout /t 30 >nul
    ping -n 1 192.168.0.24 >nul
    if %errorlevel% equ 0 (
        echo Server is now reachable.
        rem Add network drives here
        call :AddNetworkDrives
    ) else (
        echo Server is still not reachable. Exiting...
        exit /b
    )
)

