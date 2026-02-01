import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Data.Tables;

namespace ClientCustomizations;

@@clientNamespace(Data.Tables, "Azure.Data.Tables");
@@clientNamespace(Data.Tables.Service, "Azure.Data.Tables");
@@clientNamespace(Data.Tables.Table, "Azure.Data.Tables");
@@clientNamespace(ClientCustomizations, "Azure.Data.Tables");

@client(
  {
    name: "TableServiceClient",
    service: Data.Tables,
  },
  "python"
)
interface ClientParent {
  #suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Existing API"
  getProperties is Data.Tables.Service.getProperties;
  #suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Existing API"
  setProperties is Data.Tables.Service.setProperties;
  #suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Existing API"
  getStatistics is Data.Tables.Service.getStatistics;
  #suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Existing API"
  #suppress "@azure-tools/typespec-azure-core/use-standard-names" "Existing API"
  query is Data.Tables.Table.query;
}

@@clientName(ClientParent.getProperties, "getServiceProperties", "python");
@@clientName(ClientParent.setProperties, "setServiceProperties", "python");
@@clientName(ClientParent.getStatistics, "getServiceStats", "python");
@@clientName(ClientParent.query, "listTables", "python");

model TableClientOptions {
  /** The name of the table to operate on */
  tableName: string;
}

@@clientInitialization(ClientChild,
  {
    parameters: TableClientOptions,
  },
  "python"
);

@client(
  {
    name: "TableClient",
    service: Data.Tables,
  },
  "python"
)
interface ClientChild {
  #suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Existing API"
  create is Data.Tables.Table.create;
  #suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Existing API"
  delete is Data.Tables.Table.delete;
  #suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Existing API"
  #suppress "@azure-tools/typespec-azure-core/use-standard-names" "Existing API"
  queryEntities is Data.Tables.Table.queryEntities;
  #suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Existing API"
  #suppress "@azure-tools/typespec-azure-core/use-standard-names" "Existing API"
  queryEntityWithPartitionAndRowKey is Data.Tables.Table.queryEntityWithPartitionAndRowKey;
  #suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Existing API"
  insertEntity is Data.Tables.Table.insertEntity;
  #suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Existing API"
  deleteEntity is Data.Tables.Table.deleteEntity;
  #suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Existing API"
  updateEntity is Data.Tables.Table.updateEntity;
  #suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Existing API"
  mergeEntity is Data.Tables.Table.mergeEntity;
  #suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Existing API"
  getAccessPolicy is Data.Tables.Table.getAccessPolicy;
  #suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Existing API"
  setAccessPolicy is Data.Tables.Table.setAccessPolicy;
}

@@clientName(ClientChild.getAccessPolicy, "getTableAccessPolicy", "python");
@@clientName(ClientChild.setAccessPolicy, "setTableAccessPolicy", "python");
@@clientName(ClientChild.create, "createTable", "python");
@@clientName(ClientChild.delete, "deleteTable", "python");
@@clientName(ClientChild.queryEntityWithPartitionAndRowKey, "getEntity");
@@access(ClientChild.updateEntity, Access.internal, "python");
@@access(ClientChild.mergeEntity, Access.internal, "python");
@@access(ClientChild.queryEntities, Access.internal, "python");
@@alternateType(Data.Tables.AccessPolicy.start, string, "python");
@@alternateType(Data.Tables.AccessPolicy.expiry, string, "python");

/** The signed identifier. */
model SignedIdentifier {
  /** The unique ID for the signed identifier. */
  @Xml.name("Id") id: string;

  /** The access policy for the signed identifier. */
  @Xml.name("AccessPolicy") accessPolicy?: AccessPolicy;
}
@@alternateType(Data.Tables.SignedIdentifier, SignedIdentifier, "python");
/** Client initialization options for TableClient */
@@clientName(Data.Tables.AccessPolicy, "TableAccessPolicy", "python");
@@clientName(Data.Tables.Logging, "TableAnalyticsLogging", "python");
@@clientName(Data.Tables.TableProperties, "TableItem", "python");
@@clientName(Data.Tables.CorsRule, "TableCorsRule", "python");
