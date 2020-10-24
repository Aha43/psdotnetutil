. (Join-Path -Path $PSScriptRoot -ChildPath ".\Result.class.ps1")

function Get-Env-Variable(
    [Parameter(Mandatory = $true)][string]$Name,
    [string]$Type = "string"
) {
    Push-Location Env:  

    [bool]$exists = Test-Path $Name
    
    [Result]$retVal
    if (-not $exists) {
        $retVal = [Result]::new("Environment variable: " + $Name + " not set", $false)
        Pop-Location
    } else {
        $item = Get-Item -Path $Name
        $value = $item.Value
        Pop-Location
        switch ($Type) {
            "string" { 
                $retVal = [Result]::new($value, $true); 
                Break 
            }
            "dir" {
                if (Test-Path -Path $value -PathType Container) {
                    $retVal = [Result]::new($value, $true)
                }
                else {
                    $retVal = [Result]::new("Environment variable: " + $Name + " do not refer to a directory", $false)
                }
                Break
            }
            "file" {
                if (Test-Path -Path $value -PathType Leaf) {
                    $retVal = [Result]::new($value, $true)
                }
                else {
                    $retVal = [Result]::new("Environment variable: " + $Name + " do not refer to a file", $false)
                }
                Break
            }
            default { $retVal = [Result]::new("Uknown input for Type: " + $Type, $false)}
        }
    }
    
    return $retVal
}