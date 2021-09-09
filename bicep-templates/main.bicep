@minLength(4)
@maxLength(16)
param location string = resourceGroup().location

param resourcePrefix string = 'devlab'

param vmUsername string
param vmPassword string

@allowed([
  'stage'
  'prod'
])
param environmentName string = 'stage'

module vNetModule './virtual-network/vnet.bicep' = {
  name: 'virtualNetworkDeploy'
  params:{
    vNetPrefix: resourcePrefix
    location: location
  }
}

//temp while env-settings do not work
var isProd = environmentName == 'prod'
var storageSKU = isProd ? 'Premium_LRS' : 'Standard_LRS'//envSettingsModule.outputs.storageSKU

// Create storage for VM
module stgModule './storage/storage-account.bicep' = {
  name: '${resourcePrefix}${environmentName}stg'
  params: {
    namePrefix: '${resourcePrefix}${environmentName}'
    location: location
    storageSKU: storageSKU
  }
}

module vmLinuxModule './virtual-machines/vm.bicep' = {
  name: 'vmLinuxDeploy'
  params:{
    namePrefix: resourcePrefix
    namePostfix:'01'
    location: location
    osName: 'linux'
    environmentName: environmentName
    subnetId: vNetModule.outputs.subnetId
    username: vmUsername
    password: vmPassword
  }
}

module vmWindowsModule './virtual-machines/vm.bicep' = {
  name: 'vmWindowsDeploy'
  params:{
    namePrefix: resourcePrefix
    namePostfix:'02'
    location: location
    osName: 'win'
    environmentName: environmentName
    subnetId: vNetModule.outputs.subnetId
    username: vmUsername
    password: vmPassword
  }
}
