$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
$ProgressPreference = 'SilentlyContinue'

Connect-AzAccount -Identity
Install-Module -Name Az.ImageBuilder -AllowPrerelease -Force
# 'Az.ImageBuilder', 'Az.ManagedServiceIdentity' | ForEach-Object { Install-Module -Name $_ -AllowPrerelease -Force }

Install-Module -Name Az.Storage -AllowPrerelease -Force
Write-Output 'hello logs' | Set-Content -Encoding Ascii -Path file.log
$ctx = New-AzStorageContext -StorageAccountName "${env:logsStorageAccountName}"
New-AzStorageContainer -Context $ctx -Name logs -Verbose
Set-AzStorageBlobContent -Context $ctx `
                         -Container logs `
                         -Blob file.log `
                         -StandardBlobTier 'Hot' `
                         -File file.log

Write-Host "=== Starting the image build"
Invoke-AzResourceAction -ResourceName "${env:imageTemplateName}" -ResourceGroupName "${env:resourceGroupName}" -ResourceType "Microsoft.VirtualMachineImages/imageTemplates" -ApiVersion "2020-02-14" -Action Run -Force

try {
    Write-Host "=== Waiting for the image build to complete"
    
    # https://learn.microsoft.com/en-us/dotnet/api/microsoft.azure.powershell.cmdlets.imagebuilder.support.runstate?view=az-ps-latest
    $status = 'Started'
    while ($status -ne 'Succeeded' -and $status -ne 'Failed' -and $status -ne 'Cancelled') { 
        Start-Sleep -Seconds 30
        $info = Get-AzImageBuilderTemplate -ImageTemplateName ${env:imageTemplateName} -ResourceGroupName ${env:resourceGroupName}
        $status = $info.LastRunStatusRunState
    }
}
catch {
    Write-Error "!!! [ERROR] Unhandled exception:`n$_`n$($_.ScriptStackTrace)" -ErrorAction Stop
}
finally {
    Write-Host "=== Image build information (last status '$status' '$($info.LastRunStatusMessage)'):"
    $info | ConvertTo-Json -Depth 20
    Start-Sleep -Seconds 30
}

Write-Host "=== DONE ==="
Start-Sleep -Seconds 30

