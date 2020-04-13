. (Join-Path -Path $PSScriptRoot -ChildPath ".\DotProjectInfo.class.ps1")

Write-Host 'Examples on how the options -project, -nospace, -nosln and -stemsln is used to define dot net project info.'
Write-Host 'For these examples the environment variables DevTopNameSpace and DevRepDir is set to Org.Macroshaft.Amazing.Api and C:\dev\myrepos respectively.'
Write-Host 'After the examples the values of environment values are restored'
Write-Host ' '

$origrep = $env:DevRepDir
$env:DevRepDir = "C:\dev\myrepos"
$origns = $env:DevTopNameSpace
$env:DevTopNameSpace = "Org.Macroshaft.Amazing.Api"

Write-Host 'Example 1 : Foo.Bar project in solution with same qualified name:'
[DotProjectInfo]$pi1 = Get-Project-Info -project "Foo.Bar"
$pi1

Write-Host 'Example 2 : Same as example 1 but Foo.Bar project not in the namespace given by environment variable DevTopNameSpace:'
[DotProjectInfo]$pi2 = Get-Project-Info -project "Foo.Bar" -nospace
$pi2

Write-Host 'Example 3 : Same as example 1 but project is not in a solution'
[DotProjectInfo]$pi3 = Get-Project-Info -project "Foo.Bar" -nosln
$pi3

Write-Host 'Example 4 : Same as example 1 but solution name is stem to qualified project name'
[DotProjectInfo]$pi4 = Get-Project-Info -project "Foo.Bar" -stemsln
$pi4

Write-Host 'Example 5 : Same as example 4 but Foo.Bar project not in the namespace given by environment variable DevTopNameSpace:'
[DotProjectInfo]$pi5 = Get-Project-Info -project "Foo.Bar" -nospace -stemsln
$pi5

$env:DevRepDir = $origrep
$env:DevTopNameSpace = $origns
