function New-Sha256Based-Secret(
    [int]$Length = 64
) {
    $rng = New-Object System.Security.Cryptography.RNGCryptoServiceProvider
    $secretBytes = [System.Byte[]]::CreateInstance([System.Byte], $Length)
    $rng.GetBytes($secretBytes)
    $hash256 = New-Object System.Security.Cryptography.SHA256CryptoServiceProvider
    $hash = $hash256.ComputeHash($secretBytes)
    $secretEncoded = [Convert]::ToBase64String($secretBytes)
    $hashEncoded = [Convert]::ToBase64String($hash)
    Write-Output $secretEncoded
    Write-Output $hashEncoded
}
