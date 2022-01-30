# PowerShell functions to deal with byte array conversions.
# Copyright (c) 2022 by Paweł Wilk <pw@gnu.org>
# License: LGPL v3.0 -- https://www.gnu.org/licenses/lgpl-3.0.en.html

function bytes-to-nums($bytes)
{
    return $True
}
Export-ModuleMember -Function bytes-to-nums

function num-to-bytes {
    # .DESCRIPTION
    # Takes a number and creates a byte array.
    param($num)
    return [System.BitConverter]::GetBytes($num)
}
Export-ModuleMember -Function num-to-bytes

function bytes-add-left {
    # .DESCRIPTION
    # Takes two byte arrays and creates a new one by concatenating them
    # with the second one placed first.
    param([byte[]] $b, [byte[]] $v)
    [byte[]] $x = $v + $b
    return ,$x
}
Export-ModuleMember -Function bytes-add-left

function bytes-add-right {
    # .DESCRIPTION
    # Takes two byte arrays and creates a new one by concatenating them.
    param([byte[]] $b, [byte[]] $v)
    [byte[]] $x = $b + $v
    return ,$x
}
Export-ModuleMember -Function bytes-add-right

function bytes-fill-left {
    # .DESCRIPTION
    # Takes a bytes array and pads its left side with bytes of value 0
    # to match the maximum size of $min_bytes. Returns new bytes array.
    param([byte[]] $b, $min_bytes)
    if ($min_bytes -le $b.Count) { return ,$b }
    $min_bytes = $min_bytes - $b.Count
    return (bytes-add-left $b ([byte[]]::new($min_bytes)))
}
Export-ModuleMember -Function bytes-fill-left

function bytes-fill-right {
    # .DESCRIPTION
    # Takes a bytes array and pads its right side with bytes of value 0
    # to match the maximum size of $min_bytes. Returns new bytes array.
    param([byte[]] $b, $min_bytes)
    if ($min_bytes -le $b.Count) { return ,$b }
    $min_bytes = $min_bytes - $b.Count
    return (bytes-add-right $b ([byte[]]::new($min_bytes)))
}
Export-ModuleMember -Function bytes-fill-right

function bit-pos-to-bytes-little-endian {
    # .DESCRIPTION
    # Takes a bit position to set and creates a byte array with
    # Little-Endian bytes order.
    param($num)
    if ($num -eq 0) {
        return [byte[]]::new(1)
    }
    $bytes_size     = 1 + [int][Math]::Floor($num / 8.1)
    $bit_index      = 8 - ($num % 8)
    $bmask          = "00000000"
    if ($bit_index -eq 8) { $bit_index = 0}
    $bbyte          = $bmask.remove($bit_index, 1).insert($bit_index, "1")
    [byte[]] $bytes = [byte[]]::new($bytes_size)
    $bytes[0]       = [System.Convert]::ToByte($bbyte, 2)
    return ,$bytes
}
Export-ModuleMember -Function bit-pos-to-bytes-little-endian

function bits-pos-to-bytes-little-endian {
    # .DESCRIPTION
    # Takes an iterable collection of bit positions to be set and creates
    # a byte array with Little-Endian bytes order with all bits set.
    param($nums)
    $nmax       = ($nums | Measure-Object -Maximum).Maximum
    $bytes_size = 1 + [int][Math]::Floor($nmax / 8.1)
    $bytes_out  = [byte[]]::new($bytes_size)
    foreach($num in $nums) {
        $bytes    = (bit-pos-to-bytes-little-endian $num)
        $bytes    = (bytes-fill-left $bytes $bytes_size)
        $cur_byte = 0
        foreach($byte in $bytes) {
            $bytes_out[$cur_byte] = ($byte -bor $bytes_out[$cur_byte])
            $cur_byte += 1
        }
    }
    return ,([byte[]] $bytes_out)
}
Export-ModuleMember -Function bits-pos-to-bytes-little-endian

