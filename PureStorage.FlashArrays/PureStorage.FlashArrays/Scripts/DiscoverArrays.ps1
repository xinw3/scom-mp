param($sourceId, $managedEntityId, $computerName, $arrayName, $userName, $password)
$api = New-Object -ComObject 'MOM.ScriptAPI'
$discoveryData = $api.CreateDiscoveryData(0, $sourceId, $managedEntityId)
if ($computerName -eq "scom-xin.xin.com") {
    $api.LogScriptEvent("DiscoverArrays.ps1", 2222, 0, "Discover arrays $arrayName")

    $endPoint = $arrayName + ".dev.purestorage.com"
    $securePassword = ConvertTo-SecureString -String $password -AsPlainText -Force

    ######  Discover Arrays ######
    $arraysInstance = $discoveryData.CreateClassInstance("$MPElement[Name='Pure.FlashArrays.Arrays']$")
    ### array: Disposed, EndPoint, UserName, ApiVersion, Role
    $array = New-PfaArray -EndPoint $endPoint -UserName $userName -Password $securePassword -IgnoreCertificateError
    $apiVersion = $array.ApiVersion
    $role = $array.Role

    ### attributes: version, revision, array_name, id
    $attributes = Get-PfaArrayAttributes -Array $array
    $version = $attributes.version

    ### apiToken
    $apiToken = Get-PfaApiToken -Array $array -User $userName

    $arraysInstance.AddProperty("$MPElement[Name='Windows!Microsoft.Windows.Computer']/PrincipalName$", $computerName)
    $arraysInstance.AddProperty("$MPElement[Name='Pure.FlashArrays.Arrays']/Version$", $version)
    $arraysInstance.AddProperty("$MPElement[Name='Pure.FlashArrays.Arrays']/ArrayName$", $arrayName)
    $arraysInstance.AddProperty("$MPElement[Name='Pure.FlashArrays.Arrays']/UserName$", $userName)
    $arraysInstance.AddProperty("$MPElement[Name='Pure.FlashArrays.Arrays']/ApiVersion$", $apiVersion)
    $arraysInstance.AddProperty("$MPElement[Name='Pure.FlashArrays.Arrays']/ApiToken$", $apiToken)
    $arraysInstance.AddProperty("$MPElement[Name='Pure.FlashArrays.Arrays']/Role$", $role)

    $api.LogScriptEvent("DiscoverArrays.ps1", 2224, 0, "Finish Discovery $apiVersion")
    $discoveryData.AddInstance($volumesInstance)
    Disconnect-PfaArray -Array $array
    
} else {
    $api.LogScriptEvent("DiscoverArrays.ps1", 2220, 0, "Wrong Name: $computerName")
}
$discoveryData
