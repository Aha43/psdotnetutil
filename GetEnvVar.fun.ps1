. (Join-Path -Path $PSScriptRoot -ChildPath ".\Result.class.ps1")

function Get-Env-Variable(
    [Parameter(Mandatory = $true)][string]$name,
    [string]$type = "string"
) {
    Push-Location Env:  

    [bool]$exists = Test-Path $name
    
    [Result]$retVal
    if (-not $exists) {
        $retVal = [Result]::new("Environment variable: " + $name + " not set", $false)
        Pop-Location
    } else {
        $item = Get-Item -Path $name
        $value = $item.Value
        Pop-Location
        switch ($type) {
            "string" { 
                $retVal = [Result]::new($value, $true); 
                Break 
            }
            "dir" {
                if (Test-Path -Path $value -PathType Container) {
                    $retVal = [Result]::new($value, $true)
                }
                else {
                    $retVal = [Result]::new("Environment variable: " + $name + " do not refer to a directory", $false)
                }
                Break
            }
            "file" {
                if (Test-Path -Path $value -PathType Leaf) {
                    $retVal = [Result]::new($value, $true)
                }
                else {
                    $retVal = [Result]::new("Environment variable: " + $name + " do not refer to a file", $false)
                }
                Break
            }
            default { $retVal = [Result]::new("Uknown input for type: " + $type, $false)}
        }
    }
    
    return $retVal
}