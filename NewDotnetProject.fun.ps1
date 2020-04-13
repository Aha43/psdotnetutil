. (Join-Path -Path $PSScriptRoot -ChildPath ".\DotProjectInfo.class.ps1")
. (Join-Path -Path $PSScriptRoot -ChildPath ".\WriteAction.fun.ps1")
. (Join-Path -Path $PSScriptRoot -ChildPath ".\WriteDryRun.fun.ps1")

function New-Dotnet-Project(
    [Parameter(Mandatory = $true)][string]$project,
    [switch]$dryrun = $false,
    [string]$type = "webapi",
    [switch]$nosln = $false,
    [switch]$nospace = $false,
    [switch]$stemsln = $false
) {
    [string]$repoarea = $env:DevRepDir
    if (-not $repoarea) {
        Write-Error "Repository area directory not given: set the DevRepDir env variable"
        return
    }

    [DotProjectInfo]$info = [DotProjectInfo]::new($project, $nosln, $nospace, $stemsln)

    #
    # Test if can make solution / project
    #

    if (-not (Test-Path -Path $repoarea)) {
        Write-Error ("Repository area directory: " + $repoarea + " does not exists");
        return
    }

    if ($nosln) {
        if (Test-Path -Path $info.ProjectDir) {
            Write-Error ("Project directory: " + $info.ProjectDir + " exists")
            return
        }
    }
    else {
        if (Test-Path -Path $info.SolutionDir) {
            Write-Error ("Solution directory: " + $info.SolutionDir + " exists")
            return
        }
    }

    #
    # Start doing
    #

    if (-not $nosln) {
        Write-Host ""
        Write-Action ("Creates solution directory: " + $info.SolutionDir)
        if ($dryrun) {
            Write-Dry-Run ("solution directory not created")
        }
        else {
            New-Item -Path $info.SolutionDir -ItemType "directory"
        }
    }

    Write-Action ("Creates project directory: " + $info.ProjectDir)
    if ($dryrun) {
        Write-Dry-Run ("dryrun: project directory not created")
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
        Push-Location $info.RootDir
    }

    if (-not $nosln) {
        Write-Host ""
        Write-Action ("Creates solution file in " + $info.RootDir + " and adds project file " + $info.ProjectFile)
        if (-not $dryrun) {
            dotnet.exe new sln
            dotnet.exe sln add $info.ProjectFile
        }
        else {
            Write-Dry-Run("solution not created")
        }
    }

    Write-Action ("Creates git repository, gitignore file and initial commit in " + $info.RootDir)
    if (-not $dryrun) {
        git.exe init
        dotnet.exe new gitignore
        git.exe add .
        git.exe commit -m 'initial commit'
    }
    else {
        Write-Dry-Run ("git repository not created")
    }

    #
    # Done
    #

    if (-not $dryrun) {
        Pop-Location
    }

    Write-Action "Project created OK"
    if ($dryrun) {
        Write-Dry-Run ("not actually created")
    }
}
