@description('Name of the LAW')
@maxLength(15)
param name string = 'la-${uniqueString(resourceGroup().id)}'

@description('Location to deployed the LAW')
param location string


resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2021-12-01-preview' = {
  name: name
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
  }
}

output lawid string = logAnalytics.id
