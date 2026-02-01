import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./BillingProfile.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Billing;
/**
 * A policy at billing profile scope.
 */
@singleton("default")
@tenantResource
@parentResource(BillingProfile)
model BillingProfilePolicy
  is Azure.ResourceManager.ProxyResource<BillingProfilePolicyProperties> {
  ...ResourceNameParameter<
    Resource = BillingProfilePolicy,
    KeyName = "policy",
    SegmentName = "policies",
    NamePattern = ""
  >;

  /**
   * Dictionary of metadata associated with the resource. It may not be populated for all resource types. Maximum key/value length supported of 256 characters. Keys/value should not empty value nor null. Keys can not contain < > % & \ ? /
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
  tags?: Record<string>;
}

@armResourceOperations
interface BillingProfilePolicies {
  /**
   * Lists the policies for a billing profile. This operation is supported only for billing accounts with agreement type Microsoft Customer Agreement.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Policies_GetByBillingProfile")
  getByBillingProfile is ArmResourceRead<
    BillingProfilePolicy,
    BaseParameters = Azure.ResourceManager.Foundations.TenantBaseParameters
  >;

  /**
   * Updates the policies for a billing profile. This operation is supported only for billing accounts with agreement type Microsoft Customer Agreement.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Policies_CreateOrUpdateByBillingProfile")
  createOrUpdateByBillingProfile is ArmResourceCreateOrReplaceAsync<
    BillingProfilePolicy,
    BaseParameters = Azure.ResourceManager.Foundations.TenantBaseParameters,
    LroHeaders = ArmLroLocationHeader<FinalResult = BillingProfilePolicy> &
      Azure.Core.Foundations.RetryAfterHeader
  >;
}

@@doc(BillingProfilePolicy.name, "");
@@doc(BillingProfilePolicy.properties, "A policy at billing profile scope.");
@@doc(BillingProfilePolicies.createOrUpdateByBillingProfile::parameters.resource,
  "A policy at billing profile scope."
);
