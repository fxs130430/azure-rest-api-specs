import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Microsoft.EventHub;

@@clientName(Microsoft.EventHub,
  "EventHubManagementClient",
  "python,javascript"
);

// rename for duplicate model from Azure.ResourceManager.CommonTypes
@@clientName(Azure.ResourceManager.CommonTypes.ErrorDetail,
  "ArmErrorDetail",
  "go"
);
@@clientName(Azure.ResourceManager.CommonTypes.ErrorAdditionalInfo,
  "ArmErrorAdditionalInfo",
  "go"
);

// Fix TLS version naming changes for Go SDK backward compatibility
@@clientName(TlsVersion.`1.0`, "One0", "go");
@@clientName(TlsVersion.`1.1`, "One1", "go");
@@clientName(TlsVersion.`1.2`, "One2", "go");
@@clientName(TlsVersion.`1.3`, "One3", "go");

// Fix field naming changes for Go SDK backward compatibility
@@clientName(RetentionDescription.minCompactionLagTimeInMinutes,
  "MinCompactionLagInMins",
  "go"
);
