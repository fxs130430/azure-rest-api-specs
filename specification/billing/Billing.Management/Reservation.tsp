import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./ReservationOrder.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Billing;
/**
 * The definition of the reservation.
 */
@tenantResource
@parentResource(ReservationOrder)
model Reservation
  is Azure.ResourceManager.Legacy.TrackedResourceWithOptionalLocation<ReservationProperty> {
  ...ResourceNameParameter<
    Resource = Reservation,
    KeyName = "reservationId",
    SegmentName = "reservations",
    NamePattern = ""
  >;
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
  etag?: int32;

  /**
   * The sku information associated to this reservation
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
  sku?: ReservationSkuProperty;
}

@armResourceOperations
interface Reservations {
  /**
   * Get specific Reservation details in the billing account.
   */
  getByReservationOrder is ArmResourceRead<
    Reservation,
    BaseParameters = Azure.ResourceManager.Foundations.TenantBaseParameters,
    Parameters = {
      /**
       * May be used to expand the detail information of some properties.
       */
      @query("expand")
      expand?: string;
    }
  >;

  /**
   * Update reservation by billing account.
   */
  @patch(#{ implicitOptionality: false })
  updateByBillingAccount is ArmCustomPatchAsync<
    Reservation,
    PatchModel = Patch,
    BaseParameters = Azure.ResourceManager.Foundations.TenantBaseParameters,
    LroHeaders = ArmAsyncOperationHeader<FinalResult = Reservation> &
      Azure.Core.Foundations.RetryAfterHeader
  >;

  /**
   * List Reservations within a single ReservationOrder in the billing account.
   */
  listByReservationOrder is ArmResourceListByParent<
    Reservation,
    BaseParameters = Azure.ResourceManager.Foundations.TenantBaseParameters,
    Response = ArmResponse<ReservationList>
  >;
}

@@doc(Reservation.name, "Id of the reservation item");
@@doc(Reservation.properties, "The properties associated to this reservation");
@@doc(Reservations.updateByBillingAccount::parameters.properties,
  "Request body for patching a reservation"
);
