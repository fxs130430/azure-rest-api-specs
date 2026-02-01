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
 * A payment method.
 */
@tenantResource
@parentResource(BillingAccount)
model PaymentMethod
  is Azure.ResourceManager.ProxyResource<PaymentMethodProperties> {
  ...ResourceNameParameter<
    Resource = PaymentMethod,
    KeyName = "paymentMethodName",
    SegmentName = "paymentMethods",
    NamePattern = ""
  >;

  /**
   * Dictionary of metadata associated with the resource. It may not be populated for all resource types. Maximum key/value length supported of 256 characters. Keys/value should not empty value nor null. Keys can not contain < > % & \ ? /
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
  tags?: Record<string>;
}

alias PaymentMethodOps = Azure.ResourceManager.Legacy.ExtensionOperations<
  {
    ...ApiVersionParameter;

    /** the provider namespace */
    @path
    @segment("providers")
    @key
    providerNamespace: "Microsoft.Billing";

    /** The ID that uniquely identifies a billing account. */
    @path
    @segment("billingAccounts")
    @key
    billingAccountName: string;
  },
  {},
  {
    /** The ID that uniquely identifies a payment method. */
    @path
    @segment("paymentMethods")
    @key
    paymentMethodName: string;
  }
>;

@armResourceOperations
interface PaymentMethods {
  /**
   * Gets a payment method available for a billing account. The operation is supported only for billing accounts with agreement type Microsoft Customer Agreement.
   */
  getByBillingAccount is PaymentMethodOps.Read<PaymentMethod>;

  /**
   * Lists the payment methods available for a billing account. Along with the payment methods owned by the caller, these payment methods can be attached to a billing profile to make payments. The operation is supported only for billing accounts with agreement type Microsoft Customer Agreement.
   */
  listByBillingAccount is PaymentMethodOps.List<PaymentMethod>;
}
alias PaymentMethodOperationGroupOps = Azure.ResourceManager.Legacy.ExtensionOperations<
  {
    ...ApiVersionParameter;

    /** the provider namespace */
    @path
    @segment("providers")
    @key
    providerNamespace: "Microsoft.Billing";
  },
  {},
  {
    /** The ID that uniquely identifies a payment method. */
    @path
    @segment("paymentMethods")
    @key
    paymentMethodName: string;
  }
>;

@armResourceOperations
interface PaymentMethodOperationGroup {
  /**
   * Gets a payment method owned by the caller.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("PaymentMethods_GetByUser")
  getByUser is PaymentMethodOperationGroupOps.Read<PaymentMethod>;

  /**
   * Deletes a payment method owned by the caller.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("PaymentMethods_DeleteByUser")
  deleteByUser is PaymentMethodOperationGroupOps.DeleteSync<PaymentMethod>;

  /**
   * Lists the payment methods owned by the caller.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("PaymentMethods_ListByUser")
  listByUser is PaymentMethodOperationGroupOps.List<PaymentMethod>;
}

@@doc(PaymentMethod.name, "The ID that uniquely identifies a payment method.");
@@doc(PaymentMethod.properties, "Payment method properties");
