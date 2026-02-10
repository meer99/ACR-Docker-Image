@description('Name of the SQL Server')
param name string

@description('Location for the SQL Server')
param location string = resourceGroup().location

@description('SQL Server administrator login')
param administratorLogin string

@description('SQL Server administrator password')
@secure()
param administratorPassword string

@description('Managed Identity Resource ID')
param managedIdentityId string

@description('Managed Identity Principal ID')
param managedIdentityPrincipalId string

@description('SQL Server version')
param version string = '12.0'

@description('Tags for the resource')
param tags object = {}

resource sqlServer 'Microsoft.Sql/servers@2023-05-01-preview' = {
  name: name
  location: location
  tags: tags
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentityId}': {}
    }
  }
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorPassword
    version: version
    publicNetworkAccess: 'Disabled'
    minimalTlsVersion: '1.2'
    primaryUserAssignedIdentityId: managedIdentityId
  }
}

output id string = sqlServer.id
output name string = sqlServer.name
output fullyQualifiedDomainName string = sqlServer.properties.fullyQualifiedDomainName