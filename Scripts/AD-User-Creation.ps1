# ----------------------------------------------
# Script: AD-User-Creation.ps1
# Description: Automates the creation of Active Directory users and groups
# Author: Ojas Ghai
# Date: 10/02/2025
# ----------------------------------------------

# Import Active Directory Module (Ensure RSAT: AD DS and AD LDS Tools are installed)
Import-Module ActiveDirectory

# Define the Organizational Units (OUs)
$OUs = @("Sales", "IT", "Finance", "HR")

# Create OUs if they don't exist
foreach ($OU in $OUs) {
    if (-not (Get-ADOrganizationalUnit -Filter "Name -eq '$OU'")) {
        New-ADOrganizationalUnit -Name $OU -Path "DC=oghai,DC=local" -ProtectedFromAccidentalDeletion $false
        Write-Host "Created OU: $OU"
    }
}

# Create Sales-Team Security Group
$SalesGroup = "Sales-Team"
if (-not (Get-ADGroup -Filter {Name -eq $SalesGroup})) {
    New-ADGroup -Name $SalesGroup -GroupScope Global -GroupCategory Security -Path "OU=Sales,DC=oghai,DC=local"
    Write-Host "Created Security Group: $SalesGroup"
}

# Define User Accounts
$Users = @(
    @{ FirstName="John"; LastName="Doe"; Username="jdoe"; Department="Sales" },
    @{ FirstName="Emily"; LastName="Davis"; Username="edavis"; Department="Sales" },
    @{ FirstName="Jane"; LastName="Smith"; Username="jsmith"; Department="IT" },
    @{ FirstName="Dave"; LastName="Wilson"; Username="dwilson"; Department="IT" },
    @{ FirstName="Kevin"; LastName="Williams"; Username="kwilliams"; Department="HR" }
)

# Default Password for Users (Force Change at First Login)
$DefaultPassword = ConvertTo-SecureString "Enterpass#12345" -AsPlainText -Force

# Create User Accounts
foreach ($User in $Users) {
    $UserPrincipalName = "$($User.Username)@oghai.local"
    $OUPath = "OU=$($User.Department),DC=oghai,DC=local"

    if (-not (Get-ADUser -Filter {SamAccountName -eq $User.Username})) {
        New-ADUser -Name "$($User.FirstName) $($User.LastName)" `
                   -GivenName $User.FirstName `
                   -Surname $User.LastName `
                   -SamAccountName $User.Username `
                   -UserPrincipalName $UserPrincipalName `
                   -Path $OUPath `
                   -AccountPassword $DefaultPassword `
                   -Enabled $true `
                   -ChangePasswordAtLogon $true
        Write-Host "Created User: $($User.Username) in OU: $($User.Department)"
    } else {
        Write-Host "User $($User.Username) already exists!"
    }

    # Add Sales users to Sales-Team Group
    if ($User.Department -eq "Sales") {
        Add-ADGroupMember -Identity "Sales-Team" -Members $User.Username
        Write-Host "Added $($User.Username) to Sales-Team Group"
    }
}

Write-Host "All Users and Groups have been created successfully!"
