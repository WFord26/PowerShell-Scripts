@ECHO OFF
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""C:\Users\%USERNAME%\profwiz\ClearRegistryKeys.ps1""' -Verb RunAs}"