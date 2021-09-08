@minLength(4)
@maxLength(16)
param namePrefix string

// @minLength(2)
// @maxLength(4)
// param vmPostfix string = '001'

@minLength(4)
@maxLength(16)
param location string = resourceGroup().location

@allowed([
  'Standard_A2_v2'
  'Standard_A4_v2'
])
param vmSize string = 'Standard_A2_v2'


param subnetId string
param ubuntuOsVersion string = '18.04-LTS'
param osDiskType string = 'Standard_LRS'
param username string
param password string


var vmName = '${namePrefix}-VM-${uniqueString(resourceGroup().id)}'

// Bring in the nic
module nic './vm-nic.bicep' = {
  name: '${vmName}-nic'
  params: {
    namePrefix: '${vmName}-hdd'
    subnetId: subnetId
  }
}

resource ubuntuVM 'Microsoft.Compute/virtualMachines@2020-12-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: osDiskType
        }
      }
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: ubuntuOsVersion
        version: 'latest'
      }
    }
    osProfile: {
      computerName: vmName
      adminUsername: username
      adminPassword: password
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.outputs.nicId
        }
      ]
    }
  }
  // properties: {
  //   hardwareProfile: {
  //     vmSize: vmSize
  //   }
  //   osProfile: {
  //     computerName: 'computerName'
  //     adminUsername: 'adminUsername'
  //     adminPassword: 'adminPassword'
  //   }
  //   storageProfile: {
  //     imageReference: {
  //       publisher: 'Canonical'
  //       offer: 'UbuntuServer'
  //       sku: '16.04-LTS'
  //       version: 'latest'
  //     }
  //     osDisk: {
  //       name: 'name'
  //       caching: 'ReadWrite'
  //       createOption: 'FromImage'
  //     }
  //   }
  //   networkProfile: {
  //     networkInterfaces: [
  //       {
  //         id: 'id'
  //       }
  //     ]
  //   }
  //   diagnosticsProfile: {
  //     bootDiagnostics: {
  //       enabled: true
  //       storageUri: 'storageUri'
  //     }
  //   }
  // }
}

output id string = ubuntuVM.id
