function New-Branch
{
    <#
    .SYNOPSIS
    Creates a new GIT branch and publishes it to the origin

    .DESCRIPTION
    Take the specified local branch and creates a new local branch from head.  It then publishes
    that new local branch to origin and sets that origin branch as the source for the new local branch
    #>
    param
    (
        [string]
        # Name of the new branch
        $branchName,

        [string]
        # Name of the local branch to branch from
        $sourceBranch
    )

    if( ($branchName -eq $null) -or
        ($branchName -eq ""))
    {
        Get-Help New-Branch
        return $false
    }

    if( ($sourceBranch -eq $null) -or
        ($sourceBranch -eq "") -or
        ($branchName -eq $sourceBranch))
    {
        Get-Help New-Branch
        return $false
    }

    iex "git checkout $sourceBranch"
    if($LASTEXITCODE -ne 0)
    {
        LogError "Unable to check out $sourceBranch"
        return $false
    }

    iex "git checkout -b $branchName"
    if($LASTEXITCODE -ne 0)
    {
        LogError "Unable to locally create $branchName"
        return $false
    }

    iex "git push origin $branchName"
    if($LASTEXITCODE -ne 0)
    {
        LogError "Unable to push $branchName to server"
        return $false
    }

    iex "git push -u origin $sourceBranch"
    if($LASTEXITCODE -ne 0)
    {
        LogError "Unable to set $sourceBranch as the upstream branch for $branchName"
        return $false
    }

    iex "git branch --set-upstream-to=origin/$branchName $branchName"
    if($LASTEXITCODE -ne 0)
    {
        LogError "Unable to delete remote branch $branchName"
        return $false
    }

    return $true
}

function Remove-Branch
{
    <#
    .SYNOPSIS
    Delete the specified branch in the local git repository and also on the origin

    .DESCRIPTION
    Take the specified local branch and deletes it.  It then pushes deleting the origin branch of the same name
    #>
    param
    (
        [string]
        # Name of the branch to delete
        $branchName
    )

    if( ($branchName -eq $null) -or
        ($branchName -eq "") -or
        ($branchName -eq "develop") -or
        ($branchName -eq "master") )
    {
        Get-Help Remove-Branch
        return $false
    }

    iex "git checkout develop"
    if($LASTEXITCODE -ne 0)
    {
        LogError "Unable to check out develop"
        return $false
    }

    iex "git branch -d $branchName"
    if($LASTEXITCODE -ne 0)
    {
        LogError "Unable to delete $branchName"
        return $false
    }

    iex "git push origin :$branchName"
    if($LASTEXITCODE -ne 0)
    {
        LogError "Unable to delete remote branch $branchName"
        return $false
    }
}

function Get-Branch
{
    <#
    .SYNOPSIS
    Brings a new reference of a branch from origin locally using the same name

    .DESCRIPTION
    Brings a new reference of a branch from origin locally using the same name
    #>
    param
    (
        [string]
        # Name of the branch to create locally and point to origin of the same name
        $branchName
    )

    iex "git checkout --track -b $branchName origin/$branchName"
    if($LASTEXITCODE -ne 0)
    {
        LogError "Unable to setup new local branch tracking remote branch $branchName"
        return $false
    }
}

function OpenFiles
{
    #Index are files that GIT knows about
    if( ($GitStatus.Index.Added.Count    -ne 0) -or
        ($GitStatus.Index.Modified.Count -ne 0) -or
        ($GitStatus.Index.Deleted.Count  -ne 0) )
    {
        LogError "There are uncommitted changes"
        return $true
    }

    #Working are files that GIT doesn't know about but sees
    if( ($GitStatus.Working.Added.Count    -ne 0) -or
        ($GitStatus.Working.Modified.Count -ne 0) -or
        ($GitStatus.Working.Deleted.Count  -ne 0) )
    {
        LogInfo "There are untracked files"
        return $true
    }

    return $false
}

function UnpushedCommits
{
    #Is it ahead and behind?
    if (($GitStatus.BehindBy -gt 0) -and ($GitStatus.AheadBy -gt 0))
    {
        return $true
    }
    #Is it ahead?
    elseif ($GitStatus.AheadBy -gt 0)
    {
        return $true
    }

    return $false
}

Export-ModuleMember -Function 'New-Branch'
Export-ModuleMember -Function 'Remove-Branch'
Export-ModuleMember -Function 'Get-Branch'
Export-ModuleMember -Function 'OpenFiles'
Export-ModuleMember -Function 'UnpushedCommits'
