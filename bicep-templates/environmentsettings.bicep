@allowed([
  'stage'
  'prod'
])
param environmentName string

var environmentSettings = {
  test: {
    storageSKU: 'Standard_LRS'
    
    instanceCount: 1
  }
  prod: {
    storageSKU: 'Premium_LRS'
    instanceCount: 4
  }
}

output storageSKU string = environmentSettings[environmentName].storageSKU
output instanceCount int = environmentSettings[environmentName].instanceCount
