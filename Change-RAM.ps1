param (
    [string]$vCenterServer,
    [string]$vCenterUser,
    [string]$vCenterPass
)

# Import VMware PowerCLI
Import-Module VMware.PowerCLI

# Connect to the vCenter Server
Connect-VIServer -Server $vCenterServer -User $vCenterUser -Password $vCenterPass

# List of VM names
$vmNames = @("386-00", "VM2", "VM3")  # Replace with actual VM names

foreach ($vmName in $vmNames) {
    $vm = Get-VM -Name $vmName
    if ($vm) {
        # Set RAM to 96GB (which is 98304 MB)
        Set-VM -VM $vm -MemoryGB 96 -Confirm:$false
        Write-Output "RAM for VM '$vmName' changed to 96GB."
    } else {
        Write-Output "VM '$vmName' not found."
    }
}

# Disconnect from vCenter Server
Disconnect-VIServer -Server $vCenterServer -Confirm:$false
