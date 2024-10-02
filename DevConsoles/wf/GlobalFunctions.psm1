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

function Switch-Branch
{
    param (
        [string] $branch
    )

    iex "git checkout $branch"
    Open-DevEnvironment2
}

function Launch-SlnGen($project)
{
    . "$env:PkgSlnGen\\slngen.cmd" $project
}

Export-ModuleMember -Function 'Open-SetupSolution'
Export-ModuleMember -Function 'Enable-LinuxView'
Export-ModuleMember -Function 'Disable-LinuxView'
Export-ModuleMember -Function 'Switch-Branch'
Export-ModuleMember -Function 'Launch-SlnGen'
