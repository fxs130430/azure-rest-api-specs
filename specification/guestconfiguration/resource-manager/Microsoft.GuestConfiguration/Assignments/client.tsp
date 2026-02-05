import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Microsoft.GuestConfiguration;

// ============================================================================
// Type renaming for C#
// ============================================================================

// Core type renaming from autorest.md rename-mapping
@@clientName(AssignmentInfo, "GuestConfigurationAssignmentInfo", "csharp");
@@clientName(ComplianceStatus,
  "AssignedGuestConfigurationMachineComplianceStatus",
  "csharp"
);
@@clientName(Type, "GuestConfigurationAssignmentReportType", "csharp");
@@clientName(AssignmentReportResource, "AssignmentReportResourceInfo", "csharp");
@@clientName(VMInfo, "GuestConfigurationVmInfo", "csharp");
@@clientName(VmssvmInfo, "GuestConfigurationVmssVmInfo", "csharp");
@@clientName(AssignmentReportDetails,
  "GuestConfigurationAssignmentReportDetails",
  "csharp"
);
@@clientName(ConfigurationSetting, "LcmConfigurationSetting", "csharp");
@@clientName(ConfigurationMode, "LcmConfigurationMode", "csharp");
@@clientName(ProvisioningState, "GuestConfigurationProvisioningState", "csharp");
@@clientName(AssignmentType, "GuestConfigurationAssignmentType", "csharp");
@@clientName(AssignmentReport, "GuestConfigurationAssignmentReportInfo", "csharp");
@@clientName(ConfigurationInfo, "GuestConfigurationInfo", "csharp");
@@clientName(ConfigurationParameter, "GuestConfigurationParameter", "csharp");

// ============================================================================
// Property renaming for C#
// ============================================================================

// AssignmentReportResource property renaming
@@clientName(AssignmentReportResource.resourceId,
  "AssignmentResourceSettingName",
  "csharp"
);

// VmssvmInfo property renaming
@@clientName(VmssvmInfo.lastComplianceChecked, "LastComplianceCheckedOn", "csharp");

// ConfigurationSetting property renaming
@@clientName(ConfigurationSetting.allowModuleOverwrite,
  "IsModuleOverwriteAllowed",
  "csharp"
);
@@clientName(ConfigurationSetting.configurationModeFrequencyMins,
  "ConfigurationModeFrequencyInMins",
  "csharp"
);
@@clientName(ConfigurationSetting.refreshFrequencyMins,
  "RefreshFrequencyInMins",
  "csharp"
);

// GuestConfigurationAssignmentProperties property renaming
@@clientName(GuestConfigurationAssignmentProperties.lastComplianceStatusChecked,
  "LastComplianceStatusCheckedOn",
  "csharp"
);

// GuestConfigurationNavigation property renaming
@@clientName(GuestConfigurationNavigation.configurationParameter,
  "ConfigurationParameters",
  "csharp"
);
@@clientName(GuestConfigurationNavigation.configurationProtectedParameter,
  "ConfigurationProtectedParameters",
  "csharp"
);

// ============================================================================
// Acronym handling - ensure proper casing
// ============================================================================

// VMInfo already renamed above, but ensure Vm casing
@@clientName(ActionAfterReboot, "ActionAfterReboot", "csharp");
@@clientName(Kind, "GuestConfigurationKind", "csharp");

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
