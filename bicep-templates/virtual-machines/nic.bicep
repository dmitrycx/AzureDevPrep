@minLength(4)
@maxLength(32)
param namePrefix string

@minLength(4)
@maxLength(16)
param location string = resourceGroup().location

param subnetId string

var nicName = '${namePrefix}-nic'

// bring in the nsg
module nsgModule './nsg.bicep' = {
  name: '${namePrefix}-nsg'
  params: {
    namePrefix: namePrefix
    location: location
    allow_rdp: true
    allow_ssh: true
  }
}

// bring in the public IP
module publicIpModule './publicip.bicep' = {
  name: '${nicName}-pip'
  params: {
    namePrefix: nicName
    location: location
  }
}

resource networkInterface 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: nicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: '${nicName}-ipconfig'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIpModule.outputs.publicIpId
          }
          subnet: {
            id: subnetId
            properties: {
              networkSecurityGroup: {
                  id: nsgModule.outputs.nsgId
                  location: location
                  properties: {}
                }
            }
          }

          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: false
    enableIPForwarding: false
  }
}

output nicId string = networkInterface.id
