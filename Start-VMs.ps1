param(
    [string]$vCenterServer,
    [string]$vCenterUser,
    [string]$vCenterPass
)

# Ignore invalid or self-signed SSL certificates
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false -Scope User

# Connect to the vCenter Server using the provided credentials
Write-Host "Connecting to vCenter Server: $vCenterServer"
Connect-VIServer -Server $vCenterServer -User $vCenterUser -Password $vCenterPass

# List of VMs to start
$vmList = @(
    "386-00",
    "386-01"
)

# Loop through each VM name and start the VM if found
foreach ($vmName in $vmList) {
    Write-Host "Processing VM name: '$vmName'"
    if (-not [string]::IsNullOrWhiteSpace($vmName)) {
        try {
            Write-Host "Attempting to get VM '$vmName'..."
            $vm = Get-VM -Name $vmName -ErrorAction Stop

            if ($vm) {
                Write-Host "Starting VM: $vmName"
                Start-VM -VM $vm -Confirm:$false -Verbose
                Write-Host "VM '$vmName' started successfully."
            }
        } catch {
            Write-Host "Error processing VM '$vmName': $_"
        }
    } else {
        Write-Host "Skipped an empty or invalid VM name."
    }
}

# Disconnect from the vCenter Server after operations
Write-Host "Disconnecting from the vCenter Server..."
Disconnect-VIServer -Server $vCenterServer -Confirm:$false
