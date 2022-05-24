function Open-SetupSolution
{
    & "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\Common7\IDE\devenv.exe" "$global:DevPrivateRoot\solutions\Setup.sln"
}

function Enable-LinuxView
{
    if ( -not($Env:DefineConstants -match "DotNetCoreClrLinux"))
    {
        $Env:DefineConstants += "DotNetCoreClrLinux"
    }
}

function Disable-LinuxView
{
    $Env:DefineConstants = $Env:DefineConstants -replace "DotNetCoreClrLinux", ""
}

Export-ModuleMember -Function 'Open-SetupSolution'
Export-ModuleMember -Function 'Enable-LinuxView'
Export-ModuleMember -Function 'Disable-LinuxView'