function Search-CWMCompany {
    param(
        [Parameter(Mandatory=$false, HelpMessage="Enter the name of the company you want to create a configuration for")]
        [string]$company
    )
    # Ask the user if they know the company they want to create a configuration for
    $company = Read-Host "Enter the name of the company you want to create a configuration for"
    # Clear the global company object and company companyObj
    $global:companyObj = $null
    if($company -eq ""){
        $companyObj = Get-CWMCompany -condition "deletedFlag = False" -all
        $companyObj = $companyObj | Select-Object id, name | Out-GridView -OutputMode Single -Title "Select Company"
        $companyObj = Get-CWMCompany -condition "id = $($companyObj.id)" -all
    }
    # If the user enters a company name, search for it
    else{
        # Search for the company name entered by the user
        $companyObj = Get-CWMCompany -condition "name contains '$company' and deletedFlag = False" -all
        # if only one company is found, select it. If more than one is found, list them all.
        if($companyObj.id.Count -eq 1){
            $global:companyObj = $companyObj
        }
        elseif($companyObj.Count -eq 0){
            Write-Host "Company not found, listing all companies."
            $companyObj = Get-CWMCompany -condition "deletedFlag = False" -all
            $companyObj = $companyObj | Select-Object id, name | Out-GridView -OutputMode Single -Title "Select Company"
            $global:companyObj = Get-CWMCompany -condition "id = $($companyObj.id)" -all
        }
        else{
            $companyObj = $companyObj | Select-Object id, name | Out-GridView -OutputMode Single -Title "Select Company"
            $global:companyObj = Get-CWMCompany -condition "id = $($companyObj.id)" -all
        }
    }
}
function Search-CWMConfigType{
    param(
        [Parameter(Mandatory=$false, HelpMessage="Enter the name of the configuration type you want to create")]
        [string]$config
    )
    # Clear the global configType Object.
    $global:configType = $null
    if($config -eq ""){
        $configType = Get-CWMCompanyConfigurationType -all
        $configType = $configType | Select-Object id, name | Out-GridView -OutputMode Single -Title "Select Configuration Type"
        $global:configType = Get-CWMCompanyConfigurationType -condition "id = $($configType.id)" -all
    }
    else{
        $configType = Get-CWMCompanyConfigurationType -condition "name contains '$config'" -all
        if($configType.id.Count -eq 1){
            $global:configType = $configType
        }
        elseif($configType.Count -eq 0){
            Write-Host "Configuration Type not found, listing all Configuration Types."
            $configType = Get-CWMCompanyConfigurationType -all
            $configType = $configType | Select-Object id, name | Out-GridView -OutputMode Single -Title "Select Configuration Type"
            $global:configType = Get-CWMCompanyConfigurationType -condition "id = $($configType.id)" -all
        }
        else{
            $configType = $configType | Select-Object id, name | Out-GridView -OutputMode Single -Title "Select Configuration Type"
            $global:configType = Get-CWMCompanyConfigurationType -condition "id = $($configType.id)" -all
        }
    }
}
# Get required information from the user to complete the configuration.
Search-CWMCompany
Search-CWMConfigType
$global:companyObj

# Find required fields for the configuration type select headers only
#Create a entry form from the required fields and questions fields
Function Create-CWMConfigurationForm{
    param(
        [Parameter(Mandatory=$true, HelpMessage="Enter the required fields for the configuration type")]
        [array]$configType
    )
    $requiredFields = Get-CWMCompanyConfiguration -condition "type/id = $($configType.id)" -pageSize 1| Get-Member -MemberType NoteProperty
    $questionFields = Get-CWMCompanyConfiguration -condition "type/id = $($configType.id)" -pageSize 1| 
    Select-Object -ExpandProperty questions |
    Select-Object -ExpandProperty question
    # Create a form to display the required fields and questions
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Configuration Form"
    $form.Size = New-Object System.Drawing.Size(300,200)
    $form.StartPosition = "CenterScreen"
    $form.Topmost = $true
    $form.FormBorderStyle = "FixedDialog"
    $form.MaximizeBox = $false
    $form.MinimizeBox = $false
    $form.ControlBox = $false
    $form.AutoSize = $true
    $form.AutoSizeMode = "GrowAndShrink"
    $form.AutoSize = $true
    # Create a label for the required fields
    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(10,20)
    $label.Size = New-Object System.Drawing.Size(280,20)
    $label.Text = "Required Fields"
    $form.Controls.Add($label)
    # Create a label for the questions
    $questionsLabel = New-Object System.Windows.Forms.Label
    $questionsLabel.Location = New-Object System.Drawing.Point(10,60)
    $questionsLabel.Size = New-Object System.Drawing.Size(280,20)
    $questionsLabel.Text = $requiredFields[0].name
    $form.Controls.Add($questionsLabel)
    # Create a listbox for the required fields
    $listBoxRequiredFields = New-Object System.Windows.Forms.ListBox
    $listBoxRequiredFields.Location = New-Object System.Drawing.Point(10,40)
    $listBoxRequiredFields.Size = New-Object System.Drawing.Size(260,20)
    $listBoxRequiredFields.Height = 20
    $listBoxRequiredFields.Items.AddRange($requiredFields)
    $form.Controls.Add($listBoxRequiredFields)
    # Create a listbox for the questions   
    $listBoxQuestions = New-Object System.Windows.Forms.ListBox
    $listBoxQuestions.Location = New-Object System.Drawing.Point(10,80)
    $listBoxQuestions.Size = New-Object System.Drawing.Size(260,20)
    $listBoxQuestions.Height = 20
    $listBoxQuestions.Items.AddRange($questionFields)
    $form.Controls.Add($listBoxQuestions)
    # Create a button to submit the form
    $button = New-Object System.Windows.Forms.Button
    $button.Location = New-Object System.Drawing.Point(10,120)
    $button.Size = New-Object System.Drawing.Size(260,20)
    $button.Text = "Submit"
    $button.Add_Click({
        $form.Close()
    })
    $form.Controls.Add($button)
    $form.ShowDialog()
}
