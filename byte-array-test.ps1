Import-Module ./byte-array-fns.psm1 -DisableNameChecking

Write-Host (bytes-to-bin (num-to-bytes-big-endian 9))

$x =(bytes-to-bin ([byte[]]@(1,0)))
Write-Host $x

$x =(bytes-to-hex ([byte[]]@(1,0)))
Write-Host $x

$x =(bytes-to-number ([byte[]]@(1,0)))
Write-Host $x

$x =(bytes-to-number ([byte[]]@(1,1)))
Write-Host $x
