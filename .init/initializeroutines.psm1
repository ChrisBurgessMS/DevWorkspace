function Open-WindowsFabricDevEnvironment
{
    param (
        [string] $driveLetter
    )

    Open-CoreXTEnvironment "WindowsFabric" "wf" $driveLetter
}

Export-ModuleMember -Function 'Open-WindowsFabricDevEnvironment'