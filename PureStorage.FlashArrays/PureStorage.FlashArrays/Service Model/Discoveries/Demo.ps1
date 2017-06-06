param($sourceId, $managedEntityId, $computerName)
$api = New-Object -ComObject 'MOM.ScriptAPI'
$discoveryData = $api.CreateDiscoveryData(0, $sourceId, $managedEntityId)

#foreach($subFolder in $subFolders)
#{
#    $subFolder.FullName
#}

for ($i=1; $i -le 2; $i++)
{
    $instance = $discoveryData.CreateClassInstance("$MPElement[Name='Pure.FlashArrays.Arrays']$")
    $instance.AddProperty("$MPElement[Name='Windows!Microsoft.Windows.Computer']/PrincipalName$", $computerName)
    $instance.AddProperty("$MPElement[Name='Pure.FlashArrays.Arrays']/Controllers$", "Controller " + $i)
    $instance.AddProperty("$MPElement[Name='Pure.FlashArrays.Arrays']/Hosts$", "Host " + $i)
    $instance.AddProperty("$MPElement[Name='Pure.FlashArrays.Arrays']/Volumes$", "Volume " + $i)

    $discoveryData.AddInstance($instance)
}

$discoveryData