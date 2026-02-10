@description('SQL Server name')
param sqlServerName string

@description('Allow Azure services to access SQL Server')
param allowAzureServices bool = true

@description('Array of firewall rules with name, startIpAddress, and endIpAddress')
param firewallRules array = []

resource azureServicesRule 'Microsoft.Sql/servers/firewallRules@2023-05-01-preview' = if (allowAzureServices) {
  name: '${sqlServerName}/AllowAllWindowsAzureIps'
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}

resource customFirewallRules 'Microsoft.Sql/servers/firewallRules@2023-05-01-preview' = [for rule in firewallRules: {
  name: '${sqlServerName}/${rule.name}'
  properties: {
    startIpAddress: rule.startIpAddress
    endIpAddress: rule.endIpAddress
  }
}]

output ruleNames array = [for rule in firewallRules: rule.name]