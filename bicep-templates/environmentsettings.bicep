@allowed([
  'stage'
  'prod'
])
param environmentName string

var environmentSettings = {
  stage: {
    storageSKU: 'Standard_LRS'
  }
  prod: {
    storageSKU: 'Premium_LRS'
  }
}

output storageSKU string = environmentSettings[environmentName].storageSKU
