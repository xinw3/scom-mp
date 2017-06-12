param($Endpoint, $Username, $Password)
$ScriptName = "PureStorage.FlashArray.TimedScript.PowerShell.ControllerMonitor.DataSourceModuleType.ps1"
#=================================================================================

# Gather script start time
$StartTime = Get-Date             

# Gather who the script is running as
$WhoAmI = whoami

# Load MomScript API and PropertyBag function 
$momapi = new-object -comObject 'MOM.ScriptAPI'
$bag = $momapi.CreatePropertyBag()

# Log script event that we are starting task
$momapi.LogScriptEvent($ScriptName, 1239, 0, "Starting script")

# Set the condition = bad.  This represents your script finding something wrong
$strCondition = "Good"
$Password = $Password | ConvertTo-SecureString -AsPlainText -Force

# Check if array can be accessed
$FlashArray = New-PfaArray -EndPoint $Endpoint -UserName $Username -Password $Password -IgnoreCertificateError
$ObjectName = $FlashArray.GetType() | foreach {$_.Name}
if ($ObjectName -eq "PureArray") {
	if (-not ((Get-PfaControllers -Array $FlashArray).status -eq "ready")) {
		$strCondition = "Bad"
	}
	Disconnect-PfaArray -Array $FlashArray
} else {
	$strCondition = "Bad"
}

#Check the value of $strCondition
if ($strCondition -eq "Good")
  {
  $momapi.LogScriptEvent($ScriptName,1239,0, "Good Condition Found")
  $bag.AddValue('Result','GoodCondition')
  }
else
  {
  $momapi.LogScriptEvent($ScriptName,1239,0, "Bad Condition Found")
  $bag.AddValue('Result','BadCondition')
  }

#Log an event for script ending and total execution time.
$EndTime = Get-Date
$ScriptTime = ($EndTime - $StartTime).TotalSeconds
$momapi.LogScriptEvent($ScriptName,1239,0,"Script has completed.  Runtime was ($ScriptTime) seconds.")

#Output the propertybag  
$bag