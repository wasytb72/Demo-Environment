@description('Name of the Storage Account')
param name string

@description('Location of the StorageAccount')
param location string


resource storageAccount 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: name
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

output saID string = storageAccount.id
