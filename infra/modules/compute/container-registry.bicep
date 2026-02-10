@description('Name of the Container Registry')
param name string

@description('Location for the Container Registry')
param location string = resourceGroup().location

@description('SKU of the Container Registry')
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param sku string = 'Premium'

@description('Enable admin user')
param adminUserEnabled bool = false

@description('Managed Identity Resource ID')
param managedIdentityId string

@description('Tags for the resource')
param tags object = {}

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: sku
  }
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentityId}': {}
    }
  }
  properties: {
    adminUserEnabled: adminUserEnabled
    publicNetworkAccess: 'Disabled'
    networkRuleBypassOptions: 'AzureServices'
    zoneRedundancy: 'Disabled'
  }
}

output id string = containerRegistry.id
output name string = containerRegistry.name
output loginServer string = containerRegistry.properties.loginServer
