if (!(IsLoaded(".\Include.ps1"))) {. .\Include.ps1; RegisterLoaded(".\Include.ps1")}

$Path = ".\Bin\NVIDIA-TTMiner2116\TT-Miner.exe"
$Uri = "https://tradeproject.de/download/Miner/TT-Miner-2.1.16.zip"

$Commands = [PSCustomObject]@{
       "progpow"  = " -a PROGPOW-101" # (testing)
       "mtp"      = " -a MTP-101 " # (testing)
       "ethash"   = " -a ETHASH-101 "# (testing)
       #"ubqhash"  = " -a UBQHASH-100 "
       #"myr-gr"   = " -a MYRGR-100 " 
       "lyra2v3"  = " -a LYRA2V3-101 " # (testing)
}
 
$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | ForEach-Object {
    $Algo = Get-Algorithm($_)
    [PSCustomObject]@{
        Type      = "NVIDIA"
        Path      = $Path
        Arguments = "-d $($Config.SelGPUDSTM) --api-bind 127.0.0.1:$($Variables.NVIDIAMinerAPITCPPort) -o stratum+tcp://$($Pools.($Algo).Host):$($Pools.($Algo).Port) -u $($Pools.($Algo).User) -p $($Pools.($Algo).Pass)$($Commands.$_)"
        HashRates = [PSCustomObject]@{($Algo) = $Stats."$($Name)_$($Algo)_HashRate".Day * .98} # substract 2% devfee
        API       = "TTminer"
        Port      = $Variables.NVIDIAMinerAPITCPPort #4068
        Wrap      = $false
        URI       = $Uri
        User      = $Pools.($Algo).User
        Host      = $Pools.($Algo).Host
        Coin      = $Pools.($Algo).Coin
    }
}
