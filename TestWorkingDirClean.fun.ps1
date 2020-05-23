function Test-Working-Dir-Clean (
    [Parameter(Mandatory = $true)][string]$dir
) {
    if (-not (Test-Path -Path $dir)) {
        Write-Error ("Working directory: " + $dir + " does not exists");
        return $false
    }

    [string]$gitDir = Join-Path -Path $dir -ChildPath ".git"
    if (-not (Test-Path -Path $gitDir)) {
        Write-Error ("Working dir do not look like a git repo: missing .git directory")
        return $false
    }

    Push-Location $dir
        [string]$gitStatus = (git status --porcelain)
        [bool]$retVal = $true
        if ($gitStatus) {
            $retVal = $false
        }
    Pop-Location

    return $retVal
}
