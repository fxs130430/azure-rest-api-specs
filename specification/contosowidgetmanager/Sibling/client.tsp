import "../Contoso.WidgetManager/main.tsp";
import "../Contoso.Management/main.tsp";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;

namespace FooCombinedService;

@client({
  name: "FirstClient",
  service: Microsoft.Contoso,
})
interface FooCombinedClient extends Microsoft.Contoso.Operations {}

@client({
  name: "SecondClient",
  service: Azure.Contoso.WidgetManager,
})
interface FooCombinedClient2 extends Azure.Contoso.WidgetManager.Widgets {}
