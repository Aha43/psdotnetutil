
function Write-Action {
    param (
        [string]$msg
    )
    
    Write-Host ""
    Write-Host $msg -BackgroundColor Gray -ForegroundColor Blue
}

function Write-Dry-Run {
    param (
        [string]$msg
    )
    
    Write-Host ("   dryrun: " + $msg) -BackgroundColor Gray -ForegroundColor Black
}
