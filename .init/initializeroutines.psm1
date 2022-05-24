function InitializeWFEnvironment
{
    param (
        [string] $driveLetter
    )

    Open-DevEnvironment "WindowsFabric" "wf" $driveLetter
}

Export-ModuleMember -Function 'InitializeWFEnvironment'