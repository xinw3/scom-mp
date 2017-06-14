param($sourceId, $managedEntityId, $computerName, $arrayName, $userName, $password)
$api = New-Object -ComObject 'MOM.ScriptAPI'
$discoveryData = $api.CreateDiscoveryData(0, $sourceId, $managedEntityId)
if ($computerName -eq "scom-xin.xin.com") {
    $api.LogScriptEvent("DiscoverVolumes.ps1", 2233, 0, "Discover arrays $arrayName")

    $endPoint = $arrayName + ".dev.purestorage.com"
    $securePassword = ConvertTo-SecureString -String $password -AsPlainText -Force

    ### array: Disposed, EndPoint, UserName, ApiVersion, Role
    $array = New-PfaArray -EndPoint $endPoint -UserName $userName -Password $securePassword -IgnoreCertificateError
    $apiVersion = $array.ApiVersion



    ######  Discover Volumes ######
    $volumesInstance = $discoveryData.CreateClassInstance("$MPElement[Name='Pure.FlashArrays.Volumes']$")
    $volumes = Get-PfaVolumes -Array $array
    ### volume: serial, created, name, size
    # $volume = $volumes[0]
    foreach ($volume in $volumes) {
        $name = $volume.name
        $serial = $volume.serial
        $created = $volume.created
        $size = $volume.size

        $volumesInstance.AddProperty("$MPElement[Name='Windows!Microsoft.Windows.Computer']/PrincipalName$", $computerName)
        $volumesInstance.AddProperty("$MPElement[Name='Pure.FlashArrays.Arrays']/ArrayName$", $arrayName)
        $volumesInstance.AddProperty("$MPElement[Name='Pure.FlashArrays.Volumes']/Name$", $name)
        $volumesInstance.AddProperty("$MPElement[Name='Pure.FlashArrays.Volumes']/Serial$", $serial)
        $volumesInstance.AddProperty("$MPElement[Name='Pure.FlashArrays.Volumes']/DateCreated$", $created)
        $volumesInstance.AddProperty("$MPElement[Name='Pure.FlashArrays.Volumes']/Size$", $size)
        $api.LogScriptEvent("DiscoverVolumes.ps1", 2234, 0, ($name + $serial + $created + $size))
    }

    $api.LogScriptEvent("DiscoverVolumes.ps1", 2235, 0, "Finish Discovery $apiVersion")
    $discoveryData.AddInstance($volumesInstance)
    
} else {
    $api.LogScriptEvent("DiscoverVolumes.ps1", 2230, 0, "Wrong Name: $computerName")
}
$discoveryData
