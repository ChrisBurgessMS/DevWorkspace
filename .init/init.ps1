<#
.SYNOPSIS
    Initializes a personalized powershell environment
.DESCRIPTION
    Initializes a personalized powershell environment
.EXAMPLE
    # Initialize a powershell environment
        PS>.\init.ps1
#>

function InstallEnable-Module
{
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory = $true)]
        [string]$ModuleName
    )

    if (-not (Get-Module -ListAvailable -Name $ModuleName))
    {
        Write-Host "$ModuleName not installed. Installing..."
        Install-Module $ModuleName -Scope CurrentUser
    }

    Write-Host "Enabling $ModuleName module..."
    Import-Module $ModuleName -force
}

function InstallOhMyPosh
{
    Set-ExecutionPolicy Bypass -Scope Process -Force;
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://ohmyposh.dev/install.ps1'))
}

function ImportModules
{
    Import-Module "$PSScriptRoot\commonfunctions.psm1" -force -global
    Import-Module "$PSScriptRoot\gitfunctions.psm1" -force -global
    Import-Module "$PSScriptRoot\logfunctions.psm1" -force -global
    Import-Module "$PSScriptRoot\devenvironment.psm1" -force -global
    Import-Module "$PSScriptRoot\initializeroutines.psm1" -force -global
}

ImportModules
Set-Aliases $PSScriptRoot\globalaliases.json

#InstallEnable-Module "posh-git"
InstallOhMyPosh

oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\powerlevel10k_rainbow.omp.json"
#Set-PoshPrompt powerlevel10k_rainbow

