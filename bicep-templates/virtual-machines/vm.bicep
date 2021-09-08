param namePrefix string

@minLength(2)
@maxLength(4)
param vmPostfix string = '001'

@minLength(4)
@maxLength(16)
param location string = resourceGroup().location

@allowed([
  'stage'
  'prod'
])
param environmentName string = 'stage'

@allowed([
  'windows'
  'linux'
])
param osName string

@allowed([
  'Standard_A2_v2'
  'Standard_A4_v2'
])
param vmSize string = 'Standard_A2_v2'//envSettingsModule.outputs.vmSize

param subnetId string
param username string
@secure()
param password string

var vmName = '${namePrefix}-VM-${vmPostfix}'
var vmUniqueName = '${vmName}-${uniqueString(resourceGroup().id)}'
var storageSKU = 'Standard_LRS'//envSettingsModule.outputs.storageSKU

//temp while os-settings do not work
var isLinux = osName == 'Linux'
var publisher = isLinux ? 'Canonical' : 'MicrosoftWindowsServer'
var offer = isLinux ? 'UbuntuServer' : 'WindowsServer'
var sku = isLinux ? '16.04-LTS' : '2012-R2-Datacenter'

// get settings dependent on env
module envSettingsModule '../parameters/environment-settings.bicep' = {
  name: 'EnvSettings'
  params:{
    environmentName: environmentName
  }
}

// get settings dependent on VM os type
module osSettingsModule '../parameters/os-settings.bicep' = {
  name: 'OsSettings'
  params:{
    osName: osName
  }
}

// Bring in the nic
module nicModule './vm-nic.bicep' = {
  name: '${vmName}-nic'
  params: {
    namePrefix: vmName
    subnetId: subnetId
  }
}

// Create storage for VM
module stgModule '../storageaccount.bicep' = {
  name: '${vmName}-stg'
  params: {
    namePrefix: '${namePrefix}${osName}stg'
    location: location
    storageSKU: storageSKU
  }
}

resource vmModule 'Microsoft.Compute/virtualMachines@2020-12-01' = {
  name: vmUniqueName
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
        publisher: publisher//osSettingsModule.outputs.publisher
        offer: offer//osSettingsModule.outputs.offer
        sku: sku//osSettingsModule.outputs.sku
        version: 'latest'
      }
    }
    osProfile: {
      computerName: vmUniqueName
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
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        storageUri: stgModule.outputs.storageEndpoint.blob
      }
    }
  }
}

output id string = vmModule.id
