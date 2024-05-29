param location string = resourceGroup().location
param guidId string = newGuid()

resource deploymentScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'test-deployment-script'
  location: location
  kind: 'AzurePowerShell'
  properties: {
    forceUpdateTag: guidId
    azPowerShellVersion: '9.7'
    scriptContent: '''
    $ErrorActionPreference = "Stop"
    Set-StrictMode -Version Latest

    Write-Host 'Writing to Host'
    Write-Output 'Writing to Output'

    $PSVersionTable
    '''
    cleanupPreference: 'OnSuccess'
    retentionInterval: 'PT1H'
  }
}
