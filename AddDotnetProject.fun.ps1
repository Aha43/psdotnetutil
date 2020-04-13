. (Join-Path -Path $PSScriptRoot -ChildPath ".\DotProjectInfo.class.ps1")
. (Join-Path -Path $PSScriptRoot -ChildPath ".\WriteAction.fun.ps1")
. (Join-Path -Path $PSScriptRoot -ChildPath ".\WriteDryRun.fun.ps1")

function Add-Dotnet-Project(
    [Parameter(Mandatory = $true)][string]$solution,
    [Parameter(Mandatory = $true)][string]$project,
    [switch]$dryrun = $false,
    [switch]$nospace = $false,
    [string]$type = "classlib"
) {
    [DotProjectInfo]$info = [DotProjectInfo]::new($solution, $project, $nospace)

    if (-not (Test-Path -Path $info.SolutionFile)) {
        if (-not $dryrun) {
            Write-Error ("Do not look like a solution: " + $info.SolutionFile + " (solution file) does not exists");
            return
        }
    }

    if (Test-Path -Path $info.ProjectDir) {
        if (-not $dryrun) {
            Write-Error ("Looks like project exists: " + $info.ProjectDir + " (project dir) exists")
            return
        }
    }

    #
    # Start doing
    #

    if (-not $dryrun) {
        Push-Location $info.SolutionDir
    }

    Write-Action ("Creates project directory: " + $info.ProjectDir)
    if ($dryrun) {
        Write-Dry-Run ("project directory not created")
    }
    else {
        New-Item -Path $info.ProjectDir -ItemType "directory"
    }

    if (-not $dryrun) {
        Push-Location $info.ProjectDir
    }

    Write-Action ("Creates dotnet project of type '" + $type + "' in " + $info.ProjectDir)
    if (-not $dryrun) {
        dotnet.exe new $type
    }
    else {
        Write-Dry-Run("project not created")
    }

    if (-not $dryrun) {
        Pop-Location
        Push-Location $info.SolutionDir
    }

    Write-Action ("Adds project file " + $info.ProjectFile + " to solution")
    if (-not $dryrun) {
        dotnet.exe sln add $info.ProjectFile
    }
    else {
        Write-Dry-Run("project file not added")
    }

    Write-Action ('Commits new project to git repository')
    if (-not $dryrun) {
        git.exe add .
        git.exe commit -m ('added new project ' + $project);
    }
    else {
        Write-Dry-Run ("Nothing commited to repository")
    }

    #
    # Done
    #

    if (-not $dryrun) {
        Pop-Location
        Pop-Location
    }

    Write-Action "Project created OK"
    if ($dryrun) {
        Write-Dry-Run ("not actually created")
    }

    return
}
