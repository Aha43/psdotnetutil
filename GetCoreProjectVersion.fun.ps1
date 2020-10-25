. (Join-Path -Path $PSScriptRoot -ChildPath ".\Result.class.ps1")

function Get-Core-Project-Version(
    [string]$ProjectFilePath
) {
    $retVal = [Result]::new()

    try {
        if (Test-Path -Path $ProjectFilePath) {
            if ((Get-Item -Path $ProjectFilePath) -is [System.IO.FileInfo]) {
                [xml]$content = Get-Content -Path $ProjectFilePath
                if ($content) {
                    $ver = (Select-Xml -Xml $content -XPath "//Version")
                    if ($ver) {
                        [string]$version = $ver.Node.InnerText
                        if ($version) {
                            $retVal.Ok = $true
                            $retVal.Value = $version
                        }
                        else {
                            $retVal.ErrorMessage = "Version content not found in Version element"
                        }
                    }
                    else {
                        $retVal.ErrorMessage = "Version element not found in Project file"
                    }
                }
                else {
                    $retVal.ErrorMessage = "Project file is not xml file"
                }
            } else {
                $retVal.ErrorMessage = "Project file is not a file"    
            }
        }
        else {
            $retVal.ErrorMessage = "Project file not found"
        }
    }
    catch {
        $retVal.ErrorMessage = "Failed to extract version number: $($PSItem.ToString())"
    }
      
    return $retVal
}
