@minLength(4)
@maxLength(16)
param namePrefix string

@minLength(4)
@maxLength(16)
param location string = resourceGroup().location

param dnsName string = uniqueString('${location}dnsname')

var ipAddressName = '${namePrefix}-PublicIP'

resource publicIPAddress 'Microsoft.Network/publicIPAddresses@2019-11-01' = {
  name: ipAddressName
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
    dnsSettings: {
      domainNameLabel: dnsName
    }
  }
}

output publicIpId string = publicIPAddress.id
