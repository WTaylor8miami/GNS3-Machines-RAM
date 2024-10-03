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

# List of VMs to change RAM
$vmList = @(
    "386-00",
    "386-01"
)

# Loop through each VM name and change RAM if found
foreach ($vmName in $vmList) {
    Write-Host "Processing VM name: '$vmName'"
    if (-not [string]::IsNullOrWhiteSpace($vmName)) {
        try {
            Write-Host "Attempting to get VM '$vmName'..."
            $vm = Get-VM -Name $vmName -ErrorAction Stop

            if ($vm) {
                Write-Host "Changing RAM for VM: $vmName to 96GB..."
                Set-VM -VM $vm -MemoryGB 96 -Confirm:$false -Verbose
                Write-Host "RAM for VM '$vmName' changed to 96GB successfully."
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
