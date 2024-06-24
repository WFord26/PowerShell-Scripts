# Enrolling Azure AD joined Devices in ADCS PKI environment

## Requirements 

* Active Directory Domain
* Enterprise Certificate Authority 
* Root Certificate
* [Disable SAN to UPN mapping on all DCs](https://learn.microsoft.com/en-us/troubleshoot/windows-server/windows-security/disable-subject-alternative-name-upn-mapping)
* [TameMyCerts Module installed on ADCS server](https://github.com/Sleepw4lker/TameMyCerts)
* [Certificate Connector for Intune](https://learn.microsoft.com/en-us/mem/intune/protect/certificate-connector-install)
* The AddGhostDevice.ps1 script.
* The TameMyCert.xml file

## Process

1. [Export the root certificate from the the Enterprise CA.](https://learn.microsoft.com/en-us/mem/intune/protect/certificate-connector-install)
2. [Configure Certificate templates on the CA](https://learn.microsoft.com/en-us/mem/intune/protect/certificate-connector-install)
3. [Install TameMyCert add on.](https://github.com/Sleepw4lker/TameMyCerts/blob/main/user-guide/installing.adoc)
4. [Download, install, and configure the Certifcate Conector for Microsoft Intune](https://learn.microsoft.com/en-us/mem/intune/protect/certificate-connector-install)
5. [Harden Service Account](https://directaccess.richardhicks.com/2023/01/30/intune-certificate-connector-service-account-and-pkcs/)
6. [Create a trusted Certificate Profile](https://learn.microsoft.com/en-us/mem/intune/protect/certificate-connector-install)
7. [Create a PKCS certificate profile](https://learn.microsoft.com/en-us/mem/intune/protect/certificate-connector-install)

   * UPN value in the certificate must be in the “host/{AAD device ID}”
    ![image](https://i.ibb.co/4scn7h3/2022-11-22-22-52-32.jpg)
8. Create Enterprise App
9. Setup script and run on schedule