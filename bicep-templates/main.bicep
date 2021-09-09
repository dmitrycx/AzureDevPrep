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

module envSettingsModule './parameters/environment-settings.bicep' = {
  name: '${environmentName}-envSettings'
  params:{
    environmentName: environmentName
  }
}

module vNetModule './virtual-network/vnet.bicep' = {
  name: 'virtualNetworkDeploy'
  params:{
    vNetPrefix: resourcePrefix
    location: location
  }
}

// Create storage for VM
module stgModule './storage/storage-account.bicep' = {
  name: '${resourcePrefix}${environmentName}stg'
  params: {
    namePrefix: '${resourcePrefix}${environmentName}'
    location: location
    storageSKU: any(envSettingsModule.outputs.storageSKU)
  }
}

module vmLinuxModule './virtual-machines/vm.bicep' = {
  name: 'vmLinuxDeploy'
  params:{
    namePrefix: resourcePrefix
    namePostfix:'01'
    location: location
    storageSKU: any(envSettingsModule.outputs.storageSKU)
    vmSize: any(envSettingsModule.outputs.vmSize)
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
    storageSKU: any(envSettingsModule.outputs.storageSKU)
    vmSize: any(envSettingsModule.outputs.vmSize)
    osName: 'win'
    environmentName: environmentName
    subnetId: vNetModule.outputs.subnetId
    username: vmUsername
    password: vmPassword
  }
}
