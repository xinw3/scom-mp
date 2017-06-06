param($arrayId, $userName, $password)

$api = New-Object -ComObject 'MOM.ScriptAPI'
$api.LogScriptEvent("MonitorArrays.ps1", 3333, 0, "Monitor Arrays")

$endPoint = $arrayId + ".dev.purestorage.com"
$api.LogScriptEvent("MonitorArrays.ps1", 3334, 0, "endpoints $endpoint")
$securePassword = ConvertTo-SecureString -String $password -AsPlainText -Force
$array = New-PfaArray -Version 1.3 -EndPoint $endPoint -UserName $userName -Password $securePassword -IgnoreCertificateError

$volumes = Get-PfaVolumes -Array $array

$api.LogScriptEvent("MonitorArrays.ps1", 3335, 0, "array $array")


$bag = $api.CreatePropertyBag()
$bag.AddValue('Volumes', $volumes)
$bag.AddValue('ArrayId', $array)

$api.LogScriptEvent("MonitorArrays.ps1", 3336, 0, "volumes $volumes")

$api.Return($bag)
#$bag