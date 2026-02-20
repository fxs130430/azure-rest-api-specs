import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;

namespace Customizations;

@@clientNamespace(Storage.Queues, "Azure.Storage.Queues");
@@clientNamespace(Storage.Queues.Service, "Azure.Storage.Queues");
@@clientNamespace(Storage.Queues.Queue, "Azure.Storage.Queues");

@@clientName(Storage.Queues, "QueueServiceClient", "rust");
@@clientName(Storage.Queues.Queue, "QueueClient", "rust");

@@clientName(Storage.Queues.MetadataHeaders.metadata, "metadata", "rust");

@@clientInitialization(Storage.Queues.Queue,
  {
    initializedBy: InitializedBy.parent | InitializedBy.individually,
  }
);
