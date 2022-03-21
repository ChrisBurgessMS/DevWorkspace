# This is an example default profile initialization script.
# It would become the script that is referenced by the variable $PROFILE

# Mount a VHD
$toolingVHDFullPath = Join-Path "z:\cburg-code.vhdx"

$initScriptDriveLetter = "X"
$initScriptDrive = "$($initScriptDriveLetter):"

# If the VHD isn't mounted then mount it
if (-not (Test-Path $initScriptDrive))
{
    # Mount the VHD
    # We already have a drive letter but this will provide one in case we need to work on that aspect
    $initScriptDriveLetter = (Mount-VHD -Path $toolingVHDFullPath -PassThru | Get-Disk | Get-Partition | Get-Volume).DriveLetter
    $initScriptDrive = "$($initScriptDriveLetter):"
}

# Call the generic initialization script
& "$initScriptDrive\cburg\.init\init.ps1"