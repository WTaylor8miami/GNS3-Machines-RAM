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
"abbottrj-225", "alexanmf-225", "alhayen-225", "allame-225", "almafra-225", "bressmj-225", 
"brownc61-225", "cairlsr-225", "careyjr-225", "chengrl-225", "chowk3-225", "clarkap2-225", 
"colli369-225", "crockesm-225", "diallof2-225", "djandah-225", "frimmigm-225", "gaddiehl-225", 
"garberr-225", "godboltn-225", "gonzalkb-225", "harri581-225", "knauwq-225", 
"lawhorb-225", "leecf2-225", "lewisjp3-225", "maplesgl-225", "mcclela-225", "nguyenjm-225", 
"parsonjt-225", "perezi3-225", "plaughlc-225", "pottsdj-225", "pyakurd-225", "pylerd-225", 
"rimalgp-225", "samals-225", "stidhalt-225", "taylorw8-225", "wellsr2-225", "widenemg-225", 
"woodwaj4-225"
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
