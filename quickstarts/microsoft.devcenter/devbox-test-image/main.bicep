param location string = resourceGroup().location
param builderIdentity string
param imageIdentity string
param galleryName string
param galleryResourceGroup string = resourceGroup().name
param gallerySubscriptionId string = subscription().subscriptionId
param logsStorageAccountName string 

module image 'images/minimal.bicep' = {
  name: 'minimal'
  params: {
    location: location
    imageName: 'minimal'
    builderIdentity: builderIdentity
    imageIdentity: imageIdentity
    galleryName: galleryName
    galleryResourceGroup: galleryResourceGroup
    gallerySubscriptionId: gallerySubscriptionId
    logsStorageAccountName: logsStorageAccountName
  }
}

output imageBuildLog string = image.outputs.imageBuildLog

//param guidId string = newGuid()

// resource deploymentScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
//   name: 'test-deployment-script'
//   location: location
//   kind: 'AzurePowerShell'
//   properties: {
//     forceUpdateTag: guidId
//     azPowerShellVersion: '9.7'
//     scriptContent: '''
//     $ErrorActionPreference = "Stop"
//     Set-StrictMode -Version Latest

//     Write-Host 'Writing to Host'
//     Write-Output 'Writing to Output'

//     $PSVersionTable

//     $DeploymentScriptOutputs = @{}
//     $DeploymentScriptOutputs['testKey'] = 'test key value'

//     '''
//     cleanupPreference: 'OnSuccess'
//     retentionInterval: 'PT1H'
//   }
// }

// resource logs 'Microsoft.Resources/deploymentScripts/logs@2020-10-01' existing = {
//   parent: deploymentScript
//   name: 'default'
// }

// output logsStr string = logs.properties.log
// output logsArr array = split(logs.properties.log, '\n')
// output testKey string = deploymentScript.properties.outputs.testKey
