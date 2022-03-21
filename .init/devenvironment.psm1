function Initialize-DevEnvironment
{
    param (
        [string] $environmentName,
        [string] $arguments
    )

    # Call the repo's initialize command
    if( (Test-Path "$global:DevPrivateRoot\init.cmd") -eq $false )
    {
        LogError "Missing init.cmd for $environmentName"
        Exit(-1)
    }

    # File to hold environment variables from repo init
    $tmp = [System.IO.Path]::GetTempFileName()

    # Call the repo init script
    LogInfo "Calling `"$global:DevPrivateRoot\init.cmd`" $arguments"
    cmd /c "call `"$global:DevPrivateRoot\init.cmd`" $Arguments & set > `"$tmp`""

    # bring over the environment variables that were created here
    LogVerbose "Parsing variables from `"$tmp`""
    get-content $tmp | foreach-object {
        $props = $_ -split '=', 2

        LogVerbose "Setting variable `"$($props[0])`": $($props[1])"
        [System.Environment]::SetEnvironmentVariable($props[0], $props[1])
    }
}

function Initialize-DevEnvironmentGlobalVariables
{
    # create some basic variables
    LogInfo "Creating Global Variables"
    $global:BaseDir = "$env:reporoot"
    $global:ScriptsRoot = "$PSScriptRoot"
    $global:ToolsRoot = "$PSScriptRoot\..\tools"
    $global:SrcRoot = "$global:BaseDir\src"

    $env:Path = "$env:Path;$global:ToolsRoot"
}

function Set-DevEnvironmentExecutionPolicy
{
    # Need to set execution policy for posh-git
    $execPolicy = Get-ExecutionPolicy
    if (($execPolicy -ne 'Unrestricted') -and ($execPolicy -ne 'RemoteSigned'))
    {
        Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
    }
    $execPolicy = Get-ExecutionPolicy
    LogInfo "Execution Policy = $execPolicy"
}

function Execute-DevEnvironmentPostInitCommand
{
    param (
        [string] $postInitCommand = $null
    )

    if ($false -eq [string]::IsNullOrWhiteSpace($postInitCommand))
    {
        LogInfo "Executing post-init command"
        LogInfo "Command: '$postInitCommand'"

        if( $null -ne (Invoke-Expression $postInitCommand | Select-String -Pattern "False"))
        {
            LogError "Post-Init command failed"
            Exit(-1)
        }
        else
        {
            LogSuccess "Post-Init command was successful"
        }
    }
}

function Open-DevEnvironment
{
    param (
        [string] $environmentName,
        [string] $environmentFolder,
        [string] $arguments,
        [string] $postInitCommand
    )

    $global:DevPrivateRoot = Join-Path $PSScriptRoot "..\DevConsoles\$environmentFolder"

    LogInfo "Starting $Env:USERNAME specific initialization for $environmentName"

    Set-DevEnvironmentExecutionPolicy

    Initialize-DevEnvironment $environmentName $arguments

    Initialize-DevEnvironmentGlobalVariables

    $Host.UI.RawUI.WindowTitle = $environmentName

    # Load the project specific aliases
    Set-Aliases "$global:DevPrivateRoot\alias.json"

    # run any project specific powershell customization
    Invoke-Expression -command "$global:DevPrivateRoot\customize.ps1"

    LogSuccess "Initialization is complete"

    Execute-DevEnvironmentPostInitCommand $postInitCommand

    # Change to the root of the repo
    if (Test-Path "$global:DevPrivateRoot\gotoreporoot.ps1")
    {
        & $global:DevPrivateRoot\gotoreporoot.ps1
    }
}

Export-ModuleMember -Function Open-DevEnvironment