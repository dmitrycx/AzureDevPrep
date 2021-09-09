@minLength(4)
@maxLength(32)
param namePrefix string

@minLength(4)
@maxLength(16)
param location string = resourceGroup().location

param dnsName string = '${namePrefix}dnsname'

var ipAddressName = '${namePrefix}-pip'

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