function bits-pos-to-bytes-big-endian {
    # .DESCRIPTION
    # Takes an iterable collection of bit positions to be set and creates
    # a byte array with Big-Endian bytes order with all bits set.
    param($nums)
    $nmax       = ($nums | Measure-Object -Maximum).Maximum
    $bytes_size = 1 + [int][Math]::Floor($nmax / 8.1)
    $bytes_out  = [byte[]]::new($bytes_size)
    foreach($num in $nums) {
        $bytes    = (bit-pos-to-bytes-big-endian $num)
        $bytes    = (bytes-fill-right $bytes $bytes_size)
        $cur_byte = 0
        foreach($byte in $bytes) {
            $bytes_out[$cur_byte] = ($byte -bor $bytes_out[$cur_byte])
            $cur_byte += 1
        }
    }
    return ,([byte[]] $bytes_out)
}
Export-ModuleMember -Function bits-pos-to-bytes-big-endian

function bytes-copy {
    # .DESCRIPTION
    # Takes a byte array and copies it into a new structure.
    param([byte[]] $b)
    $newb = [byte[]]::new($b.Count)
    [array]::Copy([byte[]]$b, [byte[]]$newb, $b.Count)
    return ,([byte[]] $newb)
}
Export-ModuleMember -Function bytes-copy

function bytes-reverse {
    # .DESCRIPTION
    # Takes a byte array and reverses its order.
    param([byte[]] $b)
    [byte[]] $newb = (bytes-copy $b)
    [array]::Reverse($newb)
    return ,([byte[]] $newb)
}
Export-ModuleMember -Function bytes-reverse

function bit-pos-to-bytes-big-endian {
    # .DESCRIPTION
    # Takes a bit position to set and creates a byte array with Big-Endian
    # bytes order.
    param($num)
    [byte[]] $a = (bit-pos-to-bytes-little-endian $num)
    return (bytes-reverse $a)
}
Export-ModuleMember -Function bit-pos-to-bytes-big-endian

function bytes-to-int16 {
    # .DESCRIPTION
    # Takes a byte array and converts it to a 16-bit unsigned integer.
    param([byte[]] $b)
    return [System.BitConverter]::ToUInt16($b)
}
Export-ModuleMember -Function bytes-to-int16

function bytes-to-int32 {
    # .DESCRIPTION
    # Takes a byte array and converts it to a 32-bit unsigned integer.
    param([byte[]] $b)
    return [System.BitConverter]::ToUInt32($b)
}
Export-ModuleMember -Function bytes-to-int32

function bytes-to-int64 {
    # .DESCRIPTION
    # Takes a byte array and converts it to a 64-bit unsigned integer.
    param([byte[]] $b)
    return [System.BitConverter]::ToUInt64($b)
}
Export-ModuleMember -Function bytes-to-int64

function bytes-to-hex {
    # .DESCRIPTION
    # Takes a byte array and converts it to a hexadecimal string beginning with 0x.
    param([byte[]] $b)
    return ("0x" + [System.Convert]::ToHexString($b))
}
Export-ModuleMember -Function bytes-to-hex

function bytes-to-dec {
    # .DESCRIPTION
    # Takes a byte array and converts it to a decimal value.
    param([byte[]] $b)
    return [decimal](bytes-to-hex $b)
}
Export-ModuleMember -Function bytes-to-dec

function bytes-to-bin {
    # .DESCRIPTION
    # Takes a byte array and converts it to a binary string representation.
    param([byte[]] $b)
    $r = ""
    foreach($byte in $b) {
        $r += [System.Convert]::ToString($byte, 2).PadLeft(8,'0')
    }
    return $r
}
Export-ModuleMember -Function bytes-to-bin

function bytes-to-number {
    # .DESCRIPTION
    # Takes a byte array and converts it to an unsigned number selecting the best
    # data type on a basis of its length. When there is no data type which exactly
    # matches number of bytes, it will pad the input with an empty byte added
    # at the beginning before passing to a conversion function.
    param([byte[]] $b)
    $r = $Null
    switch([int]$b.Count) {
        0 { [byte]   $r = 0; break }
        1 { [byte]   $r = $b[0]; break }
        2 { [UInt16] $r = bytes-to-int16 $b; break }
        3 { [UInt32] $r = bytes-to-int32 (bytes-add-left $b 0); break }
        4 { [UInt32] $r = bytes-to-int32 $b; break }
        5 { [UInt64] $r = bytes-to-int64 (bytes-add-left $b 0); break }
        6 { [UInt64] $r = bytes-to-int64 $b; break }
        default { [decimal] $r = bytes-to-dec $b; break}
    }
    return $r
}
Export-ModuleMember -Function bytes-to-number
