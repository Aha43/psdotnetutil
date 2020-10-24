function Test-Working-Dir-Clean (
    [Parameter(Mandatory = $true)][string]$Dir
) {
    if (-not (Test-Path -Path $Dir)) {
        Write-Error ("Working directory: " + $Dir + " does not exists");
        return $false
    }

    [string]$gitDir = Join-Path -Path $Dir -ChildPath ".git"
    if (-not (Test-Path -Path $gitDir)) {
        Write-Error ("Working Dir do not look like a git repo: missing .git directory")
        return $false
    }

    Push-Location $Dir
        [string]$gitStatus = (git status --porcelain)
        [bool]$retVal = $true
        if ($gitStatus) {
            $retVal = $false
        }
    Pop-Location

    return $retVal
}
