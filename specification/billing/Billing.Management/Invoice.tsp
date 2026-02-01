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
 * An invoice.
 */
@tenantResource
@parentResource(BillingAccount)
model Invoice is Azure.ResourceManager.ProxyResource<InvoiceProperties> {
  ...ResourceNameParameter<
    Resource = Invoice,
    KeyName = "invoiceName",
    SegmentName = "invoices",
    NamePattern = "^(H[0-9]-[A-Z0-9]+)$|^(?:([GHT]|HT){1}[A-Z0-9]{9})$|^(?:[D]{1}[A-Z0-9]{9})$|^(?:E{1}[B-Z0-9]{1}[A-Z0-9]{8})$|^(?:EA[A-Z0-9]{8})$"
  >;

  /**
   * Dictionary of metadata associated with the resource. It may not be populated for all resource types. Maximum key/value length supported of 256 characters. Keys/value should not empty value nor null. Keys can not contain < > % & \ ? /
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
  tags?: Record<string>;
}

alias InvoiceOps = Azure.ResourceManager.Legacy.ExtensionOperations<
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
    @pattern("^([0-9]+|([Pp][Cc][Nn]\\.[A-Za-z0-9]+)|[0-9A-Fa-f]{8}-([0-9A-Fa-f]{4}-){3}[0-9A-Fa-f]{12}(:[0-9A-Fa-f]{8}-([0-9A-Fa-f]{4}-){3}[0-9A-Fa-f]{12}_[0-9]{4}(-[0-9]{2}){2})?)$")
    billingAccountName: string;
  },
  {},
  {
    /** The ID that uniquely identifies an invoice. */
    @path
    @segment("invoices")
    @key
    @pattern("^(H[0-9]-[A-Z0-9]+)$|^(?:([GHT]|HT){1}[A-Z0-9]{9})$|^(?:[D]{1}[A-Z0-9]{9})$|^(?:E{1}[B-Z0-9]{1}[A-Z0-9]{8})$|^(?:EA[A-Z0-9]{8})$")
    invoiceName: string;
  }
>;

@armResourceOperations
interface Invoices {
  /**
   * Gets an invoice by billing account name and ID. The operation is supported for all billing account types.
   */
  getByBillingAccount is InvoiceOps.Read<Invoice>;

  /**
   * Lists the invoices for a billing account for a given start date and end date. The operation is supported for all billing account types.
   */
  listByBillingAccount is InvoiceOps.List<
    Invoice,
    Parameters = {
      /**
       * The start date of the billing period for which the invoice is generated. The date is in MM-DD-YYYY format.
       */
      @query("periodStartDate")
      periodStartDate?: plainDate;

      /**
       * The end date of the billing period for which the invoice is generated. The date is in MM-DD-YYYY format.
       */
      @query("periodEndDate")
      periodEndDate?: plainDate;

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

  /**
   * Regenerate an invoice by billing account name and invoice name. The operation is supported for billing accounts with agreement type Microsoft Customer Agreement.
   */
  amend is InvoiceOps.ActionAsync<Invoice, void, ArmAcceptedLroResponse>;

  /**
   * Gets a URL to download an invoice document. The operation is supported for billing accounts with agreement type Microsoft Partner Agreement, Microsoft Customer Agreement or Enterprise Agreement.
   */
  @action("download")
  downloadByBillingAccount is InvoiceOps.ActionAsync<
    Invoice,
    void,
    ArmResponse<DocumentDownloadResult>,
    Parameters = {
      /**
       * The ID that uniquely identifies an invoice document. This ID may be an identifier for an invoice PDF, a credit note, or a tax receipt.
       */
      @query("documentName")
      documentName?: string;
    }
  >;

  /**
   * Gets a URL to download the summary document for an invoice. The operation is supported for billing accounts with agreement type Enterprise Agreement.
   */
  @action("downloadSummary")
  downloadSummaryByBillingAccount is InvoiceOps.ActionAsync<
    Invoice,
    void,
    ArmResponse<DocumentDownloadResult>
  >;

  /**
   * Lists the transactions for an invoice. Transactions include purchases, refunds and Azure usage charges.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Transactions_ListByInvoice")
  @list
  @get
  @action("transactions")
  listByInvoice is InvoiceOps.ActionSync<
    Invoice,
    void,
    ArmResponse<ResourceListResult<Transaction>>,
    Parameters = {
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

  /**
   * Gets a URL to download the transactions document for an invoice. The operation is supported for billing accounts with agreement type Enterprise Agreement.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Transactions_TransactionsDownloadByInvoice")
  @action("transactionsDownload")
  transactionsDownloadByInvoice is InvoiceOps.ActionAsync<
    Invoice,
    void,
    ArmResponse<DocumentDownloadResult>
  >;

  /**
   * Gets the transaction summary for an invoice. Transactions include purchases, refunds and Azure usage charges.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Transactions_GetTransactionSummaryByInvoice")
  @get
  @action("transactionSummary")
  getTransactionSummaryByInvoice is InvoiceOps.ActionSync<
    Invoice,
    void,
    ArmResponse<TransactionSummary>,
    Parameters = {
      /**
       * The filter query option allows clients to filter the line items that are aggregated to create the line item summary.
       */
      @query("filter")
      filter?: string;

      /**
       * The search query option allows clients to filter the line items that are aggregated to create the line item summary.
       */
      @query("search")
      search?: string;
    }
  >;
}
alias InvoiceByBillingSubscriptionOps = Azure.ResourceManager.Legacy.ExtensionOperations<
  {
    ...ApiVersionParameter;

    /** the provider namespace */
    @path
    @segment("providers")
    @key
    providerNamespace: "Microsoft.Billing";

    /** undefined */
    @path
    @segment("billingAccounts")
    @key
    default: string;

    ...SubscriptionIdParameter;
  },
  {},
  {
    /** The ID that uniquely identifies an invoice. */
    @path
    @segment("invoices")
    @key
    @pattern("^(H[0-9]-[A-Z0-9]+)$|^(?:([GHT]|HT){1}[A-Z0-9]{9})$|^(?:[D]{1}[A-Z0-9]{9})$|^(?:E{1}[B-Z0-9]{1}[A-Z0-9]{8})$|^(?:EA[A-Z0-9]{8})$")
    invoiceName: string;
  }
