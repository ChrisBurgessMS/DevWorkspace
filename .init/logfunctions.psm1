function LogInfo
{
	param
	(
		[string]
		$LogEntry
	)

    Write-Host "INFO: $LogEntry"
}

function LogSuccess
{
	param
	(
		[string]
		$LogEntry
	)

    Write-Host "SUCCESS: $LogEntry" -ForegroundColor green
}

function LogWarning
{
	param
	(
		[string]
		$LogEntry
	)

    Write-Host "WARNING: $LogEntry" -ForegroundColor yellow
}

function LogError
{
	param
	(
		[string]
		$LogEntry
	)
    Write-Host "ERROR: $LogEntry" -ForegroundColor red
}

function LogVerbose
{
	param
	(
		[string]
		$LogEntry
    )

    if ($global:VerboseLogEnabled)
    {
        Write-Host "VERBOSE: $LogEntry"
    }
}

Export-ModuleMember -Function 'LogInfo'
Export-ModuleMember -Function 'LogSuccess'
Export-ModuleMember -Function 'LogWarning'
Export-ModuleMember -Function 'LogError'
Export-ModuleMember -Function 'LogVerbose'