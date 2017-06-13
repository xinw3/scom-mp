### allIOMetrics: name, time, writes_persec, reads_per_sec (bandwidth); input_per_sec, output_per_sec (IOPS); usec_per_write_op, usec_per_read_op (latency);
    $allIOMetrics = Get-PfaAllVolumeIOMetrics -Array $array

    ### ioMetrics: name, time, writes_persec, reads_per_sec (bandwidth); input_per_sec, output_per_sec (IOPS); usec_per_write_op, usec_per_read_op (latency);
    $ioMetrics = Get-PfaVolumeIOMetrics -Array $array -VolumeName $volume.name -TimeRange 1h
    

    ### spaceMetrics: total, name, system, snapshots, volumes, data_reduction, size, shared_space, thin_provisioning, total_reduction
    $allSpaceMetrics = Get-PfaAllVolumeSpaceMetrics -Array $array