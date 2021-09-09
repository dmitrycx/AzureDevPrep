@allowed([
  'stage'
  'prod'
])
param environmentName string = 'stage'

var environmentSettings = {
  stage: {
    storageSKU: 'Standard_LRS'
    vmSize: 'Standard_A2_v2'
  }
  prod: {
    storageSKU: 'Premium_LRS'
    vmSize: 'Standard_B1s'
  }
}

output storageSKU string = environmentSettings[environmentName].storageSKU
output vmSize string = environmentSettings[environmentName].vmSize
