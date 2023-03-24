param (
    [switch]$VerboseLogging,
    [switch]$Help
)

function Write-VerboseLog {
    param (
        [string]$Message
    )

    if ($VerboseLogging) {
        Write-Host $Message
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
    gpupdate /force

    Write-VerboseLog "Writing event to Event Viewer..."
    $EventLog = New-Object -TypeName System.Diagnostics.EventLog -ArgumentList "Application"
    $EventLog.Source = "ResetGroupPolicy"
    $EventLog.WriteEntry("Group policy reset successfully.", [System.Diagnostics.EventLogEntryType]::Information)

    Write-VerboseLog "Group policy reset complete."
} catch {
    Write-Host "Error: $($_.Exception.Message)"
    exit 1
}
