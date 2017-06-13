param($sourceId, $managedEntityId, $computerName, $arrayName, $userName, $password)
$api = New-Object -ComObject 'MOM.ScriptAPI'
$discoveryData = $api.CreateDiscoveryData(0, $sourceId, $managedEntityId)
if ($computerName -eq "scom-xin.xin.com") {
    $api.LogScriptEvent("DiscoverHosts.ps1", 2244, 0, "Discover arrays $arrayId")

    $endPoint = $arrayName + ".dev.purestorage.com"
    $securePassword = ConvertTo-SecureString -String $password -AsPlainText -Force

    ### array: Disposed, EndPoint, UserName, ApiVersion, Role
    $array = New-PfaArray -EndPoint $endPoint -UserName $userName -Password $securePassword -IgnoreCertificateError
    $hosts = Get-PfaHosts -Array $array
     ######  Discover Hosts ######
    $hostsInstance = $discoveryData.CreateClassInstance("$MPElement[Name='Pure.FlashArrays.Hosts']$")
    $hosts = Get-PfaHosts -Array $array
    ### host: iqn, wwn, name, hgroup
    # $singleHost = $hosts[0]  

    foreach ($singleHost in $hosts) {
        $name = $singleHost.name
        $iqn = $singleHost.iqn
        $wwn = $singleHost.wwn
        $hgroup = $singleHost.hgroup

        $hostsInstance.AddProperty("$MPElement[Name='Windows!Microsoft.Windows.Computer']/PrincipalName$", $computerName)
        $hostsInstance.AddProperty("$MPElement[Name='Pure.FlashArrays.Hosts']/Name$", $name)
        $hostsInstance.AddProperty("$MPElement[Name='Pure.FlashArrays.Hosts']/IQN$", $iqn)
        $hostsInstance.AddProperty("$MPElement[Name='Pure.FlashArrays.Hosts']/WWN$", $wwn)
        $hostsInstance.AddProperty("$MPElement[Name='Pure.FlashArrays.Hosts']/HostGroup$", $hgroup)
        $api.LogScriptEvent("DiscoverArrays.ps1", 2245, 0, $name + $iqn + $wwn + $hgroup)
    }

    $api.LogScriptEvent("DiscoverHosts.ps1", 2246, 0, "Finish Discovery")
    $discoveryData.AddInstance($hostsInstance)
    
} else {
    $api.LogScriptEvent("DiscoverArrays.ps1", 2240, 0, "Wrong Name: $computerName")
}
$discoveryData
