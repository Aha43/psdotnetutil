function Publish-Dotnet-Project(
    [Parameter(Mandatory = $true)][string]$solution,
    [Parameter(Mandatory = $true)][string]$project,
    [switch]$dryrun = $false,
    [switch]$envspace = $false
) {
    [string]$repoarea = $env:DevRepDir

    
}
