param($sourceId, $managedEntityId, $computerName)
$api = New-Object -ComObject 'MOM.ScriptAPI'
$api.LogScriptEvent("Demo.ps1", 2222, 0, "Discover volumes")
$discoveryData = $api.CreateDiscoveryData(0, $sourceId, $managedEntityId)

$arrayName = "vm-mudassir-latif2.dev.purestorage.com"
$arrayPassword = "pureuser"
$securePassword = ConvertTo-SecureString -String $arrayPassword -AsPlainText -Force
$array = New-PfaArray -Version 1.3 -EndPoint $arrayName -UserName pureuser -Password $securePassword -IgnoreCertificateError
$volumes = Get-PfaVolumes -Array $array



$instance = $discoveryData.CreateClassInstance("$MPElement[Name='Pure.FlashArrays.Arrays']$")
$instance.AddProperty("$MPElement[Name='Windows!Microsoft.Windows.Computer']/PrincipalName$", $computerName)
$instance.AddProperty("$MPElement[Name='Pure.FlashArrays.Arrays']/ArrayId$", "vm-xwang")
$instance.AddProperty("$MPElement[Name='Pure.FlashArrays.Arrays']/Controllers$", "Controllers")
$instance.AddProperty("$MPElement[Name='Pure.FlashArrays.Arrays']/Hosts$", "Hosts")
$instance.AddProperty("$MPElement[Name='Pure.FlashArrays.Arrays']/Volumes$", [string]$volumes[0])

$api.LogScriptEvent("Demo.ps1", 2223, 0, "volume 0 " + [string]$volumes[0])


$discoveryData.AddInstance($instance)
$discoveryData