param($sourceId, $managedEntityId, $topFolder, $computerName)
$api = New-Object -ComObject 'MOM.ScriptAPI'
$discoveryData = $api.CreateDiscoveryData(0, $sourceId, $managedEntityId)
$subFolders = Get-ChildItem -Path $topFolder | where {$_.psIsContainer -eq $true}
#foreach($subFolder in $subFolders)
#{
#    $subFolder.FullName
#}

foreach ($subFolder in $subFolders)
{
    $instance = $discoveryData.CreateClassInstance("$MPElement[Name='PureStorage.FlashArrays.Queue']$")
    # $instance.AddProperty("$MPElement[Name='Windows!Microsoft.Windows.Computer']/PrincipalName$", $computerName)
    $instance.AddProperty("$MPElement[Name='PureStorage.FlashArrays.Queue']/ArrayCode$", $subFolder.Name)
    $instance.AddProperty("$MPElement[Name='PureStorage.FlashArrays.Queue']/FolderPath$", $subFolder.FullName)

    $discoveryData.AddInstance($instance)
}

$discoveryData