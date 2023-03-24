# Reset Group Policy (PowerShell)

This PowerShell script resets the group policies on a Windows client to their default settings. It also writes an informational event to the Event Viewer.

## Requirements

- Windows operating system
- PowerShell 5.1 or higher
- Administrator privileges

## Usage

1. Open an elevated PowerShell console (Run as Administrator).
2. Navigate to the directory containing the script.
3. Run the script using the following command:

```powershell
.\Reset-GroupPolicy.ps1 [-VerboseLogging] [-Help]
```

## Command-Line options
* `-VerboseLogging`: Enable verbose logging. When this switch is used, the script will print detailed information about its progress to the console.  
* `-Help`: Show a help message with a description of the command-line options.

## Example
To run the script with verbose logging, use the following command:

```powershell
.\Reset-GroupPolicy.ps1 -VerboseLogging
```
