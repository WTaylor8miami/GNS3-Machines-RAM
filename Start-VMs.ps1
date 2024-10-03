param(
    [string]$vCenterServer,
    [string]$vCenterUser,
    [string]$vCenterPass
)

# Ignore invalid or self-signed SSL certificates
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false -Scope User

# Connect to the vCenter Server using the provided credentials
Connect-VIServer -Server $vCenterServer -User $vCenterUser -Password $vCenterPass

# List of VMs to start
$vmList = @(
    "386-00",
    "386-01"
)

# Loop through each VM name and start the VM if found
foreach ($vmName in $vmList) {
    try {
        $vm = Get-VM -Name $vmName
        if ($vm -ne $null) {
            Write-Host "Starting VM: $vmName"
            Start-VM -VM $vm -Confirm:$false
            Write-Host "VM '$vmName' started successfully."
        } else {
            Write-Host "VM not found: $vmName"
        }
    } catch {
        Write-Host "Error processing VM: $vmName. Error: $_"
    }
}

# Disconnect from the vCenter Server after operations
Disconnect-VIServer -Server $vCenterServer -Confirm:$false
