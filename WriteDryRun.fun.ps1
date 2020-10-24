function Write-Dry-Run {
    param (
        [string]$Msg
    )
    
    Write-Host ("   dryrun: " + $Msg) -BackgroundColor Gray -ForegroundColor Black
}