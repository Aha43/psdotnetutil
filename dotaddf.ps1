function Add-Dotnet-Project(
    [Parameter(Mandatory = $true)][string]$solution,
    [Parameter(Mandatory = $true)][string]$project,
    [switch]$dryrun = $false,
    [switch]$nospace = $false,
    [string]$type = "classlib"
) {
    [string]$repoarea = $env:DevRepDir

    if ($env:DevTopNameSpace) {
        if (-not $nospace) {
            $solution = ($env:DevTopNameSpace + "." + $solution)
        }
    }

    [string]$RootDir = ""
    [string]$SolutionDir = ""
    [string]$ProjectDir = ""

    $SolutionDir = Join-Path -Path $repoarea -ChildPath $solution
    $SolutionFile = Join-Path -Path $SolutionDir -ChildPath ($solution + ".sln")
    $ProjectQualifiedName = ($solution + '.' + $project)
    $ProjectDir = Join-Path -Path $SolutionDir -ChildPath $ProjectQualifiedName
    $ProjectFile = Join-Path -Path $ProjectDir -ChildPath ($ProjectQualifiedName + ".csproj")
    $RootDir = $SolutionDir

    #
    # Test if can add project to solution
    #

    if (-not (Test-Path -Path $repoarea)) {
        Write-Error ("Repository area directory: " + $repoarea + " does not exists");
        return
    }

    if (-not (Test-Path -Path $SolutionFile)) {
        Write-Error ("Do not look like a solution: " + $SolutionFile + " (solution file) does not exists");
        return
    }

    if (Test-Path -Path $ProjectDir){
        Write-Error ("Looks like project exists: " + $ProjectDir + " (project dir) exists")
        return
    }

    #
    # Start doing
    #

    if (-not $dryrun) {
        Push-Location $SolutionDir
    }

    Write-Action ("Creates project directory: " + $ProjectDir)
    if ($dryrun) {
        Write-Dry-Run ("project directory not created")
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
        Push-Location $SolutionDir
    }

    Write-Action ("Adds project file " + $ProjectFile + " to solution")
    if (-not $dryrun) {
        dotnet.exe sln add $ProjectFile
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
