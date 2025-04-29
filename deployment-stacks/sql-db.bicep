param sqlServerName string
param elasticPoolName string
param location string = resourceGroup().location

resource sqlServer 'Microsoft.Sql/servers@2024-05-01-preview' existing = {
  name: sqlServerName
}

resource sqlElasticPool 'Microsoft.Sql/servers/elasticPools@2024-05-01-preview' existing = {
  name: elasticPoolName
  parent: sqlServer
}

resource sqlDb 'Microsoft.Sql/servers/databases@2024-05-01-preview' = [for i in range(0, 5): {
  parent: sqlServer
  name: 'sqldb-teaching-${i}'

  location: location
  properties: {
    elasticPoolId: sqlElasticPool.id
  }
}]
