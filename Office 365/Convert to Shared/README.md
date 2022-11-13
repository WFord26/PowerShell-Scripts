# Convert to Shared

Use this script to convert all users found within a text file. This script requires the use of the parameter -adminUPN followed by General Administrator UPN address. 

## EXAMPLES

**How do I use the script?**

>  .\Get-MailboxSizeReport.ps1 -adminUPN johndoe@contoso.com
> 
>  - To login as johndoe@contoso.com
>  - To use the default file in folder **UsersToShared.txt** 

**How do I choose my own file location?**

>  .\Get-MailboxSizeReport.ps1 -adminUPN johndoe@contoso.com -fileDIR c:\temp\users.txt
>
> - To login as johndoe@contoso.com
> - To use file in the path: c:\temp\users.txt

**What should my text file look like?**

filename.txt

> user1@contoso.com <br/>
> user2@contoso.com <br/>
> user3@contoso.com <br/>