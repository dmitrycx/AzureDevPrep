@allowed([
  'windows'
  'linux'
])
param osName string

var environmentSettings = {
  windows: {
    publisher: 'MicrosoftWindowsServer'
    offer: 'WindowsServer'
    sku: '2012-R2-Datacenter'
  }
  linux: {
    publisher: 'Canonical'
    offer: 'UbuntuServer'
    sku: '16.04-LTS'
  }
}

output publisher string = environmentSettings[osName].publisher
output offer string = environmentSettings[osName].offer
output sku string = environmentSettings[osName].sku
