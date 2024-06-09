$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
$ProgressPreference = 'SilentlyContinue'

Connect-AzAccount -Identity

Write-Host "=== Looking for storage account containing customizations log. Staging RG: ${env:imageBuildStagingResourceGroupName}"
$stagingStorageAccountName = (Get-AzResource -ResourceGroupName ${env:imageBuildStagingResourceGroupName} -ResourceType "Microsoft.Storage/storageAccounts")[0].Name

$ctx = New-AzStorageContext -StorageAccountName $stagingStorageAccountName
$logsBlob = Get-AzStorageBlob -Context $ctx -Container packerlogs | Where-Object { $_.Name -eq 'customization.log' }
if (-not $logsBlob) {
    Write-Host "Could not find customization.log in storage account: $stagingStorageAccountName"
    return
}

Write-Host "=== Downloading customizations.log in storage account: $stagingStorageAccountName"
Get-AzStorageBlobContent -Context $ctx -CloudBlob $logsBlob.ICloudBlob -Destination 'customization.log'

Write-Host "=== Uploading customizations.log to storage account: ${env:logsStorageAccountName}"
$ctx = New-AzStorageContext -StorageAccountName "${env:logsStorageAccountName}"
New-AzStorageContainer -Context $ctx -Name logs -Permission 'Blob'
Set-AzStorageBlobContent -Context $ctx -Container logs -Blob 'customization.log' -StandardBlobTier 'Hot' -File 'customization.log'

Write-Host "=== Waiting to allow for the logs to be accessed for troubleshooting"
Start-Sleep -Seconds (15 * 60)  # Wait 15 minutes to allow for the logs to be downloaded
