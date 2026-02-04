import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Web;

@doc("The properties of an AI gateway.")
model AIGatewayProperties {
  @visibility(Lifecycle.Read)
  @doc("The status of the last operation.")
  provisioningState?: ResourceProvisioningState;

  @doc("The description of the resource.")
  @visibility(Lifecycle.Read)
  aiGatewayId?: string;
}

@doc("An AI gateway resource.")
model AIGateway is Azure.ResourceManager.TrackedResource<AIGatewayProperties> {
  @key("name")
  @segment("aigateways")
  @doc("The name of the AI gateway")
  @path
  @pattern("[a-zA-Z0-9_.()-]{0,79}$")
  name: string;
}

@armResourceOperations
@doc("The operations of AI gateways.")
interface AIGateways {
  get is ArmResourceRead<AIGateway>;
  createOrUpdate is ArmResourceCreateOrReplaceSync<AIGateway>;
  patch is ArmResourcePatchSync<AIGateway, AIGatewayProperties>;
  delete is ArmResourceDeleteSync<AIGateway>;
  listBySubscription is ArmListBySubscription<AIGateway>;
  listByResourceGroup is ArmResourceListByParent<
    AIGateway,
    Azure.ResourceManager.Foundations.BaseParameters<AIGateway> &
      Azure.Core.StandardListQueryParameters &
      Azure.Core.FilterQueryParameter &
      Azure.Core.SelectQueryParameter &
      Azure.Core.ExpandQueryParameter &
      Azure.Core.OrderByQueryParameter
  >;
}
