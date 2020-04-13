function Write-Action {
    param (
        [string]$msg
    )
    
    Write-Host ""
    Write-Host $msg -BackgroundColor Gray -ForegroundColor Blue
}