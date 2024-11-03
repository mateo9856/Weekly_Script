<#
.SYNOPSIS
	Clone repos from GitHub
.DESCRIPTION
	This script get's user repos and clone all repos to directory.
.EXAMPLE

.LINK
	https://github.com/mateo9856/Weekly_Script
.NOTES
	Author: Mateusz Magdziak
#>

function Add-GitRepositories {
    param(
        [string]$User,
        [string]$Directory,
        [switch]$Force
    )
    try {
        git | Out-Null
    }
    catch [System.Management.Automation.CommandNotFoundException] {
        if($Force.IsPresent) {
            Write-Host "Git not installed, try install git."
            winget install --id Git.Git -e --source winget
        } 
        else {
            $GitConfirm = Read-Host "Git not installed, do you want install git ? Type [N] or [Y]"

            if($GitConfirm -eq "Y") {
                winget install --id Git.Git -e --source winget
            } 
            else {
                return "Git installation not confirmed. Abandon script." 
            }
        }
    }

    $Repositories = (Invoke-WebRequest -Uri "https://api.github.com/users/$User/repos").Content | ConvertFrom-Json
    
    $DestinationFolder = $env:USERPROFILE
    if ($PSBoundParameters.ContainsKey('Directory')) {
        $DestinationFolder = $Directory
    }
    New-Item -Path $DestinationFolder -Name 'repos' -ItemType 'directory' -Force
    Set-Location ($DestinationFolder + "\repos")

    foreach($repo in $Repositories) {
        $CloneString = "https://github.com/" + $User + "/" + $repo.name + ".git"
        Write-Host $CloneString
        git clone --recursive $CloneString
    }

}

#Add-GitRepositories -User "mateo9856" -Force