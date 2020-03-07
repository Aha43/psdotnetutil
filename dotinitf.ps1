function New-Dotnet-Project(
    [Parameter(Mandatory = $true)][string]$project,
    [switch]$dryrun = $false,
    [string]$type = "classlib",
    [switch]$nosln = $false
) {
    [string]$repoarea = $env:DevRepDir

    if (-not $repoarea) {
        Write-Error "Repository area directory not given: set the DevRepDir env variable"
        return
    }

    [string]$RootDir = ""
    [string]$SolutionDir = ""
    [string]$ProjectDir = ""
    if ($nosln) {
        $ProjectDir = Join-Path -Path $repoarea -ChildPath $project
        $RootDir = $ProjectDir
    }
    else {
        $SolutionDir = Join-Path -Path $repoarea -ChildPath $project
        $ProjectDir = Join-Path -Path $SolutionDir -ChildPath $project
        $RootDir = $SolutionDir
    }

    #
    # Test if can make solution / project
    #

    if (-not (Test-Path -Path $repoarea)) {
        Write-Error ("Repository area directory: " + $repoarea + " does not exists");
        return
    }

    if ($nosln) {
        if (Test-Path -Path $ProjectDir) {
            Write-Error ("Project directory: " + $ProjectDir + " exists")
            return
        }
    }
    else {
        if (Test-Path -Path $SolutionDir) {
            Write-Error ("Solution directory: " + $SolutionDir + " exists")
            return
        }
    }

    #
    # Start doing
    #

    if (-not $nosln) {
        Write-Host ""
        Write-Action ("Creates solution directory: " + $SolutionDir)
        if ($dryrun) {
            Write-Dry-Run ("solution directory not created")
        }
        else {
            New-Item -Path $SolutionDir -ItemType "directory"
        }
    }

    Write-Action ("Creates project directory: " + $ProjectDir)
    if ($dryrun) {
        Write-Dry-Run ("dryrun: project directory not created")
    }
    else {
        New-Item -Path $ProjectDir -ItemType "directory"
    }

    if (-not $dryrun) {
        Push-Location $ProjectDir
    }

    Write-Action ("Creates dotnet project of type '" + $type + "' in " + $ProjectDir)
    if (-not $dryrun) {
        dotnet.exe new $type
    }
    else {
        Write-Dry-Run("project not created")
    }

    if (-not $dryrun) {
        Pop-Location
        Push-Location $RootDir
    }

    if (-not $nosln) {
        [string]$ProjectFile = Join-Path -Path $ProjectDir -ChildPath ($project + ".csproj")
        Write-Host ""
        Write-Action ("Creates solution file in " + $RootDir + " and adds project file " + $ProjectFile)
        if (-not $dryrun) {
            dotnet.exe new sln
            dotnet.exe sln add $ProjectFile
        }
        else {
            Write-Dry-Run("solution not created")
        }
    }

    Write-Action ("Creates git repository, gitignore file and initial commit in " + $RootDir)
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
