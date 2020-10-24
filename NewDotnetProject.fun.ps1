. (Join-Path -Path $PSScriptRoot -ChildPath ".\DotProjectInfo.class.ps1")
. (Join-Path -Path $PSScriptRoot -ChildPath ".\WriteAction.fun.ps1")
. (Join-Path -Path $PSScriptRoot -ChildPath ".\WriteDryRun.fun.ps1")

function New-Dotnet-Project(
    [Parameter(Mandatory = $true)][string]$Project,
    [switch]$Dryrun = $false,
    [string]$Type = "webapi",
    [switch]$Nosln = $false,
    [switch]$Nospace = $false,
    [switch]$Stemsln = $false
) {
    [string]$repoarea = $env:DevRepDir
    if (-not $repoarea) {
        Write-Error "Repository area directory not given: set the DevRepDir env variable"
        return
    }

    [DotProjectInfo]$info = [DotProjectInfo]::new($Project, $Nosln, $Nospace, $Stemsln)

    #
    # Test if can make solution / Project
    #

    if (-not (Test-Path -Path $repoarea)) {
        Write-Error ("Repository area directory: " + $repoarea + " does not exists");
        return
    }

    if ($Nosln) {
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

    if (-not $Nosln) {
        Write-Host ""
        Write-Action ("Creates solution directory: " + $info.SolutionDir)
        if ($Dryrun) {
            Write-Dry-Run ("solution directory not created")
        }
        else {
            New-Item -Path $info.SolutionDir -ItemType "directory"
        }
    }

    Write-Action ("Creates Project directory: " + $info.ProjectDir)
    if ($Dryrun) {
        Write-Dry-Run ("Dryrun: Project directory not created")
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
        Push-Location $info.RootDir
    }

    if (-not $Nosln) {
        Write-Host ""
        Write-Action ("Creates solution file in " + $info.RootDir + " and adds Project file " + $info.ProjectFile)
        if (-not $Dryrun) {
            dotnet.exe new sln
            dotnet.exe sln add $info.ProjectFile
        }
        else {
            Write-Dry-Run("solution not created")
        }
    }

    Write-Action ("Creates git repository, gitignore file and initial commit in " + $info.RootDir)
    if (-not $Dryrun) {
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

    if (-not $Dryrun) {
        Pop-Location
    }

    Write-Action "Project created OK"
    if ($Dryrun) {
        Write-Dry-Run ("not actually created")
    }
}
