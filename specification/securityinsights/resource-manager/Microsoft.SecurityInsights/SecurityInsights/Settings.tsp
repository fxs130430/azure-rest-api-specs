import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.SecurityInsights;
// FIXME: Settings has no properties property
/**
 * The Setting.
 */
@discriminator("kind")
model Settings
  is Azure.ResourceManager.Legacy.DiscriminatedExtensionResource<SettingKind> {
  ...ResourceNameParameter<
    Resource = Settings,
    KeyName = "settingsName",
    SegmentName = "settings",
    NamePattern = "^[a-zA-Z][a-zA-Z0-9]*$"
  >;

  /**
   * Etag of the azure resource
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
  etag?: string;
}

@armResourceOperations
interface ProductSettings {
  /**
   * Gets a setting.
   */
  get is Extension.Read<
    workspaceExternalResource,
    Settings,
    Error = CloudError
  >;

  /**
   * Updates setting.
   */
  update is Extension.CreateOrReplaceSync<
    workspaceExternalResource,
    Settings,
    Error = CloudError
  >;

  /**
   * Delete setting of the product.
   */
  delete is Extension.DeleteSync<
    workspaceExternalResource,
    Settings,
    Error = CloudError
  >;

  /**
   * List of all the settings
   */
  list is Extension.ListByTarget<
    workspaceExternalResource,
    Settings,
    Response = ArmResponse<SettingList>,
    Error = CloudError
  >;
}

@@doc(Settings.name,
  "The setting name. Supports - Anomalies, EyesOn, EntityAnalytics, Ueba"
);
@@doc(ProductSettings.update::parameters.resource, "The setting");
