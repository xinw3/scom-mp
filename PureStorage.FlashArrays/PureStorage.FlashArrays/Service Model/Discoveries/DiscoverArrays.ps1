$arrayName = "vm-mudassir-latif2.dev.purestorage.com"
$arrayPassword = "pureuser"
$securePassword = ConvertTo-SecureString -String $arrayPassword -AsPlainText -Force
$myArray = New-PfaArray -Version 1.3 -EndPoint $arrayName -UserName pureuser -Password $securePassword -IgnoreCertificateError

### Print to hose ###
"`n***** Now connect to *****"
$myArray

$myVolumes = Get-PfaVolumes -Array $myArray
"`n***** List Volumes *****"
$myVolumes

