import "@azure-tools/typespec-client-generator-core";
import "./main.tsp";

using TypeSpec.Http;
using Azure.ClientGenerator.Core;
using Storage.Blob;

namespace Customizations;

#suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Existing API"
@client(
  {
    service: Storage.Blob,
  },
  "rust"
)
interface BlobServiceClient extends Storage.Blob.Service {}

#suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Existing API"
@client(
  {
    service: Storage.Blob,
  },
  "rust"
)
interface BlobContainerClient extends Storage.Blob.Container {}

#suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Existing API"
@client(
  {
    service: Storage.Blob,
  },
  "rust"
)
interface BlobClient extends Storage.Blob.Blob {}

#suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Existing API"
@client(
  {
    service: Storage.Blob,
  },
  "rust"
)
interface AppendBlobClient extends Storage.Blob.AppendBlob {}

#suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Existing API"
@client(
  {
    service: Storage.Blob,
  },
  "rust"
)
interface BlockBlobClient extends Storage.Blob.BlockBlob {}

#suppress "@azure-tools/typespec-azure-core/use-standard-operations" "Existing API"
@client(
  {
    service: Storage.Blob,
  },
  "rust"
)
interface PageBlobClient extends Storage.Blob.PageBlob {}

@@clientNamespace(Storage.Blob, "Azure.Storage.Blobs");
@@clientNamespace(Storage.Blob.Container, "Azure.Storage.Blobs");
@@clientNamespace(Storage.Blob.Blob, "Azure.Storage.Blobs");
@@clientNamespace(Storage.Blob.AppendBlob, "Azure.Storage.Blobs");
@@clientNamespace(Storage.Blob.BlockBlob, "Azure.Storage.Blobs");
@@clientNamespace(Storage.Blob.PageBlob, "Azure.Storage.Blobs");

@@clientName(Storage.Blob.BlockBlob.upload, "upload_internal", "rust");
@@clientName(Storage.Blob.Blob.download, "download_internal", "rust");

@@clientName(ContainerProperties.denyEncryptionScopeOverride,
  "PreventEncryptionScopeOverride"
);
@@clientName(ContainerProperties.immutableStorageWithVersioningEnabled,
  "IsImmutableStorageWithVersioningEnabled"
);
@@clientName(BlobProperties.expiryTime, "ExpiresOn");
@@clientName(BlobProperties.sealed, "IsSealed");
@@clientName(BlobProperties.lastAccessTime, "LastAccessedOn");
@@clientName(BlobProperties.immutabilityPolicyUntilDate,
  "ImmutabilityPolicyExpiresOn"
);
@@clientName(MetadataHeaders.metadata, "metadata", "rust");
@@clientName(ObjectReplicationHeaders.objectReplicationRules,
  "objectReplicationRules",
  "rust"
);
@@clientName(ImmutabilityPolicyExpiryRequiredParameter.immutabilityPolicyExpiry,
  "expiry"
);

@@alternateType(AccessPolicy.start, string, "javascript");
@@alternateType(AccessPolicy.expiry, string, "javascript");
@@clientName(AccessPolicy.start, "startsOn", "javascript");
@@clientName(AccessPolicy.expiry, "expiresOn", "javascript");
@@clientName(AccessPolicy.permission, "permissions", "javascript");
@@clientName(BlobProperties.accessTierChangeTime,
  "accessTierChangedOn",
  "javascript"
);
@@clientName(BlobProperties.creationTime, "createdOn", "javascript");
@@clientName(BlobProperties.copyCompletionTime,
  "copyCompletedOn",
  "javascript"
);
@@clientName(BlobProperties.deletedTime, "deletedOn", "javascript");
@@clientName(BlobProperties.eTag, "etag", "javascript");
@@clientName(ContainerProperties.deletedTime, "deletedOn", "javascript");
@@clientName(ContainerProperties.eTag, "etag", "javascript");
@@clientName(EtagResponseHeader.eTag, "etag", "javascript");
@@clientName(GeoReplication.lastSyncTime, "lastSyncOn", "javascript");
@@clientName(KeyInfo.start, "startsOn", "javascript");
@@clientName(KeyInfo.expiry, "expiresOn", "javascript");
@@clientName(BlobServiceProperties.logging,
  "blobAnalyticsLogging",
  "javascript"
);
@@clientName(Logging.delete, "deleteProperty", "javascript");
@@clientName(UserDelegationKey.signedOid, "signedObjectId", "javascript");
@@clientName(UserDelegationKey.signedTid, "signedTenantId", "javascript");
@@clientName(UserDelegationKey.signedStart, "signedStartsOn", "javascript");
@@clientName(UserDelegationKey.signedExpiry, "signedExpiresOn", "javascript");
@@clientName(FilterBlobSegment.nextMarker, "continuationToken", "javascript");
@@clientName(ListContainersSegmentResponse.NextMarker,
  "continuationToken",
  "javascript"
);
@@clientName(ListContainersSegmentResponse.maxResults,
  "maxPageSize",
  "javascript"
);
@@clientName(ListBlobsResponse.nextMarker, "continuationToken", "javascript");
@@clientName(ListBlobsResponse.maxResults, "maxPageSize", "javascript");
@@clientName(PageList.nextMarker, "continuationToken", "javascript");
@@clientName(ListBlobsHierarchySegmentResponse.nextMarker,
  "continuationToken",
  "javascript"
);
@@clientName(ListBlobsHierarchySegmentResponse.maxResults,
  "maxPageSize",
  "javascript"
);
@@alternateType(BlobProperties.contentLength, uint64, "rust");
@@alternateType(BlobContentLengthRequired.size, uint64, "rust");
@@alternateType(ContentLengthResponseHeader.contentLength, uint64, "rust");
@@alternateType(ContentLengthParameter.contentLength, uint64, "rust");
@@alternateType(StructuredContentLengthParameter.structuredContentLength,
  uint64,
  "rust"
);
@@alternateType(StructuredContentLengthResponseHeader.structuredContentLength,
  uint64,
  "rust"
);

