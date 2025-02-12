# ----------------------------------------------
# Script: Backup-Restore-AD.ps1
# Description: Automates the backup and restore process for Active Directory
# Author: Ojas Ghai
# Date: 10/02/2025
# ----------------------------------------------

# Import the Windows Server Backup Module (Ensure it's installed)
Import-Module WindowsServerBackup

# Define Backup Location
$BackupLocation = "E:\AD_Backup"  # Change this to your backup storage location

# Create a Backup Policy
$Policy = New-WBPolicy

# Include System State (Active Directory Data)
$SystemState = New-WBSystemState
Add-WBSystemState $Policy

# Set Backup Target (Ensure Drive is Available)
$BackupTarget = New-WBBackupTarget -VolumePath $BackupLocation
Add-WBBackupTarget -Policy $Policy -Target $BackupTarget

# Enable VSS Full Backup
$Policy.VssBackupOptions = "VssFullBackup"

# Schedule Backup Now
Write-Host "Starting Active Directory Backup..."
Start-WBBackup -Policy $Policy -Async
Write-Host "Active Directory Backup Completed Successfully."

# ---------------------- RESTORE PROCESS ----------------------

# Function to Restore Active Directory from Backup
Function Restore-AD {
    Write-Host "Restoring Active Directory from Backup..."
    
    # Restart Server in Directory Services Restore Mode (DSRM)
    Write-Host "Restarting into Directory Services Restore Mode..."
    bcdedit /set safeboot dsrepair
    Restart-Computer -Force
    
    # Wait for user to restart manually in DSRM mode and run the restore command
    Write-Host "Please log in with the DSRM Admin credentials after restart."
    Write-Host "Once logged in, run the following command manually:"
    Write-Host "wbadmin start systemstaterecovery -backupTarget:$BackupLocation -quiet"

    # Reset Boot Configuration to Normal Mode
    Write-Host "After restoration, reset boot mode by running:"
    Write-Host "bcdedit /deletevalue safeboot"
}

# Provide Options for Backup or Restore
Write-Host "Select an Option:"
Write-Host "1. Backup Active Directory"
Write-Host "2. Restore Active Directory"
$UserChoice = Read-Host "Enter Option (1 or 2)"

if ($UserChoice -eq "1") {
    Write-Host "Starting Backup..."
    Start-WBBackup -Policy $Policy -Async
    Write-Host "Backup Completed Successfully!"
} elseif ($UserChoice -eq "2") {
    Restore-AD
} else {
    Write-Host "Invalid Selection. Exiting..."
}
