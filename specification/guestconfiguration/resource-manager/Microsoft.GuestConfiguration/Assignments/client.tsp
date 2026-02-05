import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Microsoft.GuestConfiguration;

// ============================================================================
// Operation renaming - disambiguate methods for different parent resource types
// ============================================================================

// VM operations (GuestConfigurationAssignments interface)
@@clientName(GuestConfigurationAssignments.get, "GetForVirtualMachine", "csharp");
@@clientName(GuestConfigurationAssignments.createOrUpdate,
  "CreateOrUpdateForVirtualMachine",
  "csharp"
);
@@clientName(GuestConfigurationAssignments.delete, "DeleteForVirtualMachine", "csharp");
@@clientName(GuestConfigurationAssignments.list, "GetAllForVirtualMachine", "csharp");

// HCRP operations (GuestConfigurationHCRPAssignments interface)
@@clientName(GuestConfigurationHCRPAssignments.get, "GetForMachine", "csharp");
@@clientName(GuestConfigurationHCRPAssignments.createOrUpdate,
  "CreateOrUpdateForMachine",
  "csharp"
);
@@clientName(GuestConfigurationHCRPAssignments.delete, "DeleteForMachine", "csharp");
@@clientName(GuestConfigurationHCRPAssignments.list, "GetAllForMachine", "csharp");

// VMSS operations (GuestConfigurationAssignmentsVMSS interface)
@@clientName(GuestConfigurationAssignmentsVMSS.get, "GetForVmss", "csharp");
@@clientName(GuestConfigurationAssignmentsVMSS.createOrUpdate,
  "CreateOrUpdateForVmss",
  "csharp"
);
@@clientName(GuestConfigurationAssignmentsVMSS.delete, "DeleteForVmss", "csharp");
@@clientName(GuestConfigurationAssignmentsVMSS.list, "GetAllForVmss", "csharp");

// VMwarevSphere operations (GuestConfigurationConnectedVMwarevSphereAssignments interface)
@@clientName(GuestConfigurationConnectedVMwarevSphereAssignments.get,
  "GetForConnectedVMwarevSphere",
  "csharp"
);
@@clientName(GuestConfigurationConnectedVMwarevSphereAssignments.createOrUpdate,
  "CreateOrUpdateForConnectedVMwarevSphere",
  "csharp"
);
@@clientName(GuestConfigurationConnectedVMwarevSphereAssignments.delete,
  "DeleteForConnectedVMwarevSphere",
  "csharp"
);
@@clientName(GuestConfigurationConnectedVMwarevSphereAssignments.list,
  "GetAllForConnectedVMwarevSphere",
  "csharp"
);
