# ----------------------------------------------
# Script: Group-Policy-Setup.ps1
# Description: Automates the creation and linking of Group Policies (GPOs)
# Author: Ojas Ghai
# Date: 10/02/2024
# ----------------------------------------------

# Import the Group Policy Module (Ensure RSAT Group Policy Management Tools are installed)
Import-Module GroupPolicy

# Define the domain name
$DomainName = "oghai.local"

# Define Organizational Units (OUs)
$OUs = @(
    "OU=Sales,$DomainName",
    "OU=IT,$DomainName",
    "OU=Finance,$DomainName",
    "OU=HR,$DomainName"
)

# Define Group Policy Objects (GPOs)
$GPOs = @(
    @{ Name="Password Policy"; OU=""; ConfigPath="Security Settings\Account Policies\Password Policy" },
    @{ Name="USB Restriction for Finance & HR"; OU="Finance"; ConfigPath="Computer Configuration\Policies\Administrative Templates\System\Removable Storage Access" },
    @{ Name="Network Drive Mapping for Sales"; OU="Sales"; ConfigPath="User Configuration\Preferences\Windows Settings\Drive Maps" },
    @{ Name="Prevent Desktop Background Change for IT"; OU="IT"; ConfigPath="User Configuration\Policies\Administrative Templates\Control Panel\Personalization" }
)

# Create and Configure GPOs
foreach ($GPO in $GPOs) {
    $GPOName = $GPO.Name
    $OUPath = $GPO.OU
    $GPOExists = Get-GPO -Name $GPOName -ErrorAction SilentlyContinue

    if (-not $GPOExists) {
        New-GPO -Name $GPOName | Out-Null
        Write-Host "Created GPO: $GPOName"
    } else {
        Write-Host "GPO $GPOName already exists, modifying..."
    }

    # Link GPO to OU
    if ($OUPath -ne "") {
        New-GPLink -Name $GPOName -Target "OU=$OUPath,DC=oghai,DC=local" -LinkEnabled Yes
        Write-Host "Linked GPO: $GPOName to OU: $OUPath"
    }
}

# Configuring Password Policy for the Entire Domain
Write-Host "Configuring Password Policy..."
Set-GPRegistryValue -Name "Password Policy" -Key "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" -ValueName "EnforcePasswordHistory" -Type DWord -Value 5
Set-GPRegistryValue -Name "Password Policy" -Key "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" -ValueName "MaximumPasswordAge" -Type DWord -Value 90
Set-GPRegistryValue -Name "Password Policy" -Key "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" -ValueName "MinimumPasswordLength" -Type DWord -Value 10
Set-GPRegistryValue -Name "Password Policy" -Key "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" -ValueName "PasswordComplexity" -Type DWord -Value 1
Write-Host "Password Policy configured."

# Restrict USB Access for Finance & HR
Write-Host "Configuring USB Restriction for Finance & HR..."
Set-GPRegistryValue -Name "USB Restriction for Finance & HR" -Key "HKLM\SYSTEM\CurrentControlSet\Policies\RemovableStorageDevices" -ValueName "Deny_All" -Type DWord -Value 1
Write-Host "USB Restriction Applied."

# Map Network Drive for Sales
Write-Host "Configuring Network Drive Mapping for Sales..."
$DrivePath = "\\WindowsServer20\SharedSales"
Set-GPRegistryValue -Name "Network Drive Mapping for Sales" -Key "HKCU\Network\S" -ValueName "RemotePath" -Type String -Value $DrivePath
Write-Host "Sales Drive Mapping Configured."

# Prevent IT Users from Changing Desktop Background
Write-Host "Configuring Desktop Background Restriction for IT..."
Set-GPRegistryValue -Name "Prevent Desktop Background Change for IT" -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" -ValueName "NoChangingWallPaper" -Type DWord -Value 1
Write-Host "IT Desktop Background Policy Applied."

# Force Group Policy Update on All Computers
Write-Host "Forcing Group Policy Update..."
Invoke-GPUpdate -Computer "WindowsServer20" -Force
Write-Host "Group Policies Applied Successfully!"

