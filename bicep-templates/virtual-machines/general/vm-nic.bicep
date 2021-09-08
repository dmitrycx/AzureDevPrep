@minLength(3)
@maxLength(11)
param namePrefix string

@minLength(4)
@maxLength(16)
param location string = resourceGroup().location

param subnetId string
param privateIPAddress string =  '10.0.0.4'

var nicName = '${namePrefix}-nic-${uniqueString(resourceGroup().id)}'

resource networkInterface 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: nicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAddress: privateIPAddress
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: subnetId
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