@@scope(Storage.Blob.Container.submitBatch, "!rust");
@@scope(Storage.Blob.Service.submitBatch, "!rust");

@@clientName(BlobProperties, "BlobProperties", "go");
@@clientName(BlobItem, "BlobItem", "go");
@@clientName(UserDelegationKey.signedOid, "SignedOID", "go");
@@clientName(UserDelegationKey.signedTid, "SignedTID", "go");
@@alternateType(AccessPolicy.start, utcDateTime, "go");
@@alternateType(AccessPolicy.expiry, utcDateTime, "go");
@@alternateType(BlobItem.name, string, "go");
@@alternateType(BlobPrefix.name, string, "go");

@@alternateType(AccessPolicy.start, string, "python");
@@alternateType(AccessPolicy.expiry, string, "python");

@@clientName(QueryType, "QueryFormatType", "python");
@@clientName(Storage.Blob.BlockBlob.uploadBlobFromUrl,
  "putBlobFromUrl",
  "python"
);
@@clientName(BlobServiceProperties, "StorageServiceProperties", "python");
@@clientName(Storage.Blob.Blob.setProperties, "setHttpHeaders", "python");
@@clientName(Storage.Blob.PageBlob.setSequenceNumber,
  "updateSequenceNumber",
  "python"
);
@@clientName(Storage.Blob.Service.findBlobsByTags, "filterBlobs", "python");
@@clientName(Storage.Blob.Container.findBlobsByTags, "filterBlobs", "python");

@@alternateType(BlockIdParameter.blockid, string, "python");

@@Legacy.disablePageable(Storage.Blob.Container.listBlobs, "python,javascript");
@@Legacy.disablePageable(Storage.Blob.Container.listBlobHierarchySegment,
  "python,javascript"
);
@@Legacy.disablePageable(Storage.Blob.Service.listContainers,
  "python,javascript"
);

@@clientOption(Storage.Blob.Container,
  "includeRootSlash",
  false,
  "python,javascript"
);
@@clientOption(Storage.Blob.Service,
  "includeRootSlash",
  false,
  "python,javascript"
);
@@clientOption(Storage.Blob.Blob,
  "includeRootSlash",
  false,
  "python,javascript"
);
@@clientOption(Storage.Blob.PageBlob,
  "includeRootSlash",
  false,
  "python,javascript"
);
@@clientOption(Storage.Blob.BlockBlob,
  "includeRootSlash",
  false,
  "python,javascript"
);
@@clientOption(Storage.Blob.AppendBlob,
  "includeRootSlash",
  false,
  "python,javascript"
);
@@scope(Storage.Blob.Service.getUserDelegationKey, "!rust");
@@scope(Storage.Blob.Container.listBlobHierarchySegment, "!rust");
@@scope(Storage.Blob.Container.rename, "!rust");
@@scope(Storage.Blob.Container.restore, "!rust");
@@scope(Storage.Blob.Blob.abortCopyFromUrl, "!rust");
@@scope(Storage.Blob.Blob.copyFromUrl, "!rust");
@@scope(Storage.Blob.Blob.setExpiry, "!rust");
@@scope(Storage.Blob.Blob.startCopyFromUrl, "!rust");
@@scope(Storage.Blob.BlockBlob.query, "!rust");
@@scope(Storage.Blob.PageBlob.copyIncremental, "!rust");
@@scope(Storage.Blob.PageBlob.getPageRangesDiff, "!rust");
