import "@azure-tools/typespec-client-generator-core";
import "./main.tsp";

using Azure.ClientGenerator.Core;
using Microsoft.CognitiveServices;
using Azure.ResourceManager;

@@clientName(Microsoft.CognitiveServices,
  "CognitiveServicesManagementClient",
  "javascript"
);
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-operation" "customization"
#suppress "@azure-tools/typespec-azure-core/documentation-required" "override"
op checkDomainAvailabilityCustom(
  ...ApiVersionParameter,
  ...SubscriptionIdParameter,
  ...SubscriptionActionScope,
  ...Azure.ResourceManager.Legacy.Provider,
  subdomainName: string,
  type: string,
  kind?: string,
): DomainAvailability;
@@override(checkDomainAvailability,
  checkDomainAvailabilityCustom,
  "javascript"
);
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-operation" "customization"
#suppress "@azure-tools/typespec-azure-core/documentation-required" "override"
op checkSkuAvailabilityCustom(
  ...ApiVersionParameter,
  ...SubscriptionIdParameter,
  ...SubscriptionActionScope,
  ...Azure.ResourceManager.Legacy.Provider,
  location: string,
  skus: string[],
  type: string,
  kind: string,
): SkuAvailabilityListResult;
@@override(checkSkuAvailability, checkSkuAvailabilityCustom, "javascript");
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-operation" "customization"
#suppress "@azure-tools/typespec-azure-core/documentation-required" "override"
op calculateModelCapacityCustom(
  ...ApiVersionParameter,
  ...SubscriptionIdParameter,
  ...Azure.ResourceManager.Legacy.Provider,
  `model`?: DeploymentModel,
  skuName?: string,

  @identifiers(#[])
  workloads?: ModelCapacityCalculatorWorkload[],
): CalculateModelCapacityResult;
@@override(calculateModelCapacity, calculateModelCapacityCustom, "javascript");
