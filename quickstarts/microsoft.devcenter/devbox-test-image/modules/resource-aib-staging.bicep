targetScope = 'subscription'

param location string
param stagingResourceGroupName string

resource stagingResourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  location: location
  name: stagingResourceGroupName
}
