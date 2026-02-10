@description('Name of the Network Security Group')
param name string

@description('Location for the NSG')
param location string = resourceGroup().location

@description('Security rules for the NSG')
param securityRules array = []

@description('Tags for the resource')
param tags object = {}

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2023-05-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    securityRules: securityRules
  }
}

output id string = networkSecurityGroup.id
output name string = networkSecurityGroup.name
