Import-Module ./byte-array-fns.psm1 -DisableNameChecking -Force


$na = 1
$nb = 9
$nx = 10
$nd = 1

$a = (bit-pos-to-bytes-big-endian    $na)
$b = (bit-pos-to-bytes-big-endian    $nb)
$x = (bit-pos-to-bytes-little-endian $nx)
$d = (bit-pos-to-bytes-little-endian $nd)

Write-Host ""
Write-Host "------ be:"
Write-Host ""

Write-Host (bytes-to-bin $b)
Write-Host (bytes-to-hex $b)
Write-Host (bytes-to-number $b)

Write-Host ""
Write-Host "------ le:"
Write-Host ""

Write-Host (bytes-to-bin $x)
Write-Host (bytes-to-hex $x)
Write-Host (bytes-to-number $x $true)

Write-Host ""
Write-Host "-------------------------------"
Write-Host ""

Write-Host "A:" (bytes-to-bin $a) "bit position:" $na "big-endian"
Write-Host "B:" (bytes-to-bin $b) "bit position:" $nb "big-endian"
Write-Host "C:" (bytes-to-bin $x) "bit position:" $nx "little-endian"
Write-Host "D:" (bytes-to-bin $d) "bit position:" $nd "little-endian"

$r = (bits-pos-to-bytes-big-endian @($na, $na))
Write-Host ""
Write-Host "[BE]   A:" (bytes-to-bin $a) "[" (bytes-to-hex $a) "," (bytes-to-dec $a) "]"
Write-Host "[BE]   A:" (bytes-to-bin $a) "[" (bytes-to-hex $a) "," (bytes-to-dec $a) "]"
Write-Host "[BE] A|A:" (bytes-to-bin $r) "[" (bytes-to-hex $r) "," (bytes-to-dec $r) "]"
Write-Host "[BE] POS:" $((bytes-to-bit-positions $r) -join ", ")

$r = (bits-pos-to-bytes-big-endian @($na, $nb))
Write-Host ""
Write-Host "[BE]   A:" (bytes-to-bin $a) "[" (bytes-to-hex $a) "," (bytes-to-dec $a) "]"
Write-Host "[BE]   B:" (bytes-to-bin $b) "[" (bytes-to-hex $b) "," (bytes-to-dec $b) "]"
Write-Host "[BE] A|B:" (bytes-to-bin $r) "[" (bytes-to-hex $r) "," (bytes-to-dec $r) "]"
Write-Host "[BE] POS:" $((bytes-to-bit-positions $r) -join ", ")

$r = (bits-pos-to-bytes-big-endian @($nb, $nb))
Write-Host ""
Write-Host "[BE]   B:" (bytes-to-bin $b) "[" (bytes-to-hex $b) "," (bytes-to-dec $b) "]"
Write-Host "[BE]   B:" (bytes-to-bin $b) "[" (bytes-to-hex $b) "," (bytes-to-dec $b) "]"
Write-Host "[BE] B|B:" (bytes-to-bin $r) "[" (bytes-to-hex $r) "," (bytes-to-dec $r) "]"
Write-Host "[BE] POS:" $((bytes-to-bit-positions $r) -join ", ")

$r = (bits-pos-to-bytes-little-endian @($nx, $nx))
Write-Host ""
Write-Host "[LE]   C:" (bytes-to-bin $x) "[" (bytes-to-hex $x) "," (bytes-to-dec $x) "]"
Write-Host "[LE]   C:" (bytes-to-bin $x) "[" (bytes-to-hex $x) "," (bytes-to-dec $x) "]"
Write-Host "[LE] C|C:" (bytes-to-bin $r) "[" (bytes-to-hex $r) "," (bytes-to-dec $r) "]"
Write-Host "[LE] POS:" $((bytes-to-bit-positions $r) -join ", ")

$r = (bits-pos-to-bytes-little-endian @($nx, $nd))
Write-Host ""
Write-Host "[LE]   C:" (bytes-to-bin $x) "[" (bytes-to-hex $x) "," (bytes-to-dec $x) "]"
Write-Host "[LE]   D:" (bytes-to-bin $d) "[" (bytes-to-hex $d) "," (bytes-to-dec $d) "]"
Write-Host "[LE] C|D:" (bytes-to-bin $r) "[" (bytes-to-hex $r) "," (bytes-to-dec $r) "]"
Write-Host "[LE] POS:" $((bytes-to-bit-positions $r) -join ", ")

$r = (bits-pos-to-bytes-little-endian @($nd, $nd))
Write-Host ""
Write-Host "[LE]   D:" (bytes-to-bin $d)
Write-Host "[LE]   D:" (bytes-to-bin $d)
Write-Host "[LE] D|D:" (bytes-to-bin $r)
Write-Host "[LE] POS:" $((bytes-to-bit-positions $r) -join ", ")

Write-Host ""
Write-Host "-------------------------------"
Write-Host ""

$x =(bytes-to-bin ([byte[]]@(1,1)))
Write-Host $x

$x =(bytes-to-hex ([byte[]]@(1,1)))
Write-Host $x

$x =(bytes-to-number ([byte[]]@(1,1)))
Write-Host $x

$x =(bytes-to-number ([byte[]]@(1,1)))
Write-Host $x

Write-Host ""
Write-Host "-------------------------------"
Write-Host ""

$bid   = (bit-pos-to-bytes-big-endian 9)
$intid = (bytes-to-number $bid)
Write-Host $intid

$bid   = (bit-pos-to-bytes-big-endian 1)
$intid = (bytes-to-number $bid)
Write-Host $intid
