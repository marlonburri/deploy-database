targetScope = 'subscription'

param location string = 'westeurope'

@secure()
param adminPassword string

var names = {
  databasesResourceGroupName: 'rg-databases'
  appResourceGroupName: 'rg-apps'
  sqlServerName: 'sql-learn-sql-with-marlob'
  elasticPoolName: 'pool-learn-sql-with-marlob'
}

var defaultTags = {
  environment: 'dev'
  project: 'myProject'
}

resource dbRg 'Microsoft.Resources/resourceGroups@2024-11-01' = {
  name: names.databasesResourceGroupName
  location: location
  tags: union(defaultTags, {
    resourceGroupType: 'databases'
  })
}

resource appRg 'Microsoft.Resources/resourceGroups@2024-11-01' = {
  name: names.appResourceGroupName
  location: location
  tags: union(defaultTags, {
    resourceGroupType: 'apps'
  })
}

module serverModule 'br/public:avm/res/sql/server:0.16.0' = {
  name: 'serverDeployment'
  scope: dbRg
  params: {
    name: names.sqlServerName
    administratorLogin: 'sqlteacher'
    administratorLoginPassword: adminPassword
    elasticPools: [
      {
        name: names.elasticPoolName
        maxSizeBytes: 5 * 1024 * 1024 * 1024
        perDatabaseSettings: {
          maxCapacity: '5'
          minCapacity: '0.5'
        }
        sku: {
          name: 'BasicPool'
          capacity: 50
        }
        zoneRedundant: false
        availabilityZone: -1
      }
    ]
    location: location
  }
}
