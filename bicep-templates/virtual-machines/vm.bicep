@minLength(4)
@maxLength(16)
param namePrefix string

@minLength(2)
@maxLength(4)
param namePostfix string = '01'

@minLength(4)
@maxLength(16)
param location string = resourceGroup().location

@allowed([
  'stage'
  'prod'
])
param environmentName string = 'stage'

@allowed([
  'win'
  'linux'
])
param osName string

@allowed([
  'Standard_LRS'
  'Premium_LRS'
])
param storageSKU string = 'Standard_LRS'

@allowed([
  'Standard_A2_v2'
  'Standard_B1s'
])
param vmSize string = 'Standard_A2_v2'

param subnetId string
param username string
@secure()
param password string

var vmName = '${namePrefix}${environmentName}vm${namePostfix}'

// // temp while os-settings do not work
//  var isLinux = osName == 'linux'
//  var publisher = isLinux ? 'Canonical' : 'MicrosoftWindowsServer'
//  var offer = isLinux ? 'UbuntuServer' : 'WindowsServer'
//  var sku = isLinux ? '16.04-LTS' : '2012-R2-Datacenter'


// get settings dependent on VM os type
module osSettingsModule '../parameters/os-settings.bicep' = {
  name: '${osName}-osSettings'
  params:{
    osName: osName
  }
}
var publisher = any(osSettingsModule.outputs.publisher)
var offer = any(osSettingsModule.outputs.offer)
var sku = any(osSettingsModule.outputs.sku)

// Bring in the nic
module nicModule './nic.bicep' = {
  name: '${vmName}-nic'
  params: {
    namePrefix: vmName
    subnetId: subnetId
  }
}

resource vmModule 'Microsoft.Compute/virtualMachines@2020-12-01' = {
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
          storageAccountType: storageSKU
        }
      }
      imageReference: {
        publisher: publisher
        offer: offer
        sku: sku
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
          id: nicModule.outputs.nicId
        }
      ]
    }
  }
}

output id string = vmModule.id
