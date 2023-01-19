#Stores registry query for Enrollments in array list
[System.Collections.ArrayList]$regArray= reg query HKLM\SOFTWARE\Microsoft\Enrollments

#Replaces 'HKEY_LOCAL_MACHINE' with 'HKLM'
$regArray = $regArray -replace 'HKEY_LOCAL_MACHINE','HKLM'
#Removes registry keys from array list that shouldn't be deleted
#I have seen these worded ones recreated after a reboot if we want to
#delete them.
$regArray.Remove("HKLM\SOFTWARE\Microsoft\Enrollments\Ownership")
$regArray.Remove("HKLM\SOFTWARE\Microsoft\Enrollments\Context")
$regArray.Remove("HKLM\SOFTWARE\Microsoft\Enrollments\Status")
$regArray.Remove("HKLM\SOFTWARE\Microsoft\Enrollments\PollOnLoginTasksCreated")
$regArray.Remove("HKLM\SOFTWARE\Microsoft\Enrollments\ValidNodePaths")
#Delete each keys if they exist.
if ($regArray){
  foreach ($reg in $regArray)
    {
      Write-Host "Deleting $reg"
      reg delete $reg /f
    }
} else {
  Write-Host "No Registry keys to delete."
}
Exit-PSHostProcess