#param($arrayId, $userName, $password)

$api = New-Object -ComObject 'MOM.ScriptAPI'
$api.LogScriptEvent("MonitorDemo.ps1", 3333, 0, "Monitor Arrays")

$arrayId = "vm-mudassir-latif2"
$userName = "pureuser"
$password = "pureuser"

$endPoint = $arrayId + ".dev.purestorage.com"

$api.LogScriptEvent("MonitorDemo.ps1", 3334, 0, "$endpoint")



$bag = $api.CreatePropertyBag()
$bag.AddValue("Value", "10")
$bag.AddValue("InstanceName", "$arrayId")

$api.LogScriptEvent("MonitorArrays.ps1", 3336, 0, "Finish add value")


#$api.Return($bag)
$bag