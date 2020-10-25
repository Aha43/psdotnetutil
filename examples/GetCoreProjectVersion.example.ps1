. (Join-Path -Path $PSScriptRoot -ChildPath "..\GetCoreProjectVersion.fun.ps1")

$result = Get-Core-Project-Version(".\input\test.csproj.tst")
$result