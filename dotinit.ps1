param(
    [Parameter(Mandatory = $true)][string]$project,
    [switch]$dryrun = $false,
    [switch]$nogit = $false,
    [string]$type = "classlib",
    [switch]$nosln = $false
)

[string]$repoarea = $env:DevRepDir

. (Join-Path -Path $PSScriptRoot -ChildPath ".\WriteHostFunctions.ps1")

if (-not $repoarea) {
    Write-Error "Repository area directory not given: set the DevRepDir env variable"
    exit 1
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
# Test if can make project
#

if (-not (Test-Path -Path $repoarea)) {
    Write-Error ("Repository area directory: " + $repoarea + " does not exists");
    exit 1
}

if ($nosln) {
    if (Test-Path -Path $ProjectDir) {
        Write-Error ("Project directory: " + $ProjectDir + " exists")
        exit 1
    }
}
else {
    if (Test-Path -Path $SolutionDir) {
        Write-Error ("Solution directory: " + $SolutionDir + " exists")
        exit 1
    }
}

#
# Start doing
#

if (-not $nosln) {
    Write-Host ""
    WriteAction ("Creates solution directory: " + $SolutionDir)
    if ($dryrun) {
        WriteDryRun ("solution directory not created")
    }
    else {
        New-Item -Path $SolutionDir -ItemType "directory"
    }
}

Write-Host ""
WriteAction ("Creates project directory: " + $ProjectDir)
if ($dryrun) {
    WriteDryRun ("dryrun: project directory not created")
}
else {
    New-Item -Path $ProjectDir -ItemType "directory"
}

if (-not $dryrun) {
    Push-Location $ProjectDir
}

Write-Host ""
WriteAction ("Creates dotnet project of type '" + $type + "' in " + $ProjectDir)
if (-not $dryrun) {
    dotnet.exe new $type
}
else {
    WriteDryRun("project not created")
}

if (-not $dryrun) {
    Pop-Location
    Push-Location $RootDir
}

if (-not $nosln) {
    [string]$ProjectFile = Join-Path -Path $ProjectDir -ChildPath ($project + ".csproj")
    Write-Host ""
    WriteAction ("Creates solution file in " + $RootDir + " and adds project file " + $ProjectFile)
    if (-not $dryrun) {
        dotnet.exe new sln
        dotnet.exe sln add $ProjectFile
    }
    else {
        WriteDryRun("solution not created")
    }
}

if (-not $nogit) {
    Write-Host ""
    WriteAction ("Creates git repository, gitignore file and initial commit in " + $RootDir)
    if (-not $dryrun) {
        git.exe init
        dotnet.exe new gitignore
        git.exe add .
        git.exe commit -m 'initial commit'
    }
    else {
        WriteDryRun ("git repository not created")
    }
}

#
# Done
#

if (-not $dryrun) {
    Pop-Location
}

Write-Host ""
WriteAction "Project created OK"
if ($dryrun) {
    WriteDryRun ("not actually created")
}

exit 0
