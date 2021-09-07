@minLength(8)
@maxLength(16)
param resourceGroupName string

@minLength(4)
@maxLength(16)
param location string

targetScope = 'subscription'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}
