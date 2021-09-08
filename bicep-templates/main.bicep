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

// module envSettingsModule './parameters/environmentsettings.bicep' = {
//   name: 'SettingsAssignment'
//   params:{
//     environmentName: environmentName
//   }
// }

module vNetModule './virtual-network/vnet.bicep' = {
  name: 'virtualNetworkDeploy'
  params:{
    vNetPrefix: resourcePrefix
    location: location
  }
}

module vmLinuxModule './virtual-machines/vm.bicep' = {
  name: 'vmLinuxDeploy'
  params:{
    namePrefix: resourcePrefix
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
    location: location
    osName: 'win'
    environmentName: environmentName
    subnetId: vNetModule.outputs.subnetId
    username: vmUsername
    password: vmPassword
  }
}
