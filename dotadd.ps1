param(
    [Parameter(Mandatory = $true)][string]$solution,
    [Parameter(Mandatory = $true)][string]$project,
    [switch]$dryrun = $false,
    [string]$type = "classlib"
)

[string]$repoarea = $env:DevRepDir

. (Join-Path -Path $PSScriptRoot -ChildPath ".\WriteHostFunctions.ps1")

[string]$RootDir = ""
[string]$SolutionDir = ""
[string]$ProjectDir = ""

$SolutionDir = Join-Path -Path $repoarea -ChildPath $solution
$SolutionFile = Join-Path -Path $SolutionDir -ChildPath ($solution + ".sln")
$ProjectQualifiedName = ($solution + '.' + $project)
$ProjectDir = Join-Path -Path $SolutionDir -ChildPath $ProjectQualifiedName
$ProjectFile = Join-Path -Path $ProjectDir -ChildPath ($ProjectQualifiedName + ".csproj")
$RootDir = $SolutionDir

Write-Host ("SolutionDir: " + $SolutionDir)
Write-Host ("SolutionFile: " + $SolutionFile)
Write-Host ("Project qualified name: " + $ProjectQualifiedName)
Write-Host ("Project file: " + $ProjectFile)
Write-Host ("RootDir: " + $RootDir)

#
# Test if can add project to solution
#

if (-not (Test-Path -Path $repoarea)) {
    Write-Error ("Repository area directory: " + $repoarea + " does not exists");
    exit 1
}

if (-not (Test-Path -Path $SolutionFile)) {
    Write-Error ("Do not look like a solution: " + $SolutionDir + " (solution file) does not exists");
    exit 1
}

if (Test-Path -Path $ProjectDir){
    Write-Error ("Looks like project exists: " + $ProjectDir + " (project dir) exists")
    exit 1
}

#
# Start doing
#

if (-not $dryrun) {
    Push-Location $SolutionDir
}

WriteAction ("Creates project directory: " + $ProjectDir)
if ($dryrun) {
    WriteDryRun ("project directory not created")
}
else {
    New-Item -Path $ProjectDir -ItemType "directory"
}

if (-not $dryrun) {
    Push-Location $ProjectDir
}

WriteAction ("Creates dotnet project of type '" + $type + "' in " + $ProjectDir)
if (-not $dryrun) {
    dotnet.exe new $type
}
else {
    WriteDryRun("project not created")
}

if (-not $dryrun) {
    Pop-Location
    Push-Location $SolutionDir
}

WriteAction ("Adds project file " + $ProjectFile + " to solution")
if (-not $dryrun) {
    dotnet.exe sln add $ProjectFile
}
else {
    WriteDryRun("project file not added")
}

WriteAction ('Commits new project to git repository')
if (-not $dryrun) {
    git.exe add .
    git.exe commit -m ('added new project ' + $ProjectDir);
}
else {
    WriteDryRun ("Nothing commited to repository")
}

#
# Done
#

if (-not $dryrun) {
    Pop-Location
    Pop-Location
}

WriteAction "Project created OK"
if ($dryrun) {
    WriteDryRun ("not actually created")
}

exit 0
