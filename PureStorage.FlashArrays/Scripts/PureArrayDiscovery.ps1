# This script looks for a credentials file and attempt to connect to a FlashArray.
# On success, it populates the properties of the PureArray class.
param($SourceId, $ManagedEntityId, $ComputerName, $Username, $Password)
$StartTime = Get-Date
$ScriptName = "PureStorage.FlashArray.PureArray.Discovery.ps1"
$whoami = whoami
$momapi = New-Object -comObject "Mom.ScriptAPI"
$dbag = $momapi.CreateDiscoveryData(0, $SourceId, $ManagedEntityID)
$momapi.LogScriptEvent($ScriptName, 1233, 0, "Starting script. Running as ($whoami)")
$File = "C:\Users\Administrator\credentials.txt"
$FileExists = Test-Path $File
$CorrectFormat = $true
$Endpoints = New-Object System.Collections.ArrayList
If ($FileExists) {
	foreach($line in Get-Content $File) {
		If ($line -match "^\s*$") {
			continue
		} Elseif ($line -match "^endpoint:(\s)*(.*)") {
			$Endpoint = $Matches[2]
			$Endpoints.Add($Endpoint) | Out-Null
		} Else {
			$momapi.LogScriptEvent($ScriptName, 1234, 0, "Unknown credentials format.")
			$CorrectFormat = $false
			break
		}
	}
} Else {
    $momapi.LogScriptEvent($ScriptName,1233,0,"Discovery script returned no discovered objects.")
}
$Password = $Password | ConvertTo-SecureString -AsPlainText -Force
If ($FileExists -and $CorrectFormat) {
	foreach ($Endpoint in $Endpoints) {
		$FlashArray = New-PfaArray -EndPoint $Endpoint -UserName $Username -Password $Password -IgnoreCertificateError
		$ObjectName = ($FlashArray.GetType()).Name
		if (-not ($ObjectName -eq "PureArray")) {
			$momapi.LogScriptEvent($ScriptName,1233,0,"Discovery script failed on this username. $Username")
			continue
		}
		$momapi.LogScriptEvent($ScriptName,1000,0,$ObjectName)

		$Endpoint = $FlashArray.Endpoint
		$Name =  (Get-PfaArrayId -Array $FlashArray).array_name
		$Volumes = (Get-PfaVolumes -Array $FlashArray).name -join ', ' 
		$ApiVersion = $FlashArray.ApiVersion

		$instance = $dbag.CreateClassInstance("$MPElement[Name='PureStorage.FlashArray.PureArray']$")
		$instance.AddProperty("$MPElement[Name='Windows!Microsoft.Windows.Computer']/PrincipalName$", $ComputerName)
		$instance.AddProperty("$MPElement[Name='PureStorage.FlashArray.PureArray']/Endpoint$", $Endpoint)
		$instance.AddProperty("$MPElement[Name='PureStorage.FlashArray.PureArray']/Name$", $Name)
		$instance.AddProperty("$MPElement[Name='PureStorage.FlashArray.PureArray']/ApiVersion$", $ApiVersion)
		$instance.AddProperty("$MPElement[Name='PureStorage.FlashArray.PureArray']/Volumes$", $Volumes)
		$dbag.AddInstance($instance)
		Disconnect-PfaArray $FlashArray
		$momapi.LogScriptEvent($ScriptName,1233,0,"Discovery script object created. $Name")
	}
}
$dbag
$EndTime = Get-Date
$ScriptTime = ($EndTime - $StartTime).TotalSeconds
$momapi.LogScriptEvent($ScriptName,1233,0,"Script has completed.  Runtime was ($ScriptTime) seconds.")
