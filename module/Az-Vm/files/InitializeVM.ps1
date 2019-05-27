$date = Get-Date -UFormat "%d-%m-%Y"
Start-Transcript -Path "C:\terraform\$date-InitializeVM.log"

#region WinRm https
$profiles = Get-NetConnectionProfile
Foreach ($i in $profiles) {
    Write-Host ("Updating Interface ID {0} to be Private.." -f $profiles.InterfaceIndex)
    Set-NetConnectionProfile -InterfaceIndex $profiles.InterfaceIndex -NetworkCategory Private
}

Write-Host "Obtaining the Thumbprint of the Certificate from KeyVault"
$Thumbprint = (Get-ChildItem -Path Cert:\LocalMachine\My | Where-Object {$_.Subject -match "$ComputerName"}).Thumbprint

Write-Host "Enable HTTPS in WinRM.."
winrm create winrm/config/Listener?Address=*+Transport=HTTPS "@{Hostname=`"$ComputerName`"; CertificateThumbprint=`"$Thumbprint`"}"

Write-Host "Enabling Basic Authentication.."
winrm set winrm/config/service/Auth "@{Basic=`"true`"}"

Write-Host "Re-starting the WinRM Service"
net stop winrm
net start winrm

Write-Host "Open Firewall Ports"
netsh advfirewall firewall add rule name="Windows Remote Management (HTTPS-In)" dir=in action=allow protocol=TCP localport=5986
#endregion

#region Initialize DataDisk
Write-Host "Initialize Disks"
$drv = Get-WmiObject win32_volume -filter 'DriveType = "5"'
if ($drv) {
    $drv.DriveLetter = "Z:"
    $drv.Put() | out-null
}
$disks = Get-Disk | Where partitionstyle -eq 'raw' | sort number

$letters = 69..85 | ForEach-Object { [char]$_ }
$count = 0
$labels = "data1", "data2", "data3", "data4", "data5"

foreach ($disk in $disks) {
    $driveLetter = $letters[$count].ToString()
    Write-Host "Initialize Disk : $driveLetter"
    $disk | 
        Initialize-Disk -PartitionStyle MBR -PassThru |
        New-Partition -UseMaximumSize -DriveLetter $driveLetter |
        Format-Volume -FileSystem NTFS -NewFileSystemLabel $labels[$count] -Confirm:$false -Force
    Write-Host "End of task : Initialize Disk : $driveLetter"
    $count++
}
Write-Host "End Initialize Disks"
#endregion

Stop-Transcript