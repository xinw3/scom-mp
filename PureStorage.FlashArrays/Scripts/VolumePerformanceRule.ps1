# Gets performance data for the Flash Array
param($Endpoint, $Username, $Password)
$ScriptName = "PureStorage.FlashArray.PowerShell.Script.Perf.PA.ps1"

$StartTime = Get-Date
$whoami = whoami
$momapi = New-Object -comObject MOM.ScriptAPI
$bag = $momapi.CreatePropertyBag()
$Password = $Password | ConvertTo-SecureString -AsPlainText -Force

# Log an event for the script starting
$momapi.LogScriptEvent($ScriptName,1235,0, "Script is starting. Running, as ($whoami).")
$FlashArray = New-PfaArray -EndPoint $Endpoint -UserName $Username -Password $Password -IgnoreCertificateError
$metrics = Get-PfaArrayIOMetrics -Array $FlashArray
$writes_per_second = 1.0 * $metrics.writes_per_sec
$usec_per_write_op = 1.0 * $metrics.usec_per_write_op
$output_per_second = 1.0 * $metrics.output_per_sec
$reads_per_second = 1.0 * $metrics.reads_per_sec
$input_per_second = 1.0 * $metrics.input_per_sec
$usec_per_read_op = 1.0 * $metrics.usec_per_read_op
#$writes_per_second = Get-Random -Maximum 10.0
#$usec_per_write_op = Get-Random -Maximum 0.5
#$output_per_second = Get-Random -Maximum 1000.0
#$reads_per_second = Get-Random -Maximum 20.0
#$input_per_second = Get-Random -Maximum 1000.0
#$usec_per_read_op = Get-Random -Maximum 0.5
$bag.AddValue("writes_per_second", $writes_per_second)
$bag.AddValue("usec_per_write_op", $usec_per_write_op)
$bag.AddValue("output_per_second", $output_per_second)
$bag.AddValue("reads_per_second", $reads_per_second)
$bag.AddValue("input_per_second", $input_per_second)
$bag.AddValue("usec_per_read_op", $usec_per_read_op)
$momapi.LogScriptEvent($ScriptName,1235,0,"Writes per second is $writes_per_second")
Disconnect-PfaArray -Array $FlashArray
# Careful - bag may be empty
$EndTime = Get-Date
$ScriptTime = ($EndTime - $StartTime).TotalSeconds
$momapi.LogScriptEvent($ScriptName,1235,0,"Script has completed.  Runtime was ($ScriptTime) seconds.")
$bag