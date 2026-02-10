@description('Name of the Container App Environment')
param name string

@description('Location for the Container App Environment')
param location string = resourceGroup().location

@description('Log Analytics Workspace ID')
param logAnalyticsWorkspaceId string

@description('Subnet ID for VNet integration')
param subnetId string

@description('Tags for the resource')
param tags object = {}

resource containerAppEnvironment 'Microsoft.App/managedEnvironments@2023-05-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    vnetConfiguration: {
      infrastructureSubnetId: subnetId
      internal: true
    }
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: reference(logAnalyticsWorkspaceId, '2022-10-01').customerId
        sharedKey: listKeys(logAnalyticsWorkspaceId, '2022-10-01').primarySharedKey
      }
    }
    zoneRedundant: false
  }
}

output id string = containerAppEnvironment.id
output name string = containerAppEnvironment.name
output defaultDomain string = containerAppEnvironment.properties.defaultDomain
output staticIp string = containerAppEnvironment.properties.staticIp
