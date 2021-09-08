
@minLength(3)
@maxLength(11)
param storagePrefix string

@minLength(4)
@maxLength(16)
param location string = resourceGroup().location

// @allowed([
//   'Standard_LRS'
//   'Premium_LRS'
// ])
param storageSKU string = 'Standard_LRS'

var uniqueStorageName = '${storagePrefix}${uniqueString(resourceGroup().id)}'

resource stg 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: uniqueStorageName
  location: location
  kind: 'StorageV2'
  sku: {
    name: storageSKU
  }
}

output storageEndpoint object = stg.properties.primaryEndpoints
