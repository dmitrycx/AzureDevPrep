@minLength(3)
@maxLength(16)
param nsgRuleName string

@allowed([
  '22'
  '3389'
])
param destinationPortRange string

@minValue(100)
@maxValue(1000)
param priority int = 100

resource networkSecurityGroupRule 'Microsoft.Network/networkSecurityGroups/securityRules@2019-11-01' = {
  name: nsgRuleName
  properties: {
    description: 'description'
    protocol: 'Tcp'
    sourcePortRange: '*'
    destinationPortRange: destinationPortRange
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: priority
    direction: 'Inbound'
  }
}
