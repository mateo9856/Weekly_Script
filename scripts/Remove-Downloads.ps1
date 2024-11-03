<#
.DESCRIPTION
    This script removes Download files.
    Additionaly you can exclude files/folders by param
#>
function Remove-Downloads {
    param(
        [string]$Path = "", 
        [string[]]$ExcludedFolders,
        [int]$MaxDays = 90)

    if ($Path -eq "") {
        $Path = $env:USERPROFILE + "\Downloads"
    }

    $daysInterval = $MaxDays * (-1)
    Get-ChildItem -Path $env:USERPROFILE\Downloads | Where-Object { $_.LastWriteTime -le (Get-Date).AddDays($daysInterval) } | Remove-Item -Force
}
