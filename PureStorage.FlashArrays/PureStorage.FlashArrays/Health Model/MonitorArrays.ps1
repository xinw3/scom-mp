$api = New-Object -ComObject 'MOM.ScriptAPI'
#$api.LogScriptEvent("MonitorArrays.ps1", 101, 4, $folder)

$arrayName = "vm-mudassir-latif2.dev.purestorage.com"
$arrayPassword = "pureuser"
$securePassword = ConvertTo-SecureString -String $arrayPassword -AsPlainText -Force
$myArray = New-PfaArray -Version 1.3 -EndPoint $arrayName -UserName pureuser -Password $securePassword -IgnoreCertificateError

$volumes = Get-PfaVolumes -Array $myArray

$bag = $api.CreatePropertyBag()
$bag.AddValue('Volumes', $volumes)
$bag.AddValue('Array', $myArray)

#$api.Return($bag)
$bag