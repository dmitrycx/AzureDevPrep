// DONE: create vnet
// DONE: create public ip

// create nat
// create nsg

// create networkInterfaceName
// create vm win
// create vm linux

// Extra : https://docs.microsoft.com/en-us/azure/virtual-machines/windows/tutorial-load-balancer

@minLength(4)
@maxLength(16)
param location string = resourceGroup().location

param resourcePrefix string = 'devlab'

@allowed([
  'stage'
  'prod'
])
param environmentName string = 'stage'

module envSettingsModule 'environmentsettings.bicep' = {
  name: 'SettingsAssignment'
  params:{
    environmentName: environmentName
  }
}

module stgModule 'storageaccount.bicep' = {
  name: 'storageDeploy'
  params:{
    storagePrefix: resourcePrefix
    location: location
    storageSKU: envSettingsModule.outputs.storageSKU
  }
}

// module publicIPModule 'publicip.bicep' = {
//   name: 'publicIPDeploy'
//   params:{
//     ipAddressPrefix: 'DevLab'
//     location: location
//   }
// }

// module nsgModule 'nsg.bicep' = {
//   name: 'networkSecurityGroupDeploy'
//   params:{
//     nsgPrefix: 'DevLab'
//     location: location
//   }
// }

// module vNetModule 'vnet.bicep' = {
//   name: 'virtualNetworkDeploy'
//   params:{
//     vNetPrefix: 'DevLab'
//     location: location
//   }
// }

// module nicModule 'nic.bicep' = {
//   name: 'networkInterfaceConnectorDeploy'
//   params:{
//     nicPrefix: 'DevLab'
//     location: location
//   }
// }
