If (-not (IsLoaded(".\Includes\include.ps1"))) { . .\Includes\include.ps1; RegisterLoaded(".\Includes\include.ps1") }
$Path = ".\Bin\NVIDIA-ethminer19a1fix\ethminer.exe"
$Uri = ""
$Commands = [PSCustomObject]@{ 
    "ethash" = "" #ethash
}
$Name = "$(Get-Item $MyInvocation.MyCommand.Path | Select-Object -ExpandProperty BaseName)"
$Commands | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | ForEach-Object { $Algo = Get-Algorithm $_; $_ } | Where-Object { $Pools.$Algo.Host } | ForEach-Object {
    [PSCustomObject]@{ 
        Type      = "NVIDIA"
        Path      = $Path
        Arguments = "--cuda-devices $($Config.SelGPUDSTM) --api-port -$($Variables.NVIDIAMinerAPITCPPort) -U -P stratum2+tcp://$($Pools.$Algo.User):$($Pools.$Algo.Pass)@$($Pools.$Algo.Host):$($Pools.$Algo.Port)$($Commands.$_)"
        HashRates = [PSCustomObject]@{ $Algo = $Stats."$($Name)_$($Algo)_HashRate".Week }
        API       = "ethminer"
        Port      = $Variables.NVIDIAMinerAPITCPPort #4068
        Wrap      = $false
        URI       = $Uri
    }
}
