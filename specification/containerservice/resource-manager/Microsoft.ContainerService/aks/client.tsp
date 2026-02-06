import "@azure-tools/typespec-client-generator-core";
import "./main.tsp";

using Azure.ClientGenerator.Core;
using Azure.Core;
using Microsoft.ContainerService;

@@clientName(Microsoft.ContainerService.IPFamily, "IpFamily", "javascript");

// Java specific renaming for backward compatibility
@@clientName(ManagedClusterAPIServerAccessProfile,
  "ManagedClusterApiServerAccessProfile",
  "java"
);
@@clientName(ManagedClusterHTTPProxyConfig,
  "ManagedClusterHttpProxyConfig",
  "java"
);
@@clientName(ManagedClusterIngressProfile.gatewayAPI, "gatewayApi", "java");
@@clientName(ManagedClusterOIDCIssuerProfile.issuerURL, "issuerUrl", "java");
@@clientName(TrustedAccessRoleRule.nonResourceURLs, "nonResourceUrls", "java");

@@clientName(Microsoft.ContainerService, "ContainerServiceClient", "python");
@@clientName(ManagedClusterLoadBalancerProfileManagedOutboundIPs.countIPv6,
  "count_ipv6",
  "python"
);

@@clientName(ManagedClusterPodIdentityProvisioningError.error,
  "ErrorDetail",
  "csharp"
);
@@clientName(Code, "ContainerServiceStateCode", "csharp");
@@clientName(Format, "KubeConfigFormat", "csharp");
@@clientName(Expander, "AutoScaleExpander", "csharp");
@@clientName(KubeletConfig.containerLogMaxSizeMB,
  "ContainerLogMaxSizeInMB",
  "csharp"
);
@@clientName(LinuxOSConfig.swapFileSizeMB, "SwapFileSizeInMB", "csharp");
@@clientName(ManagedClusterAADProfile.managed, "IsManagedAadEnabled", "csharp");
@@clientName(ManagedClusterAADProfile.enableAzureRBAC,
  "IsAzureRbacEnabled",
  "csharp"
);
@@clientName(ConnectionStatus,
  "ContainerServicePrivateLinkServiceConnectionStatus",
  "csharp"
);
@@clientName(CredentialResults, "ManagedClusterCredentials", "csharp");
@@clientName(CredentialResult, "ManagedClusterCredential", "csharp");
@@clientName(LicenseType, "WindowsVmLicenseType", "csharp");
@@clientName(ManagedClusterPropertiesAutoScalerProfile,
  "ManagedClusterAutoScalerProfile",
  "csharp"
);
@@clientName(Snapshot, "AgentPoolSnapshot", "csharp");
@@clientName(PrivateLinkResource,
  "ContainerServicePrivateLinkResourceData",
  "csharp"
);
@@clientName(ManagedClusterAddonProfile.enabled, "IsEnabled", "csharp");
@@clientName(ManagedClusterPodIdentityProfile.enabled, "IsEnabled", "csharp");
@@clientName(WindowsGmsaProfile.enabled, "IsEnabled", "csharp");
@@clientName(TimeSpan.start, "StartOn", "csharp");
@@clientName(TimeSpan.end, "EndOn", "csharp");
@@clientName(KubeletConfig.failSwapOn, "FailStartWithSwapOn", "csharp");
@@clientName(ManagedClusterStorageProfileDiskCSIDriver.enabled,
  "IsDiskCsiDriverEnabled",
  "csharp"
);
@@clientName(ManagedClusterStorageProfileFileCSIDriver.enabled,
  "IsFileCsiDriverEnabled",
  "csharp"
);
@@clientName(ManagedClusterStorageProfileSnapshotController.enabled,
  "IsSnapshotControllerEnabled",
  "csharp"
);
@@clientName(ManagedClusterStorageProfileBlobCSIDriver.enabled,
  "IsBlobCsiDriverEnabled",
  "csharp"
);
@@clientName(KubeletConfig.cpuCfsQuota, "IsCpuCfsQuotaEnabled", "csharp");
@@clientName(OutboundEnvironmentEndpointCollection,
  "OutboundEnvironmentEndpointListResult",
  "csharp"
);
@@clientName(RunCommandRequest, "ManagedClusterRunCommandContent", "csharp");
@@clientName(RunCommandResult, "ManagedClusterRunCommandResult", "csharp");
@@alternateType(UserAssignedIdentity.objectId, uuid, "csharp");
@@alternateType(UserAssignedIdentity.clientId, uuid, "csharp");
@@alternateType(ManagedClusterAADProfile.serverAppID, uuid, "csharp");
@@alternateType(ManagedClusterAADProfile.clientAppID, uuid, "csharp");
@@clientName(ManagedClusterSecurityProfileDefenderSecurityMonitoring.enabled,
  "IsSecurityMonitoringEnabled",
  "csharp"
);
@@clientName(AzureKeyVaultKms,
  "ManagedClusterSecurityProfileKeyVaultKms",
  "csharp"
);
@@clientName(AzureKeyVaultKms.enabled, "IsEnabled", "csharp");
@@clientName(KeyVaultNetworkAccessTypes,
  "ManagedClusterKeyVaultNetworkAccessType",
  "csharp"
);
@@clientName(ManagedClusterOIDCIssuerProfile.enabled, "IsEnabled", "csharp");
@@clientName(ManagedClusterOIDCIssuerProfile.issuerURL,
  "IssuerUriInfo",
  "csharp"
);
@@clientName(AbsoluteMonthlySchedule,
  "ContainerServiceMaintenanceAbsoluteMonthlySchedule",
  "csharp"
);
@@clientName(RelativeMonthlySchedule,
  "ContainerServiceMaintenanceRelativeMonthlySchedule",
  "csharp"
);
@@clientName(Type,
  "ContainerServiceMaintenanceRelativeMonthlyScheduleWeekIndex",
  "csharp"
);
@@clientName(Schedule, "ContainerServiceMaintenanceSchedule", "csharp");
@@clientName(WeeklySchedule,
  "ContainerServiceMaintenanceWeeklySchedule",
  "csharp"
);
@@clientName(BackendPoolType,
  "ManagedClusterLoadBalancerBackendPoolType",
  "csharp"
);
@@clientName(ManagedClusterAzureMonitorProfileKubeStateMetrics,
  "ManagedClusterMonitorProfileKubeStateMetrics",
  "csharp"
);
@@clientName(ManagedClusterAzureMonitorProfileMetrics,
  "ManagedClusterMonitorProfileMetrics",
  "csharp"
);
@@clientName(ManagedClusterAzureMonitorProfileMetrics.enabled,
  "IsEnabled",
  "csharp"
);
@@clientName(ManagedClusterSecurityProfileImageCleaner.enabled,
  "IsEnabled",
  "csharp"
);
@@clientName(ManagedClusterWorkloadAutoScalerProfileVerticalPodAutoscaler,
  "ManagedClusterVerticalPodAutoscaler",
  "csharp"
);
@@clientName(ManagedClusterWorkloadAutoScalerProfileVerticalPodAutoscaler.enabled,
  "IsVpaEnabled",
  "csharp"
);
@@clientName(NodeOSUpgradeChannel,
  "ManagedClusterNodeOSUpgradeChannel",
  "csharp"
);
@@clientName(PortRange, "AgentPoolNetworkPortRange", "csharp");
@@clientName(Protocol, "AgentPoolNetworkPortProtocol", "csharp");
@@alternateType(ManagedClusterAgentPoolProfileProperties.capacityReservationGroupID,
  armResourceIdentifier,
  "csharp"
);
@@alternateType(ManagedClusterAgentPoolProfileProperties.capacityReservationGroupID,
  armResourceIdentifier,
  "csharp"
);
@@alternateType(MaintenanceWindow.startDate, string, "csharp");
@@clientName(ManagedCluster.identity, "ClusterIdentity", "csharp");
@@clientName(ManagedClusterProperties.resourceUID, "ResourceID", "csharp");
@@alternateType(ManagedClusterProperties.resourceUID,
  armResourceIdentifier,
  "csharp"
);
@@clientName(IstioEgressGateway.enabled, "IsEnabled", "csharp");
@@clientName(IstioIngressGateway.enabled, "IsEnabled", "csharp");
@@clientName(ManagedClusterWorkloadAutoScalerProfileKeda.enabled,
  "IsKedaEnabled",
  "csharp"
);
@@clientName(ManagedClusterSecurityProfileWorkloadIdentity.enabled,
  "IsWorkloadIdentityEnabled",
  "csharp"
);
@@clientName(AgentPoolWindowsProfile.disableOutboundNat,
  "IsOutboundNatDisabled",
  "csharp"
);
@@clientName(ManagedNamespace, "ManagedClusterNamespace", "csharp");
@@clientName(NamespaceProperties,
  "ManagedClusterNamespaceProperties",
  "csharp"
);
@@clientName(AdoptionPolicy, "NamespaceAdoptionPolicy", "csharp");
@@clientName(AdvancedNetworking, "ManagedClusterAdvancedNetworking", "csharp");
@@clientName(AdvancedNetworking.enabled, "IsEnabled", "csharp");
@@clientName(AdvancedNetworkingSecurity,
  "ManagedClusterAdvancedNetworkingSecurity",
  "csharp"
);
@@clientName(AdvancedNetworkPolicies,
  "ManagedClusterAdvancedNetworkPolicy",
  "csharp"
);
@@clientName(AdvancedNetworkingObservability.enabled,
  "IsObservabilityEnabled",
  "csharp"
);
@@clientName(AgentPoolDeleteMachinesParameter,
  "AgentPoolDeleteMachinesContent",
  "csharp"
);
@@clientName(AgentPoolSecurityProfile.enableVTPM, "IsVtpmEnabled", "csharp");
@@clientName(AgentPoolSecurityProfile.enableSecureBoot,
  "IsSecureBootEnabled",
  "csharp"
);
@@clientName(AgentPoolSSHAccess, "AgentPoolSshAccess", "csharp");
@@clientName(ManagedClusterStaticEgressGatewayProfile.enabled,
  "IsStaticEgressGatewayAddonEnabled",
  "csharp"
);
@@clientName(DeletePolicy, "NamespaceDeletePolicy", "csharp");
@@clientName(GPUProfile, "AgentPoolGpuProfile", "csharp");
@@clientName(GPUDriver, "AgentPoolGpuDriver", "csharp");
@@clientName(NamespaceProvisioningState,
  "ManagedClusterNamespaceProvisioningState",
  "csharp"
);
@@clientName(NetworkPolicies, "NamespaceNetworkPolicies", "csharp");
@@clientName(PolicyRule, "NamespaceNetworkPolicyRule", "csharp");
@@clientName(ResourceQuota, "NamespaceResourceQuota", "csharp");
@@clientName(RestrictionLevel,
  "ManagedClusterNodeResourceGroupRestrictionLevel",
  "csharp"
);
@@clientName(VirtualMachineNodes, "AgentPoolVirtualMachineNodes", "csharp");
@@clientName(ManagedClusterAIToolchainOperatorProfile.enabled,
  "IsAIToolchainOperatorEnabled",
  "csharp"
);
@@clientName(ManagedClusterCostAnalysis.enabled,
  "IsCostAnalysisEnabled",
  "csharp"
);
@@clientName(AdvancedNetworkingSecurity.enabled, "IsEnabled", "csharp");
@@clientName(ManagedClusterIngressProfileWebAppRouting.enabled,
  "IsEnabled",
  "csharp"
);
@@clientName(ContainerServiceNetworkProfile.ipFamilies,
  "NetworkIPFamilies",
  "csharp"
);
@@clientName(TimeSpan, "ContainerServiceTimeSpan", "csharp");
@@clientName(TimeInWeek, "ContainerServiceTimeInWeek", "csharp");
@@clientName(WeekDay, "ContainerServiceWeekDay", "csharp");
@@clientName(OSType, "ContainerServiceOSType", "csharp");
@@clientName(OSDiskType, "ContainerServiceOSDiskType", "csharp");
@@clientName(OSSKU, "ContainerServiceOSSku", "csharp");
@@clientName(UserAssignedIdentity,
  "ContainerServiceUserAssignedIdentity",
  "csharp"
);
@@clientName(AgentPool, "ContainerServiceAgentPool", "csharp");
@@clientName(MaintenanceConfiguration,
  "ContainerServiceMaintenanceConfiguration",
  "csharp"
);
@@clientName(ManagedCluster, "ContainerServiceManagedCluster", "csharp");
@@alternateType(ManagedCluster.identity,
  Azure.ResourceManager.CommonTypes.ManagedServiceIdentity,
  "csharp"
);
@@clientName(PublicNetworkAccess,
  "ContainerServicePublicNetworkAccess",
  "csharp"
);
@@clientName(CreationData, "ContainerServiceCreationData", "csharp");
@@clientName(EndpointDependency,
  "ContainerServiceEndpointDependency",
  "csharp"
);
@@clientName(EndpointDetail, "ContainerServiceEndpointDetail", "csharp");
@@clientName(LoadBalancerSku, "ContainerServiceLoadBalancerSku", "csharp");
@@clientName(NetworkMode, "ContainerServiceNetworkMode", "csharp");
@@clientName(NetworkPlugin, "ContainerServiceNetworkPlugin", "csharp");
@@clientName(NetworkPolicy, "ContainerServiceNetworkPolicy", "csharp");
@@clientName(OutboundEnvironmentEndpoint,
  "ContainerServiceOutboundEnvironmentEndpoint",
  "csharp"
);
@@clientName(OutboundType, "ContainerServiceOutboundType", "csharp");
@@clientName(PrivateLinkResourcesListResult,
  "ContainerServicePrivateLinkResourcesListResult",
  "csharp"
);
@@clientName(TagsObject, "ContainerServiceTagsObject", "csharp");
@@clientName(PowerState, "ContainerServicePowerState", "csharp");
@@clientName(DateSpan, "ContainerServiceDateSpan", "csharp");
@@clientName(IPTag, "ContainerServiceIPTag", "csharp");
@@clientName(MaintenanceWindow, "ContainerServiceMaintenanceWindow", "csharp");
@@clientName(NetworkPluginMode, "ContainerServiceNetworkPluginMode", "csharp");
@@clientName(TrustedAccessRole, "ContainerServiceTrustedAccessRole", "csharp");
@@clientName(TrustedAccessRoleBinding,
  "ContainerServiceTrustedAccessRoleBinding",
  "csharp"
);
@@clientName(TrustedAccessRoleRule,
  "ContainerServiceTrustedAccessRoleRule",
  "csharp"
);
@@clientName(TrustedAccessRoleBindingProvisioningState,
  "ContainerServiceTrustedAccessRoleBindingProvisioningState",
  "csharp"
);
@@clientName(Machine, "ContainerServiceMachine", "csharp");
@@clientName(MachineProperties, "ContainerServiceMachineProperties", "csharp");
@@clientName(ArtifactSource, "ContainerServiceArtifactSource", "csharp");
@@clientName(MachineIpAddress, "ContainerServiceMachineIpAddress", "csharp");
@@clientName(IPFamily, "ContainerServiceIPFamily", "csharp");
@@clientName(JWTAuthenticator, "ManagedClusterJwtAuthenticator", "csharp");
@@clientName(JWTAuthenticatorProperties,
  "ManagedClusterJwtAuthenticatorProperties",
  "csharp"
);
@@clientName(LoadBalancer, "ManagedClusterLoadBalancerData", "csharp");
@@clientName(LoadBalancerProperties,
  "ManagedClusterLoadBalancerProperties",
  "csharp"
);
@@clientName(ManagedClusters.listByResourceGroup, "GetAll", "csharp");
@@clientName(ManagedClusters.list,
  "GetContainerServiceManagedClusters",
  "csharp"
);
@@clientName(ManagedClusters.listClusterAdminCredentials,
  "GetClusterAdminCredentials",
  "csharp"
);
@@clientName(ManagedClusters.listClusterUserCredentials,
  "GetClusterUserCredentials",
  "csharp"
);
@@clientName(ManagedClusters.listClusterMonitoringUserCredentials,
  "GetClusterMonitoringUserCredentials",
  "csharp"
);
@@clientName(ManagedClusters.listOutboundNetworkDependenciesEndpoints,
  "GetOutboundNetworkDependenciesEndpoints",
  "csharp"
);
@@clientName(ManagedClusters.getAvailableAgentPoolVersions,
  "GetAvailableAgentPoolVersions",
  "csharp"
);
@@clientName(ManagedClusters.post, "ResolvePrivateLinkServiceId", "csharp");

@@scope(ManagedClusters.operationStatusResultList, "!csharp");
@@scope(ManagedClusters.operationStatusResultGet, "!csharp");
