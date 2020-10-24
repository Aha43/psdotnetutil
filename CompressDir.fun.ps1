. (Join-Path -Path $PSScriptRoot -ChildPath ".\Result.class.ps1")

function Compress-Dir (
    [Parameter(Mandatory=$true)][string]$SrcPath,
    [Parameter(Mandatory=$true)][string]$DstPath,
    [Switch]$DryRun
) {
    $retVal = [Result]::new()
    
    try {
        if (Test-Path -Path $SrcPath) {
            if ((Get-Item -Path $SrcPath) -is [System.IO.DirectoryInfo]) {
                if ($DryRun) {
                    Compress-Archive -Force -Path ($SrcPath + "/*") -WhatIf -DestinationPath $DstPath
                }
                else {
                    Compress-Archive -Force -Path ($SrcPath + "/*") -DestinationPath $DstPath
                }
                $retVal.Ok = $true
            } 
            else {
                $retVal.ErrorMessage = ($SrcPath + " not a directory")
            }
        }
        else {
            $retVal.ErrorMessage = ($SrcPath + " does not exists")
        }
    }
    catch {
        $retVal.ErrorMessage = "Failed to zip: $($PSItem.ToString())"
    }

    return $retVal
}