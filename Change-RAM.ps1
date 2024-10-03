# Define the list of VMs to be updated
$vmList = @(
    "284-01", "284-02", "284-03", "284-04", "284-05", "284-06", "284-07", "284-08", "284-09", "284-10",
    "284-11", "284-12", "284-13", "284-14", "284-15", "284-16", "284-17", "386-00", "386-01",
    "358-01", "358-02", "358-03", "358-04", "358-05", "358-06", "358-07", "358-08", "358-09", "358-10",
    "358-11", "358-12", "358-13", "358-14",
    "281K-01", "281K-02", "281K-03", "281K-04", "281K-05",
    "281-01", "281-02", "281-03", "281-04", "281-05", "281-06", "281-07", "281-08", "281-09", "281-10", 
    "281-11", "281-12", "281-13", "281-14"
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
        # Set RAM to 96GB (which is 98304 MB)
        Set-VM -VM $vm -MemoryGB 96 -Confirm:$false
        Write-Output "RAM for VM '$vmName' changed to 96GB."
    } else {
        Write-Output "VM '$vmName' not found."
    }
}

# Disconnect from vCenter Server
Disconnect-VIServer -Server $vCenterServer -Confirm:$false
