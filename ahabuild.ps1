
param(
    [string] $ext = "",
    [switch] $dryrun,
    [switch] $v
)

function ReplaceLine {
    param (
        [string[]]$lines,
        [string]$match,
        [string]$newLine
    )

    $nr = MatchLine -lines $lines -match $match
    if ($nr -lt -1) 
    {
        return false
    }

    $lines[$nr] = $newLine

    return true
}

function MatchLine {
    param (
        [string[]]$lines,
        [string]$match
    )

    $retVal = -1
    
    for ($i=0; $i -lt $lines.Count; $i++)
    {
        [string]$line = $lines[$i];
        if ($line -like $match)
        {
            $retVal = $i
        }
        
    }

    return $retVal
}

$buildDir = (Get-Item -Path .).Name
$yamlFile = "./Acos.IdentityServer.v2/idserver.config.yaml"
$webConfigFile = "./Acos.IdentityServer.v2\web.config.cors"
$pubDir = "../../published/" + $buildDir + $ext
$connectionString = '        <environmentVariable name="SqlConnections:ConnectionString" value="Data Source=vt-dfsql2017\DEV;Initial Catalog=SamspillIdentity;Integrated Security=SSPI" />'

Write-Output ""
Write-Output ("Build dir: " + $buildDir)
Write-Output ("Publish dir: " + $pubDir)
Write-Output ("YAML file: " + $yamlFile)
Write-Output ("web.config file: " + $webConfigFile)
Write-Output ""

$webConfigContent = Get-Content -Path $webConfigFile
$sqlConLine = (MatchLine -lines $webConfigContent -match "*SqlConnections*")
$webConfigContent[$sqlConLine] = $connectionString

if ($v)
{
    Write-Output ""
    Write-Output "--- web config ---"
    Write-Output ""
    Write-Output $webConfigContent
    Write-Output "---"
}

if (-not $dryrun)
{
    $buildResult = (dotnet build *>&1)
    if ($LASTEXITCODE -eq 0) 
    {
        Write-Output "Build ok"
        Write-Output ""

        $pubResult = (dotnet publish --no-build -o $pubDir *>&1)
        if ($LASTEXITCODE -eq 0)
        {
            Write-Output "Publishing ok"
            Write-Output ""

            $yamlResult = (Copy-Item $yamlFile $pubDir *>&1)
            if ($yamlResult.length -eq 0)
            {
                Write-Output "YAML file copied ok"

                Set-Content -Path ($pubDir + "/web.config") -Value $webConfigContent

                
            } 
            else 
            {
                Write-Output "YAML file copy failed"
                $ErrorString = $yamlResult -join [System.Environment]::NewLine
                Write-Output $ErrorString
                exit 1        
            }
        }
        else
        {
            $ErrorString = $pubResult -join [System.Environment]::NewLine
            Write-Output $ErrorString
            exit 1    
        }
    }
    else
    {
        $ErrorString = $buildResult -join [System.Environment]::NewLine
        Write-Output $ErrorString
        exit 1
    }
}

Write-Output ""
exit 0


