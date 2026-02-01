import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./BillingAccount.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Billing;
/**
 * An associated tenant.
 */
@tenantResource
@parentResource(BillingAccount)
model AssociatedTenant
  is Azure.ResourceManager.ProxyResource<AssociatedTenantProperties> {
  ...ResourceNameParameter<
    Resource = AssociatedTenant,
    KeyName = "associatedTenantName",
    SegmentName = "associatedTenants",
    NamePattern = "^[0-9A-Fa-f]{8}-([0-9A-Fa-f]{4}-){3}[0-9A-Fa-f]{12}$"
  >;

  /**
   * Dictionary of metadata associated with the resource. It may not be populated for all resource types. Maximum key/value length supported of 256 characters. Keys/value should not empty value nor null. Keys can not contain < > % & \ ? /
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
  tags?: Record<string>;
}

@armResourceOperations
interface AssociatedTenants {
  /**
   * Gets an associated tenant by ID.
   */
  get is ArmResourceRead<
    AssociatedTenant,
    BaseParameters = Azure.ResourceManager.Foundations.TenantBaseParameters
  >;

  /**
   * Create or update an associated tenant for the billing account.
   */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<
    AssociatedTenant,
    BaseParameters = Azure.ResourceManager.Foundations.TenantBaseParameters,
    LroHeaders = ArmLroLocationHeader<FinalResult = AssociatedTenant> &
      Azure.Core.Foundations.RetryAfterHeader
  >;

  /**
   * Deletes an associated tenant for a billing account.
   */
  delete is ArmResourceDeleteWithoutOkAsync<
    AssociatedTenant,
    BaseParameters = Azure.ResourceManager.Foundations.TenantBaseParameters
  >;

  /**
   * Lists the associated tenants that can collaborate with the billing account on commerce activities like viewing and downloading invoices, managing payments, making purchases, and managing or provisioning licenses.
   */
  listByBillingAccount is ArmResourceListByParent<
    AssociatedTenant,
    BaseParameters = Azure.ResourceManager.Foundations.TenantBaseParameters,
    Parameters = {
      /**
       * Can be used to get revoked associated tenants.
       */
      @query("includeRevoked")
      includeRevoked?: boolean;

      /**
       * The filter query option allows clients to filter a collection of resources that are addressed by a request URL.
       */
      @query("filter")
      filter?: string;

      /**
       * The orderby query option allows clients to request resources in a particular order.
       */
      @query("orderBy")
      orderBy?: string;

      /**
       * The top query option requests the number of items in the queried collection to be included in the result. The maximum supported value for top is 50.
       */
      @query("top")
      top?: int64;

      /**
       * The skip query option requests the number of items in the queried collection that are to be skipped and not included in the result.
       */
      @query("skip")
      skip?: int64;

      /**
       * The count query option allows clients to request a count of the matching resources included with the resources in the response.
       */
      @query("count")
      count?: boolean;

      /**
       * The search query option allows clients to request items within a collection matching a free-text search expression. search is only supported for string fields.
       */
      @query("search")
      search?: string;
    }
  >;
}

@@doc(AssociatedTenant.name, "The ID that uniquely identifies a tenant.");
@@doc(AssociatedTenant.properties, "An associated tenant.");
@@doc(AssociatedTenants.createOrUpdate::parameters.resource,
  "An associated tenant."
);
