@allowed([
  'stage'
  'prod'
])
param environmentName string

var environmentSettings = {
  stage: {
    storageSKU: 'Standard_LRS'
    vmSize: 'Standard_A2_v2'
  }
  prod: {
    storageSKU: 'Premium_LRS'
    vmSize: 'Standard_A4_v2'
  }
}

output storageSKU string = environmentSettings[environmentName].storageSKU
output vmSize string = environmentSettings[environmentName].vmSize
