
$var1 = 1
$var2 = "abc"

function setVar {
    $var1 = 2
    
}

# Clear-Variable -Name var2

# Get-ChildItem Variable:

Write-Output $var1
Write-Output $var2