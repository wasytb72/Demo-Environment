/*
Launcher for creating resources On-Demand
1.0 Log Analytics, Storage Account, Recovery Services Vault
*/
//Params for Storage Account
@description('Name of the Storage Account')
@maxLength(15)
param saname string  = toLower(substring('sa${uniqueString(resourceGroup().id)}',0,15))

//Params for LAW
@description('Name of the LAW')
@maxLength(15)
param lawname string = toLower(substring('la${uniqueString(resourceGroup().id)}',0,15))

//Params for Recovery Vault Object
@description('Recovery Services vault name')
@maxLength(15)
param vaultName string = toLower(substring('rv${uniqueString(resourceGroup().id)}',0,15))

//Params for Recovery Vault Policy Object
@description('Recovery Services vault name')
@maxLength(15)
param backupPolicyName string = toLower(substring('rv${uniqueString(resourceGroup().id)}',0,15))

@description('Location of Resources')
param location string = resourceGroup().location

@description('Enable system identity for Recovery Services vault')
param vaultenableSystemIdentity bool = false

@description('Enable system identity for Recovery Services vault')
@allowed([
  'Standard'
  'RS0'
])
param vaultsku string = 'RS0'

@description('Storage replication type for Recovery Services vault')
@allowed([
  'LocallyRedundant'
  'GeoRedundant'
  'ReadAccessGeoZoneRedundant'
  'ZoneRedundant'
])
param vaultStorageType string = 'LocallyRedundant'

@description('Enable cross region restore')
param vaultEnablecrossRegionRestore bool = false

@description('Array containing backup policies')
@metadata({
  policyName: 'Backup policy name'
  properties: 'Object containing backup policy settings'
})
param vaultBackupPolicies array = []

@description('Enable delete lock')
param vaultEnableDeleteLock bool = false

@description('Enable diagnostic logs')
param vaultEnableDiagnostics bool = true


module storageaccount 'Modules/storage_account.bicep' = {
  name: 'storageaccount'
  params: {
    name: saname
    location: location
  }
}

module logAnalytics 'Modules/loganalytics_workspace.bicep' = {
  name: 'logAnalytics'
  params: {
    name: lawname
    location: location
  }
}

module recoveryservicevault 'Modules/recovery_vault.bicep' = {
  name: 'recoveryvault'
  params: {
    vaultName: vaultName
    location: location
    enableSystemIdentity: vaultenableSystemIdentity
    sku: vaultsku
    storageType: vaultStorageType
    enablecrossRegionRestore: vaultEnablecrossRegionRestore
    backupPolicies: vaultBackupPolicies
    enableDeleteLock: vaultEnableDeleteLock
    enableDiagnostics: vaultEnableDiagnostics
    diagnosticStorageAccountId: storageaccount.outputs.saID
    logAnalyticsWorkspaceId: logAnalytics.outputs.lawid

  }

}
resource symbolicname 'Microsoft.RecoveryServices/vaults/backupPolicies@2022-02-01' = {
  name: backupPolicyName
  location: location
  tags: {
    tagName1: 'tagValue1'
    tagName2: 'tagValue2'
  }
  parent: recoveryservicevault
  eTag: 'string'
  properties: {
    protectedItemsCount: int
    resourceGuardOperationRequests: [
      'string'
    ]
    backupManagementType: 'AzureIaasVM'
    instantRPDetails: {
      azureBackupRGNamePrefix: 'string'
      azureBackupRGNameSuffix: 'string'
    }
    instantRpRetentionRangeInDays: int
    policyType: 'string'
    retentionPolicy: {
      retentionPolicyType: 'LongTermRetentionPolicy'
        dailySchedule: {
          retentionDuration: {
          count: int
          durationType: 'string'
        }
    retentionTimes: [
      'string'
    ]
  }
    monthlySchedule: {
      retentionDuration: {
        count: int
        durationType: 'string'
      }
      retentionScheduleDaily: {
        daysOfTheMonth: [
          {
            date: int
            isLast: bool
          }
        ]
      } 
      retentionScheduleFormatType: 'string'
      retentionScheduleWeekly: {
        daysOfTheWeek: [
          'string'
        ]
        weeksOfTheMonth: [
          'string'
        ]
      }
      retentionTimes: [
        'string'
      ]
  }
  weeklySchedule: {
    daysOfTheWeek: [
      'string'
    ]
    retentionDuration: {
      count: int
      durationType: 'string'
    }
    retentionTimes: [
      'string'
    ]
  }
  yearlySchedule: {
    monthsOfYear: [
      'string'
    ]
    retentionDuration: {
      count: int
      durationType: 'string'
    }
    retentionScheduleDaily: {
      daysOfTheMonth: [
        {
          date: int
          isLast: bool
        }
      ]
    }
    retentionScheduleFormatType: 'string'
    retentionScheduleWeekly: {
      daysOfTheWeek: [
        'string'
      ]
      weeksOfTheMonth: [
        'string'
      ]
    }
    retentionTimes: [
      'string'
    ]
  }
    }
    schedulePolicy: {
      schedulePolicyType: 'string'
      // For remaining properties, see SchedulePolicy objects
    }
    timeZone: 'string'
  }
}
