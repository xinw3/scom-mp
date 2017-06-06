param($sourceId, $managedEntityId, $computerName, $arrayId)
$api = New-Object -ComObject 'MOM.ScriptAPI'
$api.LogScriptEvent("DiscoverArrays.ps1", 2222, 0, "Discover volumes")
$discoveryData = $api.CreateDiscoveryData(0, $sourceId, $managedEntityId)

$instance = $discoveryData.CreateClassInstance("$MPElement[Name='Pure.FlashArrays.Arrays']$")
$instance.AddProperty("$MPElement[Name='Windows!Microsoft.Windows.Computer']/PrincipalName$", $computerName)
$instance.AddProperty("$MPElement[Name='Pure.FlashArrays.Arrays']/ArrayId$", $arrayId)

$api.LogScriptEvent("DiscoverArrays.ps1", 2223, 0, "Finish Discovery")


$discoveryData.AddInstance($instance)
$discoveryData

