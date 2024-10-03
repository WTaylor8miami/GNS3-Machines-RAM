param (
    [string]$vCenterServer,
    [string]$vCenterUser,
    [string]$vCenterPass,
    [string[]]$VMNameList
)

# Import VMware PowerCLI
Import-Module VMware.PowerCLI

# Ignore SSL Certificate Errors
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false

# Connect to the vCenter Server
Connect-VIServer -Server $vCenterServer -User $vCenterUser -Password $vCenterPass

foreach ($vmName in $VMNameList) {
    $vm = Get-VM -Name $vmName
    if ($vm) {
        Start-VM -VM $vm -Confirm:$false
        Write-Output "VM '$vmName' started successfully."
    } else {
        Write-Output "VM '$vmName' not found."
    }
}

# Disconnect from vCenter Server
Disconnect-VIServer -Server $vCenterServer -Confirm:$false
