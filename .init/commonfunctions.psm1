function GotoRoot
{
    Set-Location -Path $global:BaseDir
}

function GotoSrcRoot
{
    Set-Location -Path $global:SrcRoot
}

function GotoParentDir
{
    @(cd ..)
}

function dircmd
{
  @(cmd /c dir $args)
}

function rdcmd
{
  @(cmd /c rd $args)
}

function llcmd
{
  @(cmd /c dir $args)
}

function cdcmd
{
    $directory = $args[0]
    if ((Get-Item $directory) -is [System.IO.FileInfo])
    {
        $directory = (get-item $directory).Directory.FullName
    }

    Set-Location -Path $directory
}

function Set-Aliases
{
    <#
    .SYNOPSIS
        Find the first MSBuild project file in the current directory.
    #>

    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory = $true)]
        [ValidateScript({Test-Path $_})]
        [string]$AliasJsonFile
    )

    LogVerbose "Processing aliases from $AliasJsonFile"
    $aliasData = Get-Content -Raw -Path $AliasJsonFile | ConvertFrom-Json -AsHashtable

    foreach ($alias in $aliasData.aliases)
    {
        $option = $alias.Option
        if ([string]::IsNullOrWhiteSpace($option))
        {
            $option = "Unspecified"
        }

        LogVerbose "Set alias for $($alias.Name) with value $($alias.Value) and scope $scope"
        Set-Alias -Name $alias.Name -Scope "Global" -Option $option -value $alias.Value
    }
}

Export-ModuleMember -Function 'GotoRoot'
Export-ModuleMember -Function 'GotoSrcRoot'
Export-ModuleMember -Function 'GotoParentDir'
Export-ModuleMember -Function 'dircmd'
Export-ModuleMember -Function 'rdcmd'
Export-ModuleMember -Function 'llcmd'
Export-ModuleMember -Function 'cdcmd'
Export-ModuleMember -Function 'Set-Aliases'
