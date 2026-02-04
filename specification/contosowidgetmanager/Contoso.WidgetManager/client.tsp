import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.Contoso.WidgetManager;
using Azure.ClientGenerator.Core;

namespace ClientCustomizations;

// Augmentation decorators for existing types
@@clientName(Widgets, "ContosoWidgets", "csharp");

// Line 124: Remove "Model" suffix from FakedSharedModel
@@clientName(FakedSharedModel, "FakedShared", "python");

// Line 79: Remove "widget_" prefix from widget_name parameter
@@clientName(Widgets.createOrUpdateWidget.widgetName, "name", "python");

// Line 119: Add required parameter 'hat' of type string to list_widgets
// Define custom types for client customizations
model ListWidgetsOptions {
  @doc("The hat parameter for filtering widgets.")
  hat: string;
  ...StandardListQueryParameters;
}

op listWidgetsCustom(...ListWidgetsOptions): Azure.Core.Page<WidgetSuite>;

@@override(Widgets.listWidgets, listWidgetsCustom, "python");

// Line 101: Change delete operations to return None
// Note: For LRO delete operations returning None, this should be handled 
// automatically by the latest Python emitter. If still needed, this requires
// SDK code customization using _patch.py rather than TypeSpec customization.
// See: https://github.com/Azure/autorest.python/blob/main/docs/customizations.md
