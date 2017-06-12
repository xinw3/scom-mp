# This script attempts to connect to the FlashArray specified by the credentials file. 
param($Endpoint, $Username, $Password, $HostName)
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
$momapi.LogScriptEvent($ScriptName, 1236, 0, "Starting script")

$Password = $Password | ConvertTo-SecureString -AsPlainText -Force
$FlashArray = New-PfaArray -EndPoint $Endpoint -UserName $Username -Password $Password -IgnoreCertificateError
New-PfaHost -Array $FlashArray -Name $HostName
Disconnect-PfaArray -Array $FlashArray