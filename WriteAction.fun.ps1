function Write-Action {
    param (
        [string]$Msg
    )
    
    Write-Host ""
    Write-Host $Msg -BackgroundColor Gray -ForegroundColor Blue
}