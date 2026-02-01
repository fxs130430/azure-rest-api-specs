import "@azure-tools/typespec-azure-core";

using TypeSpec.Versioning;

namespace Microsoft.PlanetaryComputer;

#suppress "@azure-tools/typespec-azure-core/no-enum" "Version information"
@doc("Represents version information.")
enum Versions {
  @doc("Represents the 2025-04-30-preview version.")
  v2025_04_30_Preview: "2025-04-30-preview",

  @doc("Represents the 2026-04-30 version.")
  v2026_04_30: "2026-04-30",
}
