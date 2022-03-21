function InitializeWFEnvironment
{
    Open-DevEnvironment "WindowsFabric" "wf" $null $null
}

Export-ModuleMember -Function 'InitializeWFEnvironment'