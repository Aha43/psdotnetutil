function Write-Dry-Run {
    param (
        [string]$msg
    )
    
    Write-Host ("   dryrun: " + $msg) -BackgroundColor Gray -ForegroundColor Black
}