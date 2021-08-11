# #############################################################################
#
# POWERSHELL
# NAME: AD_Security_Audit_Logs.ps1
# 
# AUTHOR:  Felipe Sa
# DATE:  11/08/2021
# 
# COMMENT:  This script returns useful information (reports) from AD that can help prevent/mitigate security incidents. It can also be used periodically to audit your DCs.
#
# VERSION HISTORY
# 1.0 11.08.2021 Initial Version.
# 1.1 11.08.2021 Export in CSV format.
#
# #############################################################################

Import-Module ActiveDirectory;

$UserPath = "$($env:USERPROFILE)\Desktop"
$ADGroupMember = “Domain Admins”

$numberofdays = 0

do {
    $inputValid = [Uint16]::TryParse((Read-Host "Number of days from today's date to view the report"), [ref]$numberofdays)
    if (-not $inputValid) {
        Write-Host "Number of days must be an integer and not less than 0."            
    }
} while (-not $inputValid)


function Show-Menu {       
    param (
        [string]$Title = 'Select the Audit Log'
    )
    
    Write-Host "================ $Title ================"
    Write-Host "";    
    Write-Host "1: Press '1' for 'Computers joined to the domain within the last $numberofdays day(s)'"
    Write-Host "2: Press '2' for 'Users joined to the domain within the last $numberofdays day(s)'"
    Write-Host "3: Press '3' for 'Groups created within the last $numberofdays day(s)'"
    Write-Host "4: Press '4' for 'Recently created accounts (and recently changed accounts) within the last $numberofdays day(s)'"
    Write-Host "5: Press '5' for 'Retrieve password last set and expiry information within the last $numberofdays day(s)'"
    Write-Host "6: Press '6' for 'Export Group Members from 'EUR Region Admins' group'"
    Write-Host "Q: Press 'Q' to quit."   

}

do
 {
    Show-Menu
    Write-Host "";
    $menuoption = Read-Host "Select your option"
    switch ($menuoption)
    {
    '1' {                   
              
    Write-Host "================ Computers joined to the domain within the last $numberofdays day(s) ================"
    $Joined = [DateTime]::Today.AddDays(-$numberofdays)
    Get-ADComputer -Filter 'WhenCreated -ge $joined' -Properties whenCreated | sort-object whenCreated | Format-Table Name,whenCreated,distinguishedName -Autosize -Wrap
    
    $title    = 'Export log to CSV'
    $question = 'Do you want to export it to *.CSV?'

    $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))

    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
    if ($decision -eq 0) {       
        Get-ADComputer -Filter 'WhenCreated -ge $joined' -Properties whenCreated | sort-object whenCreated | select-object Name,whenCreated,distinguishedName | Export-csv -NoTypeInformation -path "$UserPath\Assets_joined_AD_within_$numberofdays(days).csv"
        Write-Host "File exported successfully to $UserPath"
    } else {
        Write-Host ''
    }

     
         }
         '2' {

    Write-Host "================ Users joined to the domain within the last $numberofdays day(s) ================"
    $Joined = ((Get-Date).AddDays(-$numberofdays)).Date
    Get-ADUser -Filter 'WhenCreated -ge $joined' -Properties whenCreated | sort-object whenCreated | Format-Table Name,whenCreated,distinguishedName -Autosize -Wrap

    $title    = 'Export log to CSV'
    $question = 'Do you want to export it to *.CSV?'

    $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))

    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
    if ($decision -eq 0) {       
        Get-ADUser -Filter 'WhenCreated -ge $joined' -Properties whenCreated | sort-object whenCreated | select-object Name,whenCreated,distinguishedName | Export-csv -NoTypeInformation -path "$UserPath\Users_joined_AD_within_$numberofdays(days).csv"        
        Write-Host "File exported successfully to $UserPath"
    } else {
        Write-Host ''
    }
                   
    }
    '3' {

    Write-Host "================ Groups created within the last $numberofdays day(s) ================"
    $Joined = ((Get-Date).AddDays(-$numberofdays)).Date
    Get-ADGroup -Filter 'WhenCreated -ge $joined' -Properties whenCreated | sort-object whenCreated | Format-Table Name,whenCreated,distinguishedName -Autosize -Wrap

    $title    = 'Export log to CSV'
    $question = 'Do you want to export it to *.CSV?'

    $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))

    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
    if ($decision -eq 0) {       
        Get-ADGroup -Filter 'WhenCreated -ge $joined' -Properties whenCreated | sort-object whenCreated | select-object Name,whenCreated,distinguishedName | Export-csv -NoTypeInformation -path "$UserPath\Groups_created_AD_within_$numberofdays(days).csv"              
        Write-Host "File exported successfully to $UserPath"
    } else {
        Write-Host ''
    }

    }
    '4' {

    Write-Host "================ Recently created accounts (and recently changed accounts) within the last $numberofdays day(s) ================"
    $Joined = ((Get-Date).AddDays(-$numberofdays)).Date
    Get-ADUser -Filter * -Property whenChanged | Where {$_.whenChanged -gt $Joined} | sort-object whenChanged | Format-Table Name, whenChanged -Autosize

    $title    = 'Export log to CSV'
    $question = 'Do you want to export it to *.CSV?'

    $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))

    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
    if ($decision -eq 0) {       
        Get-ADUser -Filter * -Property whenChanged | Where {$_.whenChanged -gt $Joined} | sort-object whenChanged | select-object Name, whenChanged | Export-csv -NoTypeInformation -path "$UserPath\Accounts_created_changed_AD_within_$numberofdays(days).csv"              
        Write-Host "File exported successfully to $UserPath"
    } else {
        Write-Host ''
    }
    
    }
    '5' {

    Write-Host "================ Retrieve password last set and expiry information within the last $numberofdays day(s) ================"
    $Joined = (Get-Date).AddDays(-$numberofdays).Date
    Get-ADUser -Filter 'Enabled -eq $True' -Properties PasswordLastSet,Passwordneverexpires | Where-Object {$_.PasswordLastSet -gt $Joined} | sort-object PasswordLastSet | Format-Table Name,SamAccountName,PasswordLastSet,Passwordneverexpires
    
    $title    = 'Export log to CSV'
    $question = 'Do you want to export it to *.CSV?'

    $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))

    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
    if ($decision -eq 0) {       
        Get-ADUser -Filter 'Enabled -eq $True' -Properties PasswordLastSet,Passwordneverexpires | Where-Object {$_.PasswordLastSet -gt $Joined} | sort-object PasswordLastSet | select-object Name,SamAccountName,PasswordLastSet,Passwordneverexpires | Export-csv -NoTypeInformation -path "$UserPath\Password_lastset_expiry_within_$numberofdays(days).csv"              
        Write-Host "File exported successfully to $UserPath"
    } else {
        Write-Host ''
    }

    }
    '6' {
    
    Write-Host "================ Export Group Members from $ADGroupMember group ================"
    Get-ADGroupMember -identity $ADGroupMember | select name | sort-object name | Format-Table name
    
    $title    = 'Export log to CSV'
    $question = 'Do you want to export it to *.CSV?'

    $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))

    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
    if ($decision -eq 0) {       
        Get-ADGroupMember -identity $ADGroupMember | select name | sort-object name | select-object name | Export-csv -NoTypeInformation -path "$UserPath\$ADGroupMember-Members.csv"          
        Write-Host "File exported successfully to $UserPath"
    } else {
        Write-Host ''
    }    
         
    }
    }
    pause
 }
until ($menuoption -eq 'q')