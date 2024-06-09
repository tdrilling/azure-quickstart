$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
$ProgressPreference = 'SilentlyContinue'

# Invoke-AzResourceAction -ResourceName "${env:imageTemplateName}" -ResourceGroupName "${env:resourceGroupName}" -ResourceType "Microsoft.VirtualMachineImages/imageTemplates" -ApiVersion "2020-02-14" -Action Run -Force

az login --identity
az resource invoke-action --ids "${env:imageTemplateId}" --action Run
