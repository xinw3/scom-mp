#param($arrayId, $userName, $password)
$computerName = $env:COMPUTERNAME
$api = New-Object -ComObject 'MOM.ScriptAPI'
$api.LogScriptEvent("MonitorDemo.ps1", 3333, 0, "Monitor Arrays on $computerName")

if ($computerName -eq "SCOM-XIN") {

    $arrayId = "vm-mudassir-latif2"
    $userName = "pureuser"
    $password = "pureuser"

    $endPoint = $arrayId + ".dev.purestorage.com"

    $api.LogScriptEvent("MonitorDemo.ps1", 3334, 0, "$endpoint")
    $bag = $api.CreatePropertyBag()
    $bag.AddValue("Value", "10")
    $bag.AddValue("InstanceName", "$arrayId")

    $api.LogScriptEvent("MonitorDemo.ps1", 3336, 0, "Finish add value")
    #$api.Return($bag)
    
} else {
    $api.LogScriptEvent("MonitorDemo.ps1", 3330, 0, "Monitor Arrays on $computerName, exited")
}
$bag