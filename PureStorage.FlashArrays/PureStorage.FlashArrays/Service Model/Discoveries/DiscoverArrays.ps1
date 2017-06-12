param($sourceId, $managedEntityId, $computerName, $arrayId)
$api = New-Object -ComObject 'MOM.ScriptAPI'
$discoveryData = $api.CreateDiscoveryData(0, $sourceId, $managedEntityId)
if ($computerName -eq "scom-xin.xin.com") {
    $api.LogScriptEvent("DiscoverArrays.ps1", 2222, 0, "Discover arrays $arrayId")

    

    $instance = $discoveryData.CreateClassInstance("$MPElement[Name='Pure.FlashArrays.Arrays']$")
    $instance.AddProperty("$MPElement[Name='Windows!Microsoft.Windows.Computer']/PrincipalName$", $computerName)
    $instance.AddProperty("$MPElement[Name='Pure.FlashArrays.Arrays']/ArrayId$", $arrayId)

    $api.LogScriptEvent("DiscoverArrays.ps1", 2223, 0, "Finish Discovery")
    $discoveryData.AddInstance($instance)
    
} else {
    $api.LogScriptEvent("DiscoverArrays.ps1", 2220, 0, "Wrong Name: $computerName")
}
$discoveryData


