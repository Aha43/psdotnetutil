. (Join-Path -Path $PSScriptRoot -ChildPath "..\CompressDir.fun.ps1")

$result = (Compress-Dir -SrcPath D:\published\No.Front.Dips.Auth.AuthenticationServer\arnepc.dips.local-felles.identityserver\ -DstPath .\thezip)
$result