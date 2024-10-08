<#
.DESCRIPTION
    This script runs CHKDSK to scan your filesystem.
    Additionaly you can choose which volume want to scan.
#>

function Repair-Disk {
    param(
        [string]$Volume = ""
    )

    if(!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
        Write-Host "Process required to run PowerShell as a Administrator!"
        return;
    }

    if ($Volume -ne "") {
        
        Repair-Volume -DriveLetter $Volume -SpotFix
        return;
    }
    $volumeString = ""
    Get-Partition | ForEach-Object {
        if($_.DriveLetter -ne "") {
            $volumeString += $_.DriveLetter
        }
    }
    if($volumeString -ne "") {
        Repair-Volume -DriveLetter $volumeString -SpotFix
    }
}

