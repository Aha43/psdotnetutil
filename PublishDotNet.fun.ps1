function Publish-Dot-Net (
    [Parameter(Mandatory = $true)][string]$solution,
    [Parameter(Mandatory = $true)][string]$project,
    [Parameter(Mandatory = $true)][string]$target,
    [string]$configuration = 'release',
    [switch]$skiptarget = $false,
    [string]$framework
) {
    [string]$repoDir = $env:DevRepDir
    [string]$solutionDir = ($repoDir + '/' + $solution) 
    [string]$projectDir = ($solutionDir + '/' + $project)
    if (-not (Test-Path -Path $projectDir)) {
        Throw ('Project dir: ' + $projectDir + ' does not exists')
    }

    [string]$pubDir = ""
    [string]$pubDirRoot = $env:DevPublishDir
    [string]$pubDir = ($pubDirRoot + "\" + $project)
    if (-not (Test-Path -Path $pubDir)) {
        Write-Host ('Creates pub root dir for project: ' + $pubDir)
        New-Item -Path $pubDir -ItemType Directory
    }

    Write-Host ('Adds target: ' + $target + ' to pub path')
    $pubDir += ('\' + $target)  

    if (Test-Path -Path $pubDir) {
        Write-Host ('Removes existing pub dir: ' + $pubDir)
        Remove-Item -Force -Recurse -Path $pubDir
    }

    Write-Host ('Creates pub dir: ' + $pubDir)
    New-Item -Path $pubDir -ItemType Directory

    # build and publish
    Push-Location $solutionDir

    dotnet build

    [string]$pubcmd = ('dotnet publish ' + $project + ' --output ' + $pubDir)
    if ($configuration) {
        $pubcmd += (' --configuration ' + $configuration)
    }
    if ($framework) {
        $pubcmd += (' --framework ' + $framework)
    }

    #dotnet publish $project --output $pubDir
    Invoke-Expression -Command $pubcmd

    if (-not $skiptarget) {
        # copy target files if can find
        [string]$targetFilesSourceDir = ($env:DevTargetDir + '/' + $target + '/*')
        if (Test-Path -Path $targetFilesSourceDir) {
            Write-Host ('Copy target files from: ' + $targetFilesSourceDir)
            Copy-Item -Path $targetFilesSourceDir -Destination $pubDir
        }
    }
    else {
        Write-Host 'Skip copying target files'
    }
    
    Pop-Location
}
