param($SourceId, $ManagedEntityId, $ComputerName, $Endpoint, $Username, $Password)
$StartTime = Get-Date
$ScriptName = "PureStorage.FlashArray.PureVolume.Discovery.ps1"
$whoami = whoami
$momapi = New-Object -comObject "Mom.ScriptAPI"
$dbag = $momapi.CreateDiscoveryData(0, $SourceId, $ManagedEntityID)
$momapi.LogScriptEvent($ScriptName, 1238, 0, "Starting script. Running as ($whoami)")
$Password = $Password | ConvertTo-SecureString -AsPlainText -Force
$FlashArray = New-PfaArray -EndPoint $Endpoint -UserName $Username -Password $Password -IgnoreCertificateError
$ObjectName = ($FlashArray.GetType()).Name
if (-not ($ObjectName -eq "PureArray")) {
	exit
}
$Volumes = Get-PfaVolumes -Array $FlashArray
foreach ($Volume in $Volumes) {
	$Name = $Volume.name
	$Serial = $Volume.serial
	$Size = [int]$Volume.size

	$instance = $dbag.CreateClassInstance("$MPElement[Name='PureStorage.FlashArray.PureVolume']$")
	$instance.AddProperty("$MPElement[Name='Windows!Microsoft.Windows.Computer']/PrincipalName$", $ComputerName)
	$instance.AddProperty("$MPElement[Name='PureStorage.FlashArray.PureArray']/Endpoint$", $Endpoint)
	$instance.AddProperty("$MPElement[Name='PureStorage.FlashArray.PureVolume']/Name$", $Name)
	$instance.AddProperty("$MPElement[Name='PureStorage.FlashArray.PureVolume']/Serial$", $Serial)
	$instance.AddProperty("$MPElement[Name='PureStorage.FlashArray.PureVolume']/Size$", $Size)
	$dbag.AddInstance($instance)
	$momapi.LogScriptEvent($ScriptName,1238,0,"Discovery script object created. $Name")
}
$dbag
$EndTime = Get-Date
$ScriptTime = ($EndTime - $StartTime).TotalSeconds
$momapi.LogScriptEvent($ScriptName,1238,0,"Script has completed.  Runtime was ($ScriptTime) seconds.")
