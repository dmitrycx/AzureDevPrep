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

module vmModule './virtual-machines/vm.bicep' = {
  name: 'virtualMachineDeploy'
  params:{
    namePrefix: resourcePrefix
    location: location
    //vmSize: 'Standard_A2_v2'//envSettingsModule.outputs.vmSize
    osName: 'linux'
    environmentName: environmentName
    subnetId: vNetModule.outputs.subnetId
    username: vmUsername
    password: vmPassword
  }
}

// module stgModule 'storageaccount.bicep' = {
//   name: 'storageDeploy'
//   params:{
//     storagePrefix: resourcePrefix
//     location: location
//     storageSKU: envSettingsModule.outputs.storageSKU
//   }
// }

// module publicIPModule 'publicip.bicep' = {
//   name: 'publicIPDeploy'
//   params:{
//     ipAddressPrefix: resourcePrefix
//     location: location
//   }
// }

// module nsgModule 'nsg.bicep' = {
//   name: 'networkSecurityGroupDeploy'
//   params:{
//     nsgPrefix: resourcePrefix
//     location: location
//   }
// }

output vmName string = vmModule.name
