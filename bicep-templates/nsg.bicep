@minLength(3)
@maxLength(11)
param nsgPrefix string='stg'

@minLength(4)
@maxLength(16)
param location string = resourceGroup().location

var nsgName = '${nsgPrefix}-nsg'

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2019-11-01' = {
  name: nsgName
  location: location
}

module nsgRuleRDP 'nsgrule.bicep' = {
  name: 'AllowRDP'
  params: {
    nsgRuleName: 'AllowRDP'
    destinationPortRange: '3389'
    priority: 100
  }
}
  
module nsgRuleSSH 'nsgrule.bicep' = {
  name: 'AllowSSH'
  params: {
    nsgRuleName: 'AllowSSH'
    destinationPortRange: '22'
    priority: 110
  }
}
