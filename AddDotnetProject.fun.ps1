. (Join-Path -Path $PSScriptRoot -ChildPath ".\DotProjectInfo.class.ps1")
. (Join-Path -Path $PSScriptRoot -ChildPath ".\WriteAction.fun.ps1")
. (Join-Path -Path $PSScriptRoot -ChildPath ".\WriteDryRun.fun.ps1")
. (Join-Path -Path $PSScriptRoot -ChildPath ".\TestWorkingDirClean.fun.ps1")

function Add-Dotnet-Project(
    [Parameter(Mandatory = $true)][string]$Solution,
    [Parameter(Mandatory = $true)][string]$Project,
    [switch]$Dryrun = $false,
    [switch]$Nospace = $false,
    [string]$Type = "classlib"
) {
    [DotProjectInfo]$info = [DotProjectInfo]::new($Solution, $Project, $Nospace)

    if (-not (Test-Path -Path $info.SolutionFile)) {
        if (-not $Dryrun) {
            Write-Error ("Do not look like a Solution
    : " + $info.SolutionFile + " (Solution
     file) does not exists");
            return
        }
    }

    if (Test-Path -Path $info.ProjectDir) {
        if (-not $Dryrun) {
            Write-Error ("Looks like Project exists: " + $info.ProjectDir + " (Project dir) exists")
            return
        }
    }

    if (-not (Test-Working-Dir-Clean -dir $info.SolutionDir)) {
        Write-Error ("Solution directory not clean, commit changes before adding new Project")
        return
    }

    #
    # Start doing
    #

    if (-not $Dryrun) {
        Push-Location $info.SolutionDir
    }

    Write-Action ("Creates Project directory: " + $info.ProjectDir)
    if ($Dryrun) {
        Write-Dry-Run ("Project directory not created")
    }
    else {
        New-Item -Path $info.ProjectDir -ItemType "directory"
    }

    if (-not $Dryrun) {
        Push-Location $info.ProjectDir
    }

    Write-Action ("Creates dotnet Project of Type '" + $Type + "' in " + $info.ProjectDir)
    if (-not $Dryrun) {
        dotnet.exe new $Type
    }
    else {
        Write-Dry-Run("Project not created")
    }

    if (-not $Dryrun) {
        Pop-Location
        Push-Location $info.SolutionDir
    }

    Write-Action ("Adds Project file " + $info.ProjectFile + " to Solution")
    if (-not $Dryrun) {
        dotnet.exe sln add $info.ProjectFile
    }
    else {
        Write-Dry-Run("Project file not added")
    }

    Write-Action ('Commits new Project to git repository')
    if (-not $Dryrun) {
        git.exe add .
        git.exe commit -m ('added new Project ' + $Project);
    }
    else {
        Write-Dry-Run ("Nothing commited to repository")
    }

    #
    # Done
    #

    if (-not $Dryrun) {
        Pop-Location
        Pop-Location
    }

    Write-Action "Project created OK"
    if ($Dryrun) {
        Write-Dry-Run ("not actually created")
    }

    return
}
