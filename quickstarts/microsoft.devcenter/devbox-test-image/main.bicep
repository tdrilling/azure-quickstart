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

    $DeploymentScriptOutputs = @{}
    $DeploymentScriptOutputs['testKey'] = 'test key value'

    '''
    cleanupPreference: 'OnSuccess'
    retentionInterval: 'PT1H'
  }
}


resource logs 'Microsoft.Resources/deploymentScripts/logs@2020-10-01' existing = {
  parent: deploymentScript
  name: 'default'
}

output logs array = split(logs.properties.log, '\n')
output myBool bool = deploymentScript.properties.outputs.testKey
