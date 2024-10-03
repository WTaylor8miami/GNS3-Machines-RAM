# Define the list of VMs to be started
$vmList = @(
   "386-00", "386-01"
)

param (
    [string]$vCenterServer,
    [string]$vCenterUser,
    [string]$vCenterPass
)

# Import VMware PowerCLI
Import-Module VMware.PowerCLI

# Ignore SSL Certificate Errors
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false

# Connect to the vCenter Server
Connect-VIServer -Server $vCenterServer -User $vCenterUser -Password $vCenterPass

foreach ($vmName in $vmList) {
    $vm = Get-VM -Name $vmName.Trim()
    if ($vm) {
        Start-VM -VM $vm -Confirm:$false
        Write-Output "VM '$vmName' started successfully."
    } else {
        Write-Output "VM '$vmName' not found."
    }
}

# Disconnect from vCenter Server
Disconnect-VIServer -Server $vCenterServer -Confirm:$false
