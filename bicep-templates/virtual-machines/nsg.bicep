@minLength(3)
@maxLength(11)
param namePrefix string='stg'

@minLength(4)
@maxLength(16)
param location string = resourceGroup().location

param allow_rdp bool = false
param allow_ssh bool = false

var nsgName = '${namePrefix}-nsg'

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2019-11-01' = {
  name: nsgName
  location: location
}

resource networkSecurityGroupSecurityRuleRdp 'Microsoft.Network/networkSecurityGroups/securityRules@2019-11-01' = if(allow_rdp){
  name: 'AllowRDP'
  parent: networkSecurityGroup
  properties: {

    protocol: 'Tcp'
    sourcePortRange: '*'
    destinationPortRange: '3389'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 100
    direction: 'Inbound'
  }
}

resource networkSecurityGroupSecurityRuleSSH 'Microsoft.Network/networkSecurityGroups/securityRules@2019-11-01' = if(allow_ssh){
  name: 'AllowSSH'
  parent: networkSecurityGroup
  properties: {

    protocol: 'Tcp'
    sourcePortRange: '*'
    destinationPortRange: '22'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 110
    direction: 'Inbound'
  }
}

output nsgId string = networkSecurityGroup.id
