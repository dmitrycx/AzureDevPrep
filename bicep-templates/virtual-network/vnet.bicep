@minLength(3)
@maxLength(8)
param vNetPrefix string

@minLength(4)
@maxLength(16)
param location string = resourceGroup().location

var vNetName = '${vNetPrefix}-vnet-${uniqueString(resourceGroup().id)}'
var subnetName = 'main-subnet'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: vNetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
    ]
  }
}

output vnetId string = virtualNetwork.id
output subnetId string = '${virtualNetwork.id}/subnets/${subnetName}'
output subnetName string = subnetName
