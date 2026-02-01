// FIXME: Operations in this file are not detected as a resource operation, please confirm the conversion result manually

import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;
using TypeSpec.OpenAPI;

namespace Microsoft.Billing;

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-interface-requires-decorator" "For backward compatibility"
interface AddressOperationGroup {
  /**
   * Validates an address. Use the operation to validate an address before using it as soldTo or a billTo address.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Address_Validate")
  @autoRoute
  @action("validateAddress")
  validate is ArmProviderActionSync<
    Request = AddressDetails,
    Response = AddressValidationResponse
  >;
}

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-interface-requires-decorator" "For backward compatibility"
interface InvoicesOperationGroup {
  /**
   * Gets a URL to download multiple invoice documents (invoice pdf, tax receipts, credit notes) as a zip file. The operation is supported for billing accounts with agreement type Microsoft Partner Agreement or Microsoft Customer Agreement.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Invoices_DownloadDocumentsByBillingSubscription")
  @autoRoute
  @action("downloadDocuments")
  @post
  downloadDocumentsByBillingSubscription(
    ...SubscriptionIdParameter,
    ...ApiVersionParameter,
    @body downloadUrls: DocumentDownloadRequest[],
  ): ArmResponse<DocumentDownloadResult> | ArmAcceptedLroResponse | ErrorResponse;
}
