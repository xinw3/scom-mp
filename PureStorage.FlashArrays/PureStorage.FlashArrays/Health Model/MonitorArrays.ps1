param($computerName, $arrayName, $userName, $password)
$api = New-Object -ComObject 'MOM.ScriptAPI'
$bag = $api.CreatePropertyBag()
if ($computerName -eq "scom-xin.xin.com") {
    
    $endPoint = $arrayName + ".dev.purestorage.com"
    $api.LogScriptEvent("MonitorArrays.ps1", 3333, 0, "Monitor Arrays $endPoint")
   
    $securePassword = ConvertTo-SecureString -String $password -AsPlainText -Force

    ### array: Disposed, EndPoint, UserName, ApiVersion, Role
    $array = New-PfaArray -EndPoint $endPoint -UserName $userName -Password $securePassword -IgnoreCertificateError
    $apiVersion = $array.ApiVersion

    ### attributes: version, revision, array_name, id
    $attributes = Get-PfaArrayAttributes -Array $array 

    ### arrayIOMetrics: writes_persec, reads_per_sec (bandwidth); input_per_sec, output_per_sec (IOPS); usec_per_write_op, usec_per_read_op (latency);
    $arrayIOMetrics = Get-PfaArrayIOMetrics -Array $array

    ### arraySpaceMetrics: capacity(B), hostname, system, snapshots, volumes, data_reduction, total, shared_space, thin_provisioning, total_reduction
    $arraySpaceMetrics = Get-PfaArraySpaceMetrics -Array $array

    ### allVolumeIOMetrics: name, time, writes_persec, reads_per_sec (bandwidth); input_per_sec, output_per_sec (IOPS); usec_per_write_op, usec_per_read_op (latency);
    $allVolumeIOMetrics = Get-PfaAllVolumeIOMetrics -Array $array

    ### volumeIOMetrics: name, time, writes_persec, reads_per_sec (bandwidth); input_per_sec, output_per_sec (IOPS); usec_per_write_op, usec_per_read_op (latency);
    $volumeIOMetrics = Get-PfaVolumeIOMetrics -Array $array -VolumeName $volume.name -TimeRange 1h
    

    ### allVolumeSpaceMetrics: total, name, system, snapshots, volumes, data_reduction, size, shared_space, thin_provisioning, total_reduction
    $allVolumeSpaceMetrics = Get-PfaAllVolumeSpaceMetrics -Array $array

    $bag.AddValue('IOMetrics', $ioMetrics)
    $bag.AddValue('SpaceMetrics', $spaceMetrics)

    $api.LogScriptEvent("DiscoverArrays.ps1", 2223, 0, "Finish Discovery $apiVersion")
    Disconnect-PfaArray -Array $array
    
} else {
    $api.LogScriptEvent("DiscoverArrays.ps1", 2220, 0, "Wrong Name: $computerName")
}
$bag
