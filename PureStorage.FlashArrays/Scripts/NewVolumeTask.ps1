# This script adds a new Volume according to the specified parameters
param($Endpoint, $Username, $Password, $VolumeName, $Size, $Source, $Unit)
$ScriptName = "PureStorage.FlashArray.PowerShell.Task.AddHost.ps1"
#=================================================================================
# Gather script start time
$StartTime = Get-Date             

# Gather who the script is running as
$WhoAmI = whoami

# Load MomScript API and PropertyBag function 
$momapi = new-object -comObject 'MOM.ScriptAPI'
$bag = $momapi.CreatePropertyBag()

# Log script event that we are starting task
$momapi.LogScriptEvent($ScriptName, 1237, 0, "Starting script")

$Password = $Password | ConvertTo-SecureString -AsPlainText -Force
$FlashArray = New-PfaArray -EndPoint $Endpoint -UserName $Username -Password $Password -IgnoreCertificateError
New-PfaVolume -Array $FlashArray -VolumeName $VolumeName -Size $Size -Unit $Unit
if (-not $?) {
	$momapi.LogScriptEvent($ScriptName, 1237, 0, "Volume creation failed.")
	Disconnect-PfaArray -Array $FlashArray
	Throw "Volume creation failed"
}
Disconnect-PfaArray -Array $FlashArray