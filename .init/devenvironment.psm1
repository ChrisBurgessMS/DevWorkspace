function Initialize-CoreXT
{
    param (
        [string] $environmentName
    )

    # Call the repo's initialize command
    if( (Test-Path "$global:DevPrivateRoot\init.cmd") -eq $false )
    {
        LogError "Missing init.cmd for $environmentName"
        Exit(-1)
    }

    # File to hold environment variables from repo init
    $tmp = [System.IO.Path]::GetTempFileName()
    $env:AGENT_NAME="skipupdate"
    # Call the repo init script
    LogInfo "Calling `"$global:DevPrivateRoot\init.cmd`" $global:EnvironmentArguments "
    cmd /c "call `"$global:DevPrivateRoot\init.cmd`" $global:EnvironmentArguments & set > `"$tmp`""

    # bring over the environment variables that were created here
    LogVerbose "Parsing variables from `"$tmp`""
    get-content $tmp | foreach-object {
        $props = $_ -split '=', 2

        LogVerbose "Setting variable `"$($props[0])`": $($props[1])"
        [System.Environment]::SetEnvironmentVariable($props[0], $props[1])
    }
}

function Initialize-CoreXTGlobalVariables
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

function Open-CoreXTEnvironment
{
    param (
        [string] $environmentName,
        [string] $environmentFolder,
        [string] $arguments,
        [string] $postInitCommand
    )

    $global:EnvironmentName = $environmentName
    $global:DevPrivateRoot = Join-Path $PSScriptRoot "..\DevConsoles\$environmentFolder"
    $global:EnvironmentArguments = $arguments

    Open-CoreXTEnvironment2
}

function Open-CoreXTEnvironment2
{
    LogInfo "Starting $Env:USERNAME specific initialization for $global:EnvironmentName"

    Set-DevEnvironmentExecutionPolicy

    Initialize-CoreXT $global:EnvironmentName

    Initialize-CoreXTGlobalVariables

    $Host.UI.RawUI.WindowTitle = $global:EnvironmentName

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

Export-ModuleMember -Function Open-CoreXTEnvironment
Export-ModuleMember -Function Open-CoreXTEnvironment2