@minLength(3)
@maxLength(11)
param nicPrefix string

@minLength(4)
@maxLength(16)
param location string = resourceGroup().location

var nicName = '${nicPrefix}-nic'

resource networkInterface 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: nicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'name'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: 'subnet.id'
          }
        }
      }
    ]
  }
}
