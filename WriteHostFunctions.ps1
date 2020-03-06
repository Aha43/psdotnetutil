
function WriteAction {
    param (
        [string]$msg
    )
    
    Write-Host ""
    Write-Host $msg -BackgroundColor Gray -ForegroundColor Blue
}

function WriteDryRun {
    param (
        [string]$msg
    )
    
    Write-Host ("   dryrun: " + $msg) -BackgroundColor Gray -ForegroundColor Black
}
