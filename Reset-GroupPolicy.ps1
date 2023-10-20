<#
.SYNOPSIS
This script resets the local group policy objects to their default state.

.DESCRIPTION
Reset-GroupPolicy.ps1 will delete the local group policy objects and force a group policy update. It will also log an event to the Event Viewer indicating the reset has been completed.

.PARAMETER VerboseLogging
Enable verbose logging.

.PARAMETER Help
Show the help message.

.EXAMPLE
.\Reset-GroupPolicy.ps1 -VerboseLogging

This example will run the script with verbose logging enabled.

.EXAMPLE
.\Reset-GroupPolicy.ps1 -Help

This example will display the help message.
#>

[CmdletBinding()]
param (
    [switch]$VerboseLogging,
    [switch]$Help
)

function Write-VerboseLog {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    
    if ($VerboseLogging) {
        Write-Verbose $Message
    }
}

function Show-Help {
    $helpText = @"
Reset-GroupPolicy.ps1 [-VerboseLogging] [-Help]

-VerboseLogging : Enable verbose logging
-Help           : Show this help message
"@
    Write-Host $helpText
}

if ($Help) {
    Show-Help
    exit
}

try {
    if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        throw "This script must be run as Administrator."
    }

    Write-VerboseLog "Resetting group policy for users..."
    Remove-Item -Path "${env:windir}\System32\GroupPolicyUsers" -Recurse -Force -ErrorAction SilentlyContinue

    Write-VerboseLog "Resetting group policy..."
    Remove-Item -Path "${env:windir}\System32\GroupPolicy" -Recurse -Force -ErrorAction SilentlyContinue

    Write-VerboseLog "Updating group policy..."
    Invoke-Expression -Command 'gpupdate /force'

    Write-VerboseLog "Writing event to Event Viewer..."
    $EventLog = New-Object -TypeName System.Diagnostics.EventLog -ArgumentList "Application"
    $EventLog.Source = "ResetGroupPolicy"
    $EventLog.WriteEntry("Group policy reset successfully.", [System.Diagnostics.EventLogEntryType]::Information)

    Write-VerboseLog "Group policy reset complete."
} catch {
    Write-Host "Error: $($_.Exception.Message)"
    exit 1
}