>;

@armResourceOperations
interface InvoiceByBillingSubscription {
  /**
   * Gets an invoice by subscription ID and invoice ID. The operation is supported for billing accounts with agreement type Microsoft Partner Agreement or Microsoft Customer Agreement.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Invoices_GetByBillingSubscription")
  getByBillingSubscription is InvoiceByBillingSubscriptionOps.Read<Invoice>;

  /**
   * Lists the invoices for a subscription. The operation is supported for billing accounts with agreement type Microsoft Partner Agreement or Microsoft Customer Agreement.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Invoices_ListByBillingSubscription")
  listByBillingSubscription is InvoiceByBillingSubscriptionOps.List<
    Invoice,
    Parameters = {
      /**
       * The start date of the billing period for which the invoice is generated. The date is in MM-DD-YYYY format.
       */
      @query("periodStartDate")
      periodStartDate?: plainDate;

      /**
       * The end date of the billing period for which the invoice is generated. The date is in MM-DD-YYYY format.
       */
      @query("periodEndDate")
      periodEndDate?: plainDate;

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

  /**
   * Gets a URL to download an invoice by billing subscription. The operation is supported for billing accounts with agreement type Microsoft Partner Agreement or Microsoft Customer Agreement.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Invoices_DownloadByBillingSubscription")
  @action("download")
  downloadByBillingSubscription is InvoiceByBillingSubscriptionOps.ActionAsync<
    Invoice,
    void,
    ArmResponse<DocumentDownloadResult>,
    Parameters = {
      /**
       * The ID that uniquely identifies an invoice document. This ID may be an identifier for an invoice PDF, a credit note, or a tax receipt.
       */
      @query("documentName")
      documentName?: string;
    }
  >;
}
alias InvoiceByIdOps = Azure.ResourceManager.Legacy.ExtensionOperations<
  {
    ...ApiVersionParameter;

    /** the provider namespace */
    @path
    @segment("providers")
    @key
    providerNamespace: "Microsoft.Billing";

    /** undefined */
    @path
    @segment("billingAccounts")
    @key
    default: string;
  },
  {},
  {
    /** The ID that uniquely identifies an invoice. */
    @path
    @segment("invoices")
    @key
    @pattern("^(H[0-9]-[A-Z0-9]+)$|^(?:([GHT]|HT){1}[A-Z0-9]{9})$|^(?:[D]{1}[A-Z0-9]{9})$|^(?:E{1}[B-Z0-9]{1}[A-Z0-9]{8})$|^(?:EA[A-Z0-9]{8})$")
    invoiceName: string;
  }
>;

@armResourceOperations
interface InvoiceById {
  /**
   * Gets an invoice by ID. The operation is supported for billing accounts with agreement type Microsoft Partner Agreement or Microsoft Customer Agreement.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Invoices_Get")
  get is InvoiceByIdOps.Read<Invoice>;
}

@@doc(Invoice.name, "The ID that uniquely identifies an invoice.");
@@doc(Invoice.properties, "An invoice.");
